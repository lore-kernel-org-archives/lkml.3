Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaENMkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:40:35 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55379 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaENMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:40:33 -0400
MIME-Version: 1.0
From: Will Platnick <wplatnick@gmail.com>
Date: Wed, 14 May 2014 08:40:11 -0400
Message-ID: <CAJDzJM5Da0-gnKPgqPMSpqALD+kmTeEy=LcOozdtf2G5b7Sa-g@mail.gmail.com>
Subject: Excessive IRQ RES in 3.2+ kernels
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel Devs,
I am having an issue with the 3.2+ kernel. As per the FAQ, please CC
me on anything I can do that would give us more to go on, as I am not
subscribed to the list.

When I boot into any 3.2+ kernel, vmstat is showing about 4000 to 5000
more interrupts per second (output is in report). According to
/proc/interrupts, the timer service is showing huge differences in #'s
between 2.6.32 and 3.2.  Here is an image showing my interrupts in
2.6.32 vs 3.2+. Notice the huge spike in RES, which I believe, is the
timer service.

https://www.evernote.com/shard/s5/sh/41c21e50-77c0-4958-9784-aafe2f2174b1/2b0cf126110924d0156749b49d77545c

This is causing a much higher reported load to the system. In 2.6.32,
we have an average load of 0.7-3, depending on our load. In 3.2+, we
have an average load of 4-15, depending on load.

Initially, I thought it may just be a reporting issue, as my requests
to the server when running the 3.2 kernel are actually 2-3 ms faster
than my other servers, but under high load (more requests per second
to our app), the 3.2 kernel had very degraded performance. On
identical boxes in our app cluster, the 3.2 kernel was taking 2.6
seconds to respond to pages, whereas the 2.6.32 kernels were
responding in 30 ms. I know these #'s don't mean much to the kernel
dev's, but it's all I have right now and I am more than willing to
grab any numbers or metrics that might be helpful.

To work around this, I tried everything in:
https://help.ubuntu.com/community/ReschedulingInterrupts

I've also tried the CSTATE and intel driver workarounds described in:
http://stackoverflow.com/questions/12111954/context-switches-much-slower-in-new-linux-kernels

Can someone tell me where to go from here? If this isn't enough
information, what do I have to do to gather better information that
would be more helpful?

vmstat 1 output for a machine with 3.2 kernel:
 3  0      0 10080568  22872 223280    0    0     4    28 16731 11850
14  2 83  0
 4  0      0 10080764  22872 223352    0    0     0     0 15854 10877
13  2 85  0
 2  0      0 10080284  22872 223468    0    0     0     0 16939 11083
19  2 79  0
 6  0      0 10070336  22876 223484    0    0     0     0 14874 9470 13  2 85  0
 2  0      0 10072328  22888 223536    0    0     0   624 16322 10791
14  2 83  1
 2  0      0 10072460  22888 223624    0    0     0     0 15675 10396
13  2 85  0
 1  0      0 10073456  22892 223508    0    0     0     0 16620 10748
15  3 82  0
 3  0      0 10074412  22892 222016    0    0     0     0 17643 11492
16  2 81  0
 3  0      0 10073488  22904 222080    0    0     0     0 16612 10943
16  2 82  0
 1  0      0 10074852  22940 222140    0    0    12   728 15861 10470
13  2 84  1
 4  0      0 10073892  22940 222212    0    0     0     8 14443 9292 13  2 85  0
 0  0      0 10074656  22940 222264    0    0     0     0 13721 9305 12  2 86  0
 0  0      0 10073696  22940 222324    0    0     0     0 15248 10123
12  2 86  0
 1  0      0 10073464  22952 222392    0    0     0   516 14452 9784 12  2 86  1
 4  0      0 10077296  22952 222456    0    0     0     0 15032 9584 12  2 86  0
 0  0      0 10074396  22952 222520    0    0     0   520 14409 9463 11  2 87  0
 1  0      0 10067316  22952 222572    0    0     0     0 14370 9169 13  2 86  0
 2  0      0 10075872  22952 222640    0    0     0     0 15960 11108
11  2 87  0
 5  0      0 10074908  22964 222712    0    0     0   620 15415 10118
12  2 85  1
 4  0      0 10075472  22964 222768    0    0     0     0 15639 10184
14  2 84  0

