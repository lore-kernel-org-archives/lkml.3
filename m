Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaECC23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 22:28:29 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33324 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaECC21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 22:28:27 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 22:32:01 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1405022227420.25174@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu> <20140502154217.GW11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu> <20140502162234.GX11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu> <20140502172731.GK30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405021337390.22556@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022111540.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405021611540.23984@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405022243550.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Thomas Gleixner wrote:

> > OK the proper patch has been running the quick reproducer for a bit 
> > without triggering the issue, I'll let it run a bit more and then upgrade 
> > to full fuzzing.
> 
> If you do that, please add the patch below.

I've been fuzzing without your additional patch for 6 hours and all looks
(almost) good.  I can add in your patch and let it fuzz overnight.

I say almost because the following gets triggered, but I think it's an 
unrelated issue.

Vince

[17190.202941] ------------[ cut here ]------------
[17190.207906] WARNING: CPU: 2 PID: 4743 at 
arch/x86/kernel/cpu/perf_event_intel.c:1373 intel_pmu_handle_irq+0x2a4/0x3c0()
[17190.219460] perfevents: irq loop stuck!
[17190.223579] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp kvm snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_controller crct10dif_pclmul snd_hda_codec crc32_pclmul snd_hwdep ghash_clmulni_intel snd_pcm aesni_intel aes_x86_64 lrw snd_seq snd_timer snd_seq_device gf128mul snd i915 glue_helper evdev soundcore drm_kms_helper mei_me iTCO_wdt iTCO_vendor_support lpc_ich battery drm ppdev psmouse serio_raw ablk_helper cryptd wmi parport_pc mei parport tpm_tis i2c_algo_bit button processor video tpm i2c_i801 i2c_core mfd_core pcspkr sd_mod sr_mod crc_t10dif cdrom crct10dif_common ehci_pci ahci xhci_hcd ehci_hcd libahci e1000e libata ptp crc32c_intel usbcore scsi_mod pps_core usb_common thermal fan thermal_sys
[17190.298419] CPU: 2 PID: 4743 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #102
[17190.305926] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[17190.313906]  0000000000000009 ffff88011ea86cb0 ffffffff81649c80 ffff88011ea86cf8
[17190.322034]  ffff88011ea86ce8 ffffffff810646ad 0000000000000064 ffff88011ea8cbe0
[17190.330134]  ffff8800cf7a7800 0000000000000040 ffff88011ea8cde0 ffff88011ea86d48
[17190.338122] Call Trace:
[17190.340775]  <NMI>  [<ffffffff81649c80>] dump_stack+0x45/0x56
[17190.347023]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[17190.353472]  [<ffffffff8106471c>] warn_slowpath_fmt+0x4c/0x50
[17190.359677]  [<ffffffff8102ef94>] intel_pmu_handle_irq+0x2a4/0x3c0
[17190.366315]  [<ffffffff8105034d>] ? native_write_msr_safe+0xd/0x10
[17190.372954]  [<ffffffff8165378b>] perf_event_nmi_handler+0x2b/0x50
[17190.379629]  [<ffffffff81652f58>] nmi_handle.isra.5+0xa8/0x150
[17190.385879]  [<ffffffff81652eb5>] ? nmi_handle.isra.5+0x5/0x150
[17190.392287]  [<ffffffff816530d8>] do_nmi+0xd8/0x340
[17190.397572]  [<ffffffff81652581>] end_repeat_nmi+0x1e/0x2e
[17190.403472]  [<ffffffff8105034a>] ? native_write_msr_safe+0xa/0x10
[17190.410098]  [<ffffffff8105034a>] ? native_write_msr_safe+0xa/0x10
[17190.416765]  [<ffffffff8105034a>] ? native_write_msr_safe+0xa/0x10
[17190.423386]  <<EOE>>  [<ffffffff8102eb7d>] intel_pmu_enable_event+0x21d/0x240
[17190.431048]  [<ffffffff81027baa>] x86_pmu_start+0x7a/0x100
[17190.436992]  [<ffffffff810283a5>] x86_pmu_enable+0x295/0x310
[17190.443104]  [<ffffffff8113528f>] perf_pmu_enable+0x2f/0x40
[17190.449087]  [<ffffffff811369a8>] perf_event_context_sched_in+0x88/0xd0
[17190.456165]  [<ffffffff8113713d>] __perf_event_task_sched_in+0x1dd/0x1f0
[17190.463412]  [<ffffffff81090ca8>] finish_task_switch+0xd8/0x120
[17190.469750]  [<ffffffff8164ca90>] __schedule+0x2c0/0x740
[17190.475443]  [<ffffffff8164cf39>] schedule+0x29/0x70
[17190.480772]  [<ffffffff8164c74c>] schedule_hrtimeout_range_clock+0x13c/0x180
[17190.488331]  [<ffffffff8108b1c0>] ? hrtimer_get_res+0x50/0x50
[17190.494491]  [<ffffffff8164c6c9>] ? schedule_hrtimeout_range_clock+0xb9/0x180
[17190.502135]  [<ffffffff8164c7a3>] schedule_hrtimeout_range+0x13/0x20
[17190.508983]  [<ffffffff811c94c9>] poll_schedule_timeout+0x49/0x70
[17190.515535]  [<ffffffff811cab22>] do_sys_poll+0x422/0x540
[17190.521354]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.528737]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.536129]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.543552]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.550915]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.558290]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.565698]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.573075]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.580488]  [<ffffffff811c9650>] ? poll_select_copy_remaining+0x130/0x130
[17190.589071]  [<ffffffff811cad15>] SyS_poll+0x65/0x100
[17190.595690]  [<ffffffff8165a96d>] system_call_fastpath+0x1a/0x1f
[17190.603315] ---[ end trace d44f7960e96a18da ]---
[17190.609412] 
[17190.612182] CPU#2: ctrl:       0000000000000000
[17190.618136] CPU#2: status:     0000000000000000
[17190.624190] CPU#2: overflow:   0000000000000000
[17190.630144] CPU#2: fixed:      00000000000000ba
[17190.636123] CPU#2: pebs:       0000000000000000
[17190.642042] CPU#2: active:     0000000300000001
[17190.648000] CPU#2:   gen-PMC0 ctrl:  00000000004000c4
[17190.654531] CPU#2:   gen-PMC0 count: 0000000000000001
[17190.661059] CPU#2:   gen-PMC0 left:  0000ffffffffffff
[17190.667576] CPU#2:   gen-PMC1 ctrl:  0000000000120280
[17190.674101] CPU#2:   gen-PMC1 count: 0000000000005439
[17190.680623] CPU#2:   gen-PMC1 left:  0000ffffffffaf43
[17190.687127] CPU#2:   gen-PMC2 ctrl:  0000000000114f2e
[17190.693589] CPU#2:   gen-PMC2 count: 0000000000000001
[17190.700039] CPU#2:   gen-PMC2 left:  0000ffffffffffff
[17190.706455] CPU#2:   gen-PMC3 ctrl:  00000000001300c0
[17190.712846] CPU#2:   gen-PMC3 count: 0000000000000001
[17190.719135] CPU#2:   gen-PMC3 left:  0000ffffffffffff
[17190.725357] CPU#2: fixed-PMC0 count: 0000fffffffffffe
[17190.731529] CPU#2: fixed-PMC1 count: 0000ffff192febe2
[17190.737687] CPU#2: fixed-PMC2 count: 0000000000000001
[17190.743840] perf_event_intel: clearing PMU state on CPU#2
...
[21886.270130] perf_event_intel: clearing PMU state on CPU#2

