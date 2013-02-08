Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab3BHOPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:15:13 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51925 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3BHOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:15:11 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <2612804.Hcyse1lRVO@vostro.rjw.lan>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
	<CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
	<CA+icZUUaFb8zvdkY2JLz5h_7CBgaTzyyTphGid+GkigV+NfVKA@mail.gmail.com>
	<2612804.Hcyse1lRVO@vostro.rjw.lan>
Date: Fri, 8 Feb 2013 15:15:09 +0100
Message-ID: <CA+icZUWQNU-z4VnVDneFmfAT=nyFB-r+9_vm2Ett1i-Rg5FMqA@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 8 [ smp|cpufreq: WARNING: at
 kernel/smp.c:245 smp_call_function_single ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hillf Danton <dhillf@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 2:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 08, 2013 01:47:44 PM Sedat Dilek wrote:
>> On Fri, Feb 8, 2013 at 12:53 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> > Hello Sedat
>> >
>> > On Fri, Feb 8, 2013 at 4:46 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> >> On Fri, Feb 8, 2013 at 5:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >> With today's Linux-Next I see this warning:
>> >>
>> >> [    0.377442] ------------[ cut here ]------------
>> >> [    0.377452] WARNING: at kernel/smp.c:245
>> >> smp_call_function_single+0x146/0x190()
>> >> [    0.377455] Hardware name: 530U3BI/530U4BI/530U4BH
>> >> [    0.377458] Modules linked in:
>> >> [    0.377463] Pid: 1, comm: swapper/0 Not tainted
>> >> 3.8.0-rc6-next20130208-1-iniza-small #1
>> >> [    0.377467] Call Trace:
>> >> [    0.377473]  [<ffffffff8105a5ef>] warn_slowpath_common+0x7f/0xc0
>> >> [    0.377479]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
>> >> [    0.377483]  [<ffffffff8105a64a>] warn_slowpath_null+0x1a/0x20
>> >> [    0.377487]  [<ffffffff810bb7e6>] smp_call_function_single+0x146/0x190
>> >> [    0.377492]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
>> >> [    0.377496]  [<ffffffff810bb881>] smp_call_function_any+0x51/0x100
>> >> [    0.377500]  [<ffffffff815788c9>] get_cur_val+0x99/0x130
>> >> [    0.377504]  [<ffffffff81579444>] ? acpi_cpufreq_cpu_init+0x2b4/0x6a0
>> >> [    0.377508]  [<ffffffff81578db0>] get_cur_freq_on_cpu+0x60/0x80
>> >> [    0.377512]  [<ffffffff815795a2>] acpi_cpufreq_cpu_init+0x412/0x6a0
>> >> [    0.377517]  [<ffffffff81575bb9>] cpufreq_add_dev+0x2d9/0x4f0
>> >> [    0.377523]  [<ffffffff81d44b22>] ? cpufreq_gov_dbs_init+0x2c/0x2c
>> >> [    0.377528]  [<ffffffff8145d379>] subsys_interface_register+0x89/0xd0
>> >> [    0.377533]  [<ffffffff81573dee>] cpufreq_register_driver+0x8e/0x180
>> >> [    0.377537]  [<ffffffff81d44c18>] acpi_cpufreq_init+0xf6/0x1f8
>> >> [    0.377542]  [<ffffffff814608e6>] ? platform_driver_register+0x46/0x50
>> >> [    0.377547]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
>> >> [    0.377553]  [<ffffffff81d07029>] kernel_init_freeable+0x13e/0x1cd
>> >> [    0.377560]  [<ffffffff81d06895>] ? do_early_param+0x86/0x86
>> >> [    0.377565]  [<ffffffff8169cf20>] ? rest_init+0x80/0x80
>> >> [    0.377569]  [<ffffffff8169cf2e>] kernel_init+0xe/0xf0
>> >> [    0.377575]  [<ffffffff816c722c>] ret_from_fork+0x7c/0xb0
>> >> [    0.377578]  [<ffffffff8169cf20>] ? rest_init+0x80/0x80
>> >> [    0.377581] ---[ end trace c6ec8280ce20313a ]---
>> >>
>> >> kernel/smp.c: Line #245 see [1].
>> >>
>> > Can you please try the following?
>> >
>> > --- a/kernel/smp.c      Fri Feb  8 19:25:32 2013
>> > +++ b/kernel/smp.c      Fri Feb  8 19:53:14 2013
>> > @@ -241,7 +241,7 @@ int smp_call_function_single(int cpu, sm
>> >          * send smp call function interrupt to this cpu and as such deadlocks
>> >          * can't happen.
>> >          */
>> > -       WARN_ON_ONCE(cpu_online(this_cpu) && (irqs_disabled() || in_interrupt())
>> > +       WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>> >                      && !oops_in_progress);
>> >
>> >         if (cpu == this_cpu) {
>> > --
>>
>> NO, it doesn't.
>>
>> So, you want to partly revert...
>>
>> commit b29f39c7c3e75a741a7da88244ec707f293ec04c
>> "smp: Give WARN()ing if in_interrupt() when calling
>> smp_call_function_many()/single()"
>>
>> ...why not completely?
>>
>> This patch was in last days Linux-Next and did not cause troubles (AFAICS).
>
> This problem was introduced by some cpufreq changes that have been dropped from
> linux-next for now (they are still present in the one you're testing, though).
>

"...some...changes..." is not very concrete :-).
Which commit(s) caused this trouble?

Is current (meanwhile updated?) linux-pm.git#linux-next good (didn't
check last commit-ids of your tree from Next/ dir)?

- Sedat -

> Thanks,
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