vmstat output for the same machine with the 2.6 kenel:
 1  0   3100 3703992 351436 5462264    0    0     0     0 10120 10600
13  1 86  0
 8  0   3100 3702032 351436 5462356    0    0     0   700 10010 10058
19  1 80  0
 4  1   3100 3702676 351408 5462192    0    0     0     0 10130 10430
13  2 82  3
 4  0   3100 3702344 351408 5462008    0    0     0     0 9808 10731 12  2 86  0
 1  0   3100 3707056 351408 5462052    0    0     0     0 10852 10984
14  2 84  0
 1  0   3100 3708760 351408 5462100    0    0     0     0 9770 10119 11  1 88  0
 1  0   3100 3708788 351408 5462164    0    0     0   692 9738 10517 12  2 87  0
 1  0   3100 3708496 351408 5462212    0    0     0     0 9201 9636 10  1 89  0
 2  1   3100 3706860 351372 5461872    0    0     0     0 9904 10721 12  1 83  4
 5  0   3100 3712580 351352 5461540    0    0     0     0 8987 9562 11  1 85  3
 2  0   3100 3713276 351352 5461608    0    0     0     0 8725 9638 11  1 88  0
 4  0   3100 3708548 351352 5461648    0    0     4   536 9224 9901 11  1 88  0
 3  0   3100 3709248 351352 5461708    0    0     0     0 8776 9441 12  1 87  0
 4  0   3100 3713852 351352 5461772    0    0     0     0 9238 9850 12  1 87  0
 3  0   3100 3714836 351352 5461816    0    0     0     0 8555 9456 10  1 88  0
 3  0   3100 3714344 351352 5461868    0    0     0     0 9169 9919 10  1 89  0
 1  0   3100 3715684 351356 5461920    0    0     0   536 10190 10632
13  1 86  0
 6  0   3100 3705400 351356 5463064    0    0     0     0 9774 10077 13  1 85  0
 2  0   3100 3707384 351356 5462036    0    0     0     0 9209 9421 12  2 87  0
 0  0   3100 3712216 351356 5462236    0    0     0     0 10183 10450
14  1 85  0
 3  0   3100 3711952 351356 5462136    0    0     0     0 9316 10084 11  1 87  0


