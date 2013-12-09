Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab3LIOac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:30:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54272 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab3LIOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:30:30 -0500
Message-ID: <52A5D3F1.9040301@ti.com>
Date: Mon, 9 Dec 2013 10:30:09 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Christian Daudt <bcm@fixthebug.org>,
        James King <james.king@linaro.org>
Subject: Re: [RFC PATCH] thermal: add generic cpu hotplug cooling device
References: <1379715336-22620-1-git-send-email-zoran.markovic@linaro.org> <CAME+o4myuSVwc=8mpk9x6tKZoskG6i2djrHSBGmVhKqaHqYwMA@mail.gmail.com> <CAME+o4m+1O4pMYa8jNoSuVtmtbkRC2H-9YZj+hnDwsd=Ex0wmw@mail.gmail.com> <52989FCA.2010107@ti.com> <CAME+o4mbtbDV+tZ6itEBqGp5Xy=6a0CsAZ+Kuvu3+oa-TR=_dw@mail.gmail.com>
In-Reply-To: <CAME+o4mbtbDV+tZ6itEBqGp5Xy=6a0CsAZ+Kuvu3+oa-TR=_dw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="5asVvonhhm6o2OGHaMCT1veaFJQ4dLUKL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5asVvonhhm6o2OGHaMCT1veaFJQ4dLUKL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02-12-2013 19:05, Zoran Markovic wrote:
> Hi Eduardo,
> I have some graphs created for Broadcom's Capri (Cortex-A9x2) device.
> I do a full temperature ramp using ARM-proprietary test, which heats
> it up to ~48C. By hot-unplugging CPU1 I can cool it down to ~40C
> within seconds. Let me know if you'd like to see the graphs.

Yeah, I would like to see it. But what I was more interested in seeing
is how long does it take to offline a CPU?

> Regards, Zoran
>=20
> On 29 November 2013 06:08, Eduardo Valentin <eduardo.valentin@ti.com> w=
rote:
>> Hello Zoran,
>>
>> On 27-11-2013 17:56, Zoran Markovic wrote:
>>> Pinging again... Does anyone have any opinion on this feature?
>>
>> Sorry for not answering you. Yes there is interest in such work.
>> Besides, your patch is not the very first attempt to do so. If I
>> remember correctly, when Amit D. K was originally sending the current
>> cpu cooling device, it included a hotplug part. That is why it was nam=
ed
>> cpucooling and not cpufreqcooling. Anyways, the major concerns by that=

>> time was the latencies to off line a CPU, mainly due to task and
>> structure migration.
>>
>> Thus the question is, have you measure the behavior of your system whe=
n
>> using this cooling device? Does it present any cooling effectiveness
>> during high system load scenarios for instance? In case you have data,=

>> would you be able to share them?
>>
>>
>>> Thanks,
>>> Zoran
>>>
>>> On 4 October 2013 15:52, Zoran Markovic <zoran.markovic@linaro.org> w=
rote:
>>>> Any comments on this proposed feature and implementation? Apparently=

>>>> it's also useful for server systems.
>>
>>
>>
>>
>>>> Thanks,
>>>> Zoran
>>>>
>>>> On 20 September 2013 15:15, Zoran Markovic <zoran.markovic@linaro.or=
g> wrote:
>>>>> This patch implements a generic CPU hotplug cooling device. The
>>>>> implementation scales down the number of running CPUs when temperat=
ure
>>>>> increases through a thermal trip point and prevents booting CPUs
>>>>> until thermal conditions are restored. Upon restoration, the action=

>>>>> of starting up a CPU is left to another entity (e.g. CPU offline
>>>>> governor, for which a patch is in the works).
>>>>>
>>>>> In the past two years, ARM considerably reduced the time required f=
or
>>>>> CPUs to boot and shutdown; this time is now measured in microsecond=
s.
>>>>> This patch is predominantly intended for ARM big.LITTLE architectur=
es
>>>>> where big cores are expected to have a much bigger impact on therma=
l
>>>>> budget than little cores, resulting in fast temperature ramps to a =
trip
>>>>> point, i.e. thermal runaways. Switching off the big core(s) may be =
one
>>>>> of the recovery mechanisms to restore system temperature, but the a=
ctual
>>>>> strategy is left to the thermal governor.
>>>>>
>>>>> The assumption is that CPU shutdown/startup is a rare event, so no
>>>>> attempt was made to make the code atomic, i.e. the code evidently r=
aces
>>>>> with CPU hotplug driver. The set_cur_state() function offlines CPUs=

