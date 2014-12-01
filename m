Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaLASnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:43:52 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59560 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbaLASnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:43:51 -0500
Date: Mon, 1 Dec 2014 10:43:24 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: lizf@kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 43/91] perf: Fix a race condition in
 perf_remove_from_context()
Message-ID: <20141201184324.GA5032@us.ibm.com>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
 <1417077794-9299-43-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417077794-9299-43-git-send-email-lizf@kernel.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120118-0029-0000-0000-0000014505EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lizf@kernel.org [lizf@kernel.org] wrote:
| From: Cong Wang <cwang@twopensource.com>
| 
| 3.4.105-rc1 review patch.  If anyone has any objections, please let me know.
| 
<snip>
| 
| diff --git a/kernel/events/core.c b/kernel/events/core.c
| index 685ce46..c958be1 100644
| --- a/kernel/events/core.c
| +++ b/kernel/events/core.c
| @@ -1702,6 +1702,16 @@ retry:
|  	 */
|  	if (ctx->is_active) {
|  		raw_spin_unlock_irq(&ctx->lock);
| +		/*
| +		 * Reload the task pointer, it might have been changed by
| +		 * a concurrent perf_event_context_sched_out().
| +		 */
| +		task = ctx->task;
| +		/*
| +		 * Reload the task pointer, it might have been changed by
| +		 * a concurrent perf_event_context_sched_out().
| +		 */
| +		task = ctx->task;

Something wrong in the way the patch was applied ?
The lines are identical...

The original commit, 3577af70, has the change applied in two
places: perf_event_disable() and perf_remove_from_context().

|  		goto retry;
|  	}
| 
| -- 
| 1.9.1
| 
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/

