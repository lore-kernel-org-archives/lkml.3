Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3IAPdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:33:14 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34943 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab3IAPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:33:12 -0400
MIME-Version: 1.0
Date: Sun, 1 Sep 2013 12:33:11 -0300
Message-ID: <CAH3kUhE5BLt=373NYiA4-GDmz4v5g4ekxT=Bo6U35fn0uhwmOw@mail.gmail.com>
Subject: network stopped with a kernel error
From: Roberto Spadim <roberto@spadim.com.br>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi guys, an problem occured, could anyone try to help me? i think it's
hardware error, but it's nice a second opnion
if i remove eth2 cable bond0 and everything work
the eth2 is running (yellow led on board) at 10mbps, but it's a
1000mbps (normally a green led on board) link, the other side is
running nice...
bond0 is a active backup bonding..
ethtool show eth2 and eth1 as up and running and eth2 as fibre but
it's a TP board?!
i'm considering eth2 a broken board now, but please check if i'm wrong:


[beto@raja1 bonding]# cat /proc/version
Linux version 2.6.39-ARCH (thomas@evey) (gcc version 4.6.0 20110603
(prerelease) (GCC) ) #1 SMP PREEMPT Mon Jun 27 21:26:22 CEST 2011




Sep  1 11:42:31 localhost kernel: [   57.509187] ------------[ cut
here ]------------
Sep  1 11:42:31 localhost kernel: [   57.509199] WARNING: at
net/sched/sch_generic.c:256 dev_watchdog+0x2a3/0x2b0()
Sep  1 11:42:31 localhost kernel: [   57.509202] Hardware name: System
Product Name
Sep  1 11:42:31 localhost kernel: [   57.509204] NETDEV WATCHDOG: eth2
(r8169): transmit queue 0 timed out
Sep  1 11:42:31 localhost kernel: [   57.509207] Modules linked in:
xt_limit xt_tcpudp ipt_LOG xt_state nf_nat_ftp nf_conntrack_ftp
nf_nat_irc nf_conntrack_irc ipt_MASQUERADE iptable_mangle iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter
ip_tables x_tables bonding ipv6 usbhid hid usb_storage uas serio_raw
i915 ehci_hcd drm_kms_helper pcspkr 8139too drm i2c_i801 i2c_algo_bit
skge usbcore r8169 evdev psmouse asus_atk0110 intel_agp i2c_core video
mii intel_gtt button processor iTCO_wdt iTCO_vendor_support xfs raid1
md_mod sg sd_mod pata_acpi ata_generic ata_piix libata scsi_mod
Sep  1 11:42:31 localhost kernel: [   57.509257] Pid: 0, comm:
kworker/0:1 Not tainted 2.6.39-ARCH #1
Sep  1 11:42:31 localhost kernel: [   57.509260] Call Trace:
Sep  1 11:42:31 localhost kernel: [   57.509262]  <IRQ>
[<ffffffff8105b8ff>] warn_slowpath_common+0x7f/0xc0
Sep  1 11:42:31 localhost kernel: [   57.509273]  [<ffffffff8105b9f6>]
warn_slowpath_fmt+0x46/0x50
Sep  1 11:42:31 localhost kernel: [   57.509278]  [<ffffffff81347823>]
dev_watchdog+0x2a3/0x2b0
Sep  1 11:42:31 localhost kernel: [   57.509285]  [<ffffffff81012fd9>]
? sched_clock+0x9/0x10
Sep  1 11:42:31 localhost kernel: [   57.509291]  [<ffffffff8106b7d1>]
run_timer_softirq+0x131/0x440
Sep  1 11:42:31 localhost kernel: [   57.509296]  [<ffffffff81347580>]
? qdisc_reset+0x50/0x50
Sep  1 11:42:31 localhost kernel: [   57.509300]  [<ffffffff81012a89>]
? read_tsc+0x9/0x20
Sep  1 11:42:31 localhost kernel: [   57.509304]  [<ffffffff81062ec0>]
__do_softirq+0xb0/0x280
Sep  1 11:42:31 localhost kernel: [   57.509309]  [<ffffffff8108ea98>]
? tick_dev_program_event+0x48/0x110
Sep  1 11:42:31 localhost kernel: [   57.509312]  [<ffffffff8108eb7f>]
? tick_program_event+0x1f/0x30
Sep  1 11:42:31 localhost kernel: [   57.509319]  [<ffffffff813ea15c>]
call_softirq+0x1c/0x30
Sep  1 11:42:31 localhost kernel: [   57.509321]  [<ffffffff8100dad5>]
do_softirq+0x65/0xa0
Sep  1 11:42:31 localhost kernel: [   57.509323]  [<ffffffff810633de>]
irq_exit+0x9e/0xb0
Sep  1 11:42:31 localhost kernel: [   57.509325]  [<ffffffff813eaaa0>]
smp_apic_timer_interrupt+0x70/0x9b
Sep  1 11:42:31 localhost kernel: [   57.509327]  [<ffffffff813e9913>]
apic_timer_interrupt+0x13/0x20
Sep  1 11:42:31 localhost kernel: [   57.509328]  <EOI>
[<ffffffff8126b9ce>] ? intel_idle+0xce/0x120
Sep  1 11:42:31 localhost kernel: [   57.509333]  [<ffffffff8126b9ad>]
? intel_idle+0xad/0x120
Sep  1 11:42:31 localhost kernel: [   57.509337]  [<ffffffff8130960d>]
cpuidle_idle_call+0x9d/0x350
Sep  1 11:42:31 localhost kernel: [   57.509340]  [<ffffffff8100a21a>]
cpu_idle+0xba/0x100
Sep  1 11:42:31 localhost kernel: [   57.509343]  [<ffffffff813d769c>]
start_secondary+0x202/0x209
Sep  1 11:42:31 localhost kernel: [   57.509344] ---[ end trace
fc047c16ecc8b29b ]---