>>>>> iteratively one at a time, checking the cooling state before each C=
PU
>>>>> shutdown. A hotplug notifier callback validates any CPU boot reques=
ts
>>>>> against current cooling state and approves/denies accordingly. This=

>>>>> mechanism guarantees that the desired cooling state could be reache=
d in a
>>>>> maximum of d-c iterations, where d and c are the "desired" and "cur=
rent"
>>>>> cooling states expressed in the number of offline CPUs.
>>>>>
>>>>> Credits to Amit Daniel Kachhap for initial attempt to upstream this=
 feature.
>>>>>
>>>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>>>> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
>>>>> Cc: Rob Landley <rob@landley.net>
>>>>> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: Durgadoss R <durgadoss.r@intel.com>
>>>>> Cc: Christian Daudt <bcm@fixthebug.org>
>>>>> Cc: James King <james.king@linaro.org>
>>>>> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
>>>>> ---
>>>>>  Documentation/thermal/cpu-cooling-api.txt |   17 ++
>>>>>  drivers/thermal/Kconfig                   |   10 +
>>>>>  drivers/thermal/Makefile                  |    1 +
>>>>>  drivers/thermal/cpu_hotplug.c             |  362 +++++++++++++++++=
++++++++++++
>>>>>  include/linux/cpuhp_cooling.h             |   57 +++++
>>>>>  5 files changed, 447 insertions(+)
>>>>>  create mode 100644 drivers/thermal/cpu_hotplug.c
>>>>>  create mode 100644 include/linux/cpuhp_cooling.h
>>>>>
>>>>> diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentat=
ion/thermal/cpu-cooling-api.txt
>>>>> index fca24c9..2f94f68 100644
>>>>> --- a/Documentation/thermal/cpu-cooling-api.txt
>>>>> +++ b/Documentation/thermal/cpu-cooling-api.txt
>>>>> @@ -30,3 +30,20 @@ the user. The registration APIs returns the cool=
ing device pointer.
>>>>>      This interface function unregisters the "thermal-cpufreq-%x" c=
ooling device.
>>>>>
>>>>>      cdev: Cooling device pointer which has to be unregistered.
>>>>> +
>>>>> +1.2 cpu hotplug registration/unregistration APIs
>>>>> +1.2.1 struct thermal_cooling_device *cpuhp_cooling_register(
>>>>> +       struct cpumask *cpus, const char *ext)
>>>>> +
>>>>> +    This function creates and registers a cpu hotplug cooling devi=
ce with
>>>>> +    the name "cpu-hotplug-%s".
>>>>> +
>>>>> +    cpus: cpumask of cpu cores participating in cooling.
>>>>> +    ext: instance-specific name of device
>>>>> +
>>>>> +1.2.2 void cpuhotplug_cooling_unregister(struct thermal_cooling_de=
vice *cdev)
>>>>> +
>>>>> +    This function unregisters and frees the cpu hotplug cooling de=
vice cdev.
>>>>> +
>>>>> +    cdev: Pointer to cooling device to unregister.
>>>>> +
>>>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>>>> index 52b6ed7..3509100 100644
>>>>> --- a/drivers/thermal/Kconfig
>>>>> +++ b/drivers/thermal/Kconfig
>>>>> @@ -79,6 +79,16 @@ config CPU_THERMAL
>>>>>
>>>>>           If you want this support, you should say Y here.
>>>>>
>>>>> +config CPU_THERMAL_HOTPLUG
>>>>> +       bool "Generic CPU hotplug cooling"
>>>>> +       depends on HOTPLUG_CPU
>>>>> +       help
>>>>> +         Shutdown CPUs to prevent the device from overheating. Thi=
s feature
>>>>> +         uses generic CPU hot-unplug capabilities to control devic=
e
>>>>> +         temperature. When the temperature increases over a trip p=
oint, a
>>>>> +         random subset of CPUs is shut down to reach the desired c=
ooling
>>>>> +         state.
>>>>> +
>>>>>  config THERMAL_EMULATION
>>>>>         bool "Thermal emulation mode support"
>>>>>         help
>>>>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>>>>> index 5ee0db0..0bd08be 100644
>>>>> --- a/drivers/thermal/Makefile
>>>>> +++ b/drivers/thermal/Makefile
>>>>> @@ -12,6 +12,7 @@ thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)  +=3D=
 user_space.o
