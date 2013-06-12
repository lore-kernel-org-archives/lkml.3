Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3FLHkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:40:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43607 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3FLHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:40:22 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-4a-51b825e3d4ea
Date: Wed, 12 Jun 2013 09:39:38 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v2 1/3] cpufreq:boost: CPU frequency boost code unification
 for software and hardware solutions
Message-id: <20130612093938.1cf73c9a@amdc308.digital.local>
In-reply-to: <CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-2-git-send-email-l.majewski@samsung.com>
 <CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jAd3HqjsCDWYs0bf483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j3XT3jJ79G1ZxejxaHELo8fnTXIBrFFcNimpOZllqUX6dglcGe9W/GIvmF9Y8e/kO/YG
	xgtBXYycHBICJhJLN35mhLDFJC7cW8/WxcjFISSwiFHi89W7rCAJIYF2JokPe7hAbBYBVYk5
	Dw+AxdkE9CQ+333K1MXIwSEioCXx8mYqSC+zwDNmicdf1oDVCAuUSjyZ+ZIdxOYVsJY48WE+
	mM0pECxx5dU9ZohlbUwSOxcdYQFJ8AtISrT/+8EMcZGdxLlPG6CaBSV+TL4HVsMMtGzztiZW
	CFteYvOat8wTGAVnISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+WZ
	1A7GlQ0WhxgFOBiVeHgPmG0PFGJNLCuuzD3EKMHBrCTC+0d4R6AQb0piZVVqUX58UWlOavEh
	RmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxhbZW3yKjiwlSimb181I/BsTuE7/0tej
	deZMl1LNH9lZluzuWXJll2xI5pT1D1tiLCaWh0pu6ig3XN7dsGzVDiMOo06tz4q2YceT2V68
	750Z8odzukDDgkvmqtJPVCeKFzxc8eXukhtZV24L3XL2FE2QMtgW9lR8n35zUn0dn33jsvn8
	JwSnKrEUZyQaajEXFScCAEZDMKiRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> Hi,
> 
> Change subject to: "cpufreq: Add boost frequency support in core"

Ok.

> 
> On 11 June 2013 14:33, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > This commit adds support for software based frequency boosting.
> 
> No. It adds support for both software and hardware boosting. So just
> write: This commit adds boost frequency support in cpufreq core
> (Hardware & Software).

Ok.
> 
> > Some SoC (like Exynos4 - e.g. 4x12) allow setting frequency above
> > its normal condition limits. Such a change shall be only done for a
> > short
> 
> s/condition/operation
> s/change/mode
> s/done/used
> 

Ok.

> > time.
> >
> > Overclocking (boost) support is essentially provided by platform
> > dependent cpufreq driver.
> >
> > This commit unifies support for SW and HW (Intel) over clocking
> > solutions in the core cpufreq driver. Previously the "boost" sysfs
> > attribute was defined at acpi driver code.
> > By default boost is disabled. One global attribute is available at:
> > /sys/devices/system/cpu/cpufreq/boost.
> 
> Enter a blank line here.

Ok

> 
> > It only shows up when cpufreq driver supports overclocking.
> > Under the hood frequencies dedicated for boosting are marked with a
> > special flag (CPUFREQ_BOOST_FREQ) at driver's frequency table.
> > It is the user's concern to enable/disable overclocking with proper
> > call to sysfs.
> 
> Good.
> 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> >
> > --- 
    ^^^^
[*] this --- was added manually by me.

> > Changes for v2:
> > - Removal of cpufreq_boost structure and move its fields to
> > cpufreq_driver structure
> > - Flag to indicate if global boost attribute is already defined
> > - Extent the pr_{err|debbug} functions to show current function
> > names ---
> 
> You don't have to manually add "---" here. Just keep a blank line
> instead.

One "---" is added by git automatically. The [*] was added to distinct
the changelog from rest of the commit. At least older versions of GIT
required this to not include changelog to commit messages.

