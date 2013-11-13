Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab3KMP4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:56:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33210 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3KMP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:56:19 -0500
Message-ID: <5283A10E.2090304@kernel.dk>
Date: Wed, 13 Nov 2013 08:55:58 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] block: Employ u64_stats_init()
References: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 08:42 PM, John Stultz wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Now that seqcounts are lockdep enabled objects, we need to properly
> initialize them.
> 
> Without this patch, Fengguang was seeing:
> [    4.127282] INFO: trying to register non-static key.
> [    4.128027] the code is fine but needs lockdep annotation.
> [    4.128027] turning off the locking correctness validator.
> [    4.128027] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-next-20131108-10601-gbad570d #2
> [    4.128027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.128027] Workqueue: events_unbound async_run_entry_fn
> [    4.128027]  7908e744 00000000 78019968 79dc7cf2 7a80e0a8 780199a0 7908953e 7a1b7f4d
> [    4.128027]  7a1b7fa7 7a1b7f7d 7f368608 00000000 00000011 44374011 0000a805 7f368110
> [    4.128027]  7f368110 85bf2a70 00000000 780199cc 7908a1c5 00000000 00000001 00000000
> [    4.128027] Call Trace:
> [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> [    4.128027]  [<794079aa>] blk_throtl_bio+0x1c3/0x485
> ...
> 
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> [jstultz: Folded in another fix from the mailing list as well as a fix
> to that fix. Tweaked commit message.]
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Thanks for fixing this up, John/Peter. I'll get it queued up.

-- 
Jens Axboe

