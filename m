Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683Ab3BTJsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:48:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56666 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933774Ab3BTJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:48:05 -0500
Message-ID: <1361353681.10155.10.camel@laptop>
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 10:48:01 +0100
In-Reply-To: <1361164062-20111-12-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	 <1361164062-20111-12-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 13:07 +0800, Alex Shi wrote:
> @@ -4053,6 +4053,8 @@ struct lb_env {
>         unsigned int            loop;
>         unsigned int            loop_break;
>         unsigned int            loop_max;
> +       int                     power_lb;  /* if power balance needed
> */
> +       int                     perf_lb;   /* if performance balance
> needed */
>  };
>  
>  /*
> @@ -5195,6 +5197,8 @@ static int load_balance(int this_cpu, struct rq
> *this_rq,
>                 .idle           = idle,
>                 .loop_break     = sched_nr_migrate_break,
>                 .cpus           = cpus,
> +               .power_lb       = 0,
> +               .perf_lb        = 1,
>         };
>  
>         cpumask_copy(cpus, cpu_active_mask);

This construct allows for the possibility of power_lb=1,perf_lb=1, does
that make sense? Why not have a single balance_policy enumeration?

