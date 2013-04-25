Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3DYLNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:13:55 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:42670 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3DYLNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
	<CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
	<CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
	<20130424161208.GA16991@mtj.dyndns.org>
	<CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
	<CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
Date: Thu, 25 Apr 2013 16:43:52 +0530
Message-ID: <CAP245DW3RwTZBXX-gcYKGDcRqrO8E86a9Y1jWNCL2kOO4+UJmA@mail.gmail.com>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, davem@davemloft.net,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 9:13 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 April 2013 09:00, Amit Kucheria <amit.kucheria@linaro.org> wrote:
>> Yes. That was my intention - preventing a prompt on existing defconfigs and
>> there by maintaining current behavior.
>
> Hmm... Following is the version after fixing all problems you reported.
> @Tejun: I have attached it too as gmail's copy-paste may break it. Please
> consider applying this series if it looks fine to you.
>
>
> ---------------x----------------x---------------------
>
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Mon, 8 Apr 2013 16:45:40 +0530
> Subject: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT for
>  power oriented workqueues
>
> Workqueues can be performance or power-oriented. Currently, most workqueues are
> bound to the CPU they were created on. This gives good performance (due to cache
> effects) at the cost of potentially waking up otherwise idle cores just to
> process some work. To save power, we can allow the work to be rescheduled on a
> core that is already awake.
>
> Workqueues created with the WQ_UNBOUND flag will allow some power savings.
> However, we don't change the default behaviour of the system.  To enable
> power-saving behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT needs to
> be turned on. This option can also be overridden by the
> workqueue.power_efficient boot parameter.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

For the series, you can add my:

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

> ---
>  Documentation/kernel-parameters.txt | 17 +++++++++++++++++
>  include/linux/workqueue.h           |  3 +++
>  kernel/power/Kconfig                | 19 +++++++++++++++++++
>  kernel/workqueue.c                  | 11 +++++++++++
>  4 files changed, 50 insertions(+)
>
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index c4fa000..22edc83 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3312,6 +3312,23 @@ bytes respectively. Such letter suffixes can
> also be entirely omitted.
>                         that this also can be controlled per-workqueue for
>                         workqueues visible under /sys/bus/workqueue/.
>
> +       workqueue.power_efficient
> +                       Workqueues can be performance or power-oriented.
> +                       Currently, most workqueues are bound to the CPU they
> +                       were created on. This gives good performance (due to
> +                       cache effects) at the cost of potentially waking up
> +                       otherwise idle cores just to process some work. To save
> +                       power, we can allow the work to be rescheduled on a core
> +                       that is already awake.
> +
> +                       Workqueues created with the WQ_UNBOUND flag will allow
> +                       some power savings.  However, we don't change the
> +                       default behaviour of the system.  To enable power-saving
> +                       behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT
> +                       needs to be turned on. This option can also be
> +                       overridden by the workqueue.power_efficient boot
> +                       parameter.
> +
>         x2apic_phys     [X86-64,APIC] Use x2apic physical mode instead of
>                         default x2apic cluster mode on platforms
>                         supporting x2apic.
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 623488f..83fa570 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -302,6 +302,9 @@ enum {
>         WQ_HIGHPRI              = 1 << 4, /* high priority */
>         WQ_CPU_INTENSIVE        = 1 << 5, /* cpu instensive workqueue */
>         WQ_SYSFS                = 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
> +       WQ_POWER_EFFICIENT      = 1 << 7, /* WQ_UNBOUND, for power
> +                                          * saving, if wq_power_efficient is
> +                                          * enabled. Unused otherwise. */
>
>         __WQ_DRAINING           = 1 << 16, /* internal: workqueue is draining */
>         __WQ_ORDERED            = 1 << 17, /* internal: workqueue is ordered */
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 5dfdc9e..018f039 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -263,6 +263,25 @@ config PM_GENERIC_DOMAINS
>         bool
>         depends on PM
>
> +config WQ_POWER_EFFICIENT
> +       bool "Workqueue allocated as UNBOUND (by default) for power efficiency"
> +       depends on PM
> +       default n
> +       help
> +         Workqueues can be performance or power-oriented. Currently, most
> +         workqueues are bound to the CPU they were created on. This gives good
> +         performance (due to cache effects) at the cost of potentially waking
> +         up otherwise idle cores just to process some work. To save power, we
> +         can allow the work to be rescheduled on a core that is already awake.
> +
> +         Workqueues created with the WQ_UNBOUND flag will allow some power
> +         savings.  However, we don't change the default behaviour of the
> +         system.  To enable power-saving behaviour, a new config option
> +         CONFIG_WQ_POWER_EFFICIENT needs to be turned on. This option can also
> +         be overridden by the workqueue.power_efficient boot parameter.
> +
> +         If in doubt, say N.
> +
>  config PM_GENERIC_DOMAINS_SLEEP
>         def_bool y
>         depends on PM_SLEEP && PM_GENERIC_DOMAINS
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 4aa9f5b..a327027 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -272,6 +272,14 @@ static cpumask_var_t *wq_numa_possible_cpumask;
>  static bool wq_disable_numa;
>  module_param_named(disable_numa, wq_disable_numa, bool, 0444);
>
> +#ifdef CONFIG_WQ_POWER_EFFICIENT
> +static bool wq_power_efficient = true;
> +#else
> +static bool wq_power_efficient;
> +#endif
> +
> +module_param_named(power_efficient, wq_power_efficient, bool, 0444);
> +
>  static bool wq_numa_enabled;           /* unbound NUMA affinity enabled */
>
>  /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug
> exclusion */
> @@ -4085,6 +4093,9 @@ struct workqueue_struct
> *__alloc_workqueue_key(const char *fmt,
>         struct workqueue_struct *wq;
>         struct pool_workqueue *pwq;
>
> +       if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
> +               flags |= WQ_UNBOUND;
> +
>         /* allocate wq and format name */
>         if (flags & WQ_UNBOUND)
>                 tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);
