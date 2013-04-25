Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3DYGpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:45:20 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57547 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3DYGpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:45:18 -0400
Message-ID: <5178D049.9090303@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 12:12:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] idle: fix hlt/nohlt command-line handling in new generic
 idle
References: <1366849153-25564-1-git-send-email-khilman@linaro.org>
In-Reply-To: <1366849153-25564-1-git-send-email-khilman@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042506-2000-0000-0000-00000BDCF4D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 05:49 AM, Kevin Hilman wrote:
> commit d1669912 (idle: Implement generic idle function) added a new
> generic idle along with support for hlt/nohlt command line options to
> override default idle loop behavior.  However, the command-line
> processing is never compiled.
> 
> The command-line handling is wrapped by CONFIG_GENERIC_IDLE_POLL_SETUP
> and arches that use this feature select it in their Kconfigs.
> However, no Kconfig definition was created for this option, so it is
> never enabled, and therefore command-line override of the idle-loop
> behavior is broken after migrating to the generic idle loop.
> 
> To fix, add a Kconfig definition for GENERIC_IDLE_POLL_SETUP.
> 
> Tested on ARM (OMAP4/Panda) which enables the command-line overrides
> by default.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> Applies on tip/smp/hotplug where generic idle feature is added
>
>  arch/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 1455579..e0ef57b 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -216,6 +216,9 @@ config USE_GENERIC_SMP_HELPERS
>  config GENERIC_SMP_IDLE_THREAD
>         bool
> 
> +config GENERIC_IDLE_POLL_SETUP
> +       bool
> +
>  # Select if arch init_task initializer is different to init/init_task.c
>  config ARCH_INIT_TASK
>         bool
> 