>>>>>
>>>>>  # cpufreq cooling
>>>>>  thermal_sys-$(CONFIG_CPU_THERMAL)      +=3D cpu_cooling.o
>>>>> +thermal_sys-$(CONFIG_CPU_THERMAL_HOTPLUG)      +=3D cpu_hotplug.o
>>>>>
>>>>>  # platform thermal drivers
>>>>>  obj-$(CONFIG_SPEAR_THERMAL)    +=3D spear_thermal.o
>>>>> diff --git a/drivers/thermal/cpu_hotplug.c b/drivers/thermal/cpu_ho=
tplug.c
>>>>> new file mode 100644
>>>>> index 0000000..8c3021e
>>>>> --- /dev/null
>>>>> +++ b/drivers/thermal/cpu_hotplug.c
>>>>> @@ -0,0 +1,362 @@
>>>>> +/*
>>>>> + *  drivers/thermal/cpu_hotplug.c
>>>>> + *
>>>>> + *  Copyright (C) 2013  Broadcom Corporation Ltd.
>>>>> + *  Copyright (C) 2013  Zoran Markovic <zoran.markovic@linaro.org>=

>>>>> + *
>>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>>>>> + *  This program is free software; you can redistribute it and/or =
modify
>>>>> + *  it under the terms of the GNU General Public License as publis=
hed by
>>>>> + *  the Free Software Foundation; version 2 of the License.
>>>>> + *
>>>>> + *  This program is distributed in the hope that it will be useful=
, but
>>>>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the =
GNU
>>>>> + *  General Public License for more details.
>>>>> + *
>>>>> + *  You should have received a copy of the GNU General Public Lice=
nse along
>>>>> + *  with this program; if not, write to the Free Software Foundati=
on, Inc.,
>>>>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>>>>> + *
>>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>>>>> + */
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/thermal.h>
>>>>> +#include <linux/workqueue.h>
>>>>> +#include <linux/cpu.h>
>>>>> +#include <linux/err.h>
>>>>> +#include <linux/slab.h>
>>>>> +#include <linux/cpuhp_cooling.h>
>>>>> +
>>>>> +/**
>>>>> + * struct cpuhotplug_cooling_device - cpu hotplug cooling device d=
ata
>>>>> + * @cpus: cpu mask representing cpus that can be hot-unplugged for=
 cooling
>>>>> + * @cdev: pointer to generic cooling device
>>>>> + */
>>>>> +struct cpuhotplug_cooling_device {
>>>>> +       unsigned int target;
>>>>> +       struct cpumask cpus;
>>>>> +       struct thermal_cooling_device *cdev;
>>>>> +       struct list_head list;
>>>>> +};
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_list - list of all cpu hotplug cooling devices. Trav=
ersed
>>>>> + * by cpu hotplug notifier to check constraints on booting cpus. L=
ocked
>>>>> + * by cpuhotplug_cooling_lock mutex.
>>>>> + */
>>>>> +static LIST_HEAD(cpuhotplug_list);
>>>>> +static DEFINE_MUTEX(cpuhotplug_cooling_lock);
>>>>> +
>>>>> +/**
>>>>> + * boot_cpu - return index of boot CPU; same criteria as in
>>>>> + * disable_nonboot_cpus()
>>>>> + */
>>>>> +static inline int boot_cpu(void)
>>>>> +{
>>>>> +       int cpu;
>>>>> +       get_online_cpus();
>>>>> +       cpu =3D cpumask_first(cpu_online_mask);
>>>>> +       put_online_cpus();
>>>>> +       return cpu;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * random_online_cpu - pick any online hot-unpluggable cpu
>>>>> + * @d: pointer to cpuhotplug_cooling_device containing hot-pluggab=
le cpu mask
>>>>> + */
>>>>> +static inline int random_online_cpu(struct cpuhotplug_cooling_devi=
ce *d)
>>>>> +{
>>>>> +       int cpu;
>>>>> +
>>>>> +       get_online_cpus();
>>>>> +       cpu =3D any_online_cpu(d->cpus);
>>>>> +       put_online_cpus();
>>>>> +
>>>>> +       return cpu;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * _num_offline_cpus - number of hot-pluggable cpus currently offl=
ine
>>>>> + * @d: pointer to cpuhotplug_cooling_device containing hot-pluggab=
le cpu mask
>>>>> + */
>>>>> +static inline int _num_offline_cpus(struct cpuhotplug_cooling_devi=
ce *d)
>>>>> +{
>>>>> +       struct cpumask offline;
>>>>> +
>>>>> +       cpumask_andnot(&offline, &(d->cpus), cpu_online_mask);
>>>>> +       return cpumask_weight(&offline);
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * num_offline_cpus - same as _num_offline_cpus, but safe from bac=
kground
>>>>> + * hotplug events.
>>>>> + * @d: pointer to cpuhotplug_cooling_device containing hot-pluggab=
le cpu mask
>>>>> + */
>>>>> +static inline int num_offline_cpus(struct cpuhotplug_cooling_devic=
e *d)
>>>>> +{
>>>>> +       int num;
>>>>> +
>>>>> +       get_online_cpus();
>>>>> +       num =3D _num_offline_cpus(d);
>>>>> +       put_online_cpus();
>>>>> +
>>>>> +       return num;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_get_max_state - get maximum cooling state of device
>>>>> + * @cdev: pointer to generic cooling device
>>>>> + * @state: returned maximum cooling state
>>>>> + *
>>>>> + * Thermal framework callback to get the maximum cooling state of =
cpu
>>>>> + * hotplug cooling device.
>>>>> + *
>>>>> + * Return: always 0.
>>>>> + */
>>>>> +static int cpuhotplug_get_max_state(struct thermal_cooling_device =
*cdev,
>>>>> +                                   unsigned long *state)
>>>>> +{
>>>>> +       struct cpuhotplug_cooling_device *d =3D cdev->devdata;
>>>>> +
>>>>> +       /* defined as number of CPUs in hot-pluggable mask: this is=
 invariant */
>>>>> +       *state =3D cpumask_weight(&(d->cpus));
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_get_cur_state - get current cooling state of device
>>>>> + * @cdev: pointer to generic cooling device
>>>>> + * @state: current cooling state
>>>>> + *
>>>>> + * Thermal framework callback to get the current cooling state of =
cpu
>>>>> + * hotplug cooling device.
>>>>> + *
>>>>> + * Return: always 0.
>>>>> + */
>>>>> +static int cpuhotplug_get_cur_state(struct thermal_cooling_device =
*cdev,
>>>>> +                                   unsigned long *state)
>>>>> +{
>>>>> +       struct cpuhotplug_cooling_device *d =3D cdev->devdata;
>>>>> +
>>>>> +       *state =3D d->target;
>>>>> +
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_get_cur_state - set cooling state of device
>>>>> + * @cdev: pointer to generic cooling device
>>>>> + * @state: cooling state
>>>>> + *
>>>>> + * Thermal framework callback to set/change cooling state of cpu h=
otplug
>>>>> + * cooling device.
>>>>> + *
>>>>> + * Return: 0 on success, or error code otherwise
>>>>> + */
>>>>> +static int cpuhotplug_set_cur_state(struct thermal_cooling_device =
*cdev,
>>>>> +                                   unsigned long state)
>>>>> +{
>>>>> +       struct cpuhotplug_cooling_device *d =3D cdev->devdata;
>>>>> +       unsigned long cstate;
>>>>> +       unsigned int cpu;
>>>>> +       int err =3D 0;
>>>>> +
>>>>> +       if (state > cpumask_weight(&(d->cpus)))
>>>>> +               return -EINVAL; /* out of allowed range */
>>>>> +
>>>>> +       /*
>>>>> +        * Set target state here; hot-unplug CPUs if we are too hot=
, but
>>>>> +        * don't attempt to hot-plug CPUs if we're cold. Starting C=
PUs
>>>>> +        * should be left to CPUOffline governor.
>>>>> +        *
>>>>> +        * There is a chance that CPU hotplug driver is racing with=
 this
>>>>> +        * code. Rather than trying to make the procedure atomic, i=
terate
>>>>> +        * until we reach the desired state, or signal error if the=
 state
>>>>> +        * cannot be reached.
>>>>> +        *
>>>>> +        * Neither CPU hotplug nor this code is expected to run too=
 often.
>>>>> +        */
>>>>> +       d->target =3D state;
>>>>> +
>>>>> +       /* compare desired cooling state to current cooling state *=
/
>>>>> +       while ((cstate =3D num_offline_cpus(d)) < state && !err) {
>>>>> +               /* cstate < cstate: we're too hot, unplug any cpu *=
/
>>>>> +               cpu =3D random_online_cpu(d);
>>>>> +               if (cpu < nr_cpu_ids)
>>>>> +                       err =3D work_on_cpu(boot_cpu(),
>>>>> +                                         (long(*)(void *))cpu_down=
,
>>>>> +                                         (void *)cpu);
>>>>> +                       /* on error, message would come from cpu_do=
wn() */
>>>>> +               else {
>>>>> +                       pr_warn("cpuhotplug: CPUs already down\n");=

>>>>> +                       err =3D -EAGAIN;
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       return err;
>>>>> +}
>>>>> +
>>>>> +/* cpu hotplug cooling device ops */
>>>>> +static struct thermal_cooling_device_ops const cpuhotplug_cooling_=
ops =3D {
>>>>> +       .get_max_state =3D cpuhotplug_get_max_state,
>>>>> +       .get_cur_state =3D cpuhotplug_get_cur_state,
>>>>> +       .set_cur_state =3D cpuhotplug_set_cur_state,
>>>>> +};
>>>>> +
>>>>> +/**
>>>>> + * _cpu_startup_allowed - traverse list of hotplug cooling devices=
 to
>>>>> + * check if startup of cpu violates thermal constraints
>>>>> + */
>>>>> +static inline int _cpu_startup_allowed(int cpu)
>>>>> +{
>>>>> +       struct cpuhotplug_cooling_device *d;
>>>>> +       int ret =3D 1;
>>>>> +
>>>>> +       /*
>>>>> +        * Prevent starting CPU if it violates any cooling
>>>>> +        * device's constraint. Called from hotplug notifier, so
>>>>> +        * cpu_up()/cpu_down() already holds a lock on hotplug
>>>>> +        * events.
>>>>> +        */
>>>>> +       mutex_lock(&cpuhotplug_cooling_lock);
>>>>> +       list_for_each_entry(d, &cpuhotplug_list, list) {
>>>>> +               if (cpumask_test_cpu(cpu, &(d->cpus)) &&
>>>>> +                   d->target >=3D _num_offline_cpus(d)) {
>>>>> +                       pr_warn("%s: CPU%d startup prevented\n",
>>>>> +                               dev_name(&(d->cdev->device)), cpu);=

>>>>> +                       ret =3D 0;
>>>>> +                       break;
>>>>> +               }
>>>>> +       }
>>>>> +       mutex_unlock(&cpuhotplug_cooling_lock);
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_thermal_notifier - notifier callback for CPU hotplug=
 events.
>>>>> + * @nb: struct notifier_block
>>>>> + * @event: cpu hotplug event for which callback is invoked.
>>>>> + * @data: context data, in this particular case CPU index.
>>>>> + *
>>>>> + * Callback intercepting CPU hotplug events. Compares CPU hotplug =
action
>>>>> + * with current thermal state and allows/denies accordingly.
>>>>> + *
>>>>> + * Return: 0 (allow) or error (deny).
>>>>> + */
>>>>> +static int cpuhotplug_thermal_notifier(struct notifier_block *nb,
>>>>> +                                      unsigned long event, void *d=
ata)
>>>>> +{
>>>>> +       int cpu =3D (int)data;
>>>>> +
>>>>> +       switch (event) {
>>>>> +       case CPU_UP_PREPARE:
>>>>> +       case CPU_UP_PREPARE_FROZEN:
>>>>> +               /* _cpu_up() only cares about result from CPU_UP_PR=
EPAREs */
>>>>> +               if (!_cpu_startup_allowed(cpu))
>>>>> +                       return notifier_from_errno(-EAGAIN);
>>>>> +               break;
>>>>> +       default:
>>>>> +               /* allow all other actions */
>>>>> +               break;
>>>>> +       }
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static struct notifier_block cpuhotplug_thermal_notifier_block =3D=
 {
>>>>> +       .notifier_call =3D cpuhotplug_thermal_notifier,
>>>>> +};
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_cooling_register - create cpu hotplug cooling device=

>>>>> + * @cpus: cpumask of cpu cores participating in cooling
>>>>> + * @ext: instance-specific name of device
>>>>> + *
>>>>> + * Creates and registers a cpu hotplug cooling device with the nam=
e
>>>>> + * "cpu-hotplug-<ext>".
>>>>> + *
>>>>> + * Return: valid pointer to cpuhotplug_cooling_device struct on su=
ccess,
>>>>> + * corresponding ERR_PTR() on failure.
>>>>> + */
>>>>> +struct thermal_cooling_device *
>>>>> +cpuhotplug_cooling_register(const struct cpumask *cpus, const char=
 *ext)
>>>>> +{
>>>>> +       struct thermal_cooling_device *cdev;
>>>>> +       struct cpuhotplug_cooling_device *cpuhotplug_cdev;
>>>>> +       struct cpumask test;
>>>>> +       char name[THERMAL_NAME_LENGTH];
>>>>> +       int err;
>>>>> +
>>>>> +       /* test if we passed in a good cpumask */
>>>>> +       cpu_maps_update_begin();
>>>>> +       cpumask_and(&test, cpus, cpu_possible_mask);
>>>>> +       cpu_maps_update_done();
>>>>> +
>>>>> +       if (cpumask_test_cpu(boot_cpu(), &test)) {
>>>>> +               pr_warn("cannot hot-plug boot CPU%d\n", boot_cpu())=
;
>>>>> +               cpumask_clear_cpu(boot_cpu(), &test);
>>>>> +       }
>>>>> +       if (cpumask_empty(&test)) {
>>>>> +               pr_err("CPUs unavailable for hot-plug cooling\n");
>>>>> +               err =3D -EINVAL;
>>>>> +               goto out;
>>>>> +       }
>>>>> +
>>>>> +       cpuhotplug_cdev =3D kzalloc(sizeof(struct cpuhotplug_coolin=
g_device),
>>>>> +                            GFP_KERNEL);
>>>>> +       if (!cpuhotplug_cdev) {
>>>>> +               err =3D -ENOMEM;
>>>>> +               goto out;
>>>>> +       }
>>>>> +
>>>>> +       cpumask_copy(&cpuhotplug_cdev->cpus, &test);
>>>>> +
>>>>> +       snprintf(name, sizeof(name), "cpu-hotplug-%s", ext);
>>>>> +
>>>>> +       cpuhotplug_cdev->target =3D 0;
>>>>> +       cdev =3D thermal_cooling_device_register(name, cpuhotplug_c=
dev,
>>>>> +                                              &cpuhotplug_cooling_=
ops);
>>>>> +       if (!cdev) {
>>>>> +               pr_err("%s: cooling device registration failed.\n",=
 name);
>>>>> +               err =3D -EINVAL;
>>>>> +               goto out_free;
>>>>> +       }
>>>>> +       cpuhotplug_cdev->cdev =3D cdev;
>>>>> +
>>>>> +       mutex_lock(&cpuhotplug_cooling_lock);
>>>>> +       if (list_empty(&cpuhotplug_list))
>>>>> +               register_cpu_notifier(&cpuhotplug_thermal_notifier_=
block);
>>>>> +       list_add(&(cpuhotplug_cdev->list), &cpuhotplug_list);
>>>>> +       mutex_unlock(&cpuhotplug_cooling_lock);
>>>>> +
>>>>> +       return cdev;
>>>>> +
>>>>> +out_free:
>>>>> +       kfree(cpuhotplug_cdev);
>>>>> +out:
>>>>> +       return ERR_PTR(err);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(cpuhotplug_cooling_register);
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_cooling_unregister - remove cpu hotplug cooling devi=
ce
>>>>> + * @cdev: cooling device to remove
>>>>> + *
>>>>> + * Unregisters and frees the cpu hotplug cooling device.
>>>>> + */
>>>>> +void cpuhotplug_cooling_unregister(struct thermal_cooling_device *=
cdev)
>>>>> +{
>>>>> +       struct cpuhotplug_cooling_device *cpuhotplug_cdev =3D cdev-=
>devdata;
>>>>> +
>>>>> +       mutex_lock(&cpuhotplug_cooling_lock);
>>>>> +       list_del(&(cpuhotplug_cdev->list));
>>>>> +       if (list_empty(&cpuhotplug_list))
>>>>> +               unregister_cpu_notifier(&cpuhotplug_thermal_notifie=
r_block);
>>>>> +       mutex_unlock(&cpuhotplug_cooling_lock);
>>>>> +
>>>>> +       thermal_cooling_device_unregister(cpuhotplug_cdev->cdev);
>>>>> +       kfree(cpuhotplug_cdev);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(cpuhotplug_cooling_unregister);
>>>>> +
>>>>> diff --git a/include/linux/cpuhp_cooling.h b/include/linux/cpuhp_co=
oling.h
>>>>> new file mode 100644
>>>>> index 0000000..ace1d5b
>>>>> --- /dev/null
>>>>> +++ b/include/linux/cpuhp_cooling.h
>>>>> @@ -0,0 +1,57 @@
>>>>> +/*
>>>>> + *  linux/include/linux/cpuhp_cooling.h
>>>>> + *
>>>>> + *  Copyright (C) 2013 Broadcom Corporation Ltd.
>>>>> + *  Copyright (C) 2013 Zoran Markovic <zoran.markovic@linaro.org>
>>>>> + *
>>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>>>>> + *  This program is free software; you can redistribute it and/or =
modify
>>>>> + *  it under the terms of the GNU General Public License as publis=
hed by
>>>>> + *  the Free Software Foundation; version 2 of the License.
>>>>> + *
>>>>> + *  This program is distributed in the hope that it will be useful=
, but
>>>>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the =
GNU
>>>>> + *  General Public License for more details.
>>>>> + *
>>>>> + *  You should have received a copy of the GNU General Public Lice=
nse along
>>>>> + *  with this program; if not, write to the Free Software Foundati=
on, Inc.,
>>>>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>>>>> + *
>>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>>>>> + */
>>>>> +
>>>>> +#ifndef __CPUHP_COOLING_H__
>>>>> +#define __CPUHP_COOLING_H__
>>>>> +
>>>>> +#include <linux/thermal.h>
>>>>> +#include <linux/cpumask.h>
>>>>> +
>>>>> +#ifdef CONFIG_CPU_THERMAL_HOTPLUG
>>>>> +/**
>>>>> + * cpuhotplug_cooling_register - create cpu hotplug cooling device=
=2E
>>>>> + * @cpus: cpumask of hot-pluggable cpus
>>>>> + * @ext: instance-specific device name
>>>>> + */
>>>>> +struct thermal_cooling_device *
>>>>> +cpuhotplug_cooling_register(const struct cpumask *cpus, const char=
 *ext);
>>>>> +
>>>>> +/**
>>>>> + * cpuhotplug_cooling_unregister - remove cpu hoptlug cooling devi=
ce.
>>>>> + * @cdev: thermal cooling device pointer.
>>>>> + */
>>>>> +void cpuhotplug_cooling_unregister(struct thermal_cooling_device *=
cdev);
>>>>> +#else /* !CONFIG_CPU_THERMAL_HOTPLUG */
>>>>> +static inline struct thermal_cooling_device *
>>>>> +cpuhotplug_cooling_register(const struct cpumask *cpus, const char=
 *ext)
>>>>> +{
>>>>> +       return NULL;
>>>>> +}
>>>>> +static inline
>>>>> +void cpuhotplug_cooling_unregister(struct thermal_cooling_device *=
cdev)
>>>>> +{
>>>>> +       return;
>>>>> +}
>>>>> +#endif /* CONFIG_CPU_THERMAL_HOTPLUG */
>>>>> +
>>>>> +#endif /* __CPU_COOLING_H__ */
>>>>> --
>>>>> 1.7.9.5
>>>>>
>>>
>>>
>>
>>
>> --
>> You have got to be excited about what you are doing. (L. Lamport)
>>
>> Eduardo Valentin
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--5asVvonhhm6o2OGHaMCT1veaFJQ4dLUKL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKl0/gACgkQCXcVR3XQvP2YXAEAqo141JXKeS1hlssO0NG7iL54
11/WQTRruMCT+/grk5IA/32SBofRfKRBsZkb7h+k/ziFG/IcEIy4aiiUi2QLr36i
=DH4J
-----END PGP SIGNATURE-----

--5asVvonhhm6o2OGHaMCT1veaFJQ4dLUKL--
