Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3FRSql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab3FRSqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:46:40 -0400
Message-ID: <51C0AB09.2090605@redhat.com>
Date: Tue, 18 Jun 2013 14:46:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: BUG: tick device NULL pointer during system initialization and shutdown
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar panics reported during bringup here:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166205.html
http://lkml.org/lkml/2013/5/8/342

I've seen this a few times on 3.10 based kernels.

[  175.842027] Disabling non-boot CPUs ...
[  475.827017] BUG: unable to handle kernel NULL pointer dereference at
0000000000000048
[  475.835780] IP: [<ffffffff810b8257>] tick_do_broadcast+0x67/0xa0
[  475.842499] PGD 0
[  475.844750] Oops: 0000 [#1] SMP
[  475.848368] Modules linked in: lockd nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg
acpi_cpufreq mperf i7core_edac coretemp iTCO_wdt iTCO_vendor_support kvm_intel
edac_core kvm lpc_ich mfd_core serio_raw microcode pcspkr xfs libcrc32c sr_mod
cdrom sd_mod crc_t10dif mgag200 drm_kms_helper ttm ixgbe igb ahci dca mdio drm
libahci i2c_algo_bit ptp crc32c_intel libata hpsa i2c_core pps_core sunrpc
dm_mirror dm_region_hash dm_log dm_mod
[  475.917907] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G          I
--------------   3.10.0-0.rc5.61.el7.x86_64 #1
[  475.929071] Hardware name: HP ProLiant DL180 G6  , BIOS O20 10/01/2012
[  475.936355] task: ffffffff818ff440 ti: ffffffff818ec000 task.ti:
ffffffff818ec000
[  475.944706] RIP: 0010:[<ffffffff810b8257>]  [<ffffffff810b8257>]
tick_do_broadcast+0x67/0xa0
[  475.954135] RSP: 0018:ffff88013bc03e60  EFLAGS: 00010006
[  475.960061] RAX: 0000000000000000 RBX: ffff88013b843800 RCX: 00000000000000f8
[  475.968024] RDX: 0000000000000000 RSI: 00000000000000f8 RDI: ffff88013b843800
[  475.975987] RBP: ffff88013bc03e70 R08: ffff88013b843800 R09: 000000000000004a
[  475.983950] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000e8e0
[  475.991914] R13: 000000000000e8e0 R14: 0000000000000000 R15: ffffffff8190e200
[  475.999878] FS:  0000000000000000(0000) GS:ffff88013bc00000(0000)
knlGS:0000000000000000
[  476.008908] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  476.015318] CR2: 0000000000000048 CR3: 00000000018f8000 CR4: 00000000000007f0
[  476.023281] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  476.031244] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  476.039206] Stack:
[  476.041448]  7fffffffffffffff 0000006e86ffee75 ffff88013bc03ea8 ffffffff810b847c
[  476.049741]  ffffffff81902740 0000000000000000 0000000000000000 0000000000000000
[  476.058033]  ffffffff8199dba0 ffff88013bc03eb8 ffffffff81013a75 ffff88013bc03f00
[  476.066326] Call Trace:
[  476.069054]  <IRQ>
[  476.071198]  [<ffffffff810b847c>] tick_handle_oneshot_broadcast+0x14c/0x190
[  476.079185]  [<ffffffff81013a75>] timer_interrupt+0x15/0x20
[  476.085404]  [<ffffffff810eef6e>] handle_irq_event_percpu+0x3e/0x1e0
[  476.092495]  [<ffffffff810ef147>] handle_irq_event+0x37/0x60
[  476.098812]  [<ffffffff810f1b2f>] handle_edge_irq+0x6f/0x120
[  476.105127]  [<ffffffff8101329f>] handle_irq+0xbf/0x150
[  476.110959]  [<ffffffff8160837a>] ? atomic_notifier_call_chain+0x1a/0x20
[  476.118439]  [<ffffffff8160e64d>] do_IRQ+0x4d/0xc0
[  476.123786]  [<ffffffff8160466d>] common_interrupt+0x6d/0x6d
[  476.130099]  <EOI>
[  476.132244]  [<ffffffff814abd0f>] ? cpuidle_enter_state+0x4f/0xc0
[  476.139262]  [<ffffffff814abe49>] cpuidle_idle_call+0xc9/0x210
[  476.145773]  [<ffffffff81019e6e>] arch_cpu_idle+0xe/0x30
[  476.151704]  [<ffffffff810b0387>] cpu_startup_entry+0x87/0x230
[  476.158206]  [<ffffffff815e1537>] rest_init+0x77/0x80
[  476.163845]  [<ffffffff81a26ee9>] start_kernel+0x415/0x421
[  476.169968]  [<ffffffff81a268dd>] ? repair_env_string+0x5c/0x5c
[  476.176575]  [<ffffffff81a26120>] ? early_idt_handlers+0x120/0x120
[  476.183473]  [<ffffffff81a265dc>] x86_64_start_reservations+0x2a/0x2c
[  476.190661]  [<ffffffff81a266d1>] x86_64_start_kernel+0xf3/0x100
[  476.197363] Code: 00 00 00 00 48 63 35 b1 bc 94 00 48 89 df 49 c7 c4 e0 e8 00
00 e8 aa 11 24 00 89 c0 48 89 df 48 8b 04 c5 c0 5e 9f 81 4a 8b 04 20 <ff> 50 48
5b 41 5c 5d c3 90 f0 0f b3 07 48 98 48 c7 c2 e0 e8 00
[  476.219005] RIP  [<ffffffff810b8257>] tick_do_broadcast+0x67/0xa0
[  476.225816]  RSP <ffff88013bc03e60>
[  476.229706] CR2: 0000000000000048
[  476.233402] ---[ end trace b7cdc1f0d37ce6df ]---
[  476.238552] Kernel panic - not syncing: Fatal exception in interrupt
[  477.305771] Shutting down cpus with NMI
[  477.310252] drm_kms_helper: panic occurred, switching back to text console

I'm debugging assuming a race between the downing of a cpu and the setting of
the cpu mask in the broadcast code -- tglx, what do you think?

P.
