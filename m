Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3KLKgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:36:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55265 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3KLKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:36:20 -0500
Date: Tue, 12 Nov 2013 11:36:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        l.majewski@samsung.com
Subject: Re: [RFC][PATCH v5 07/14] sched: get CPU's activity statistic
Message-ID: <20131112103610.GG4971@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-7-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382097147-30088-7-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:52:20PM +0200, Vincent Guittot wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index db9b871..7e26f65 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -179,6 +179,11 @@ void sched_init_granularity(void)
>  }
>  
>  #ifdef CONFIG_SMP
> +static unsigned long available_of(int cpu)
> +{
> +	return cpu_rq(cpu)->cpu_available;
> +}
> +
>  #ifdef CONFIG_SCHED_PACKING_TASKS
>  /*
>   * Save the id of the optimal CPU that should be used to pack small tasks

This hunk wants to be in the previous patch, as I'm fairly sure I saw
this function used there.