> 
> >  drivers/cpufreq/cpufreq.c    |   69
> > ++++++++++++++++++++++++++++++++++++++++++
> > drivers/cpufreq/freq_table.c |   57
> > ++++++++++++++++++++++++++++++++-- include/linux/cpufreq.h      |
> > 12 ++++++++ 3 files changed, 136 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 1b8a48e..98ba5f1 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -40,6 +40,7 @@
> >   * also protects the cpufreq_cpu_data array.
> >   */
> >  static struct cpufreq_driver *cpufreq_driver;
> > +static bool cpufreq_boost_sysfs_defined;
> >  static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  /* This one keeps track of the previously set governor of a
> > removed CPU */ @@ -315,6 +316,33 @@
> > EXPORT_SYMBOL_GPL(cpufreq_notify_transition); /*********************************************************************
> >   *                          SYSFS
> > INTERFACE                          *
> > *********************************************************************/
> > +ssize_t show_boost_status(struct kobject *kobj,
> > +                                struct attribute *attr, char *buf)
> > +{
> > +       return sprintf(buf, "%d\n", cpufreq_driver->boost_en);
> 
> This isn't correct. It shows if cpufreq driver supports boost or
> not and it should show if boost is enabled from sysfs when
> cpufreq driver supports boost.

The cpufreq_driver->low_level_boost() is only valid when cpufreq driver
supports boost. Otherwise it is NULL. Thereof you will not see those
attributes exported to /sysfs until cpufreq driver supports boost. 

When "boost" attribute is exported - then it returns state of boosting
(if it is enabled or not).

> 
> > +}
> > +
> > +static ssize_t store_boost_status(struct kobject *kobj, struct
> > attribute *attr,
> > +                                 const char *buf, size_t count)
> > +{
> > +       int ret, enable;
> > +
> > +       ret = sscanf(buf, "%d", &enable);
> > +       if (ret != 1 || enable < 0 || enable > 1)
> > +               return -EINVAL;
> > +
> > +       if (cpufreq_boost_trigger_state(enable)) {
> > +               pr_err("%s: Cannot %sable boost!\n", __func__,
> > +                      enable ? "en" : "dis");
> 
> %sable doesn't look very much readable. Use complete strings:
> "enable" and "disable".

Ok.

> 
> > +               return -EINVAL;
> > +       }
> > +
> > +       return count;
> > +}
> > +
> > +static struct global_attr global_boost = __ATTR(boost, 0644,
> > +                                               show_boost_status,
> > +                                               store_boost_status);
> 
> User define_one_global_rw.

Ok, will reuse available macros (this code was taken directly from
acpi-cpufreq.c file).

