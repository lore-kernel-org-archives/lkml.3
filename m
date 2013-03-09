Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3CIFUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 00:20:34 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:52344 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3CIFUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 00:20:33 -0500
MIME-Version: 1.0
Date: Fri, 8 Mar 2013 21:20:32 -0800
Message-ID: <CAHc-4Wa8mHcEDZxc2QhhdqD4H4cSnLNruLfdBdipkPeRB5CmTw@mail.gmail.com>
Subject: BUG in get_next_timer_interrupt
From: Syam Puranam <bugs@syam.in>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello -

I am seeing the following crash on a older kernel (2.6.32-200) but
thought I would share as I couldn't
find earlier reports of this. Please let me know if any more
information will help.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffff8107c488>] get_next_timer_interrupt+0x148/0x250
PGD b0c981067 PUD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/module/garp/parameters/garp_join_time
CPU 6
Modules linked in: 8021q garp bridge stp llc nfp(U) ipmi_devintf
ipmi_si ipmi_msghandler fuse sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf bonding nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT
xt_comment ipt_LOG xt_limit iptable_filter ip_tables ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables ipv6 xfs exportfs igb sg dcdbas microcode i2c_i801 i2c_core
iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac edac_core shpchp
ext4 mbcache jbd2 sd_mod crc_t10dif mpt2sas scsi_transport_sas
raid_class ahci dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
scsi_wait_scan]

Pid: 0, comm: swapper Tainted: G        W  ----------------
2.6.32-220.el6.x86_64 #1 Dell       C6100           /0D61XP
RIP: 0010:[<ffffffff8107c488>]  [<ffffffff8107c488>]
get_next_timer_interrupt+0x148/0x250
RSP: 0018:ffff880630a37e48  EFLAGS: 00010007
RAX: 0000000000000000 RBX: 0000000281159654 RCX: ffff880c30fa5340
RDX: 0000000000000001 RSI: 0000000000000032 RDI: ffff880c30fa5020
RBP: ffff880630a37e98 R08: 0000000000000030 R09: 0000000002811570
R10: ffff880630a37e60 R11: ffff880630a37e78 R12: 0000000281156f45
R13: ffff880c30fa4000 R14: 0000000000000040 R15: 0016f42f2a7cd7a4
FS:  0000000000000000(0000) GS:ffff880655440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000b0cabc000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff880630a36000, task ffff880c30e394c0)
Stack:
 ffff880630a37e58 ffffffff81013563 ffff880c30fa5020 ffff880c30fa5420
<0> ffff880c30fa5820 ffff880c30fa5c20 ffff880655451040 0000000000000006
<0> 0000000281156f45 0000000000000292 ffff880630a37ef8 ffffffff810a14f8
Call Trace:
 [<ffffffff81013563>] ? native_sched_clock+0x13/0x60
 [<ffffffff810a14f8>] tick_nohz_stop_sched_tick+0x2e8/0x3d0
 [<ffffffff81009dc9>] cpu_idle+0x79/0x110
 [<ffffffff814e5f23>] start_secondary+0x202/0x245
Code: 89 45 d8 45 89 c8 41 83 e0 3f 44 89 c6 66 0f 1f 44 00 00 48 63
ce 48 c1 e1 04 48 8b 04 39 48 8d 0c 0f 48 39 c8 74 22 0f 1f 40 00 <f6>
40 28 01 75 10 48 8b 50 10 48 39 da 48 0f 48 da ba 01 00 00
RIP  [<ffffffff8107c488>] get_next_timer_interrupt+0x148/0x250
 RSP <ffff880630a37e48>
CR2: 0000000000000028