---------------------------
Sep  1 11:57:02 localhost smbd[1114]: [2013/09/01 11:57:02.948770,  0]
printing/print_cups.c:108(cups_connect)
Sep  1 11:57:02 localhost smbd[1114]:   Unable to connect to CUPS
server localhost:631 - Interrupted system call
Sep  1 11:57:20 localhost kernel: [   57.535647] ------------[ cut
here ]------------
Sep  1 11:57:20 localhost kernel: [   57.535659] WARNING: at
net/sched/sch_generic.c:256 dev_watchdog+0x2a3/0x2b0()
Sep  1 11:57:20 localhost kernel: [   57.535662] Hardware name: System
Product Name
Sep  1 11:57:20 localhost kernel: [   57.535664] NETDEV WATCHDOG: eth2
(r8169): transmit queue 0 timed out
Sep  1 11:57:20 localhost kernel: [   57.535667] Modules linked in:
xt_limit xt_tcpudp ipt_LOG xt_state nf_nat_ftp nf_conntrack_ftp
nf_nat_irc nf_conntrack_irc ipt_MASQUERADE iptable_mangle iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter
ip_tables x_tables bonding ipv6 usbhid hid usb_storage uas i915
drm_kms_helper i2c_i801 drm i2c_algo_bit 8139too ehci_hcd iTCO_wdt
serio_raw r8169 mii skge psmouse evdev usbcore pcspkr asus_atk0110
iTCO_vendor_support video button i2c_core processor intel_agp
intel_gtt xfs raid1 md_mod sg sd_mod pata_acpi ata_generic ata_piix
libata scsi_mod
Sep  1 11:57:20 localhost kernel: [   57.535721] Pid: 0, comm:
kworker/0:0 Not tainted 2.6.39-ARCH #1
Sep  1 11:57:20 localhost kernel: [   57.535723] Call Trace:
Sep  1 11:57:20 localhost kernel: [   57.535725]  <IRQ>
[<ffffffff8105b8ff>] warn_slowpath_common+0x7f/0xc0
Sep  1 11:57:20 localhost kernel: [   57.535737]  [<ffffffff8105b9f6>]
warn_slowpath_fmt+0x46/0x50
Sep  1 11:57:20 localhost kernel: [   57.535742]  [<ffffffff81347823>]
dev_watchdog+0x2a3/0x2b0
Sep  1 11:57:20 localhost kernel: [   57.535748]  [<ffffffff81012fd9>]
? sched_clock+0x9/0x10
Sep  1 11:57:20 localhost kernel: [   57.535755]  [<ffffffff8106b7d1>]
run_timer_softirq+0x131/0x440
Sep  1 11:57:20 localhost kernel: [   57.535760]  [<ffffffff81347580>]
? qdisc_reset+0x50/0x50
Sep  1 11:57:20 localhost kernel: [   57.535764]  [<ffffffff81012a89>]
? read_tsc+0x9/0x20
Sep  1 11:57:20 localhost kernel: [   57.535770]  [<ffffffff81062ec0>]
__do_softirq+0xb0/0x280
Sep  1 11:57:20 localhost kernel: [   57.535773]  [<ffffffff8108ea98>]
? tick_dev_program_event+0x48/0x110
Sep  1 11:57:20 localhost kernel: [   57.535775]  [<ffffffff8108eb7f>]
? tick_program_event+0x1f/0x30
Sep  1 11:57:20 localhost kernel: [   57.535777]  [<ffffffff813ea15c>]
call_softirq+0x1c/0x30
Sep  1 11:57:20 localhost kernel: [   57.535779]  [<ffffffff8100dad5>]
do_softirq+0x65/0xa0
Sep  1 11:57:20 localhost kernel: [   57.535781]  [<ffffffff810633de>]
irq_exit+0x9e/0xb0
Sep  1 11:57:20 localhost kernel: [   57.535783]  [<ffffffff813eaaa0>]
smp_apic_timer_interrupt+0x70/0x9b
Sep  1 11:57:20 localhost kernel: [   57.535786]  [<ffffffff813e9913>]
apic_timer_interrupt+0x13/0x20
Sep  1 11:57:20 localhost kernel: [   57.535787]  <EOI>
[<ffffffff8126b9ce>] ? intel_idle+0xce/0x120
Sep  1 11:57:20 localhost kernel: [   57.535792]  [<ffffffff8126b9ad>]
? intel_idle+0xad/0x120
Sep  1 11:57:20 localhost kernel: [   57.535795]  [<ffffffff8130960d>]
cpuidle_idle_call+0x9d/0x350
Sep  1 11:57:20 localhost kernel: [   57.535799]  [<ffffffff8100a21a>]
cpu_idle+0xba/0x100
Sep  1 11:57:20 localhost kernel: [   57.535802]  [<ffffffff813d769c>]
start_secondary+0x202/0x209
Sep  1 11:57:20 localhost kernel: [   57.535804] ---[ end trace
78886bd90bfc7475 ]---




