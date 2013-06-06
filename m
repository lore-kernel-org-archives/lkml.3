Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab3FFLtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:49:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20668 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab3FFLtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:49:12 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-36-51b07736d879
Date: Thu, 06 Jun 2013 13:49:03 +0200
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
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 2/5] cpufreq:boost: Add support for software based CPU
 frequency boost
Message-id: <20130606134903.5f69b8fb@amdc308.digital.local>
In-reply-to: <CAKohpok3KTfSWDU6PdDd4_VW4Pp+6J80yn5cLrYr5RuBNH-agA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-3-git-send-email-l.majewski@samsung.com>
 <CAKohpok3KTfSWDU6PdDd4_VW4Pp+6J80yn5cLrYr5RuBNH-agA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xoK5Z+YZAg6dzJSz+vF3OavG06Qe7
	xbzPshadZ58wW7x5xG3x/tAzZovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx+1/j5k91k17y+zRt2UVo8ejxS2MHp83yQWwRXHZpKTmZJalFunbJXBl/L//hr3gfHnF
	jFt3mBoYL4R1MXJySAiYSExf38gGYYtJXLi3Hsjm4hASmM4oMfXzHBaQhJBAO5PE2ymMIDaL
	gKrE6evPmEBsNgE9ic93nwLZHBwiAloSL2+mgvQyC/xilmh5tYAZpEZYIEbizMbHYPW8AtYS
	5+7/AYtzCgRLnGz7yAyx7ASjxNqrl8CK+AUkJdr//WCGuMhO4tynDewQzYISPybfAzuIGWjZ
	5m1NrBC2vMTmNW+ZJzAKzkJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BEfNM+kdjKsaLA4xCnAwKvHwSgSsDxRiTSwrrsw9xCjBwawkwrvLZ0OgEG9KYmVValF+fFFp
	TmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkZex5snF7NF8S55lKL7TuR0mLBE
	/O5Jf/4cPnnq6MTjVz6XPd5acaCizcPZWHqJ19qV25mmly/6+MB8r6FJ0Ep5AwZp97Q/658W
	21iLcp9NOHxD3m7zRSf/F6dln76avvWMP+cXS8+SnGeRaTK2O3Q62ea/KY9zP3OEie+rf29t
	2Y3kf6aRXR5KLMUZiYZazEXFiQCpmvNAlgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> Hi,
> 
> On 6 June 2013 12:37, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > This commit adds support for software based frequency boosting.
> > Exynos4 SoCs (e.g. 4x12) allow setting of frequency above its normal
> > condition limits. This can be done for some short time.
> >
> > Overclocking (boost) support came from cpufreq driver (which is
> > platform dependent). Hence the data structure describing it is
> > defined at its file.
> >
> > To allow support for either SW and HW (Intel) based boosting, the
> > cpufreq core code has been extended to support both solutions.
> >
> > The main boost switch has been put
> > at /sys/devices/system/cpu/cpufreq/boost.
> 
> Log requires some better paragraphs but I am not concerned about it
> for now.
> 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> > ---
> >  drivers/cpufreq/cpufreq.c    |  156
> > ++++++++++++++++++++++++++++++++++++++++++
> > drivers/cpufreq/freq_table.c |   87 ++++++++++++++++++++++-
> > include/linux/cpufreq.h      |   35 +++++++++- 3 files changed, 275
> > insertions(+), 3 deletions(-)
> 
> My initial view on this patch is: "It is overly engineered and needs
> to get simplified"
> 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index ca74e27..8cf9a92 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -133,6 +133,11 @@ bool have_governor_per_policy(void)
> >         return cpufreq_driver->have_governor_per_policy;
> >  }
> >
> > +/**
> > + * Global definition of cpufreq_boost structure
> > + */
> > +struct cpufreq_boost *cpufreq_boost;
> 
> Probably just a 'static bool' here cpufreq_boost_enabled. Which takes
> care of selection from sysfs.

The pointer to struct cpufreq_boost is needed for further reference
(as it is now done with struct cpufreq_driver pointer - *cpufreq_driver
- defined at cpufreq.c file).


