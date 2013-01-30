Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3A3Fvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:51:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14245 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3A3Fvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:51:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 21:51:24 -0800
Subject: Re: [PATCH 2/5] cpufreq: star/stop cpufreq timers on cpu hotplug
From: Joseph Lo <josephl@nvidia.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Fabio Baltieri <fabio.baltieri@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>
In-Reply-To: <CAOh2x=mjNbSbGrirOOddE-Kitj7MqtDXiwb6rSo8UWQK4wzJvw@mail.gmail.com>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
	 <1356620142-8680-3-git-send-email-fabio.baltieri@linaro.org>
	 <CAOh2x=mjNbSbGrirOOddE-Kitj7MqtDXiwb6rSo8UWQK4wzJvw@mail.gmail.com>
Date: Wed, 30 Jan 2013 13:51:28 +0800
Message-ID: <1359525088.23163.9.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 12:52 +0800, Viresh Kumar wrote:
> Hi Fabio,
> 
> Sorry for waking up very late :)
> 
> The reason why i am starting this thread again is due to problem
> reported by Joseph,
> with latest linux-next/master branch (which contains few big patches
> from me :) ):
> 
After Viresh point me out what patch may cause the issue that I met
below, I also try to just revert this patch on linux-next. Then
everything that may trigger to disable_nonboot_cpus or hotplug back to
normal. So just reverting this patch also fix the issues I saw.
FYI.

Thanks,
Joseph