Sep  1 12:11:18 localhost kernel: [   57.508961] ------------[ cut
here ]------------
Sep  1 12:11:18 localhost kernel: [   57.508976] WARNING: at
net/sched/sch_generic.c:256 dev_watchdog+0x2a3/0x2b0()
Sep  1 12:11:18 localhost kernel: [   57.508979] Hardware name: System
Product Name
Sep  1 12:11:18 localhost kernel: [   57.508983] NETDEV WATCHDOG: eth2
(r8169): transmit queue 0 timed out
Sep  1 12:11:18 localhost kernel: [   57.508985] Modules linked in:
xt_limit xt_tcpudp ipt_LOG xt_state nf_nat_ftp nf_conntrack_ftp
nf_nat_irc nf_conntrack_irc ipt_MASQ
UERADE iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bonding
ipv6 usbhid hid usb_storage uas i915 dr
m_kms_helper drm ehci_hcd 8139too i2c_i801 psmouse skge r8169 usbcore
i2c_algo_bit serio_raw pcspkr evdev iTCO_wdt mii asus_atk0110
intel_agp i2c_core iTCO_vendor_suppo
rt intel_gtt video button processor xfs raid1 md_mod sg sd_mod
pata_acpi ata_generic ata_piix libata scsi_mod
Sep  1 12:11:18 localhost kernel: [   57.509046] Pid: 0, comm:
kworker/0:1 Not tainted 2.6.39-ARCH #1
Sep  1 12:11:18 localhost kernel: [   57.509049] Call Trace:
Sep  1 12:11:18 localhost kernel: [   57.509052]  <IRQ>
[<ffffffff8105b8ff>] warn_slowpath_common+0x7f/0xc0
Sep  1 12:11:18 localhost kernel: [   57.509067]  [<ffffffff8105b9f6>]
warn_slowpath_fmt+0x46/0x50
Sep  1 12:11:18 localhost kernel: [   57.509073]  [<ffffffff81347823>]
dev_watchdog+0x2a3/0x2b0
Sep  1 12:11:18 localhost kernel: [   57.509080]  [<ffffffff81012fd9>]
? sched_clock+0x9/0x10
Sep  1 12:11:18 localhost kernel: [   57.509088]  [<ffffffff8106b7d1>]
run_timer_softirq+0x131/0x440
Sep  1 12:11:18 localhost kernel: [   57.509096]  [<ffffffff81347580>]
? qdisc_reset+0x50/0x50
Sep  1 12:11:18 localhost kernel: [   57.509098]  [<ffffffff81012a89>]
? read_tsc+0x9/0x20
Sep  1 12:11:18 localhost kernel: [   57.509100]  [<ffffffff81062ec0>]
__do_softirq+0xb0/0x280
Sep  1 12:11:18 localhost kernel: [   57.509103]  [<ffffffff8108ea98>]
? tick_dev_program_event+0x48/0x110
Sep  1 12:11:18 localhost kernel: [   57.509105]  [<ffffffff8108eb7f>]
? tick_program_event+0x1f/0x30
Sep  1 12:11:18 localhost kernel: [   57.509107]  [<ffffffff813ea15c>]
call_softirq+0x1c/0x30
Sep  1 12:11:18 localhost kernel: [   57.509109]  [<ffffffff8100dad5>]
do_softirq+0x65/0xa0
Sep  1 12:11:18 localhost kernel: [   57.509111]  [<ffffffff810633de>]
irq_exit+0x9e/0xb0
Sep  1 12:11:18 localhost kernel: [   57.509113]  [<ffffffff813eaaa0>]
smp_apic_timer_interrupt+0x70/0x9b
Sep  1 12:11:18 localhost kernel: [   57.509116]  [<ffffffff813e9913>]
apic_timer_interrupt+0x13/0x20
Sep  1 12:11:18 localhost kernel: [   57.509116]  <EOI>
[<ffffffff8126b9ce>] ? intel_idle+0xce/0x120
Sep  1 12:11:18 localhost kernel: [   57.509122]  [<ffffffff8126b9ad>]
? intel_idle+0xad/0x120
Sep  1 12:11:18 localhost kernel: [   57.509125]  [<ffffffff8130960d>]
cpuidle_idle_call+0x9d/0x350
Sep  1 12:11:18 localhost kernel: [   57.509129]  [<ffffffff8100a21a>]
cpu_idle+0xba/0x100
Sep  1 12:11:18 localhost kernel: [   57.509132]  [<ffffffff813d769c>]
start_secondary+0x202/0x209
Sep  1 12:11:18 localhost kernel: [   57.509134] ---[ end trace
62ca9193243984e5 ]---
Sep  1 12:11:18 localhost kernel: [   57.522354] r8169 0000:04:02.0:
eth2: link up





