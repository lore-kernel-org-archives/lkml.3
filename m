Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbbA2LjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:39:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbA2LjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:39:17 -0500
MIME-Version: 1.0
In-Reply-To: <54CA1929.8060903@sandisk.com>
References: <54C92A47.2030709@sandisk.com>
	<CACVXFVOtOujWH5jLLf16+-MeW--aiP1N14a=4aJP2h2_UVdtsw@mail.gmail.com>
	<54CA1929.8060903@sandisk.com>
Date: Thu, 29 Jan 2015 19:39:14 +0800
Message-ID: <CACVXFVP0d=17wtH5hHP6oUtA_XZC8TmfhRvYZv_-Kug6=iMtbA@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: Fix a recently introduced scsi-mq regression
From: Ming Lei <ming.lei@canonical.com>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Thu, Jan 29, 2015 at 7:27 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 01/29/15 00:52, Ming Lei wrote:
>> On Thu, Jan 29, 2015 at 2:28 AM, Bart Van Assche
>> <bart.vanassche@sandisk.com> wrote:
>>> This patch fixes a use-after-free that was introduced via patch
>>> "blk-mq: fix hctx/ctx kobject use-after-free" (commit
>>> 76d697d10769; kernel v3.19-rc4) and fixes the following crash:
>>
>> Sorry, my fault, I shouldn't have linked mq's release with mq_kobj,
>> which may be released before running blk_cleanup_queue().
>>
>> Another approach may be to revert the faulty commit and release all
>> mq stuff in request queue's release handler(blk_release_queue)
>> which should be more safe and simple.
>
> Hello Ming,
>
> How important is the patch with commit ID 76d697d10769 ? Does it have to
> be included in kernel v3.19 or can it be postponed until kernel v3.19.1
> or kernel v3.19.2 ? If so, how about reverting that patch for kernel

The patch has been in linus tree, but it isn't marked as -stable.

> v3.19 and sending a reworked patch to Jens with a "Cc: stable" tag after
> the release of kernel v3.19 ? That last patch will then get included in
> a stable version of kernel v3.19.

Anyway, it need to be fixed, either reverted or a new patch.

I will post out one revert and another fix candidate, and let's
discuss further.


Thanks,
Ming Lei
