Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaEBRDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:03:17 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:47806 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaEBRDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:03:16 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 2 May 2014 13:06:52 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140502154217.GW11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405021304460.22556@vincent-weaver-1.umelst.maine.edu>
References: <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu> <20140501150948.GR11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu> <20140502154217.GW11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Peter Zijlstra wrote:
> 
> Can you give this a spin?
> 
> ---
> Subject: perf: Fix race in removing an event
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri May 2 16:56:01 CEST 2014

Nope, still shows the bug pretty quickly:

[  210.411542] ------------[ cut here ]------------
[  210.416638] WARNING: CPU: 7 PID: 2646 at kernel/events/core.c:3232 __free_event+0x93/0xa0()
[  210.425777] Modules linked in: fuse snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic x86_pkg_temp_thermal intel_powerclamp coretemp kvm snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm i915 crct10dif_pclmul crc32_pclmul snd_seq snd_timer ghash_clmulni_intel snd_seq_device aesni_intel aes_x86_64 snd lrw gf128mul ppdev glue_helper soundcore evdev drm_kms_helper iTCO_wdt drm i2c_algo_bit iTCO_vendor_support mei_me mei psmouse ablk_helper cryptd parport_pc i2c_i801 i2c_core tpm_tis battery lpc_ich mfd_core wmi parport serio_raw tpm pcspkr button processor video sd_mod sr_mod crc_t10dif cdrom crct10dif_common ahci libahci ehci_pci e1000e libata ptp xhci_hcd crc32c_intel ehci_hcd usbcore scsi_mod pps_core usb_common fan thermal thermal_sys
[  210.500288] CPU: 7 PID: 2646 Comm: perf_fuzzer Not tainted 3.15.0-rc1+ #101
[  210.507740] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[  210.515703]  0000000000000009 ffff8800cdf03b78 ffffffff81649b70 0000000000000000
[  210.523768]  ffff8800cdf03bb0 ffffffff810646ad ffff880036ee9000 0000000000000000
[  210.531931]  ffff8800cdb00a10 ffff8800cdb23248 ffff880036ee92a0 ffff8800cdf03bc0
[  210.539985] Call Trace:
[  210.542647]  [<ffffffff81649b70>] dump_stack+0x45/0x56
[  210.548199]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[  210.554644]  [<ffffffff8106478a>] warn_slowpath_null+0x1a/0x20
[  210.560916]  [<ffffffff81133083>] __free_event+0x93/0xa0
[  210.566679]  [<ffffffff81133c6e>] _free_event+0xce/0x210
[  210.572386]  [<ffffffff81133f30>] put_event+0x180/0x1f0
[  210.578004]  [<ffffffff81133e20>] ? put_event+0x70/0x1f0
[  210.583730]  [<ffffffff81133fd7>] perf_release+0x17/0x20
[  210.589443]  [<ffffffff811b68cc>] __fput+0xdc/0x1e0
[  210.594698]  [<ffffffff811b6a1e>] ____fput+0xe/0x10
[  210.599948]  [<ffffffff81085137>] task_work_run+0xa7/0xe0
[  210.605786]  [<ffffffff81066d5c>] do_exit+0x2cc/0xa50
[  210.611233]  [<ffffffff81076949>] ? get_signal_to_deliver+0x249/0x650
[  210.618186]  [<ffffffff8106756c>] do_group_exit+0x4c/0xc0
[  210.623995]  [<ffffffff81076991>] get_signal_to_deliver+0x291/0x650
[  210.630731]  [<ffffffff81012438>] do_signal+0x48/0x990
[  210.636246]  [<ffffffff81655992>] ? do_page_fault+0x22/0x30
[  210.642268]  [<ffffffff81012df0>] do_notify_resume+0x70/0xa0
[  210.648350]  [<ffffffff81651ebc>] retint_signal+0x48/0x8c
[  210.654207] ---[ end trace 55a1ac7c9a3f451c ]---
[  212.567179] Slab corruption (Tainted: G        W    ): kmalloc-2048 start=ffff880036ee9000, len=2048
[  212.576985] 040: 6b 6b 6b 6b 6b 6b 6b 6b a8 15 94 cf 00 88 ff ff  kkkkkkkk........

