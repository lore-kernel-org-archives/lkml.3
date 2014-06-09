Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaFIHu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:50:29 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:46657 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaFIHu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOu_J6kXB0rFJ+Z1-FcUwEVQ7dhKZseQBzVONhT1wG=41zFNGA@mail.gmail.com>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<CAOu_J6kXB0rFJ+Z1-FcUwEVQ7dhKZseQBzVONhT1wG=41zFNGA@mail.gmail.com>
Date: Mon, 9 Jun 2014 15:50:25 +0800
Message-ID: <CACVXFVNGB0JzRVE8rQru3s12s0U9gtxd0t_ZhnUHQao4ppH8DQ@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 2:00 PM, Matias Bjørling <m@bjorling.me> wrote:
> On Mon, Jun 9, 2014 at 6:35 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Fri, Jun 6, 2014 at 8:20 PM, Matias Bjørling <m@bjorling.me> wrote:
>>> This converts the current NVMe driver to utilize the blk-mq layer.
>>
>> Looks it can't be applied cleanly against 3.15-rc8 + Jens's for-linux
>> branch, when I fix the conflict manually, below failure is triggered:
>>
>> [  487.696057] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>> [  487.699005] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>> [  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>> [  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>> [  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
>> [  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0
>>
>>
>> when running fio randread(libaio, iodepth:64) with more than 3 jobs.
>>
>> And looks no such failure when jobs is 1 or 2.
>
> Can you try with the nvmemq_review branch at
>
> https://github.com/MatiasBjorling/linux-collab.git

Looks git-pull from the branch does work, so you
might have out-of-tree patches.


Thanks,
-- 
Ming Lei
