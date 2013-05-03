Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763124Ab3ECQ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:58:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39040 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3ECQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:58:50 -0400
Date: Fri, 3 May 2013 09:58:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] rcu: Fix full dynticks' dependency on wide RCU nocb
 mode
Message-ID: <20130503165844.GG3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1367599676-2049-1-git-send-email-fweisbec@gmail.com>
 <1367599676-2049-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367599676-2049-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050316-5406-0000-0000-0000082F465F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 06:47:55PM +0200, Frederic Weisbecker wrote:
> Commit 0637e029392386e6996f5d6574aadccee8315efa
> ("nohz: Select wide RCU nocb for full dynticks") intended
> to force CONFIG_RCU_NOCB_CPU_ALL=y when full dynticks is
> enabled.
> 
> However this option is part of a choice menu and Kconfig's
> "select" instruction has no effect on such targets.
> 
> Fix this by using reverse dependencies on the targets we
> don't want instead.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  init/Kconfig        |    4 ++--
>  kernel/time/Kconfig |    1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 66f67af..b3fdf9a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -687,7 +687,7 @@ choice
> 
>  config RCU_NOCB_CPU_NONE
>  	bool "No build_forced no-CBs CPUs"
> -	depends on RCU_NOCB_CPU
> +	depends on RCU_NOCB_CPU && !NO_HZ_FULL
>  	help
>  	  This option does not force any of the CPUs to be no-CBs CPUs.
>  	  Only CPUs designated by the rcu_nocbs= boot parameter will be
> @@ -695,7 +695,7 @@ config RCU_NOCB_CPU_NONE
> 
>  config RCU_NOCB_CPU_ZERO
>  	bool "CPU 0 is a build_forced no-CBs CPU"
> -	depends on RCU_NOCB_CPU
> +	depends on RCU_NOCB_CPU && !NO_HZ_FULL
>  	help
>  	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
>  	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index a2ddd65..e4c07b0 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -109,7 +109,6 @@ config NO_HZ_FULL
>  	select NO_HZ_COMMON
>  	select RCU_USER_QS
>  	select RCU_NOCB_CPU
> -	select RCU_NOCB_CPU_ALL
>  	select VIRT_CPU_ACCOUNTING_GEN
>  	select CONTEXT_TRACKING_FORCE
>  	select IRQ_WORK
> -- 
> 1.7.5.4
> 

