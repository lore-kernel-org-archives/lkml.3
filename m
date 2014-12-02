Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaLBBYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:24:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47205 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaLBBYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:24:50 -0500
Message-ID: <547D146B.3070407@huawei.com>
Date: Tue, 2 Dec 2014 09:22:51 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: <lizf@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3.4 43/91] perf: Fix a race condition in perf_remove_from_context()
References: <1417077368-9217-1-git-send-email-lizf@kernel.org> <1417077794-9299-43-git-send-email-lizf@kernel.org> <20141201184324.GA5032@us.ibm.com>
In-Reply-To: <20141201184324.GA5032@us.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | diff --git a/kernel/events/core.c b/kernel/events/core.c
> | index 685ce46..c958be1 100644
> | --- a/kernel/events/core.c
> | +++ b/kernel/events/core.c
> | @@ -1702,6 +1702,16 @@ retry:
> |  	 */
> |  	if (ctx->is_active) {
> |  		raw_spin_unlock_irq(&ctx->lock);
> | +		/*
> | +		 * Reload the task pointer, it might have been changed by
> | +		 * a concurrent perf_event_context_sched_out().
> | +		 */
> | +		task = ctx->task;
> | +		/*
> | +		 * Reload the task pointer, it might have been changed by
> | +		 * a concurrent perf_event_context_sched_out().
> | +		 */
> | +		task = ctx->task;
> 
> Something wrong in the way the patch was applied ?
> The lines are identical...
> 
> The original commit, 3577af70, has the change applied in two
> places: perf_event_disable() and perf_remove_from_context().
> 

I guess it's because the two parts of the original patch are identical,
so the patch command wasn't smart enough to do the right work.

It looks to me this won't make things worse than bebore, so I'll fix
it in 3.4.106.

Thanks for spotting this!

