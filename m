Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3FZMyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:54:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31730 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZMyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:54:22 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-04-51cae47bb41c
Date: Wed, 26 Jun 2013 14:54:12 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130626145412.1e9bfa63@amdc308.digital.local>
In-reply-to: <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jQd2aJ6cCDbatZrL483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitri8aw6bxefeI4wWtxtXsFn0L+xlsnjysI/NYv2M
	1ywWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxtJ3/ewFt9IqLqzuZ21gXOPZxcjJISFgIjHv2TlmCFtM4sK99WxdjFwc
	QgLTGSV6f19gh3DamSR6D+0Fcjg4WARUJQ7eFgdpYBPQk/h89ykTSFhEQEvi5c1UkHJmgdMs
	EjseXGMHqREW8JDYvqufFcTmFbCW+P7qEpjNKRAs0d+6iBlifguTxNlrDWBX8AtISrT/+wF1
	kZ3EuU8b2CGaBSV+TL7HAmIzAy3bvK2JFcKWl9i85i3zBEbBWUjKZiEpm4WkbAEj8ypG0dSC
	5ILipPRcQ73ixNzi0rx0veT83E2M4Oh6JrWDcWWDxSFGAQ5GJR5eha0nA4VYE8uKK3MPMUpw
	MCuJ8L6ZfypQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dU
	A+PkG0ff8+98EbF25ytWE7aqdJM09giZ33JPpn+Y43Nj1r1JLhsbtJQYbxtmz0iQWbbxHJ/b
	52UTGnL048z7X9rv1QhePeMax73XwgWa/28lvHU4qVH8ao7fhtMb807P93m06vHiuv67jmXS
	LzY9TnOrTPzwYIVY+YsfP1p0NDt/He0y+COfudhbiaU4I9FQi7moOBEAcB6W06oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 16:24:32 +0530, Viresh Kumar wrote:
> On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Boost sysfs attribute is always exported (to support legacy API). By
> > default boost is exported as read only. One global attribute is
> > available at: /sys/devices/system/cpu/cpufreq/boost.
> 
> I assume you are going to fix this as discussed in other threads.
Yes. Boost attribute will be visible only when boost is supported.

> 
> > Changes for v4:
> > - Remove boost parameter from cpufreq_frequency_table_cpuinfo()
> > function
> > - Introduce cpufreq_boost_supported() method
> > - Use of cpufreq_boost_supported() and cpufreq_boost_enabled() to
> > decide if frequency shall be skipped
> > - Rename set_boost_freq() to enable_boost()
> > - cpufreq_attr_available_freq() moved to freq_table.c
> > - Use policy list to get access to cpufreq policies
> > - Rename global boost flag (cpufreq_boost_enabled -> boost_enabled)
> > - pr_err corrected ( %sable)
> > - Remove sanity check at cpufreq_boost_trigger_state() entrance [to
> > test if boost is supported]
> > - Use either HW (boost_enable) callback or SW managed boost
> > - Introduce new cpufreq_boost_trigger_state_sw() method to handle
> > boost at SW.
> > - Protect boost_enabled manipulation with lock
> > - Always export boost attribute (preserve legacy behaviour). When
> > boost is not supported this attribute is read only
> 
> Very well written changelog. But write it after ---

I will stick to the rule proposed at patch 1/4, ver 4.

> 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 665e641..9141d33 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -40,6 +40,7 @@
> >   * also protects the cpufreq_cpu_data array.
> >   */
> >  static struct cpufreq_driver *cpufreq_driver;
> > +static bool boost_enabled;
> >  static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  /* This one keeps track of the previously set governor of a
> > removed CPU */ @@ -316,6 +317,29 @@
> > EXPORT_SYMBOL_GPL(cpufreq_notify_transition); /*********************************************************************
> >   *                          SYSFS
> > INTERFACE                          *
> > *********************************************************************/
> > +ssize_t show_boost(struct kobject *kobj,
> > +                                struct attribute *attr, char *buf)
> > +{
> > +       return sprintf(buf, "%d\n", boost_enabled);
> > +}
> > +
> > +static ssize_t store_boost(struct kobject *kobj, struct attribute
> > *attr,
> > +                                 const char *buf, size_t count)
> > +{
> > +       int ret, enable;
> > +
> > +       ret = sscanf(buf, "%d", &enable);
> > +       if (ret != 1 || enable < 0 || enable > 1)
> > +               return -EINVAL;
> > +
> > +       if (cpufreq_boost_trigger_state(enable)) {
> > +               pr_err("%s: Cannot enable boost!\n", __func__);
> > +               return -EINVAL;
> > +       }
> 
> Probably do boost_enabled = true here.

I would prefer to set boot_enabled at
cpufreq_boost_trigger_state() method. It is closer to the 
cpufreq_driver->enable_boost and cpufreq_boost_trigger_state_sw();
functions, which do change the freq.

> 
> > +       return count;
> > +}
> > +define_one_global_rw(boost);
> 
> >  /*********************************************************************
> > + *
> > BOOST                                              *
> > +
> > *********************************************************************/
> > +static int cpufreq_boost_trigger_state_sw(void) +{
> > +       struct cpufreq_frequency_table *freq_table;
> > +       struct cpufreq_policy *policy;
> > +       int ret = -EINVAL;
> > +
> > +       list_for_each_entry(policy, &cpufreq_policy_list,
> > policy_list) {
> > +               freq_table =
> > cpufreq_frequency_get_table(policy->cpu);
> > +               if (freq_table)
> > +                       ret =
> > cpufreq_frequency_table_cpuinfo(policy,
> > +                                                       freq_table);
> > +       }
> > +
> > +       return ret;
> > +
> > +}
> 
> add blank line here.

