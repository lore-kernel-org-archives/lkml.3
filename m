Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3KNKug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:50:36 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58399 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3KNKud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:50:33 -0500
Date: Thu, 14 Nov 2013 16:20:17 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131114105017.GD543@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <20131113151718.GN21461@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131113151718.GN21461@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111410-5806-0000-0000-00002369C5BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +			/*
> +			 * build_sched_domains() -> init_sched_groups_power()
> +			 * gets here before we've attached the domains to the
> +			 * runqueues.
> +			 *
> +			 * Use power_of(), which is set irrespective of domains
> +			 * in update_cpu_power().
> +			 *
> +			 * This avoids power/power_orig from being 0 and
> +			 * causing divide-by-zero issues on boot.
> +			 *
> +			 * Runtime updates will correct power_orig.
> +			 */
> +			if (!rq->sd) {

Because this condition is only true during boot up, I am now
thinking if we should do mark this as unlikely i.e if (unlikely(!rq->sd)) {

Peter, 

Please do let me know if you agree and if you want to spin of a new
version?

> +				power_orig += power_of(cpu);
> +				power += power_of(cpu);
> +				continue;
> +			}
> +
> +			sgp = rq->sd->groups->sgp;
> +			power_orig += sgp->power_orig;
> +			power += sgp->power;
>  		}
>  	} else  {
>  		/*
> 

-- 
Thanks and Regards
Srikar Dronamraju

