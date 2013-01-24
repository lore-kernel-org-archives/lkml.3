Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3AXKIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:08:34 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40226 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3AXKIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:08:30 -0500
Date: Thu, 24 Jan 2013 11:08:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
Message-ID: <20130124100823.GE26351@gmail.com>
References: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
 <1358998243-23176-3-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358998243-23176-3-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> @@ -2539,7 +2539,11 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> +#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
> +	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
> +#else
>  	unsigned long load = this_rq->load.weight;
> +#endif

I'd not make it conditional - just calculate runnable_load_avg 
all the time (even if group scheduling is disabled) and use it 
consistently. The last thing we want is to bifurcate scheduler 
balancer behavior even further.

Thanks,

	Ingo
