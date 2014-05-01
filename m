Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaEAODe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:03:34 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:59577 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEAODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:03:33 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 1 May 2014 10:07:08 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140430184437.GH17778@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
References: <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014, Peter Zijlstra wrote:

> Vince, could you add the below to whatever tracing muck you already
> have?

OK, running with your patch, I get this messages a few times.  No crashing 
or memory corruption messages, but as I've said before that only happens 
maybe 10% of the time, let me run a few more times.

line 1666 is
	        WARN_ON(event->ctx != ctx);

[  583.051054] ------------[ cut here ]------------
[  583.056011] WARNING: CPU: 1 PID: 2479 at kernel/events/core.c:1666 event_sched_in.isra.77+0x209/0x230()
[  583.066099] Modules linked in: fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp i915 kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller crct10dif_pclmul drm_kms_helper snd_hda_codec crc32_pclmul ghash_clmulni_intel aesni_intel snd_hwdep snd_pcm drm snd_seq aes_x86_64 lrw evdev parport_pc iTCO_wdt gf128mul snd_timer tpm_tis snd_seq_device glue_helper i2c_i801 snd iTCO_vendor_support ablk_helper cryptd parport psmouse pcspkr serio_raw button processor video battery i2c_algo_bit i2c_core tpm wmi lpc_ich mfd_core mei_me mei soundcore sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci libahci ehci_pci xhci_hcd ehci_hcd libata e1000e scsi_mod ptp usbcore crc32c_intel pps_core usb_common fan thermal thermal_sys
[  583.139793] CPU: 1 PID: 2479 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #92
[  583.147150] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[  583.155136]  0000000000000009 ffff8800cdb85bf0 ffffffff81649790 0000000000000000
[  583.163109]  ffff8800cdb85c28 ffffffff810646ad ffff8800cf085000 ffff8800cd762c00
[  583.171171]  ffff88011ea58398 ffff88011ea5839c 0000007c37c9d592 ffff8800cdb85c38
[  583.179182] Call Trace:
[  583.181834]  [<ffffffff81649790>] dump_stack+0x45/0x56
[  583.187355]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[  583.193802]  [<ffffffff8106478a>] warn_slowpath_null+0x1a/0x20
[  583.200054]  [<ffffffff81135d69>] event_sched_in.isra.77+0x209/0x230
[  583.206830]  [<ffffffff81135e42>] group_sched_in+0xb2/0x1e0
[  583.212824]  [<ffffffff81136094>] ctx_sched_in+0x124/0x1f0
[  583.218711]  [<ffffffff811361c0>] perf_event_sched_in+0x60/0x90
[  583.225063]  [<ffffffff81136a1f>] __perf_install_in_context+0x11f/0x1a0
[  583.232181]  [<ffffffff811317a0>] remote_function+0x40/0x50
[  583.238127]  [<ffffffff810dda26>] generic_exec_single+0x126/0x170
[  583.244681]  [<ffffffff81131760>] ? task_clock_event_add+0x40/0x40
[  583.251300]  [<ffffffff810ddad7>] smp_call_function_single+0x67/0xa0
[  583.258103]  [<ffffffff81130784>] task_function_call+0x44/0x50
[  583.264366]  [<ffffffff81136900>] ? perf_cpu_hrtimer_handler+0x200/0x200
[  583.271547]  [<ffffffff81131ba6>] perf_install_in_context+0x86/0x100
[  583.278342]  [<ffffffff8113a488>] SYSC_perf_event_open+0x968/0xb00
[  583.284990]  [<ffffffff8113aa09>] SyS_perf_event_open+0x9/0x10
[  583.291249]  [<ffffffff8165a46d>] system_call_fastpath+0x1a/0x1f
[  583.297658] ---[ end trace 41ec7a21bb260454 ]---
[  623.740479] ------------[ cut here ]------------