-- Package-specific info:
** Version:
Linux version 3.2.0-0.bpo.4-amd64 (debian-kernel@lists.debian.org)
(gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Debian 3.2.51-1~bpo60+1

** Command line:
BOOT_IMAGE=/vmlinuz-3.2.0-0.bpo.4-amd64
root=UUID=84bb0054-11d8-44e8-85e0-919da171bb1b ro

** Not tainted

** Kernel log:
[    3.402344] usb 4-1: New USB device found, idVendor=046b, idProduct=ff10
[    3.407405] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.407475] usb 4-1: Product: Virtual Keyboard and Mouse
[    3.407547] usb 4-1: Manufacturer: American Megatrends Inc.
[    3.407614] usb 4-1: SerialNumber: serial
[    3.455727] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.455811] ata2.01: SATA link down (SStatus 0 SControl 300)
[    3.459756] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.459838] ata1.01: SATA link down (SStatus 0 SControl 300)
[    3.464212] ata2.00: ATA-8: WDC WD2502ABYS-01B7A0, 02.03B03, max UDMA/133
[    3.464286] ata2.00: 490350672 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.472185] ata1.00: ATA-8: WDC WD2502ABYS-01B7A0, 02.03B03, max UDMA/133
[    3.472259] ata1.00: 490350672 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.480165] ata2.00: configured for UDMA/133
[    3.492114] ata1.00: configured for UDMA/133
[    3.492548] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
[    3.493613] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
[    3.503667] sd 0:0:0:0: [sda] 490350672 512-byte logical blocks:
(251 GB/233 GiB)
[    3.503767] sd 1:0:0:0: [sdb] 490350672 512-byte logical blocks:
(251 GB/233 GiB)
[    3.503789] sd 0:0:0:0: [sda] Write Protect is off
[    3.503792] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.503806] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.504292] sd 1:0:0:0: [sdb] Write Protect is off
[    3.504362] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.504458] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.505356] input: American Megatrends Inc. Virtual Keyboard and
Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input0
[    3.505552] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID
v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse]
on usb-0000:00:1a.1-1/input0
[    3.512519]  sdb: unknown partition table
[    3.513892] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.520326] input: American Megatrends Inc. Virtual Keyboard and
Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/input/input1
[    3.520811] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID
v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.1-1/input1
[    3.520950] usbcore: registered new interface driver usbhid
[    3.521020] usbhid: USB HID core driver
[    3.541357]  sda: sda1 sda2 < sda5 sda6 >
[    3.542800] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.873638] device-mapper: uevent: version 1.0.3
[    3.875142] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[    3.884148] PM: Starting manual resume from disk
[    3.884231] PM: Hibernation image partition 8:5 present
[    3.884233] PM: Looking for hibernation image.
[    3.884497] PM: Image not found (code -22)
[    3.884500] PM: Hibernation image not present or could not be loaded.
[    3.916553] kjournald starting.  Commit interval 5 seconds
[    3.916645] EXT3-fs (sda6): mounted filesystem with ordered data mode
[    5.084348] udev[440]: starting version 164
[    5.563411] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    5.563506] ACPI: Power Button [PWRB]
[    5.563639] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    5.563727] ACPI: Power Button [PWRF]
[    5.659082] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    5.659251] ioatdma 0000:00:16.0: setting latency timer to 64
[    5.659340] ioatdma 0000:00:16.0: irq 82 for MSI/MSI-X
[    5.659540] igb 0000:01:00.0: DCA enabled
[    5.659666] igb 0000:01:00.1: DCA enabled
[    5.659832] ioatdma 0000:00:16.1: setting latency timer to 64
[    5.659900] ioatdma 0000:00:16.1: irq 83 for MSI/MSI-X
[    5.660146] ioatdma 0000:00:16.2: setting latency timer to 64
[    5.660207] ioatdma 0000:00:16.2: irq 84 for MSI/MSI-X
[    5.660458] ioatdma 0000:00:16.3: setting latency timer to 64
[    5.660520] ioatdma 0000:00:16.3: irq 85 for MSI/MSI-X
[    5.660763] ioatdma 0000:00:16.4: setting latency timer to 64
[    5.660825] ioatdma 0000:00:16.4: irq 86 for MSI/MSI-X
[    5.661069] ioatdma 0000:00:16.5: setting latency timer to 64
[    5.661131] ioatdma 0000:00:16.5: irq 87 for MSI/MSI-X
[    5.661369] ioatdma 0000:00:16.6: setting latency timer to 64
[    5.661431] ioatdma 0000:00:16.6: irq 88 for MSI/MSI-X
[    5.661636] ioatdma 0000:00:16.7: setting latency timer to 64
[    5.661698] ioatdma 0000:00:16.7: irq 89 for MSI/MSI-X
[    5.667132] EDAC MC: Ver: 2.1.0
[    5.723571] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core
#1': DEV 0000:fe:03.0
[    5.723688] EDAC PCI0: Giving out device to module 'i7core_edac'
controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[    5.725212] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core
#0': DEV 0000:ff:03.0
[    5.725304] EDAC PCI1: Giving out device to module 'i7core_edac'
controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[    5.725932] EDAC i7core: Driver loaded, 2 memory controller(s) found.
[    5.767136] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.203052] Error: Driver 'pcspkr' is already registered, aborting...
[    6.738690] Adding 999420k swap on /dev/sda5.  Priority:-1
extents:1 across:999420k
[    6.897353] EXT3-fs (sda6): using internal journal
[    7.086906] loop: module loaded
[    7.702644] kjournald starting.  Commit interval 5 seconds
[    7.702965] EXT3-fs (sda1): using internal journal
[    7.703037] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    8.994868] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.462395] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.862172] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   10.178300] RPC: Registered named UNIX socket transport module.
[   10.178369] RPC: Registered udp transport module.
[   10.178434] RPC: Registered tcp transport module.
[   10.178498] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.209822] FS-Cache: Loaded
[   10.231929] FS-Cache: Netfs 'nfs' registered for caching
[   11.698407] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   11.699989] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.069782] igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   12.071261] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   12.888012] Loading iSCSI transport class v2.0-870.
[   12.935972] iscsi: registered transport (tcp)
[   13.073363] iscsi: registered transport (iser)
[   13.091071] iscsid (1493): /proc/1493/oom_adj is deprecated, please
use /proc/1493/oom_score_adj instead.
[   22.587832] eth0: no IPv6 routers present

