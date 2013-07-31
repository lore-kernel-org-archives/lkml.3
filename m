Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3GaV15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:27:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49486 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab3GaV14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:27:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Re-arrange header files
Date: Wed, 31 Jul 2013 23:38:07 +0200
Message-ID: <5948193.cosVqkRF9h@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <be0fa53fe03550ec49b8bade1af7d4e1f6e06b39.1375284946.git.viresh.kumar@linaro.org>
References: <be0fa53fe03550ec49b8bade1af7d4e1f6e06b39.1375284946.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 09:05:57 PM Viresh Kumar wrote:
> This exercise has been done earlier but hasn't been done for few files. Lets do
> it now. It targets to fix following problems:
> - Include headers in ascending order, so that we don't add same multiple times
>   by mistake.

Normally, I'd regard that as pointless churn, but why don't you actually
remove direct #includes already included through cpufreq.h when you're at it?

For example, what's the point of including cpumask.h directly from
cpufreq_governor.c if it includes cpufreq.h too?

Also it doesn't look like all of the includes are really necessary.

> - <asm/> must be included after <linux/>, so that they override whatever they
>   need.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c             | 23 +++++++++++------------
>  drivers/cpufreq/cpufreq_governor.c    |  2 +-
>  drivers/cpufreq/cpufreq_ondemand.c    |  2 +-
>  drivers/cpufreq/cpufreq_performance.c |  4 ++--
>  drivers/cpufreq/cpufreq_powersave.c   |  4 ++--
>  drivers/cpufreq/cpufreq_stats.c       | 12 ++++++------
>  include/linux/cpufreq.h               | 10 +++++-----
>  7 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 170d344..d5f2a09 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -17,25 +17,24 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <asm/cputime.h>
> +#include <linux/cpu.h>
> +#include <linux/cpufreq.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
> +#include <linux/mutex.h>
>  #include <linux/notifier.h>
> -#include <linux/cpufreq.h>
> -#include <linux/delay.h>
> -#include <linux/interrupt.h>
> -#include <linux/spinlock.h>
> -#include <linux/tick.h>
> -#include <linux/device.h>
>  #include <linux/slab.h>
> -#include <linux/cpu.h>
> -#include <linux/completion.h>
> -#include <linux/mutex.h>
> +#include <linux/spinlock.h>
>  #include <linux/syscore_ops.h>
> -
> +#include <linux/tick.h>
>  #include <trace/events/power.h>
> +#include <asm/cputime.h>
>  
>  /**
>   * The "cpufreq driver" - the arch- or hardware-dependent low
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 7409dbd..5876788 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -16,7 +16,6 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <asm/cputime.h>
>  #include <linux/cpufreq.h>
>  #include <linux/cpumask.h>
>  #include <linux/export.h>
> @@ -25,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
> +#include <asm/cputime.h>
>  
>  #include "cpufreq_governor.h"
>  
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index a3c5574..d3344b5 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -12,6 +12,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/cpu.h>
>  #include <linux/cpufreq.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -24,7 +25,6 @@
>  #include <linux/sysfs.h>
>  #include <linux/tick.h>
>  #include <linux/types.h>
> -#include <linux/cpu.h>
>  
>  #include "cpufreq_governor.h"
>  
> diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
> index 9fef7d6..bdfda75 100644
> --- a/drivers/cpufreq/cpufreq_performance.c
> +++ b/drivers/cpufreq/cpufreq_performance.c
> @@ -12,10 +12,10 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <linux/kernel.h>
> -#include <linux/module.h>
>  #include <linux/cpufreq.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
>  
>  static int cpufreq_governor_performance(struct cpufreq_policy *policy,
>  					unsigned int event)
> diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
> index 32109a1..47235e2 100644
> --- a/drivers/cpufreq/cpufreq_powersave.c
> +++ b/drivers/cpufreq/cpufreq_powersave.c
> @@ -12,10 +12,10 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <linux/kernel.h>
> -#include <linux/module.h>
>  #include <linux/cpufreq.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
>  
>  static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
>  					unsigned int event)
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index cb38413..7610e4b 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -9,17 +9,17 @@
>   * published by the Free Software Foundation.
>   */
>  
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
>  #include <linux/cpu.h>
> -#include <linux/sysfs.h>
>  #include <linux/cpufreq.h>
> -#include <linux/module.h>
>  #include <linux/jiffies.h>
> -#include <linux/percpu.h>
> +#include <linux/kernel.h>
>  #include <linux/kobject.h>
> -#include <linux/spinlock.h>
> +#include <linux/module.h>
>  #include <linux/notifier.h>
> +#include <linux/percpu.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
>  #include <asm/cputime.h>
>  
>  static spinlock_t cpufreq_stats_lock;
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index e1fd215..247d83a 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -11,15 +11,15 @@
>  #ifndef _LINUX_CPUFREQ_H
>  #define _LINUX_CPUFREQ_H
>  
> -#include <asm/cputime.h>
> +#include <linux/cpumask.h>
> +#include <linux/completion.h>
> +#include <linux/kobject.h>
>  #include <linux/mutex.h>
>  #include <linux/notifier.h>
> -#include <linux/threads.h>
> -#include <linux/kobject.h>
>  #include <linux/sysfs.h>
> -#include <linux/completion.h>
> +#include <linux/threads.h>
>  #include <linux/workqueue.h>
> -#include <linux/cpumask.h>
> +#include <asm/cputime.h>
>  #include <asm/div64.h>
>  
>  #define CPUFREQ_NAME_LEN 16
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
