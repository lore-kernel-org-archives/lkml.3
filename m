Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbbAVFNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:13:17 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:50732 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbAVFNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:13:12 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 21 Jan 2015 21:13:11 -0800
Message-ID: <CAMsRxfJVxUcTvpaUSvTY19Ha93J1R-=o97hO+bfgkL3zU7Nrpw@mail.gmail.com>
Subject: Re: perf: easily crash kernel with rapl event close
From: Stephane Eranian <eranian@googlemail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

On Wed, Jan 21, 2015 at 10:55 AM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> Hello
>
> on my haswell system, running 3.19-rc5, and with
>         echo "0" > /proc/sys/kernel/perf_event_paranoid
>
> I can easily crash my system with the attached test program that simply
> opens a RAPL event and then closes it.
>
> This bug was found by the perf_fuzzer.
>
> It looks like somehow rapl_pmu gets freed to NULL but the
> call in rapl_scale()
>         __this_cpu_read(rapl_pmu->hw_unit)
> still happens.
>
I don't see how this can happen.

I get some crashes but not with your program on my laptop.
But I cannot catch the serial console from my laptop.
Will try with another machine tomorrow.

> [  189.424003] BUG: unable to handle kernel paging request at 000000000000cc68
> [  189.431591] IP: [<ffffffff81032bb2>] rapl_event_update+0x82/0xb0
> [  189.438069] PGD 0
> [  189.440308] Oops: 0000 [#1] SMP
> [  189.443882] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel snd_hda_codec_hdmi aes_x86_64 lrw i915 gf128mul glue_helper evdev mei_me snd_hda_codec_realtek snd_hda_codec_generic xhci_pci ppdev iTCO_wdt iTCO_vendor_support lpc_ich mfd_core mei psmouse ablk_helper serio_raw parport_pc cryptd pcspkr i2c_i801 xhci_hcd tpm_tis snd_hda_intel parport tpm battery video snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer drm_kms_helper snd soundcore wmi button processor drm i2c_algo_bit sg sr_mod sd_mod cdrom ehci_pci ehci_hcd ahci libahci libata e1000e usbcore ptp crc32c_intel scsi_mod usb_common pps_core thermal fan thermal_sys
> [  189.515919] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.19.0-rc5+ #123
> [  189.522911] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
> [  189.530797] task: ffff880119470390 ti: ffff880119474000 task.ti: ffff880119474000
> [  189.538773] RIP: 0010:[<ffffffff81032bb2>]  [<ffffffff81032bb2>] rapl_event_update+0x82/0xb0
> [  189.547823] RSP: 0018:ffff88011eb43e40  EFLAGS: 00010046
> [  189.553485] RAX: 000000000208d460 RBX: ffff88011eb43e4c RCX: 0000000000000020
> [  189.561104] RDX: 0000000000000000 RSI: 000000000208d460 RDI: 0000000000000000
> [  189.568774] RBP: ffff88011eb43e78 R08: 0000000000000000 R09: 0000000000000090
> [  189.576300] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000208d460
> [  189.583903] R13: ffff8800cfbb29a0 R14: ffff8800cfbb2800 R15: 000000000208d460
> [  189.591389] FS:  0000000000000000(0000) GS:ffff88011eb40000(0000) knlGS:0000000000000000
> [  189.600138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  189.606320] CR2: 000000000000cc68 CR3: 0000000001c13000 CR4: 00000000001407e0
> [  189.613965] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  189.621567] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  189.629219] Stack:
> [  189.631419]  ffff8800cd9ffbe0 00000000cd9ffb80 ffff8800cfbb2800 ffff8800cd9ffb80
> [  189.639447]  0000000000000082 0000000000000004 ffffe8ffffd43f54 ffff88011eb43ea8
> [  189.647569]  ffffffff81032db8 ffff8800cfbb2800 ffffe8ffffd43d10 0000002c1a89ebed
> [  189.655590] Call Trace:
> [  189.658229]  <IRQ>
> [  189.660307]  [<ffffffff81032db8>] rapl_pmu_event_stop+0x98/0x120
> [  189.666975]  [<ffffffff81032e53>] rapl_pmu_event_del+0x13/0x20
> [  189.673271]  [<ffffffff811585b6>] event_sched_out.isra.73+0xf6/0x240
> [  189.680082]  [<ffffffff81158969>] __perf_remove_from_context+0x59/0xd0
> [  189.687086]  [<ffffffff810ea589>] ? tick_nohz_irq_exit+0x29/0x30
> [  189.693536]  [<ffffffff811541b0>] remote_function+0x50/0x60
> [  189.699549]  [<ffffffff810ef762>] flush_smp_call_function_queue+0x62/0x140
> [  189.706905]  [<ffffffff810efd83>] generic_smp_call_function_single_interrupt+0x13/0x60
> [  189.715411]  [<ffffffff81046dd7>] smp_call_function_single_interrupt+0x27/0x40
> [  189.723165]  [<ffffffff816bf7bd>] call_function_single_interrupt+0x6d/0x80
> [  189.730545]  <EOI>
> [  189.732617]  [<ffffffff81553ca5>] ? cpuidle_enter_state+0x65/0x160
> [  189.739449]  [<ffffffff81553c91>] ? cpuidle_enter_state+0x51/0x160
> [  189.746056]  [<ffffffff81553e87>] cpuidle_enter+0x17/0x20
> [  189.751787]  [<ffffffff810aebc1>] cpu_startup_entry+0x311/0x3c0
> [  189.758151]  [<ffffffff810476b0>] start_secondary+0x140/0x150
> [  189.764307] Code: 00 00 41 8b be 48 01 00 00 48 89 de e8 d8 42 02 00 66 90 49 89 c7 4c 89 e0 4d 0f b1 7d 00 4c 39 e0 75 d6 4c 89 f8 b9 20 00 00 00 <48> 8b 15 af a0 fd 7e 4c 29 e0 65 8b 52 38 48 98 29 d1 48 d3 e0
> [  189.785900] RIP  [<ffffffff81032bb2>] rapl_event_update+0x82/0xb0
> [  189.792456]  RSP <ffff88011eb43e40>
> [  189.796233] CR2: 000000000000cc68
> [  189.799800] ---[ end trace 71cd60a89559b021 ]---
> [  189.804777] Kernel panic - not syncing: Fatal exception in interrupt
> [  189.811644] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> [  189.822598] drm_kms_helper: panic occurred, switching back to text console
> [  189.829996] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
>