** Model information
sys_vendor: Supermicro
product_name: X8DTU
product_version: 1234567890
chassis_vendor: Supermicro
chassis_version: 1234567890
bios_vendor: American Megatrends Inc.
bios_version: 2.1c
board_vendor: Supermicro
board_name: X8DTU
board_version: 1234567890

** Loaded modules:
xt_multiport
ib_iser
rdma_cm
ib_cm
iw_cm
ib_sa
ib_mad
ib_core
ib_addr
iscsi_tcp
libiscsi_tcp
libiscsi
scsi_transport_iscsi
nfs
lockd
fscache
auth_rpcgss
nfs_acl
sunrpc
ipt_REJECT
xt_tcpudp
iptable_filter
ip_tables
x_tables
loop
snd_pcm
snd_timer
snd
soundcore
snd_page_alloc
coretemp
crc32c_intel
tpm_tis
tpm
tpm_bios
i2c_i801
pcspkr
i7core_edac
i2c_core
edac_core
ioatdma
evdev
joydev
processor
button
psmouse
serio_raw
thermal_sys
ext3
jbd
mbcache
dm_mod
sd_mod
crc_t10dif
usbhid
hid
ata_generic
uhci_hcd
ata_piix
libata
scsi_mod
ehci_hcd
usbcore
usb_common
igb
dca

** Network interface configuration:
############################################
#For more information, see interfaces(5).
############################################
##Loopback
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
pre-up /sbin/ethtool -s eth0 autoneg off speed 1000 duplex full
address 10.4.35.4
netmask 255.255.255.192
up route add -net 10.0.0.0/8 gw 10.4.35.1

auto eth1
iface eth1 inet static
pre-up /sbin/ethtool -s eth1 autoneg off speed 1000 duplex full
address 75.126.75.164
netmask 255.255.255.248
gateway 75.126.75.161


** Network status:
*** IP interfaces and addresses:
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 00:30:48:df:95:78 brd ff:ff:ff:ff:ff:ff
    inet 10.4.35.4/26 brd 10.4.35.63 scope global eth0
    inet6 fe80::230:48ff:fedf:9578/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 00:30:48:df:95:79 brd ff:ff:ff:ff:ff:ff
    inet x.x.x.x/29 brd 75.126.75.167 scope global eth1
    inet6 fe80::230:48ff:fedf:9579/64 scope link
       valid_lft forever preferred_lft forever

*** Device statistics:
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed
multicast|bytes    packets errs drop fifo colls carrier compressed
    lo: 5075133270 5439386    0    0    0     0          0         0
5075133270 5439386    0    0    0     0       0          0
  eth1: 4152453   18598    0    0    0     0          0         0
16236197   29903    0    0    0     0       0          0
  eth0: 2239876853 4479109    0    0    0     0          0         0
4626536018 7002044    0    0    0     0       0          0

*** Protocol statistics:
Ip:
    9024874 total packets received
    0 forwarded
    0 incoming packets discarded
    9024874 incoming packets delivered
    10080637 requests sent out
Icmp:
    17 ICMP messages received
    0 input ICMP message failed.
    ICMP input histogram:
        echo requests: 17
    19 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        destination unreachable: 2
        echo replies: 17
IcmpMsg:
        InType8: 17
        OutType0: 17
        OutType3: 2
Tcp:
    369281 active connections openings
    438597 passive connection openings
    4141 failed connection attempts
    93 connection resets received
    151 connections established
    8557621 segments received
    12007383 segments send out
    91 segments retransmited
    1 bad segments received.
    362 resets sent
Udp:
    467234 packets received
    2 packets to unknown port received.
    0 packet receive errors
    476643 packets sent