> Reboot is giving following to him:
> 
> * Will now halt
> [ 193.756068] Disabling non-boot CPUs...
> [ 193.760088] BUG: scheduling while atomic: halt/780/0x00000002
> [ 193.765845] Modules linked in: brcmfmac brcmutil
> [ 193.770613] [<c0014990>] (unwind_backtrace+0x0/0xf8) from [<c0049510>]
> (__schedule_bug+0x44/0x5c)
> [ 193.779548] [<c0049510>] (__schedule_bug+0x44/0x5c) from [<c04fa320>]
> (__schedule+0x688/0x6ec)
> [ 193.788206] [<c04fa320>] (__schedule+0x688/0x6ec) from [<c04fa75c>]
> (schedule_preempt_disabled+0x24/0x34)
> [ 193.797811] [<c04fa75c>] (schedule_preempt_disabled+0x24/0x34) from
> [<c04f916c>] (__mutex_lock_slowpath+0x170/0x34c)
> [ 193.808367] [<c04f916c>] (__mutex_lock_slowpath+0x170/0x34c) from
> [<c04f9354>] (mutex_lock+0xc/0x24)
> [ 193.817554] [<c04f9354>] (mutex_lock+0xc/0x24) from [<c04f1cdc>]
> (unregister_cpu_notifier+0xc/0x24)
> [ 193.826640] [<c04f1cdc>] (unregister_cpu_notifier+0xc/0x24) from
> [<c033a8a4>] (cpufreq_governor_dbs+0x118/0x614)
> [ 193.836866] [<c033a8a4>] (cpufreq_governor_dbs+0x118/0x614) from
> [<c033747c>] (__cpufreq_governor+0x58/0xc0)
> [ 193.846737] [<c033747c>] (__cpufreq_governor+0x58/0xc0) from
> [<c0339104>] (__cpufreq_remove_dev.clone.7+0x58/0x320)
> [ 193.857207] [<c0339104>] (__cpufreq_remove_dev.clone.7+0x58/0x320)
> from [<c04f7958>] (cpufreq_cpu_callback+0x8c/0x9c)
> [ 193.867850] [<c04f7958>] (cpufreq_cpu_callback+0x8c/0x9c) from
> [<c0044f4c>] (notifier_call_chain+0x44/0x84)
> [ 193.877623] [<c0044f4c>] (notifier_call_chain+0x44/0x84) from
> [<c0026e24>] (__cpu_notify+0x2c/0x48)
> [ 193.886704] [<c0026e24>] (__cpu_notify+0x2c/0x48) from [<c04f1b08>]
> (_cpu_down+0xb0/0x23c)
> [ 193.895004] [<c04f1b08>] (_cpu_down+0xb0/0x23c) from [<c00270ec>]
> (disable_nonboot_cpus+0x68/0x104)
> [ 193.904089] [<c00270ec>] (disable_nonboot_cpus+0x68/0x104) from
> [<c0034fbc>] (kernel_power_off+0x24/0x48)
> [ 193.913688] [<c0034fbc>] (kernel_power_off+0x24/0x48) from
> [<c0035810>] (sys_reboot+0x104/0x1e0)
> [ 193.922517] [<c0035810>] (sys_reboot+0x104/0x1e0) from [<c000e520>]
> (ret_fast_syscall+0x0/0x30)
> 
> 
> And the crash log show this patch of yours somewhere :)
> 
> First question: Is this patch still required? Because following patch from me is
> sending a STOP/START to governors on cpu hot-[un]plug ?
> 
> commit dbcb63407c095af73f3464767e00902cdee55e8b
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Sat Jan 12 05:14:39 2013 +0000
> 
>     cpufreq: Notify governors when cpus are hot-[un]plugged
> 
> 
> For me, the answer is NO.
> 
> Over that, i tried these patches on ARM bigLITTLE TC2 (3 A7's  and 2 A15's) and
> my system wasn't booting at all for ondemand governor. Reverting your patch does
> fix the issue:
> 
> [    2.613573] arm_big_little: bL_cpufreq_init: Initialized, cpu: 0, cluster 0
> [    2.635436] arm_big_little: bL_cpufreq_init: Initialized, cpu: 2, cluster 1
> [   23.650184] INFO: rcu_sched self-detected stall on CPU { 0}
> (t=2100 jiffies g=4294967088 c=4294967087 q=10)
> [   23.679664] Backtrace for cpu 0 (current):
> [   23.680239] INFO: rcu_sched detected stalls on CPUs/tasks: { 0}
> (detected by 2, t=2103 jiffies, g=4294967088, c=4294967087, q=10)
> [   23.726839] [<c0014020>] (unwind_backtrace+0x0/0xf8) from
> [<c0012f60>] (smp_send_all_cpu_backtrace+0x60/0xcc)
> [   23.756545] [<c0012f60>] (smp_send_all_cpu_backtrace+0x60/0xcc)
> from [<c008232c>] (rcu_pending+0x2c8/0x63c)
> [   23.785731] [<c008232c>] (rcu_pending+0x2c8/0x63c) from
> [<c0083854>] (rcu_check_callbacks+0x7c/0x148)
> [   23.813358] [<c0083854>] (rcu_check_callbacks+0x7c/0x148) from
> [<c002d1e0>] (update_process_times+0x38/0x68)
> [   23.842808] [<c002d1e0>] (update_process_times+0x38/0x68) from
> [<c0066b00>] (tick_sched_handle+0x48/0x54)
> [   23.871472] [<c0066b00>] (tick_sched_handle+0x48/0x54) from
> [<c0066d6c>] (tick_sched_timer+0x44/0x74)
> [   23.899098] [<c0066d6c>] (tick_sched_timer+0x44/0x74) from
> [<c00416d8>] (__run_hrtimer+0x84/0x1b4)
> [   23.925940] [<c00416d8>] (__run_hrtimer+0x84/0x1b4) from
> [<c004224c>] (hrtimer_interrupt+0x108/0x2d4)
> [   23.953563] [<c004224c>] (hrtimer_interrupt+0x108/0x2d4) from
> [<c0013990>] (arch_timer_handler_virt+0x30/0x38)
> [   23.983530] [<c0013990>] (arch_timer_handler_virt+0x30/0x38) from
> [<c007e41c>] (handle_percpu_devid_irq+0x74/0x110)
> [   24.014799] [<c007e41c>] (handle_percpu_devid_irq+0x74/0x110) from
> [<c007ac8c>] (generic_handle_irq+0x20/0x30)
> [   24.044765] [<c007ac8c>] (generic_handle_irq+0x20/0x30) from
> [<c000e9f4>] (handle_IRQ+0x38/0x94)
> [   24.071085] [<c000e9f4>] (handle_IRQ+0x38/0x94) from [<c0008570>]
> (gic_handle_irq+0x28/0x5c)
> [   24.096362] [<c0008570>] (gic_handle_irq+0x28/0x5c) from
> [<c000dd80>] (__irq_svc+0x40/0x50)
> [   24.121374] Exception stack(0xef047ec0 to 0xef047f08)
> [   24.136492] 7ec0: 00000000 c0591780 00000000 c0591798 c0591780
> c05d5d60 00000000 c0593280
> [   24.160986] 7ee0: c0552c98 c02b1df4 ef046000 00000000 c059179c
> ef047f08 c03b5f84 c0043698
> [   24.185477] 7f00: a0000113 ffffffff
> [   24.195910] [<c000dd80>] (__irq_svc+0x40/0x50) from [<c0043698>]
> (raw_notifier_chain_register+0x24/0x54)
> [   24.224314] [<c0043698>] (raw_notifier_chain_register+0x24/0x54)
> from [<c03b5f84>] (register_cpu_notifier+0x18/0x2c)
> [   24.255843] [<c03b5f84>] (register_cpu_notifier+0x18/0x2c) from
> [<c02ab1b0>] (cpufreq_register_driver+0x134/0x190)
> [   24.286852] [<c02ab1b0>] (cpufreq_register_driver+0x134/0x190) from
> [<c02b1930>] (bL_cpufreq_register+0x68/0xd4)
> [   24.317337] [<c02b1930>] (bL_cpufreq_register+0x68/0xd4) from
> [<c0008740>] (do_one_initcall+0x110/0x178)
> [   24.345738] [<c0008740>] (do_one_initcall+0x110/0x178) from
> [<c03b5994>] (kernel_init+0x194/0x330)
> [   24.372577] [<c03b5994>] (kernel_init+0x194/0x330) from
> [<c000e1d8>] (ret_from_fork+0x14/0x3c)
> [   24.398371]
> 
> 
> On Thu, Dec 27, 2012 at 8:25 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> > Add a CPU notifier to start and stop individual core timers on CPU
> > hotplug events when running on CPUs with SW coordinated frequency.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >  drivers/cpufreq/cpufreq_governor.c | 51 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >
> > diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> > index b0e4506..e881250 100644
> > --- a/drivers/cpufreq/cpufreq_governor.c
> > +++ b/drivers/cpufreq/cpufreq_governor.c
> > @@ -25,9 +25,12 @@
> >  #include <linux/tick.h>
> >  #include <linux/types.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/cpu.h>
> >
> >  #include "cpufreq_governor.h"
> >
> > +static DEFINE_PER_CPU(struct dbs_data *, cpu_cur_dbs);
> > +
> >  static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> >  {
> >         u64 idle_time;
> > @@ -185,6 +188,46 @@ static inline void dbs_timer_exit(struct cpu_dbs_common_info *cdbs)
> >         cancel_delayed_work_sync(&cdbs->work);
> >  }
> >
> > +static int __cpuinit cpu_callback(struct notifier_block *nfb,
> > +               unsigned long action, void *hcpu)
> > +{
> > +       unsigned int cpu = (unsigned long)hcpu;
> > +       struct device *cpu_dev = get_cpu_device(cpu);
> > +       struct dbs_data *dbs_data = per_cpu(cpu_cur_dbs, cpu);
> > +       struct cpu_dbs_common_info *cpu_cdbs = dbs_data->get_cpu_cdbs(cpu);
> > +       unsigned int sampling_rate;
> > +
> > +       if (dbs_data->governor == GOV_CONSERVATIVE) {
> > +               struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
> > +               sampling_rate = cs_tuners->sampling_rate;
> > +       } else {
> > +               struct od_dbs_tuners *od_tuners = dbs_data->tuners;
> > +               sampling_rate = od_tuners->sampling_rate;
> > +       }
> > +
> > +       if (cpu_dev) {
> > +               switch (action) {
> > +               case CPU_ONLINE:
> > +               case CPU_ONLINE_FROZEN:
> > +               case CPU_DOWN_FAILED:
> > +               case CPU_DOWN_FAILED_FROZEN:
> > +                       dbs_timer_init(dbs_data, cpu_cdbs,
> > +                                       sampling_rate, cpu);
> > +                       break;
> > +               case CPU_DOWN_PREPARE:
> > +               case CPU_DOWN_PREPARE_FROZEN:
> > +                       dbs_timer_exit(cpu_cdbs);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       return NOTIFY_OK;
> > +}
> > +
> > +static struct notifier_block __refdata ondemand_cpu_notifier = {
> 
> Over that, why is it called ondemand here ?
> 
> > +       .notifier_call = cpu_callback,
> > +};
> > +
> >  int cpufreq_governor_dbs(struct dbs_data *dbs_data,
> >                 struct cpufreq_policy *policy, unsigned int event)
> >  {
> > @@ -296,7 +339,11 @@ second_time:
> >                                 j_cdbs = dbs_data->get_cpu_cdbs(j);
> >                                 dbs_timer_init(dbs_data, j_cdbs,
> >                                                *sampling_rate, j);
> > +
> > +                               per_cpu(cpu_cur_dbs, j) = dbs_data;
> >                         }
> > +
> > +                       register_hotcpu_notifier(&ondemand_cpu_notifier);
> >                 } else {
> >                         dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate, cpu);
> >                 }
> > @@ -307,11 +354,15 @@ second_time:
> >                         cs_dbs_info->enable = 0;
> >
> >                 if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
> > +                       unregister_hotcpu_notifier(&ondemand_cpu_notifier);
> > +
> >                         for_each_cpu(j, policy->cpus) {
> >                                 struct cpu_dbs_common_info *j_cdbs;
> >
> >                                 j_cdbs = dbs_data->get_cpu_cdbs(j);
> >                                 dbs_timer_exit(j_cdbs);
> > +
> > +                               per_cpu(cpu_cur_dbs, j) = NULL;
> >                         }
> >                 } else {
> >                         dbs_timer_exit(cpu_cdbs);
> 
> --
> viresh


