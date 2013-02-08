Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946373Ab3BHLyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:54:14 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54171 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946329Ab3BHLx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:53:57 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
Date: Fri, 8 Feb 2013 19:53:56 +0800
Message-ID: <CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 8 [ smp|cpufreq: WARNING: at
 kernel/smp.c:245 smp_call_function_single ]
From: Hillf Danton <dhillf@gmail.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sedat

On Fri, Feb 8, 2013 at 4:46 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Feb 8, 2013 at 5:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> With today's Linux-Next I see this warning:
>
> [    0.377442] ------------[ cut here ]------------
> [    0.377452] WARNING: at kernel/smp.c:245
> smp_call_function_single+0x146/0x190()
> [    0.377455] Hardware name: 530U3BI/530U4BI/530U4BH
> [    0.377458] Modules linked in:
> [    0.377463] Pid: 1, comm: swapper/0 Not tainted
> 3.8.0-rc6-next20130208-1-iniza-small #1
> [    0.377467] Call Trace:
> [    0.377473]  [<ffffffff8105a5ef>] warn_slowpath_common+0x7f/0xc0
> [    0.377479]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
> [    0.377483]  [<ffffffff8105a64a>] warn_slowpath_null+0x1a/0x20
> [    0.377487]  [<ffffffff810bb7e6>] smp_call_function_single+0x146/0x190
> [    0.377492]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
> [    0.377496]  [<ffffffff810bb881>] smp_call_function_any+0x51/0x100
> [    0.377500]  [<ffffffff815788c9>] get_cur_val+0x99/0x130
> [    0.377504]  [<ffffffff81579444>] ? acpi_cpufreq_cpu_init+0x2b4/0x6a0
> [    0.377508]  [<ffffffff81578db0>] get_cur_freq_on_cpu+0x60/0x80
> [    0.377512]  [<ffffffff815795a2>] acpi_cpufreq_cpu_init+0x412/0x6a0
> [    0.377517]  [<ffffffff81575bb9>] cpufreq_add_dev+0x2d9/0x4f0
> [    0.377523]  [<ffffffff81d44b22>] ? cpufreq_gov_dbs_init+0x2c/0x2c
> [    0.377528]  [<ffffffff8145d379>] subsys_interface_register+0x89/0xd0
> [    0.377533]  [<ffffffff81573dee>] cpufreq_register_driver+0x8e/0x180
> [    0.377537]  [<ffffffff81d44c18>] acpi_cpufreq_init+0xf6/0x1f8
> [    0.377542]  [<ffffffff814608e6>] ? platform_driver_register+0x46/0x50
> [    0.377547]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
> [    0.377553]  [<ffffffff81d07029>] kernel_init_freeable+0x13e/0x1cd
> [    0.377560]  [<ffffffff81d06895>] ? do_early_param+0x86/0x86
> [    0.377565]  [<ffffffff8169cf20>] ? rest_init+0x80/0x80
> [    0.377569]  [<ffffffff8169cf2e>] kernel_init+0xe/0xf0
> [    0.377575]  [<ffffffff816c722c>] ret_from_fork+0x7c/0xb0
> [    0.377578]  [<ffffffff8169cf20>] ? rest_init+0x80/0x80
> [    0.377581] ---[ end trace c6ec8280ce20313a ]---
>
> kernel/smp.c: Line #245 see [1].
>
Can you please try the following?

--- a/kernel/smp.c	Fri Feb  8 19:25:32 2013
+++ b/kernel/smp.c	Fri Feb  8 19:53:14 2013
@@ -241,7 +241,7 @@ int smp_call_function_single(int cpu, sm
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(this_cpu) && (irqs_disabled() || in_interrupt())
+	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
 		     && !oops_in_progress);

 	if (cpu == this_cpu) {
--
