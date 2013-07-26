Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3GZIeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:34:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18395 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZIeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:34:02 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-92-51f23472ee0b
Date: Fri, 26 Jul 2013 10:33:21 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
Message-id: <20130726103321.21238bbb@amdc308.digital.local>
In-reply-to: <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-3-git-send-email-l.majewski@samsung.com>
 <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAd0ik0+BBv/OG1hsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8f7QM2aLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPG7/e8zssW7aW2aPvi2rGD0eLW5h9Dh+YzuTx+dN
	cgEcUVw2Kak5mWWpRfp2CVwZpw5/Zyzos6roOOLSwPhNvYuRk0NCwERi7pGprBC2mMSFe+vZ
	uhi5OIQEFjFKbN28lAXCaWeSOLW6l7GLkYODRUBV4vnzBJAGNgE9ic93nzKBhEUEtCRe3kwF
	KWcWuMci0dqzBmyosICHxJFf38BqeAWsJa5+DgIJcwoES0z8/pgdYnwbk8SkdzeYQBL8ApIS
	7f9+MEMcZCdx7tMGdhCbV0BQ4sfkeywgNjPQrs3bmlghbHmJzWveMk9gFJyFpGwWkrJZSMoW
	MDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOsWfSOxhXNVgcYhTgYFTi4VVw+hgoxJpY
	VlyZe4hRgoNZSYS34RhQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA6OHkOx9ncaDB26r6+92sm+/X3Bf5eDGz/nr/nyLvPxEe19qvG/AbJ8j7ZbJBn8e
	G8hNdX+vkbdKQshtW6PU7ZqbLbGcH1/cago64jRx8zJv5iMKUfLrtI7+XafuyuM39ZYgx78J
	xv22DHfZ3DUOhSf9vz9/7auj8t2nONg9rWvfrYv54Wp7vF+JpTgj0VCLuag4EQCfvw9prQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 12:47:15 +0530 Viresh Kumar wrote,
> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
> >  /*********************************************************************
> > + *
> > BOOST                                              *
> > +
> > *********************************************************************/
> > +static int cpufreq_boost_set_sw(int state) +{
> > +       struct cpufreq_frequency_table *freq_table;
> > +       struct cpufreq_policy *policy;
> > +       int ret = -EINVAL;
> > +
> > +       list_for_each_entry(policy, &cpufreq_policy_list,
> > policy_list) {
> > +               freq_table =
> > cpufreq_frequency_get_table(policy->cpu);
> > +               if (freq_table) {
> > +                       ret =
> > cpufreq_frequency_table_cpuinfo(policy,
> > +                                                       freq_table);
> > +                       if (!ret) {
> > +                               policy->user_policy.max =
> > policy->max;
> > +                               __cpufreq_governor(policy,
> > CPUFREQ_GOV_LIMITS);
> > +                       }
> > +               }
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +int cpufreq_boost_trigger_state(int state)
> > +{
> > +       unsigned long flags;
> > +       int ret = 0;
> > +
> > +       if (cpufreq_driver->boost_enabled == state)
> > +               return 0;
> > +
> > +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +       cpufreq_driver->boost_enabled = state;
> > +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
	    ^^^^^^^^^^^^^^^^^^^^ [*]
> 
> Not sure if we should leave the lock at this point of time, as we
> haven't enabled boost until now.

The problem here is with the cpufreq_driver->set_boost() call.

I tried to avoid acquiring lock at one function and release it at
another (in this case cpufreq_boost_set_sw), especially since the
__cpufreq_governor() acquires its own lock - good place for deadlock.

Is it OK for you to grab lock at one function
(cpufreq_boost_trigger_state()) and then at other function
(cpufreq_boost_set_sw) release it before calling __cpufreq_governor()
and grab it again after its completion?


> 
> If somebody tries to use this variable at this point of time, then
> it would get the wrong information about it.
> 
> > +       ret = cpufreq_driver->set_boost(state);
> > +       if (ret) {
> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +               cpufreq_driver->boost_enabled = 0;
> 
> should be:
>                     cpufreq_driver->boost_enabled = !state;

For me = 0 (or = false) is more readable. 
If you wish, I will change it to = !state.

> 
> > +               write_unlock_irqrestore(&cpufreq_driver_lock,
> > flags); +
> > +               pr_err("%s: BOOST cannot %s\n", __func__,
> 
> s/BOOST cannot %s/Cannot %s BOOST

Ok.

> 
> > +                      state ? "enabled" : "disabled");
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +int cpufreq_boost_supported(void)
> > +{
> > +       if (cpufreq_driver)
> 
> This routine is always called from places where cpufreq_driver
> can't be NULL..

It is also called from thermal. And it happens that thermal is
initialized earlier.
Then "NULL pointer dereference" happens.

> 
> --contd--
> 
> > +               return cpufreq_driver->boost_supported;
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_boost_supported);
> > +
> > +int cpufreq_boost_enabled(void)
> > +{
> > +       return cpufreq_driver->boost_enabled;
	^^^^^^^^^^^^^^ [1]

> 
> And if above check is necessary, then don't you need to check
> it here as well?

Because on thermal I check first if cpufreq_boost_supported() is true.
If boost is not supported then check for cpufreq_boost_enabled() is not
performed.

In my opinion at [1] we don't need the if (cpufreq_driver) check.
But it is up to you to decide. 

> 
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_boost_enabled);
> > +
> > +/*********************************************************************
> >   *               REGISTER / UNREGISTER CPUFREQ
> > DRIVER                *
> > *********************************************************************/
> >
> > @@ -2008,9 +2099,25 @@ int cpufreq_register_driver(struct
> > cpufreq_driver *driver_data) cpufreq_driver = driver_data;
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> > +       if (cpufreq_boost_supported()) {
> > +               /*
> > +                * Check if boost driver provides function to
> > enable boost -
> 
> s/boost driver/driver

Ok.

> 
> > +                * if not, use cpufreq_boost_set_sw as default
> > +                */
> > +               if (!cpufreq_driver->set_boost)
> > +                       cpufreq_driver->set_boost =
> > cpufreq_boost_set_sw; +
> > +               ret = cpufreq_sysfs_create_file(&(boost.attr));
> 
> You don't need braces around boost.attr.

Ok.

> 
> > +               if (ret) {
> > +                       pr_err("%s: cannot register global BOOST
> > sysfs file\n",
> > +                               __func__);
> > +                       goto err_null_driver;
> > +               }
> > +       }
> > +
> >         ret = subsys_interface_register(&cpufreq_interface);
> >         if (ret)
> > -               goto err_null_driver;
> > +               goto err_boost_unreg;
> >
> >         if (!(cpufreq_driver->flags & CPUFREQ_STICKY)) {
> >                 int i;
> > @@ -2037,6 +2144,9 @@ int cpufreq_register_driver(struct
> > cpufreq_driver *driver_data) return 0;
> >  err_if_unreg:
> >         subsys_interface_unregister(&cpufreq_interface);
> > +err_boost_unreg:
> > +       if (cpufreq_boost_supported())
> > +               cpufreq_sysfs_remove_file(&(boost.attr));
> 
> same here.

Ok.

> 
> >  err_null_driver:
> >         write_lock_irqsave(&cpufreq_driver_lock, flags);
> >         cpufreq_driver = NULL;
> > @@ -2063,6 +2173,9 @@ int cpufreq_unregister_driver(struct
> > cpufreq_driver *driver) pr_debug("unregistering driver %s\n",
> > driver->name);
> >
> >         subsys_interface_unregister(&cpufreq_interface);
> > +       if (cpufreq_boost_supported())
> > +               cpufreq_sysfs_remove_file(&(boost.attr));
> 
> here too.

Ok.

> 
> > +
> >         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
> >
> >         write_lock_irqsave(&cpufreq_driver_lock, flags);
> 
> > +static ssize_t scaling_available_frequencies_show(struct
> > cpufreq_policy *policy,
> > +                                                 char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 0);
> 
> s/0/false

Ok.

> 
> > +}
> 
> > +static ssize_t scaling_boost_frequencies_show(struct
> > cpufreq_policy *policy,
> > +                                             char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 1);
> 
> s/1/true

Ok.

> 
> > +}
> 
> Looks good mostly.. We Should be to get it in 3.12 :)

If we agree about above comments, I will post v7 ASAP.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
