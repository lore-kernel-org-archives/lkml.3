Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbbA0K1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:27:49 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56337 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbbA0K1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:27:46 -0500
Message-ID: <54C7681F.1010901@brockmann-consult.de>
Date: Tue, 27 Jan 2015 11:27:43 +0100
From: Peter Maloney <peter.maloney@brockmann-consult.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CentOS 7.0, e1000e driver issue/bug - "Detected Hardware Unit Hang:"
 "Reset adapter unexpectedly"
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:nEK5UzpE9Bog5jyIYIWnIKy/5zGHydlPrmLoDy3PBF8koO1dkYz
 KSJN7IHVuWbui13J2z99esz8ff1zkosUe416oY0lmzK5Z1u6apdoHmeTKRjUSst09vHWXNy
 A5U9EJxHRjLvfppym2S36UZ01v4oI+uuWkcYpNSzrhBjhsyw/HgqHQwZcrpBHERWWmto7OL
 J4cx6SLyqMcTBbAE+cXsg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I have a problem on a machine running CentOS 7.0, where the
kernel/e1000e reports things like "Detected Hardware Unit Hang:" and
"Reset adapter unexpectedly". The kernel version is
3.10.0-123.13.2.el7.x86_64.

I had a similar issue years ago with the same machine running openSUSE
12.3 with kernel 3.7.10, and downgrading to 3.4.47 fixed it completely.
At that time, I found this bug reported in fedora, marked as WONTFIX due
to the fedora release hitting EoL
https://bugzilla.redhat.com/show_bug.cgi?id=785806 and the dmesg output
looks similar. And recently I found this old bug for CentOS 6.
http://bugs.centos.org/view.php?id=6517 to which I replied but haven't
seen any activity there for a week.

Years ago on openSUSE 12.3 with kernel 3.7.10, this would eventually
make the network fail completely requiring a reboot. So far (up 12 days)
the machine with 3.10.x hasn't been disconnected long enough to be
noticeable.

I have seen
http://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=09357b00255c233705b1cf6d76a8d147340545b8
as mentioned in the fedora bug page, and it appears to already be
applied to this kernel.

*Here are the details for the machine with the problem:

*root@machine:~ # lsb_release -a
LSB Version: :core-4.1-amd64:core-4.1-noarch
Distributor ID: CentOS
Description: CentOS Linux release 7.0.1406 (Core)
Release: 7.0.1406
Codename: Core

root@machine:~ # uname -a
Linux machine.bc.local 3.10.0-123.13.2.el7.x86_64 #1 SMP Thu Dec 18
14:09:13 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

root@machine:~ # lspci -v
...
00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network
Connection (rev 05)
        Subsystem: Super Micro Computer Inc Device 1502
        Flags: bus master, fast devsel, latency 0, IRQ 42
        Memory at dfd00000 (32-bit, non-prefetchable) [size=128K]
        Memory at dfd25000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at f020 [size=32]
        Capabilities: [c8] Power Management version 2
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] PCI Advanced Features
        Kernel driver in use: e1000e


Here is dmesg right after boot and plugging in network after booted:

[ 368.697841] e1000e 0000:00:19.0 com: Detected Hardware Unit Hang:
  TDH <3d>
  TDT <67>
  next_to_use <67>
  next_to_clean <39>
buffer_info[next_to_clean]:
  time_stamp <1000106e9>
  next_to_watch <3d>
  jiffies <100010c60>
  next_to_watch.status <0>
MAC Status <40080083>
PHY Status <796d>
PHY 1000BASE-T Status <3800>
PHY Extended Status <3000>
PCI Status <10>
[ 370.696960] e1000e 0000:00:19.0 com: Detected Hardware Unit Hang:
  TDH <3d>
  TDT <67>
  next_to_use <67>
  next_to_clean <39>
buffer_info[next_to_clean]:
  time_stamp <1000106e9>
  next_to_watch <3d>
  jiffies <100011430>
  next_to_watch.status <0>
MAC Status <40080083>
PHY Status <796d>
PHY 1000BASE-T Status <3800>
PHY Extended Status <3000>
PCI Status <10>
[ 372.695807] e1000e 0000:00:19.0 com: Detected Hardware Unit Hang:
  TDH <3d>
  TDT <67>
  next_to_use <67>
  next_to_clean <39>
buffer_info[next_to_clean]:
  time_stamp <1000106e9>
  next_to_watch <3d>
  jiffies <100011c00>
  next_to_watch.status <0>
MAC Status <40080083>
PHY Status <796d>
PHY 1000BASE-T Status <3800>
PHY Extended Status <3000>
PCI Status <10>
[ 374.694933] e1000e 0000:00:19.0 com: Detected Hardware Unit Hang:
  TDH <3d>
  TDT <67>
  next_to_use <67>
  next_to_clean <39>
buffer_info[next_to_clean]:
  time_stamp <1000106e9>
  next_to_watch <3d>
  jiffies <1000123d0>
  next_to_watch.status <0>
