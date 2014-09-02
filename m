Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaIBRHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:07:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46914 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaIBRHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:07:33 -0400
Date: Tue, 2 Sep 2014 10:07:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stefan Hengelein <stefan.hengelein@fau.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz,
        paul.gortmaker@windriver.com, mhocko@suse.cz, mattst88@gmail.com,
        josh@joshtriplett.org, geert@linux-m68k.org, khilman@linaro.org,
        Andreas Ruprecht <rupran@einserver.de>
Subject: Re: [PATCH] init/Kconfig: move RCU_NOCB_CPU dependencies to choice
Message-ID: <20140902170726.GF5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1409317700-3836-1-git-send-email-stefan.hengelein@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409317700-3836-1-git-send-email-stefan.hengelein@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090217-6688-0000-0000-00000474E125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 03:08:20PM +0200, Stefan Hengelein wrote:
> Every choice item of the "Build-forced no-CBs CPUs" choice had a
> dependency to RCU_NOCB_CPU. It's more comprehensible if the choice
> itself has the dependency instead of every choice item.
> The choice itself doesn't need to be visible if there are no items
> selectable (i.e. on arch/frv) or RCU_NOCB_CPU is not defined.
> 
> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
> Signed-off-by: Andreas Ruprecht <rupran@einserver.de>

Looks like a nice improvement, but could you please forward-port to branch
rcu/dev of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git?

								Thanx, Paul

> ---
>  init/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 197b563..d604000 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -729,6 +729,7 @@ config RCU_NOCB_CPU
>  choice
>  	prompt "Build-forced no-CBs CPUs"
>  	default RCU_NOCB_CPU_NONE
> +	depends on RCU_NOCB_CPU
>  	help
>  	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
>  	  from kthreads rather than from softirq context) to be specified
> @@ -737,7 +738,7 @@ choice
> 
>  config RCU_NOCB_CPU_NONE
>  	bool "No build_forced no-CBs CPUs"
> -	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
> +	depends on !NO_HZ_FULL_ALL
>  	help
>  	  This option does not force any of the CPUs to be no-CBs CPUs.
>  	  Only CPUs designated by the rcu_nocbs= boot parameter will be
> @@ -751,7 +752,7 @@ config RCU_NOCB_CPU_NONE
> 
>  config RCU_NOCB_CPU_ZERO
>  	bool "CPU 0 is a build_forced no-CBs CPU"
> -	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
> +	depends on !NO_HZ_FULL_ALL
>  	help
>  	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
>  	  callbacks are invoked by a per-CPU kthread whose name begins
> @@ -766,7 +767,6 @@ config RCU_NOCB_CPU_ZERO
> 
>  config RCU_NOCB_CPU_ALL
>  	bool "All CPUs are build_forced no-CBs CPUs"
> -	depends on RCU_NOCB_CPU
>  	help
>  	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
>  	  boot parameter will be ignored.  All CPUs' RCU callbacks will
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

