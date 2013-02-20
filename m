Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3BTRCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:02:40 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:33551 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3BTRCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:02:39 -0500
MIME-Version: 1.0
In-Reply-To: <1361373550-4011-2-git-send-email-clark.williams@gmail.com>
References: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
	<1361373550-4011-2-git-send-email-clark.williams@gmail.com>
Date: Wed, 20 Feb 2013 09:02:21 -0800
Message-ID: <CA+8MBb+-Btdiga9omw0g_jU2eH5DwHDmNC5n1qqh9tgFjtXN7A@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: move RR_TIMESLICE from sysctl.h to rt.h
From: Tony Luck <tony.luck@gmail.com>
To: Clark Williams <clark.williams@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 7:19 AM, Clark Williams
<clark.williams@gmail.com> wrote:
> Signed-off-by: Clark Williams <clark.williams@gmail.com>
> ---

This happens to unbreak the ia64 build which is currently grumbling about:

arch/ia64/kernel/init_task.c:38: error: 'RR_TIMESLICE' undeclared here
(not in a function)

So I'd be happy if it got applied directly to Linus tree before I get too big of
a bisection gap.

Acked-by: Tony Luck <tony.luck@intel.com>

>  include/linux/sched/rt.h     | 6 ++++++
>  include/linux/sched/sysctl.h | 6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
> index 94e19ea..440434d 100644
> --- a/include/linux/sched/rt.h
> +++ b/include/linux/sched/rt.h
> @@ -55,4 +55,10 @@ static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
>  extern void normalize_rt_tasks(void);
>
>
> +/*
> + * default timeslice is 100 msecs (used only for SCHED_RR tasks).
> + * Timeslices get refilled after they expire.
> + */
> +#define RR_TIMESLICE           (100 * HZ / 1000)
> +
>  #endif /* _SCHED_RT_H */
> diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
> index d2bb0ae..bf8086b 100644
> --- a/include/linux/sched/sysctl.h
> +++ b/include/linux/sched/sysctl.h
> @@ -91,12 +91,6 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
>  extern unsigned int sysctl_sched_autogroup_enabled;
>  #endif
>
> -/*
> - * default timeslice is 100 msecs (used only for SCHED_RR tasks).
> - * Timeslices get refilled after they expire.
> - */
> -#define RR_TIMESLICE           (100 * HZ / 1000)
> -
>  extern int sched_rr_timeslice;
>
>  extern int sched_rr_handler(struct ctl_table *table, int write,
> --
> 1.8.1.2
>
> --