OK.

> 
> > +int cpufreq_boost_trigger_state(int state)
> > +{
> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       if (boost_enabled != state) {
> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +               boost_enabled = state;
> > +               if (cpufreq_driver->enable_boost)
> > +                       ret = cpufreq_driver->enable_boost(state);
						  ^^^^^^^^^^^^^
					I would prefer to change this
					name to enable_boost_hw
It is more informative, since it is tailored to hw based boost (Intel).

> > +               else
> > +                       ret = cpufreq_boost_trigger_state_sw();
> > +
> > +               if (ret) {
> > +                       boost_enabled = 0;
> > +
> > write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > +                       pr_err("%s: BOOST cannot enable (%d)\n",
> > +                              __func__, ret);
> > +
> > +                       return ret;
> > +               }
> > +               write_unlock_irqrestore(&cpufreq_driver_lock,
> > flags);
> 
> You can rewrite if (ret) and unlock() code to make it less redundant.
> unlock and return ret at the end and write other stuff before it.

I will rewrite it as follow:

if (ret)
	boost_enabled = 0;
		
write_unlock_irqrestore(&cpufreq_driver_lock, flags);
pr_debug("%s: cpufreq BOOST %s\n", __func__,
		 state ? "enabled" : "disabled");

return ret;

> 
> > +               pr_debug("%s: cpufreq BOOST %s\n", __func__,
> > +                        state ? "enabled" : "disabled");
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +int cpufreq_boost_supported(void)
> > +{
> > +       return cpufreq_driver->boost_supported;
> > +}
> > +
> > +int cpufreq_boost_enabled(void)
> > +{
> > +       return boost_enabled;
> > +}
> 
> EXPORT_SYMBOL_GPL ??

I will export cpufreq_boost_enabled() and cpufreq_boost_supported()

> 
> > +/*********************************************************************
> >   *               REGISTER / UNREGISTER CPUFREQ
> > DRIVER                *
> > *********************************************************************/
> >
> > @@ -1936,6 +2019,16 @@ int cpufreq_register_driver(struct
> > cpufreq_driver *driver_data) cpufreq_driver = driver_data;
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> > +       if (!cpufreq_driver->boost_supported)
> > +               boost.attr.mode = 0444;
            Will be removed ^^^^^^^^^^^^^^^
> > +
> > +       ret = cpufreq_sysfs_create_file(&(boost.attr));
> > +       if (ret) {
> > +               pr_err("%s: cannot register global boost sysfs
> > file\n",
> > +                      __func__);
> > +               goto err_null_driver;
> > +       }
> 
> This would change.

This will be only exported when cpufreq_boost_supported() is true.

> 
> >         ret = subsys_interface_register(&cpufreq_interface);
> >         if (ret)
> >                 goto err_null_driver;
> > @@ -1992,6 +2085,8 @@ int cpufreq_unregister_driver(struct
> > cpufreq_driver *driver) pr_debug("unregistering driver %s\n",
> > driver->name);
> >
> >         subsys_interface_unregister(&cpufreq_interface);
> > +
> > +       cpufreq_sysfs_remove_file(&(boost.attr));
> >         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
> >
> >         list_del(&cpufreq_policy_list);
> > diff --git a/drivers/cpufreq/freq_table.c
> > b/drivers/cpufreq/freq_table.c index d7a7966..9c8e71e 100644
> > --- a/drivers/cpufreq/freq_table.c
> > +++ b/drivers/cpufreq/freq_table.c
> > @@ -34,6 +34,11 @@ int cpufreq_frequency_table_cpuinfo(struct
> > cpufreq_policy *policy,
> >
> >                         continue;
> >                 }
> > +               if (cpufreq_boost_supported())
> 
> Probably remove this check. Assume somebody while testing exynos,
> just sent boost_supported as false. Then you will not skip this
> frequency and may burn your chip :)

OK.

> 
> > +                       if (!cpufreq_boost_enabled()
> > +                           && table[i].index == CPUFREQ_BOOST_FREQ)
> > +                               continue;
> 
> This should be enough.

Let's only rely on the cpufreq_boost_enabled() test here.

> 
> >                 pr_debug("table entry %u: %u kHz, %u index\n",
> >                                         i, freq, table[i].index);
> >                 if (freq < min_freq)
> > @@ -171,7 +176,8 @@ static DEFINE_PER_CPU(struct
> > cpufreq_frequency_table *, cpufreq_show_table); /**
> >   * show_available_freqs - show available frequencies for the
> > specified CPU */
> > -static ssize_t show_available_freqs(struct cpufreq_policy *policy,
> > char *buf) +static ssize_t show_available_freqs(struct
> > cpufreq_policy *policy, char *buf,
> > +                                   int show_boost)
> >  {
> >         unsigned int i = 0;
> >         unsigned int cpu = policy->cpu;
> > @@ -186,6 +192,9 @@ static ssize_t show_available_freqs(struct
> > cpufreq_policy *policy, char *buf) for (i = 0;
> > (table[i].frequency != CPUFREQ_TABLE_END); i++) { if
> > (table[i].frequency == CPUFREQ_ENTRY_INVALID) continue;
> 
> Add a comment here describing your complex logic.

OK.

> 
> > +               if (show_boost ^ (table[i].index ==
> > CPUFREQ_BOOST_FREQ))
> > +                       continue;
> > +
> >                 count += sprintf(&buf[count], "%d ",
> > table[i].frequency); }
> >         count += sprintf(&buf[count], "\n");
> > @@ -194,14 +203,34 @@ static ssize_t show_available_freqs(struct
> > cpufreq_policy *policy, char *buf)
> >
> >  }
> >
> > -struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
> > -       .attr = { .name = "scaling_available_frequencies",
> > -                 .mode = 0444,
> > -               },
> > -       .show = show_available_freqs,
> > -};
> > +#define cpufreq_attr_available_freq(_name)       \
> > +struct freq_attr cpufreq_freq_attr_##_name##_freqs =     \
> > +__ATTR_RO(_name##_frequencies)
> > +
> > +/**
> > + * show_scaling_available_frequencies - show normal boost
> > frequencies for
> 
> You missed this comment earlier. boost??

My mistake. This will be corrected.

> 
> > + * the specified CPU
> > + */
> > +static ssize_t scaling_available_frequencies_show(struct
> > cpufreq_policy *policy,
> > +                                                 char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 0);
> > +}
> > +cpufreq_attr_available_freq(scaling_available);
> >  EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
> >
> > +/**
> > + * show_available_boost_freqs - show available boost frequencies
> > for
> > + * the specified CPU
> > + */
> > +static ssize_t scaling_boost_frequencies_show(struct
> > cpufreq_policy *policy,
> > +                                             char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 1);
> > +}
> > +cpufreq_attr_available_freq(scaling_boost);
> > +EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_boost_freqs);
> > +
> >  /*
> >   * if you use these, you must assure that the frequency table is
> > valid
> >   * all the time between get_attr and put_attr!
> > diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> > index 5348981..4783c4c 100644
> > --- a/include/linux/cpufreq.h
> > +++ b/include/linux/cpufreq.h
> > @@ -267,6 +267,10 @@ struct cpufreq_driver {
> >         int     (*suspend)      (struct cpufreq_policy *policy);
> >         int     (*resume)       (struct cpufreq_policy *policy);
> >         struct freq_attr        **attr;
> > +
> > +       /* platform specific boost support code */
> > +       bool                    boost_supported;
> > +       int (*enable_boost)    (int state);
> >  };
> >
> >  /* flags */
> > @@ -408,6 +412,9 @@ extern struct cpufreq_governor
> > cpufreq_gov_conservative; #define CPUFREQ_ENTRY_INVALID ~0
> >  #define CPUFREQ_TABLE_END     ~1
> >
> > +/* Define index for boost frequency */
> > +#define CPUFREQ_BOOST_FREQ    ~2
> > +
> >  struct cpufreq_frequency_table {
> >         unsigned int    index;     /* any */
> >         unsigned int    frequency; /* kHz - doesn't need to be in
> > ascending @@ -426,11 +433,15 @@ int
> > cpufreq_frequency_table_target(struct cpufreq_policy *policy,
> > unsigned int relation, unsigned int *index);
> >
> > +int cpufreq_boost_trigger_state(int state);
> 
> Why is this present here?

We had agreed to talk only about cpufreq :-).

This declaration will be removed.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
