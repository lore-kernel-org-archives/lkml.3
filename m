Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaEAPrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:47:19 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47104 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEAPrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:47:18 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 1 May 2014 11:50:54 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140501150948.GR11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu> <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Peter Zijlstra wrote:
> 
> But yes please!

OK, sorry for the delay, had forgotten to re-enable -pg for perf in the 
makefile when I applied your patch so had to re-build the kernel.

The trace is here:
	www.eece.maine.edu/~vweaver/junk/pzbug.out.bz2

No analysis so hopefully it's good, I've got an event to go to in a few 
minutes.

The messages:

[  634.846367] ------------[ cut here ]------------
[  634.851477] WARNING: CPU: 6 PID: 2915 at kernel/events/core.c:3232 __free_event+0x93/0xa0()
[  634.860583] Modules linked in: fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm crct10dif_pclmul snd_hda_codec_realtek snd_hda_codec_generic i915 drm_kms_helper crc32_pclmul snd_hda_intel snd_hda_controller ghash_clmulni_intel aesni_intel snd_hda_codec aes_x86_64 drm snd_hwdep evdev psmouse iTCO_wdt iTCO_vendor_support lrw gf128mul glue_helper snd_pcm pcspkr serio_raw i2c_i801 ablk_helper tpm_tis parport_pc parport cryptd snd_seq snd_timer snd_seq_device video battery button snd i2c_algo_bit i2c_core tpm mei_me mei lpc_ich mfd_core processor wmi soundcore sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ehci_pci ahci xhci_hcd e1000e libahci ehci_hcd libata usbcore ptp crc32c_intel pps_core scsi_mod usb_common thermal fan thermal_sys
[  634.935276] CPU: 6 PID: 2915 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #94
[  634.942754] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[  634.950728]  0000000000000009 ffff8801174b7b78 ffffffff81649bf0 0000000000000000
[  634.958795]  ffff8801174b7bb0 ffffffff810646ad ffff8800cef05000 0000000000000000
[  634.966855]  ffff8800cd47be10 ffff880036c7b388 ffff8800cef052a0 ffff8801174b7bc0
[  634.974858] Call Trace:
[  634.977482]  [<ffffffff81649bf0>] dump_stack+0x45/0x56
[  634.983007]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[  634.989447]  [<ffffffff8106478a>] warn_slowpath_null+0x1a/0x20
[  634.995674]  [<ffffffff811330e3>] __free_event+0x93/0xa0
[  635.001429]  [<ffffffff81133cce>] _free_event+0xce/0x210
[  635.007180]  [<ffffffff81133f90>] put_event+0x180/0x1f0
[  635.012796]  [<ffffffff81133e80>] ? put_event+0x70/0x1f0
[  635.018487]  [<ffffffff81134037>] perf_release+0x17/0x20
[  635.024228]  [<ffffffff811b694c>] __fput+0xdc/0x1e0
[  635.029457]  [<ffffffff811b6a9e>] ____fput+0xe/0x10
[  635.034719]  [<ffffffff81085137>] task_work_run+0xa7/0xe0
[  635.040524]  [<ffffffff81066d5c>] do_exit+0x2cc/0xa50
[  635.045978]  [<ffffffff81076949>] ? get_signal_to_deliver+0x249/0x650
[  635.052880]  [<ffffffff8106756c>] do_group_exit+0x4c/0xc0
[  635.058669]  [<ffffffff81076991>] get_signal_to_deliver+0x291/0x650
[  635.065384]  [<ffffffff81012438>] do_signal+0x48/0x990
[  635.070911]  [<ffffffff8101f516>] ? ftrace_raw_event_sys_exit+0x56/0x80
[  635.077994]  [<ffffffff81012df0>] do_notify_resume+0x70/0xa0
[  635.084059]  [<ffffffff81651f3c>] retint_signal+0x48/0x8c
[  635.089912] ---[ end trace bf0bdbfdb698177c ]---
[  635.995839] Slab corruption (Tainted: G        W    ): kmalloc-2048 start=ffff8800cef05000, len=2048
[  636.006669] 040: 6b 6b 6b 6b 6b 6b 6b 6b a8 75 90 17 01 88 ff ff  kkkkkkkk.u......
[  636.017593] Next obj: start=ffff8800cef05800, len=2048
[  636.024510] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[  636.035462] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