[beto@raja1 log]# ifconfig
bond0     Link encap:Ethernet  HWaddr 00:0C:46:CD:F2:42
          inet addr:172.18.0.5  Bcast:172.18.255.255  Mask:255.255.0.0
          inet6 addr: fe80::20c:46ff:fecd:f242/64 Scope:Link
          UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:255852531 overruns:0 frame:0
          TX packets:588 errors:0 dropped:230 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:38880 (37.9 Kb)

eth0      Link encap:Ethernet  HWaddr F4:6D:04:CC:E9:13
          inet addr:172.16.0.5  Bcast:172.16.255.255  Mask:255.255.0.0
          inet6 addr: fe80::f66d:4ff:fecc:e913/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6503 errors:0 dropped:0 overruns:0 frame:0
          TX packets:9470 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:521621 (509.3 Kb)  TX bytes:11194217 (10.6 Mb)
          Interrupt:40 Base address:0x4000

eth0:0    Link encap:Ethernet  HWaddr F4:6D:04:CC:E9:13
          inet addr:172.17.0.5  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          Interrupt:40 Base address:0x4000

eth1      Link encap:Ethernet  HWaddr 00:0C:46:CD:F2:42
          UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:588 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:38880 (37.9 Kb)
          Interrupt:16

eth2      Link encap:Ethernet  HWaddr 00:0C:46:CD:F2:42
          UP BROADCAST SLAVE MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:255852531 overruns:0 frame:0
          TX packets:0 errors:0 dropped:230 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:17 Base address:0x2000

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:927 errors:0 dropped:0 overruns:0 frame:0
          TX packets:927 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:83940 (81.9 Kb)  TX bytes:83940 (81.9 Kb)




[beto@raja1 bonding]# ethtool eth2
Settings for eth2:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Speed: 1000Mb/s
        Duplex: Full
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: off
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000033 (51)
                               drv probe ifdown ifup
        Link detected: yes


[beto@raja1 bonding]# ethtool eth1
Settings for eth1:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: Unknown
        Supports Wake-on: pg
        Wake-on: g
        Current message level: 0x00000037 (55)
                               drv probe link ifdown ifup
        Link detected: yes


[beto@raja1 bonding]# ethtool eth0
Settings for eth0:
        Supported ports: [ TP MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Half 1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
        Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
        Speed: 100Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000033 (51)
                               drv probe ifdown ifup
        Link detected: yes



any help is wellcome, thanks guys
