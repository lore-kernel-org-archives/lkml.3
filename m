Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaCaRbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:31:45 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34588 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaCaRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:31:43 -0400
Date: Mon, 31 Mar 2014 13:34:37 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: perf_fuzzer lockup in x86_schedule_events()
In-Reply-To: <alpine.DEB.2.10.1403101137050.30293@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1403311329070.9133@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403101137050.30293@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been seeing some more of these lockups up x86_schedule_events(),
not sure if they are related.  The fuzzer triggers them often (both
on core2 and haswell) but they are not reproducible with the same random 
seed.

This one is on 3.14 on haswell.

[ 3838.480346] BUG: unable to handle kernel paging request at ffffffff7d760be0
[ 3838.491875] IP: [<ffffffff81029c8c>] x86_schedule_events+0x10c/0x270
[ 3838.502767] PGD 1811067 PUD 0 
[ 3838.510163] Oops: 0000 [#1] SMP 
[ 3838.517638] Dumping ftrace buffer:
[ 3838.525137]    (ftrace buffer empty)
[ 3838.532700] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse snd_hda_codec_hdmi i915 x86_pkg_temp_thermal intel_powerclamp coretemp drm_kms_helper drm kvm crct10dif_pclmul crc32_pclmul parport_pc ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel aesni_intel snd_hda_codec snd_hwdep aes_x86_64 snd_pcm lrw gf128mul glue_helper tpm_tis iTCO_wdt iTCO_vendor_support parport tpm video battery ablk_helper lpc_ich snd_seq snd_seq_device i2c_algo_bit snd_timer psmouse button pcspkr i2c_i801 mei_me serio_raw wmi i2c_core processor mei cryptd snd mfd_core soundcore evdev sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci libata scsi_mod e1000e ehci_pci xhci_hcd ehci_hcd ptp pps_core crc32c_intel usbcore usb_common thermal fan thermal_sys
[ 3838.636984] CPU: 2 PID: 28866 Comm: perf_fuzzer Tainted: G        W    3.14.0+ #14
[ 3838.649070] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 3838.660899] task: ffff8801156e6450 ti: ffff8800cfe66000 task.ti: ffff8800cfe66000
[ 3838.672858] RIP: 0010:[<ffffffff81029c8c>]  [<ffffffff81029c8c>] x86_schedule_events+0x10c/0x270
[ 3838.686239] RSP: 0018:ffff8800cfe67950  EFLAGS: 00010046
[ 3838.695912] RAX: 0000000000000000 RBX: ffff88011ea8ca60 RCX: 0000000000110000
[ 3838.707555] RDX: ffffffff8181e128 RSI: ffff8801181bc400 RDI: ffffffffdead0000
[ 3838.719257] RBP: ffff8800cfe679a8 R08: 0000000000000000 R09: ffffffff81a06be0
[ 3838.730928] R10: ffff88011ea8ee00 R11: 0000000000000005 R12: ffff880116f5a400
[ 3838.742611] R13: ffff88011ea8cf90 R14: 0000000000000004 R15: 0000000000000000
[ 3838.754296] FS:  00007f8b3820c700(0000) GS:ffff88011ea80000(0000) knlGS:0000000000000000
[ 3838.767010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3838.777259] CR2: ffffffff7d760be0 CR3: 00000000cf246000 CR4: 00000000001407e0
[ 3838.788988] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3838.800750] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[ 3838.812414] Stack:
[ 3838.818623]  ffff88011ea8cf80 000000021ea57068 0000000000000001 ffff8800cfe679b8
[ 3838.830794]  ffff88011ea8cf90 0000000000000000 ffff88011ea8ca60 ffff880118768ac0
[ 3838.842990]  0000000000000002 ffffffff8181afe0 0000000000000000 ffff8800cfe67ad8
[ 3838.855151] Call Trace:
[ 3838.861900]  [<ffffffff81028829>] x86_pmu_commit_txn+0x49/0xa0
[ 3838.872274]  [<ffffffff8101cba5>] ? native_sched_clock+0x35/0x90
[ 3838.882839]  [<ffffffff8102aa0f>] ? arch_perf_update_userpage+0x7f/0x90
[ 3838.894110]  [<ffffffff8112e076>] ? perf_event_update_userpage+0xa6/0x120
[ 3838.905494]  [<ffffffff8101cba5>] ? native_sched_clock+0x35/0x90
[ 3838.915928]  [<ffffffff8101cc09>] ? sched_clock+0x9/0x10
[ 3838.925549]  [<ffffffff8109afe5>] ? local_clock+0x25/0x30
[ 3838.935186]  [<ffffffff811297a7>] ? cpu_clock_event_stop+0x37/0x50
[ 3838.945515]  [<ffffffff8112c137>] ? perf_pmu_enable+0x27/0x30
[ 3838.955307]  [<ffffffff8112c29b>] ? event_sched_out.isra.75+0x15b/0x1f0
[ 3838.965936]  [<ffffffff8112cd70>] ? event_sched_in.isra.77+0x140/0x1d0
[ 3838.976427]  [<ffffffff8112cfc0>] group_sched_in+0x1c0/0x1e0
[ 3838.985931]  [<ffffffff8112c793>] ? ctx_sched_out+0x123/0x130
[ 3838.995504]  [<ffffffff8112d12b>] ctx_sched_in+0x14b/0x1d0
[ 3839.004775]  [<ffffffff8112d1ea>] perf_event_sched_in+0x3a/0x90
[ 3839.014481]  [<ffffffff8112d6b8>] perf_event_context_sched_in+0x78/0xc0
[ 3839.024927]  [<ffffffff8112ddbc>] __perf_event_task_sched_in+0x18c/0x1a0
[ 3839.035467]  [<ffffffff81091818>] finish_task_switch+0xa8/0x100
[ 3839.045174]  [<ffffffff8155c8ac>] __schedule+0x2cc/0x730
[ 3839.054178]  [<ffffffff8155cd39>] schedule+0x29/0x70
[ 3839.062864]  [<ffffffff8155c019>] schedule_timeout+0x1b9/0x250
[ 3839.072469]  [<ffffffff8131d2eb>] ? debug_object_active_state+0x12b/0x170
[ 3839.083157]  [<ffffffff8155d75f>] wait_for_completion+0x9f/0x110
[ 3839.092953]  [<ffffffff81098130>] ? wake_up_state+0x20/0x20
[ 3839.102279]  [<ffffffff810c4110>] ? call_rcu_bh+0x20/0x20
[ 3839.111418]  [<ffffffff810c1aea>] wait_rcu_gp+0x5a/0x70
[ 3839.120362]  [<ffffffff810c1a30>] ? ftrace_raw_output_rcu_utilization+0x50/0x50
[ 3839.131520]  [<ffffffff810c377a>] synchronize_sched+0x3a/0x50
[ 3839.141007]  [<ffffffff8111bb0b>] perf_trace_event_unreg.isra.1+0x3b/0x90
[ 3839.151643]  [<ffffffff8111be36>] perf_trace_destroy+0x36/0x50
[ 3839.161242]  [<ffffffff81128829>] tp_perf_event_destroy+0x9/0x10
[ 3839.171085]  [<ffffffff8112a583>] __free_event+0x23/0x60
[ 3839.180047]  [<ffffffff8112aac6>] free_event+0x96/0x170
[ 3839.188879]  [<ffffffff81130fce>] SYSC_perf_event_open+0x51e/0xb40
[ 3839.198778]  [<ffffffff8112aff3>] ? perf_event_enable+0x33/0xf0
[ 3839.208402]  [<ffffffff811319b9>] SyS_perf_event_open+0x9/0x10
[ 3839.217942]  [<ffffffff81568d6d>] system_call_fastpath+0x1a/0x1f
[ 3839.227649] Code: 8d 40 01 74 32 48 8b b4 c3 28 05 00 00 48 83 c0 01 48 63 be 4c 01 00 00 4c 8b 8e 88 01 00 00 83 ff ff 0f 84 22 01 00 00 41 89 c0 <49> 0f a3 39 45 19 c9 45 85 c9 75 a0 45 31 e4 44 3b 45 b4 be 01 
[ 3839.256436] RIP  [<ffffffff81029c8c>] x86_schedule_events+0x10c/0x270
[ 3839.266604]  RSP <ffff8800cfe67950>
[ 3839.273438] CR2: ffffffff7d760be0
[ 3839.392197] ---[ end trace 15b4d5d0a680d664 ]---