MAC Status <40080083>
PHY Status <796d>
PHY 1000BASE-T Status <3800>
PHY Extended Status <3000>
PCI Status <10>
[ 374.710096] ------------[ cut here ]------------
[ 374.710124] WARNING: at net/sched/sch_generic.c:259
dev_watchdog+0x270/0x280()
[ 374.710128] NETDEV WATCHDOG: com (e1000e): transmit queue 0 timed out
[ 374.710131] Modules linked in: binfmt_misc act_police cls_basic
cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb sch_hfsc
sch_ingress sch_sfq xt_CHECKSUM ipt_rpfilter xt_stat
istic xt_CT xt_connlimit xt_realm xt_addrtype xt_comment xt_recent
xt_nat ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set
ip_set ipt_ULOG xt_LOG nf_nat_tftp nf_nat_snmp_basic n
f_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pro
to_udplite nf_conntrack_proto_sctp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 xt_TPROXY
nf_defrag_ipv6 xt_time xt_TCPMSS xt_tcpmss xt_sctp
[ 374.710177] xt_policy xt_pkttype xt_physdev xt_owner xt_NFQUEUE
xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length
xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack
xt_connmark xt_CLASSIFY xt_AUDIT xt_state iptable_raw iptable_nat
nf_nat_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_mangle nfnetlink
nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables
8021q garp stp mrp llc sg iTCO_wdt iTCO_vendor_support coretemp kvm
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel lrw gf128mul glue_helper ablk_helper cryptd serio_raw pcspkr
i2c_i801 lpc_ich mfd_core shpchp ipmi_si video ipmi_msghandler
acpi_cpufreq mperf ext4 mbcache jbd2 raid1 sd_mod crc_t10dif
crct10dif_common mgag200 syscopyarea sysfillrect ahci sysimgblt
[ 374.710232] drm_kms_helper libahci ttm libata drm igb e1000e dca
i2c_algo_bit i2c_core ptp pps_core dm_mirror dm_region_hash dm_log dm_mod
[ 374.710247] CPU: 1 PID: 0 Comm: swapper/1 Not tainted
3.10.0-123.13.2.el7.x86_64 #1
[ 374.710251] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS
2.0b 09/17/2012
[ 374.710254] ffff88022fc83d90 a08d8f9572a8441c ffff88022fc83d48
ffffffff815e232c
[ 374.710259] ffff88022fc83d80 ffffffff8105dee1 0000000000000000
ffff8802209b4000
[ 374.710264] ffff880220f60e80 0000000000000001 0000000000000001
ffff88022fc83de8
[ 374.710268] Call Trace:
[ 374.710271] <IRQ> [<ffffffff815e232c>] dump_stack+0x19/0x1b
[ 374.710285] [<ffffffff8105dee1>] warn_slowpath_common+0x61/0x80
[ 374.710291] [<ffffffff8105df5c>] warn_slowpath_fmt+0x5c/0x80
[ 374.710298] [<ffffffff81088681>] ? run_posix_cpu_timers+0x51/0x840
[ 374.710313] [<ffffffff814f0d20>] dev_watchdog+0x270/0x280
[ 374.710318] [<ffffffff814f0ab0>] ? dev_graft_qdisc+0x80/0x80
[ 374.710323] [<ffffffff8106d236>] call_timer_fn+0x36/0x110
[ 374.710328] [<ffffffff814f0ab0>] ? dev_graft_qdisc+0x80/0x80
[ 374.710333] [<ffffffff8106f2ff>] run_timer_softirq+0x21f/0x320
[ 374.710339] [<ffffffff81067047>] __do_softirq+0xf7/0x290
[ 374.710345] [<ffffffff815f435c>] call_softirq+0x1c/0x30
[ 374.710352] [<ffffffff81014cf5>] do_softirq+0x55/0x90
[ 374.710356] [<ffffffff810673e5>] irq_exit+0x115/0x120
[ 374.710361] [<ffffffff815f4d35>] smp_apic_timer_interrupt+0x45/0x60
[ 374.710366] [<ffffffff815f369d>] apic_timer_interrupt+0x6d/0x80
[ 374.710368] <EOI> [<ffffffff814835a2>] ? cpuidle_enter_state+0x52/0xc0
[ 374.710380] [<ffffffff814836d5>] cpuidle_idle_call+0xc5/0x200
[ 374.710386] [<ffffffff8101bc7e>] arch_cpu_idle+0xe/0x30
[ 374.710393] [<ffffffff810b47e5>] cpu_startup_entry+0xf5/0x290
[ 374.710399] [<ffffffff815d028e>] start_secondary+0x1c4/0x1da
[ 374.710403] ---[ end trace feb9f00b67f36ca1 ]---
[ 374.710420] e1000e 0000:00:19.0 com: Reset adapter unexpectedly
[ 378.560296] e1000e: com NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: Rx/Tx



And hours later, it repeats (no trace after first time) about 6-11 times
per day every day:

[12881.408092] e1000e 0000:00:19.0 com: Detected Hardware Unit Hang:
  TDH <63>
  TDT <7d>
  next_to_use <7d>
  next_to_clean <60>
buffer_info[next_to_clean]:
  time_stamp <100bfef24>
  next_to_watch <63>
  jiffies <100c012b9>
  next_to_watch.status <0>
MAC Status <40080083>
PHY Status <796d>
PHY 1000BASE-T Status <3800>
PHY Extended Status <3000>
PCI Status <10>
[12881.414206] e1000e 0000:00:19.0 com: Reset adapter unexpectedly
[12885.520180] e1000e: com NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: Rx/Tx


I scanned through all the machines here to see if any others use e1000e,
and found only one, which has no known issues, but doesn't have as much
network traffic.

*Here are the details for the only other e1000e machine I have, without
problems:*

09:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
Connection
        Subsystem: Super Micro Computer Inc Device 0000
        Kernel driver in use: e1000e
        Kernel modules: e1000e

Linux machine2 3.2.0-55-generic #85-Ubuntu SMP Wed Oct 2 12:29:27 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

Distributor ID: Ubuntu
Description:    Ubuntu 12.04.4 LTS
Release:        12.04
Codename:       precise