UdpLite:
TcpExt:
    4117 resets received for embryonic SYN_RECV sockets
    60 TCP sockets finished time wait in fast timer
    493747 TCP sockets finished time wait in slow timer
    181296 delayed acks sent
    49 delayed acks further delayed because of locked socket
    Quick ack mode was activated 88 times
    135092 packets directly queued to recvmsg prequeue.
    467415 bytes directly in process context from backlog
    138594 bytes directly received in process context from prequeue
    3463488 packet headers predicted
    36 packets header predicted and directly queued to user
    1748971 acknowledgments not containing data payload received
    3310262 predicted acknowledgments
    33 times recovered from packet loss by selective acknowledgements
    Detected reordering 1 times using FACK
    Detected reordering 5 times using SACK
    3 congestion windows fully recovered without slow start
    29 congestion windows recovered without slow start by DSACK
    1 congestion windows recovered without slow start after partial ack
    1 timeouts after SACK recovery
    27 fast retransmits
    60 forward retransmits
    1 retransmits in slow start
    2 other TCP timeouts
    88 DSACKs sent for old packets
    83 DSACKs received
    83 connections reset due to unexpected data
    23 connections reset due to early user close
    TCPSackShifted: 2
    TCPSackMerged: 78
    TCPSackShiftFallback: 182
    TCPBacklogDrop: 1
    TCPDeferAcceptDrop: 12722
    TCPChallengeACK: 3
    TCPSYNChallenge: 1
IpExt:
    InOctets: -1381169528
    OutOctets: 905225816


