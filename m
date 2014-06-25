Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaFYJyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:54:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:17963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaFYJyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:54:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="553001892"
Date: Wed, 25 Jun 2014 17:54:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jet Chen <jet.chen@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "Su, Tao" <tao.su@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [cpufreq] kernel BUG at kernel/irq_work.c:175!
Message-ID: <20140625095444.GA1635@localhost>
References: <20140625093650.GD27280@localhost>
 <CAKohpo=qmJktRviycErY205xo=-MJ1NZG-uGidRXjO+aAEczEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=qmJktRviycErY205xo=-MJ1NZG-uGidRXjO+aAEczEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nothing specific to my tree, its there in linux-next and PeterZ is
> already working on it:
> 
> https://lkml.org/lkml/2014/6/25/25

That's great! Sorry I should have googled LKML before reporting this error.

Fengguang

> Last diff from him:
> 
> ---
>  kernel/irq_work.c |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> Index: linux-2.6/kernel/irq_work.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq_work.c
> +++ linux-2.6/kernel/irq_work.c
> @@ -160,21 +160,11 @@ static void irq_work_run_list(struct lli
>         }
>  }
> 
> -static void __irq_work_run(void)
> +static void irq_work_run(void)
>  {
>         irq_work_run_list(&__get_cpu_var(raised_list));
>         irq_work_run_list(&__get_cpu_var(lazy_list));
>  }
> -
> -/*
> - * Run the irq_work entries on this cpu. Requires to be ran from hardirq
> - * context with local IRQs disabled.
> - */
> -void irq_work_run(void)
> -{
> -       BUG_ON(!in_irq());
> -       __irq_work_run();
> -}
>  EXPORT_SYMBOL_GPL(irq_work_run);
