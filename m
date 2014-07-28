Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbaG1DmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:42:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaG1DmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAFdhcLRzT-ia5W7Bz3RNAsX75EUeGKFXZdNcyxWMJJJ-JH_KvA@mail.gmail.com>
References: <CAFdhcLRzT-ia5W7Bz3RNAsX75EUeGKFXZdNcyxWMJJJ-JH_KvA@mail.gmail.com>
Date: Mon, 28 Jul 2014 11:42:03 +0800
Message-ID: <CACVXFVO9OEG7OPRdtYNbp3DqYqQcAN3iqBRFpF02qo7Uc2YrBw@mail.gmail.com>
Subject: Re: [PATCH 9/9] block: loop: support to submit I/O via kernel aio based
From: Ming Lei <ming.lei@canonical.com>
To: David Horner <ds2horner@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for your interest in the patch.

On Sun, Jul 27, 2014 at 10:20 PM, David Horner <ds2horner@gmail.com> wrote:
> You mention > 100 % improvement.
>
> Can you help me to run some (micro) benchmarks that I could contribute to
> V1?

Sure, no problem, generally I just run tests over the loop block device
directly, since I want to expose performance improvement.  But I did
run test bench(mkfs, copy big file and compare, ...) over filesystem
mounted on the loop device too, and looks it is stable enough.

So your benchmarks are either on loop block or filesystem, both
are fine.

> If you can direct me to relevant threads and docs that would be greatly
> appreciated.

Follows my test which was observed with 100% improvement(
throughout is doubled, actually it is more than doubled):

- losetup -f /dev/nullb0   #so /dev/loop0 will be backed with /dev/nullb0
                                      #if it is the 1st loop device

- run below fio script[1] in single job to test direct randread on /dev/loop0

- it is just for single job improvement, with more than 1 jobs, the
throughout should be increased more with blk-mq conversion

I will send out V1 this week, and more test cases may be posted
too.


[1], fio test script
[global]
direct=1
size=32G
bsrange=4k-4k
timeout=20
numjobs=1
ioengine=libaio
iodepth=64
filename=/dev/loop0
group_reporting=1

[f]
rw=randread


Thanks,
