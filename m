Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227Ab3BTMND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:13:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50655 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935139Ab3BTMNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:13:00 -0500
Date: Wed, 20 Feb 2013 13:12:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
Message-ID: <20130220121256.GD16775@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
	akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
	namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
	gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
	viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
	morten.rasmussen@arm.com
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
 <1361164062-20111-12-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361164062-20111-12-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 01:07:38PM +0800, Alex Shi wrote:
> If a sched domain is idle enough for regular power balance, power_lb
> will be set, perf_lb will be clean. If a sched domain is busy,
> their value will be set oppositely.
> 
> If the domain is suitable for power balance, but balance should not
> be down by this cpu(this cpu is already idle or full), both of perf_lb
>  and power_lb are cleared to wait a suitable cpu to do power balance.
> That mean no any balance, neither power balance nor performance balance
> will be done on this cpu.
> 
> Above logical will be implemented by incoming patches.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2e8131d..0047856 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4053,6 +4053,8 @@ struct lb_env {
>  	unsigned int		loop;
>  	unsigned int		loop_break;
>  	unsigned int		loop_max;
> +	int			power_lb;  /* if power balance needed */
> +	int			perf_lb;   /* if performance balance needed */

Those look like they're used like simple boolean flags. Why not make
them such, i.e. bitfields? See struct perf_event_attr for an example.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