> 
> >  static struct cpufreq_governor *__find_governor(const char
> > *str_governor) {
> > @@ -754,6 +782,17 @@ static int cpufreq_add_dev_interface(unsigned
> > int cpu,
> 
> Why not do this in cpufreq_register_driver()?

Good point. I will move this code to cpufreq_register_driver.

> 
> >                         goto err_out_kobj_put;
> >                 drv_attr++;
> >         }
> > +       if (cpufreq_driver->low_level_boost
> > && !cpufreq_boost_sysfs_defined) {
> 
> I thought low_level_boost() is a function which will only be supported
> for drivers
> using hardware boost feature, like intel.

I think that we shall give users some flexibility and don't assume that
low_level_boost is only used for one solution/vendor.

It is also needed with software controlled boost. Please refer to patch
3/3. 

> And so we must have used
> boost_en here.

boost_en has two meanings:
0 - either boost disabled or not supported (when low_level_boost=NULL).
1 - boost is enabled.

> 
> > +               ret = sysfs_create_file(cpufreq_global_kobject,
> > +                                       &(global_boost.attr));
> 
> cpufreq_sysfs_create_file(), check
> 2361be23666232dbb4851a527f466c4cbf5340fc for details.

Ok, I will rebase those changes to newest
kernel/git/rafael/linux-pm.git ,branch
kernel_pm/pm-cpufreq

> 
> > +               if (ret) {
> > +                       pr_err("%s: cannot register global boost
> > sysfs file\n",
> > +                               __func__);
> > +                       goto err_out_kobj_put;
> > +               }
> > +               cpufreq_boost_sysfs_defined = 1;
> > +       }
> > +
> >         if (cpufreq_driver->get) {
> >                 ret = sysfs_create_file(&policy->kobj,
> > &cpuinfo_cur_freq.attr); if (ret)
> > @@ -1853,6 +1892,30 @@ static struct notifier_block __refdata
> > cpufreq_cpu_notifier = { };
> >
> >  /*********************************************************************
> > + *
> > BOOST                                              *
> > +
> > *********************************************************************/
> > +int cpufreq_boost_trigger_state(int state) +{
> > +       int ret = 0;
> > +
> > +       if (!cpufreq_driver->low_level_boost)
> > +               return -ENODEV;
> 
> I am certainly not aligned with your design. What's the
> use of this field? 

I had to rewrite a bit :-) patches since we decided to drop struct
cpufreq_boost.

I've added two fields to cpufreq_driver:
 - low_level_boost: 
	* When boost is not supported (default) it is set to NULL. This
	  field has two purposes: Indicates if boost is available on
	  the system and provides address of low level callback
	* When cpufreq driver assigns pointer to this field,
	  it means that it is supported

 - boost_en:
	* It shows if boost is enabled or disabled/not supported to the
	  rest of the system.

> And please update documentation too for these
> new entries in cpufreq_driver structure.

Ok I will extend it.

> 
> > +       if (cpufreq_driver->boost_en != state) {
> 
> So, you are using boost_en to see if boost is enabled from sysfs?
> Then you have put it at wrong place.

I check if boost is already enabled. 

> 
> I thought there would be three variables:
> - cpufreq_driver->boost_supported: boost is enabled for driver

For this purpose I check the low_level_boost pointer if it's NULL or
not.

> - cpufreq_driver->low_level_boost(): to set desired boost state
> (Only for hardware boosting)

It has two purposes (as described above) and can be used (defined) by
software and hardware boost solutions.

> - boost_enabled: global variable in cpufreq.c file, used only if
> cpufreq_driver->boost_supported is true.

I think that boost enabled flag shall be defined at cpufreq driver
(please look into acpi_cpufreq.c - which used another set of global
flags). 
It will then provide one flag for cpufreq.c (core) and drivers.

However I've added one global flag: cpufreq_boost_sysfs_defined 
which indicates if /sys/devices/system/cpu/cpufreq/boost attribute has
been already defined (to prevent multiple definitions attempts).

> 
> 
> > diff --git a/drivers/cpufreq/freq_table.c
> > b/drivers/cpufreq/freq_table.c index d7a7966..4e4f692 100644
> > --- a/drivers/cpufreq/freq_table.c
> > +++ b/drivers/cpufreq/freq_table.c
> > @@ -20,6 +20,27 @@
> >   *                     FREQUENCY TABLE
> > HELPERS                       *
> > *********************************************************************/
> >
> > +unsigned int
> > +cpufreq_frequency_table_max(struct cpufreq_frequency_table
> > *freq_table,
> > +                           int boost)
> > +{
> > +       int i = 0, boost_freq_max = 0, freq_max = 0;
> > +
> > +       for (; freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
> > +               if (freq_table[i].index == CPUFREQ_BOOST_FREQ) {
> > +                       if (freq_table[i].frequency >
> > boost_freq_max)
> > +                               boost_freq_max =
> > freq_table[i].frequency;
> 
> Do above only when boost==true and below when boost==false.

Ok.

> 
> > +               } else {
> > +                       if (freq_table[i].frequency > freq_max)
> > +                               freq_max = freq_table[i].frequency;
> > +               }
> > +       }
> > +
> > +       return boost ? boost_freq_max : freq_max;
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(cpufreq_frequency_table_max);
> > +
> >  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
> >                                     struct cpufreq_frequency_table
> > *table) {
> > @@ -171,7 +192,8 @@ static DEFINE_PER_CPU(struct
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
> > @@ -186,22 +208,53 @@ static ssize_t show_available_freqs(struct
> > cpufreq_policy *policy, char *buf) for (i = 0;
> > (table[i].frequency != CPUFREQ_TABLE_END); i++) { if
> > (table[i].frequency == CPUFREQ_ENTRY_INVALID) continue;
> > +               if (show_boost)
> > +                       if (table[i].index != CPUFREQ_BOOST_FREQ)
> > +                               continue;
> > +
> 
> Looks wrong. You will show boost freqs when show_boost is false.

My purpose here is to display frequencies only tagged with
CPUFREQ_BOOST_FREQ and when show_boost is true. 

When show_boost is false, the operation of the function is unchanged.


> 
> >                 count += sprintf(&buf[count], "%d ",
> > table[i].frequency); }
> >         count += sprintf(&buf[count], "\n");
> >
> >         return count;
> > +}
> >
> > +/**
> > + * show_available_normal_freqs - show normal boost frequencies for
> > + * the specified CPU
> > + */
> > +static ssize_t show_available_normal_freqs(struct cpufreq_policy
> > *policy,
> > +                                          char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 0);
> >  }
> >
> >  struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
> >         .attr = { .name = "scaling_available_frequencies",
> >                   .mode = 0444,
> >                 },
> > -       .show = show_available_freqs,
> > +       .show = show_available_normal_freqs,
> >  };
> >  EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
> >
> > +/**
> > + * show_available_boost_freqs - show available boost frequencies
> > for
> > + * the specified CPU
> > + */
> > +static ssize_t show_available_boost_freqs(struct cpufreq_policy
> > *policy,
> > +                                         char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 1);
> > +}
> > +
> > +struct freq_attr cpufreq_freq_attr_boost_available_freqs = {
> > +       .attr = { .name = "scaling_boost_frequencies",
> > +                 .mode = 0444,
> > +               },
> > +       .show = show_available_boost_freqs,
> > +};
> > +EXPORT_SYMBOL_GPL(cpufreq_freq_attr_boost_available_freqs);
> > +
> 
> Code redundancy can be reduced by creating a macro for declaring
> **_availabe_freqs, its attributes and export symbol.

Yes, you are right here. Those two structures only differ with
different names.

> 
> >  /*
> >   * if you use these, you must assure that the frequency table is
> > valid
> >   * all the time between get_attr and put_attr!
> 
> With this patch alone, we would be using boost frequencies even in
> normal cases where we haven't enabled boost.

Correct me if I'm wrong here, but the
cpufreq_freq_attr_boost_available_freqs will be added to cpufreq
driver's freq_attr table (i.e. *exynos_cpufreq_attr[]). 
It is cpufreq driver's responsibility to add this attribute. By default
all other drivers add only cpufreq_freq_attr_boost_available_freqs.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
