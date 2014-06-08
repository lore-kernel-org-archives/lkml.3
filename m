Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaFHGID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 02:08:03 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42027 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaFHGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 02:08:00 -0400
Date: Sun, 8 Jun 2014 08:03:16 +0200
From: Henrik Austad <henrik@austad.us>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, rjw@rjwysocki.net,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140608060316.GA18179@austad.us>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 07:16:29PM +0100, Morten Rasmussen wrote:
> The Energy-aware scheduler implementation is guarded by
> CONFIG_SCHED_ENERGY.
> 
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  arch/arm/Kconfig |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index ab438cb..bfc3a85 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig

Is this going to be duplicate for each architecture enabling this? Why
not make a kernel/Kconfig.energy and link to that from those
architectures using it?

> @@ -1926,6 +1926,11 @@ config XEN
>  	help
>  	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
>  
> +config SCHED_ENERGY
> +	bool "Energy-aware scheduling (EXPERIMENTAL)"
> +	help
> +	  Highly experimental energy aware task scheduling.
> +

how about adding *slightly* more info here? :) (yes, yes, I know it's an RFC)

"""
Highly experimental energy aware task scheduling.

This will allow the kernel to keep track of energy required for
different capacity levels for a given CPU. That way, the scheduler can
make more informed decisions as to where a newly woken task should be
placed. Heterogenous platform will benefit the most from this option.

Enabling this will add a significant overhead for a task-switch.

If unsure, say N here.
"""

>  endmenu
>  
>  menu "Boot options"
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Henrik Austad