** PCI devices:
00:00.0 Host bridge [0600]: Intel Corporation 5520 I/O Hub to ESI Port
[8086:3406] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
Address: 00000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v2) Root Port (Slot-), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<512ns, L1 <64us
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [150 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>

00:01.0 PCI bridge [0604]: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 1 [8086:3408] (rev 13) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fbd00000-fbdfffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: Super Micro Computer Inc Device [15d9:0600]
Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
Address: 00000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 256 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0 <512ns, L1 <64us
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Off, PwrInd Off, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd+
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [150 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
Kernel driver in use: pcieport

00:03.0 PCI bridge [0604]: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 3 [8086:340a] (rev 13) (prog-if 00 [Normal decode])
Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: Super Micro Computer Inc Device [15d9:0600]
Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
Address: 00000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #3, PowerLimit 25.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Off, PwrInd Off, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [150 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
Kernel driver in use: pcieport

00:05.0 PCI bridge [0604]: Intel Corporation 5520/X58 I/O Hub PCI
Express Root Port 5 [8086:340c] (rev 13) (prog-if 00 [Normal decode])
Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: Super Micro Computer Inc Device [15d9:0600]
Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
Address: 00000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #2, PowerLimit 25.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Off, PwrInd Off, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [150 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:07.0 PCI bridge [0604]: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 7 [8086:340e] (rev 13) (prog-if 00 [Normal decode])
Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: Super Micro Computer Inc Device [15d9:0600]
Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
Address: 00000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #1, PowerLimit 25.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Off, PwrInd Off, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [150 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Capabilities: [160 v0] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
Kernel driver in use: pcieport

00:09.0 PCI bridge [0604]: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 9 [8086:3410] (rev 13) (prog-if 00 [Normal decode])
Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Subsystem: Super Micro Computer Inc Device [15d9:0600]
Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
Address: 00000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag+ RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #1, PowerLimit 25.000W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Off, PwrInd Off, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BCD, TimeoutDis+ ARIFwd+
DevCtl2: Completion Timeout: 260ms to 900ms, TimeoutDis- ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [150 v1] Access Control Services
ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+
EgressCtrl- DirectTrans-
ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd-
EgressCtrl- DirectTrans-
Kernel driver in use: pcieport

00:13.0 PIC [0800]: Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC
Interrupt Controller [8086:342d] (rev 13) (prog-if 20 [IO(X)-APIC])
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Region 0: Memory at fec8a000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [6c] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:14.0 PIC [0800]: Intel Corporation 5520/5500/X58 I/O Hub System
Management Registers [8086:342e] (rev 13) (prog-if 00 [8259])
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Kernel driver in use: i7core_edac

00:14.1 PIC [0800]: Intel Corporation 5520/5500/X58 I/O Hub GPIO and
Scratch Pad Registers [8086:3422] (rev 13) (prog-if 00 [8259])
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB

00:14.2 PIC [0800]: Intel Corporation 5520/5500/X58 I/O Hub Control
Status and RAS Registers [8086:3423] (rev 13) (prog-if 00 [8259])
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM L0s, Latency L0
unlimited, L1 unlimited
ClockPM- Surprise+ LLActRep+ BwNot+
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB

00:14.3 PIC [0800]: Intel Corporation 5520/5500/X58 I/O Hub Throttle
Registers [8086:3438] (rev 13) (prog-if 00 [8259])
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:16.0 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:3430] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin A routed to IRQ 43
Region 0: Memory at fbef8000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.1 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:3431] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin B routed to IRQ 44
Region 0: Memory at fbef4000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.2 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:3432] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin C routed to IRQ 45
Region 0: Memory at fbef0000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.3 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:3433] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin D routed to IRQ 46
Region 0: Memory at fbeec000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.4 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:3429] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin A routed to IRQ 43
Region 0: Memory at fbee8000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.5 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:342a] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin B routed to IRQ 44
Region 0: Memory at fbee4000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.6 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:342b] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin C routed to IRQ 45
Region 0: Memory at fbee0000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:16.7 System peripheral [0880]: Intel Corporation 5520/5500/X58
Chipset QuickData Technology Device [8086:342c] (rev 13)
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin D routed to IRQ 46
Region 0: Memory at fbedc000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [80] MSI-X: Enable+ Count=1 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [90] Express (v2) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [e0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: ioatdma

00:1a.0 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB UHCI Controller #4 [8086:3a37] (prog-if 00 [UHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Region 4: I/O ports at dc00 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1a.1 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB UHCI Controller #5 [8086:3a38] (prog-if 00 [UHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 21
Region 4: I/O ports at d880 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1a.2 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB UHCI Controller #6 [8086:3a39] (prog-if 00 [UHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin D routed to IRQ 19
Region 4: I/O ports at d800 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1a.7 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB2 EHCI Controller #2 [8086:3a3c] (prog-if 20 [EHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 18
Region 0: Memory at fbeda000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci_hcd

00:1d.0 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB UHCI Controller #1 [8086:3a34] (prog-if 00 [UHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 4: I/O ports at d480 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1d.1 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB UHCI Controller #2 [8086:3a35] (prog-if 00 [UHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 19
Region 4: I/O ports at d400 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1d.2 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB UHCI Controller #3 [8086:3a36] (prog-if 00 [UHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 18
Region 4: I/O ports at d080 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1d.7 USB Controller [0c03]: Intel Corporation 82801JI (ICH10
Family) USB2 EHCI Controller #1 [8086:3a3a] (prog-if 20 [EHCI])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 0: Memory at fbed8000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge
[8086:244e] (rev 90) (prog-if 01 [Subtractive decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
Memory behind bridge: faf00000-fb7fffff
Prefetchable memory behind bridge: 00000000f9000000-00000000f9ffffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Subsystem: Super Micro Computer Inc Device [15d9:0600]

00:1f.0 ISA bridge [0601]: Intel Corporation 82801JIR (ICH10R) LPC
Interface Controller [8086:3a16]
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 IDE interface [0101]: Intel Corporation 82801JI (ICH10 Family)
4 port SATA IDE Controller #1 [8086:3a20] (prog-if 8f [Master SecP
SecO PriP PriO])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 19
Region 0: I/O ports at d000 [size=8]
Region 1: I/O ports at cc00 [size=4]
Region 2: I/O ports at c880 [size=8]
Region 3: I/O ports at c800 [size=4]
Region 4: I/O ports at c480 [size=16]
Region 5: I/O ports at c400 [size=16]
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [b0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ata_piix

00:1f.3 SMBus [0c05]: Intel Corporation 82801JI (ICH10 Family) SMBus
Controller [8086:3a30]
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin C routed to IRQ 18
Region 0: Memory at fbed6000 (64-bit, non-prefetchable) [size=256]
Region 4: I/O ports at 0400 [size=32]
Kernel driver in use: i801_smbus

00:1f.5 IDE interface [0101]: Intel Corporation 82801JI (ICH10 Family)
2 port SATA IDE Controller #2 [8086:3a26] (prog-if 85 [Master SecO
PriO])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 19
Region 0: I/O ports at c000 [size=8]
Region 1: I/O ports at bc00 [size=4]
Region 2: I/O ports at b880 [size=8]
Region 3: I/O ports at b800 [size=4]
Region 4: I/O ports at b480 [size=16]
Region 5: I/O ports at b400 [size=16]
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [b0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ata_piix

01:00.0 Ethernet controller [0200]: Intel Corporation 82576 Gigabit
Network Connection [8086:10c9] (rev 01)
Subsystem: Super Micro Computer Inc Device [15d9:0100]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin A routed to IRQ 28
Region 0: Memory at fbde0000 (32-bit, non-prefetchable) [size=128K]
Region 1: Memory at fbdc0000 (32-bit, non-prefetchable) [size=128K]
Region 2: I/O ports at ec00 [size=32]
Region 3: Memory at fbd9c000 (32-bit, non-prefetchable) [size=16K]
Expansion ROM at fbda0000 [disabled] [size=128K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
Address: 0000000000000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
Vector table: BAR=3 offset=00000000
PBA: BAR=3 offset=00002000
Capabilities: [a0] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
MaxPayload 256 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #247, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<4us, L1 <64us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Device Serial Number 00-30-48-ff-ff-df-95-78
Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
ARICap: MFVC- ACS-, Next Function: 1
ARICtl: MFVC- ACS-, Function Group: 0
Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
IOVCap: Migration-, Interrupt Message Number: 000
IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy+
IOVSta: Migration-
Initial VFs: 8, Total VFs: 8, Number of VFs: 8, Function Dependency Link: 00
VF offset: 128, stride: 2, Device ID: 10ca
Supported Page Size: 00000553, System Page Size: 00000001
Region 0: Memory at 0000000000000000 (64-bit, non-prefetchable)
Region 3: Memory at 0000000000000000 (64-bit, non-prefetchable)
VF Migration: offset: 00000000, BIR: 0
Kernel driver in use: igb

01:00.1 Ethernet controller [0200]: Intel Corporation 82576 Gigabit
Network Connection [8086:10c9] (rev 01)
Subsystem: Super Micro Computer Inc Device [15d9:0100]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 256 bytes
Interrupt: pin B routed to IRQ 40
Region 0: Memory at fbd60000 (32-bit, non-prefetchable) [size=128K]
Region 1: Memory at fbd40000 (32-bit, non-prefetchable) [size=128K]
Region 2: I/O ports at e880 [size=32]
Region 3: Memory at fbd1c000 (32-bit, non-prefetchable) [size=16K]
Expansion ROM at fbd20000 [disabled] [size=128K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
Address: 0000000000000000  Data: 0000
Masking: 00000000  Pending: 00000000
Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
Vector table: BAR=3 offset=00000000
PBA: BAR=3 offset=00002000
Capabilities: [a0] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
MaxPayload 256 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #247, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0
<4us, L1 <64us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Device Serial Number 00-30-48-ff-ff-df-95-78
Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
ARICap: MFVC- ACS-, Next Function: 0
ARICtl: MFVC- ACS-, Function Group: 0
Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
IOVCap: Migration-, Interrupt Message Number: 000
IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy-
IOVSta: Migration-
Initial VFs: 8, Total VFs: 8, Number of VFs: 8, Function Dependency Link: 01
VF offset: 128, stride: 2, Device ID: 10ca
Supported Page Size: 00000553, System Page Size: 00000001
Region 0: Memory at 0000000000000000 (64-bit, non-prefetchable)
Region 3: Memory at 0000000000000000 (64-bit, non-prefetchable)
VF Migration: offset: 00000000, BIR: 0
Kernel driver in use: igb

06:01.0 VGA compatible controller [0300]: Matrox Graphics, Inc. MGA
G200eW WPCM450 [102b:0532] (rev 0a) (prog-if 00 [VGA controller])
Subsystem: Super Micro Computer Inc Device [15d9:0600]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 256 bytes
Interrupt: pin A routed to IRQ 10
Region 0: Memory at f9000000 (32-bit, prefetchable) [size=16M]
Region 1: Memory at faffc000 (32-bit, non-prefetchable) [size=16K]
Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=8M]
Expansion ROM at <unassigned> [disabled]
Capabilities: [dc] Power Management version 1
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

fe:00.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
QuickPath Architecture Generic Non-Core Registers [8086:2c40] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:00.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
QuickPath Architecture System Address Decoder [8086:2c01] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:02.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Link 0 [8086:2c10] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:02.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Physical 0 [8086:2c11] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:02.4 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Link 1 [8086:2c14] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:02.5 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Physical 1 [8086:2c15] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:03.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller [8086:2c18] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:03.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Target Address Decoder [8086:2c19] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:03.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller RAS Registers [8086:2c1a] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:03.4 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Test Registers [8086:2c1c] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:04.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Control Registers [8086:2c20]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:04.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Address Registers [8086:2c21]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:04.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Rank Registers [8086:2c22] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:04.3 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Thermal Control Registers
[8086:2c23] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:05.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Control Registers [8086:2c28]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:05.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Address Registers [8086:2c29]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:05.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Rank Registers [8086:2c2a] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:05.3 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Thermal Control Registers
[8086:2c2b] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:06.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Control Registers [8086:2c30]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:06.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Address Registers [8086:2c31]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:06.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Rank Registers [8086:2c32] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

fe:06.3 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Thermal Control Registers
[8086:2c33] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:00.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
QuickPath Architecture Generic Non-Core Registers [8086:2c40] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:00.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
QuickPath Architecture System Address Decoder [8086:2c01] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Link 0 [8086:2c10] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Physical 0 [8086:2c11] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.4 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Link 1 [8086:2c14] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.5 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7 QPI
Physical 1 [8086:2c15] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:03.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller [8086:2c18] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:03.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Target Address Decoder [8086:2c19] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:03.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller RAS Registers [8086:2c1a] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:03.4 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Test Registers [8086:2c1c] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:04.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Control Registers [8086:2c20]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:04.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Address Registers [8086:2c21]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:04.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Rank Registers [8086:2c22] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:04.3 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 0 Thermal Control Registers
[8086:2c23] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:05.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Control Registers [8086:2c28]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:05.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Address Registers [8086:2c29]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:05.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Rank Registers [8086:2c2a] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:05.3 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 1 Thermal Control Registers
[8086:2c2b] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:06.0 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Control Registers [8086:2c30]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:06.1 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Address Registers [8086:2c31]
(rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:06.2 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Rank Registers [8086:2c32] (rev
05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:06.3 Host bridge [0600]: Intel Corporation Xeon 5500/Core i7
Integrated Memory Controller Channel 2 Thermal Control Registers
[8086:2c33] (rev 05)
Subsystem: Intel Corporation Device [8086:8086]
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0


** USB devices:
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 046b:ff10 American Megatrends, Inc.
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub


-- System Information:
Debian Release: 6.0.9
  APT prefers oldstable-updates
  APT policy: (500, 'oldstable-updates'), (500, 'oldstable')
Architecture: amd64 (x86_64)

Kernel: Linux 3.2.0-0.bpo.4-amd64 (SMP w/16 CPU cores)
Locale: LANG=en_US, LC_CTYPE=en_US (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages linux-image-3.2.0-0.bpo.4-amd64 depends on:
ii  debconf [debconf-2.0]       1.5.36.1     Debian configuration management sy
ii  initramfs-tools [linux-init 0.99~bpo60+1 tools for generating an initramfs
ii  linux-base                  3.4~bpo60+1  Linux image base package
ii  module-init-tools           3.12-2       tools for managing Linux kernel mo

Versions of packages linux-image-3.2.0-0.bpo.4-amd64 recommends:
pn  firmware-linux-free           <none>     (no description available)

Versions of packages linux-image-3.2.0-0.bpo.4-amd64 suggests:
pn  debian-kernel- <none>                    (no description available)
ii  grub-pc        1.98+20100804-14+squeeze1 GRand Unified Bootloader, version
pn  linux-doc-3.2  <none>                    (no description available)

Versions of packages linux-image-3.2.0-0.bpo.4-amd64 is related to:
pn  firmware-atheros              <none>     (no description available)
pn  firmware-bnx2                 <none>     (no description available)
pn  firmware-bnx2x                <none>     (no description available)
pn  firmware-brcm80211            <none>     (no description available)
pn  firmware-intelwimax           <none>     (no description available)
pn  firmware-ipw2x00              <none>     (no description available)
pn  firmware-ivtv                 <none>     (no description available)
pn  firmware-iwlwifi              <none>     (no description available)
pn  firmware-libertas             <none>     (no description available)
pn  firmware-linux                <none>     (no description available)
pn  firmware-linux-nonfree        <none>     (no description available)
pn  firmware-myricom              <none>     (no description available)
pn  firmware-netxen               <none>     (no description available)
pn  firmware-qlogic               <none>     (no description available)
pn  firmware-ralink               <none>     (no description available)
pn  firmware-realtek              <none>     (no description available)
pn  xen-hypervisor                <none>     (no description available)

-- debconf-show failed