> 
> >  static struct cpufreq_governor *__find_governor(const char
> > *str_governor) {
> > @@ -761,6 +805,18 @@ static int cpufreq_add_dev_interface(unsigned
> > int cpu, if (cpufreq_set_drv_attr_files(policy,
> > cpufreq_driver->attr)) goto err_out_kobj_put;
> >
> > +       if (cpufreq_driver->boost) {
> > +               if (sysfs_create_file(cpufreq_global_kobject,
> > +                                     &(global_boost.attr)))
> 
> This will report error for systems where we have two policy
> structures. As we are creating something already present.
Good point, thanks.

> 
> > +                       pr_warn("could not register global boost
> > sysfs file\n");
> > +               else
> > +                       pr_debug("registered global boost sysfs
> > file\n");
> 
> Please make all your prints to print function name too:
> 
> pr_debug("%s: foo\n", __func__, foo);

OK.

> 
> > +               if (cpufreq_set_drv_attr_files(policy,
> > +
> > cpufreq_driver->boost->attr))
> 
> Why is this required? Why do we want platforms to add some files
> in sysfs?

There are two kinds of attributes, which are exported by boost:

1. global boost (/sys/devices/system/cpu/cpufreq/boost)

2. attributes describing cpufreq abilities when boost is available
(/sys/devices/syste/cpu/cpu0/cpufreq/):
	- scaling_boost_frequencies - which will show over clocked
	  frequencies
	- the scaling_available_frequencies will also display boosted
	  frequency (when boost enabled)

Information from 2. is cpufreq_driver dependent. And that information
shouldn't been displayed when boost is not available



> 
> >  /*********************************************************************
> > + *
> > BOOST                                              *
> > +
> > *********************************************************************/
> > +int cpufreq_boost_trigger_state(struct cpufreq_policy *policy, int
> > state) +{
> > +       struct cpufreq_boost *boost;
> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       if (!policy || !policy->boost
> > || !policy->boost->low_level_boost)
> > +               return -ENODEV;
> > +
> > +       boost = policy->boost;
> > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +
> > +       if (boost->status != state) {
> > +               policy->boost->status = state;
> > +               ret = boost->low_level_boost(policy, state);
> > +               if (ret) {
> > +                       pr_err("BOOST cannot %sable low level code
> > (%d)\n",
> > +                              state ? "en" : "dis", ret);
> > +                       return ret;
> > +               }
> > +       }
> > +
> > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > +
> > +       pr_debug("cpufreq BOOST %sabled\n", state ? "en" : "dis");
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * cpufreq_boost_notifier - notifier callback for cpufreq policy
> > change.
> > + *  <at> nb:   struct notifier_block * with callback info.
> > + *  <at> event: value showing cpufreq event for which this
> > function invoked.
> > + *  <at> data: callback-specific data
> > + */
> > +static int cpufreq_boost_notifier(struct notifier_block *nb,
> > +                                 unsigned long event, void *data)
> > +{
> > +       struct cpufreq_policy *policy = data;
> > +
> > +       if (event == CPUFREQ_INCOMPATIBLE) {
> > +               if (!policy || !policy->boost)
> > +                       return -ENODEV;
> > +
> > +               if (policy->boost->status == CPUFREQ_BOOST_EN) {
> > +                       pr_info("NOTIFIER BOOST: MAX: %d e:%lu cpu:
> > %d\n",
> > +                               policy->max, event, policy->cpu);
> > +                       cpufreq_boost_trigger_state(policy, 0);
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +/* Notifier for cpufreq policy change */
> > +static struct notifier_block cpufreq_boost_notifier_block = {
> > +       .notifier_call = cpufreq_boost_notifier,
> > +};
> > +
> > +int cpufreq_boost_init(struct cpufreq_policy *policy)
> > +{
> > +       int ret = 0;
> > +
> > +       if (!policy)
> > +               return -EINVAL;
> 
> Heh, policy can't be NULL here.

Extra precautions :-). I will remove it.

> 
> > +       if (!cpufreq_driver->boost) {
> > +               pr_err("Boost mode not supported on this device\n");
> 
> Wow!! You want to screw everybody else's logs with this message.
> Its not a crime if you don't have boost mode supported :)

Hmm, I've exaggerated a bit here.... :)

> 
> Actually this routine must be called only if cpufreq_driver->boost
> is valid.
> 
> > +               return -ENODEV;
> > +       }
> > +
> > +       policy->boost = cpufreq_boost = cpufreq_driver->boost;
> 
> Why are we copying same pointer to policy->boost? Driver is
> passing pointer to a single memory location, just save it globally.

This needs some explanation.

The sysfs entry presented at [1] doesn't bring any useful information
to reuse (like *policy). For this reason the global cpufreq_boost
pointer is needed.

However to efficiently manage the boost, it is necessary to keep per
policy pointer to the only struct cpufreq_boost instance (defined at
cpufreq_driver code).

> 
> > +       /* disable boost for newly created policy - as we e.g.
> > change
> > +          governor */
> > +       policy->boost->status = CPUFREQ_BOOST_DIS;
> 
> Drivers supporting boost may want boost to be enabled by default,
> maybe without any sysfs calls.

This can be done by setting the struct cpufreq_boost status field to
CPUFREQ_BOOST_EN at cpufreq driver code (when boost structure is
defined)

> 
> > +       /* register policy notifier */
> > +       ret =
> > cpufreq_register_notifier(&cpufreq_boost_notifier_block,
> > +                                       CPUFREQ_POLICY_NOTIFIER);
> > +       if (ret) {
> > +               pr_err("CPUFREQ BOOST notifier not registered.\n");
> > +               return ret;
> > +       }
> > +       /* add policy to policies list headed at struct
> > cpufreq_boost */
> > +       list_add_tail(&policy->boost_list,
> > &cpufreq_boost->policies); +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_boost_init);
> 
> Why do we need to maintain a list of boost here? notifiers? complex :(

Notifier is needed to disable boost when policy is changed (for
example when we change from ondemand/lab to performance governor).

I wanted to avoid the situation when boost stays enabled across
different governors.

The list of in system available policies is defined to allow boost
enable/disable for all policies available (by changing for example
policy->max field).

If we decide, that we will support only one policy (as it is now at
e.g. Exynos), the list is unnecessary here.

> 
> > +/*********************************************************************
> >   *               REGISTER / UNREGISTER CPUFREQ
> > DRIVER                *
> > *********************************************************************/
> >
> > @@ -1954,6 +2106,10 @@ int cpufreq_unregister_driver(struct
> > cpufreq_driver *driver) pr_debug("unregistering driver %s\n",
> > driver->name);
> >
> >         subsys_interface_unregister(&cpufreq_interface);
> > +
> > +       if (cpufreq_driver->boost)
> > +               sysfs_remove_file(cpufreq_global_kobject,
> > &(global_boost.attr));
> 
> You haven't removed this from policy. Memory leak.

Yes, you are right.

> 
> >         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
> >
> >         write_lock_irqsave(&cpufreq_driver_lock, flags);
> > diff --git a/drivers/cpufreq/freq_table.c
> > b/drivers/cpufreq/freq_table.c index d7a7966..0e95524 100644
> > --- a/drivers/cpufreq/freq_table.c
> > +++ b/drivers/cpufreq/freq_table.c
> > @@ -3,6 +3,8 @@
> >   *
> >   * Copyright (C) 2002 - 2003 Dominik Brodowski
> >   *
> > + * Copyright (C) 2013 Lukasz Majewski <l.majewski@samsung.com>
> > + *
> 
> You shouldn't add it unless you did some major work on this file. You
> aren't maintaining this file in 2013.

OK, I will remove the entry.

> 
> > +static int cpufreq_frequency_table_skip_boost(struct
> > cpufreq_policy *policy,
> > +                                             unsigned int index)
> > +{
> > +       if (index == CPUFREQ_BOOST)
> > +               if (!policy->boost ||
> 
> This shouldn't be true. If index has got CPUFREQ_BOOST, then driver
> has to support boost.

Correct me if I'm wrong here, but in my understanding the boost shall be
only supported when both CPUFREQ_BOOST index is defined in a freq_table
and boost.state = CPUFREQ_BOOST_EN is set.

Setting of CPUFREQ_BOOST shouldn't by default allow to use over
clocking frequency. 

> 
> > +                   policy->boost->status == CPUFREQ_BOOST_DIS)
> > +                       return 1;
> > +
> > +       return 0;
> > +}
> > +
> > +unsigned int
> > +cpufreq_frequency_table_boost_max(struct cpufreq_frequency_table
> > *freq_table) +{
> > +       int index, boost_freq_max;
> > +
> > +       for (index = 0, boost_freq_max = 0;
> > +               freq_table[index].frequency != CPUFREQ_TABLE_END;
> > index++)
> > +               if (freq_table[index].index == CPUFREQ_BOOST) {
> > +                       if (freq_table[index].frequency >
> > boost_freq_max)
> > +                               boost_freq_max =
> > freq_table[index].frequency;
> > +               }
> > +
> > +       return boost_freq_max;
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_frequency_table_boost_max);
> 
> why do we need this?

To evaluate the maximal boost frequency from the frequency table. It is
then used as a delimiter (when LAB cooperates with thermal framework).

> 
> >  /*
> >   * if you use these, you must assure that the frequency table is
> > valid
> >   * all the time between get_attr and put_attr!
> > diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> > index 037d36a..1294c8c 100644
> > --- a/include/linux/cpufreq.h
> > +++ b/include/linux/cpufreq.h
> > @@ -88,6 +88,25 @@ struct cpufreq_real_policy {
> >         struct cpufreq_governor *governor; /* see below */
> >  };
> >
> > +#define CPUFREQ_BOOST_DIS            (0)
> > +#define CPUFREQ_BOOST_EN             (1)
> 
> You don't need these.. Just create variable as bool and 0 & 1 would
> be fine.

Yes, this seems to be a clearer solution.

> 
> > +struct cpufreq_policy;
> > +struct cpufreq_boost {
> > +       unsigned int            max_boost_freq; /* maximum value of
> > +                                                * boosted freq */
> > +       unsigned int            max_normal_freq; /* non boost max
> > freq */
> > +       int                     status; /* status of boost */
> > +
> > +       /* boost sysfs attributies */
> > +       struct freq_attr        **attr;
> > +
> > +       /* low-level trigger for boost */
> > +       int (*low_level_boost) (struct cpufreq_policy *policy, int
> > state); +
> > +       struct list_head        policies;
> > +};
> 
> We don't need it. Just add two more fields to cpufreq_driver:
> - have_boost_freqs and low_level_boost (maybe a better name.
> What's its use?)

The separate struct cpufreq_boost was created to explicitly separate
boost fields from cpufreq_driver structure. 

If in your opinion this structure is redundant, I can remove it and
extend cpufreq_driver structure.

> 
> >  struct cpufreq_policy {
> >         /* CPUs sharing clock, require sw coordination */
> >         cpumask_var_t           cpus;   /* Online CPUs only */
> > @@ -113,6 +132,9 @@ struct cpufreq_policy {
> >
> >         struct cpufreq_real_policy      user_policy;
> >
> > +       struct cpufreq_boost    *boost;
> > +       struct list_head        boost_list;
> 
> We don't need both of these.

*boost pointer is necessary when one wants to enable/disable boost from
e.g governor code (which operates mostly on struct cpufreq_policy
*policy pointers).

The boost_list is necessary to connect policies in a list. 

> 
> >         struct kobject          kobj;
> >         struct completion       kobj_unregister;
> >  };
> 
> > @@ -277,7 +302,6 @@ struct cpufreq_driver {
> >  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
> >  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
> >
> > -
> 
> ??
> 
> >  void cpufreq_notify_transition(struct cpufreq_policy *policy,
> >                 struct cpufreq_freqs *freqs, unsigned int state);
> >
> > @@ -403,6 +427,9 @@ extern struct cpufreq_governor
> > cpufreq_gov_conservative; #define CPUFREQ_ENTRY_INVALID ~0
> >  #define CPUFREQ_TABLE_END     ~1
> >
> > +/* Define index for boost frequency */
> > +#define CPUFREQ_BOOST         ~2
> 
> s/CPUFREQ_BOOST/CPUFREQ_BOOST_FREQ

Ok, will be changed to something more descriptive. 

Thanks for thorough review :-)

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
