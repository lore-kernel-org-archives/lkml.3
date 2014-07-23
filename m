Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbaGWJMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:12:40 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:25250
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757699AbaGWJME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:12:04 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <mark.rutland@arm.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v5 0/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 23 Jul 2014 16:24:41 +0800
Message-ID: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(479174003)(199002)(189002)(97736001)(102836001)(62966002)(229853001)(85852003)(33646002)(77156001)(50986999)(88136002)(81542001)(81342001)(23676002)(104016003)(105606002)(36756003)(83072002)(87286001)(46102001)(76482001)(4396001)(31966008)(47776003)(80022001)(50226001)(104166001)(20776003)(106466001)(84676001)(83322001)(6806004)(95666004)(86362001)(79102001)(74502001)(19580395003)(89996001)(44976005)(575784001)(21056001)(74662001)(81156004)(87936001)(93916002)(64706001)(77982001)(69596002)(85306003)(68736004)(107046002)(50466002)(99396002)(92726001)(26826002)(19580405001)(92566001)(19627235001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB571;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changed in v5:
- add "*chan_dev = dma->chan_using->device->dev" for reduce the call time.
- add the test logs.

Changed in v4:
- cancelled  "i2c_imx->use_dma".
- changed "Dma" to "DMA".
- add Timeout handling  for Transfer complete.

Changed in v3:
- fix a bug when request the dma faild.
- some minor fixes for coding style.
- other minor fixes.

Changed in v2:
- remove has_dma_support property
- unify i2c_imx_dma_rx and i2c_imx_dma_tx
- unify i2c_imx_dma_read and i2c_imx_pio_read
- unify i2c_imx_dma_write and i2c_imx_pio_write

Added in v1:
- Enable dma if it's support dma and transfer size bigger than the threshold.
- Add device tree bindings for i2c eDMA support.
- Add eDMA support for i2c driver.

The test log:(one EEPROM on I2C2, use i2cdump tools)


U-Boot 2014.01-00634-g22b2f38-dirty (Jul 17 2014 - 17:16:37)

CPU:   Freescale LayerScape SLS1020, Version: 1.0, (0x87080010)
Clock Configuration:
       CPU0(ARMV7):1000 MHz,
       Bus:300  MHz, DDR:800  MHz (1600 MT/s data rate), Reset Configuration Word (RCW):
       00000000: 0608000a 00000000 00000000 00000000
       00000010: 20000000 00407900 e0025a00 21046000
       00000020: 00000000 00000000 00000000 00038000
       00000030: 00000000 881b7540 00000000 00000000
Board: LS1021ATWR
CPLD:  V1.1
PCBA:  V2.0
VBank: 1
I2C:   ready
DRAM:  PGTABLE_SIZE 4000, gd->relocaddr c0000000
gd->relocaddr bfffc000
gd->relocaddr bfff0000
TLB table from bfff0000 to bfff4000
1 GiB
Using SERDES1 Protocol: 32 (0x20)
Flash: 128 MiB
MMC:   FSL_SDHC: 0
EEPROM: ret 1 0
ret 2 0
ID: NXID v16777216
SN:
Errata:
Build date: 2014/07/17 12:12:12
Eth0: 00:04:9f:ef:00:00
Eth1: 00:04:9f:ef:01:01
Eth2: 00:04:9f:ef:02:02
Eth3: 00:04:9f:ef:03:03
CRC: bf83b86a
NXID v16777216
In:    serial
Out:   serial
Err:   serial
Net:   eTSEC1 is in sgmii mode.
eTSEC2 is in sgmii mode.
eTSEC1 [PRIME], eTSEC2, eTSEC3
=> run yyboot
Speed: 1000, full duplex
BOOTP broadcast 1
BOOTP broadcast 2
*** Unhandled DHCP Option in OFFER/ACK: 44
*** Unhandled DHCP Option in OFFER/ACK: 46
*** Unhandled DHCP Option in OFFER/ACK: 44
*** Unhandled DHCP Option in OFFER/ACK: 46 DHCP client bound to address 10.193.20.30 Using eTSEC1 device TFTP from server 10.193.20.35; our IP address is 10.193.20.30 Filename 'twr/uImage.ls1'.
Load address: 0x82000000
Loading: #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         ###################################
         2.7 MiB/s
done
Bytes transferred = 6236192 (5f2820 hex)
Speed: 1000, full duplex
Using eTSEC1 device
TFTP from server 10.193.20.35; our IP address is 10.193.20.30 Filename 'twr/ls1021a-twr.dtb'.
Load address: 0x8f000000
Loading: ##
         229.5 KiB/s
done
Bytes transferred = 19995 (4e1b hex)
Speed: 1000, full duplex
Using eTSEC1 device
TFTP from server 10.193.20.35; our IP address is 10.193.20.30 Filename 'twr/Ramdisk.uboot'.
Load address: 0x88000000
Loading: #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #################################################################
         #####
         2.9 MiB/s
done
Bytes transferred = 19156457 (1244de9 hex) ## Booting kernel from Legacy Image at 82000000 ...
   Image Name:   Linux Kernel
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    6236128 Bytes = 5.9 MiB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
## Loading init Ramdisk from Legacy Image at 88000000 ...
   Image Name:   fsl-image-core-ls1021atwr-201406
   Image Type:   ARM Linux RAMDisk Image (gzip compressed)
   Data Size:    19156393 Bytes = 18.3 MiB
   Load Address: 00000000
   Entry Point:  00000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 8f000000
   Booting using the fdt blob at 0x8f000000
   Loading Kernel Image ... OK
   Using Device Tree in place at 8f000000, end 8f007e1a

Starting kernel ...

Booting Linux on physical CPU 0xf00
Linux version 3.12.0+ (b46683@rock) (gcc version 4.8.3 20131202 (prerelease) (cr                                         osstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC 2013.11) ) #190 SMP Fri Jul 18                                          14:24:11 CST 2014
CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=30c73c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: Freescale Layerscape LS1021A, model: LS1021A TWR Board Memory policy: ECC disabled, Data cache writealloc
PERCPU: Embedded 7 pages/cpu @89a56000 s7680 r8192 d12800 u32768 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096 Kernel command line: root=/dev/ram0 rw console=ttyS0,115200 PID hash table entries: 4096 (order: 2, 16384 bytes) Dentry cache hash table entries: 131072 (order: 7, 524288 bytes) Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1014380K/1048576K available (4367K kernel code, 241K rwdata, 1288K rodat                                         a, 191K init, 215K bss, 34196K reserved, 0K highmem)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc0800000 - 0xff000000   (1000 MB)
    lowmem  : 0x80000000 - 0xc0000000   (1024 MB)
    pkmap   : 0x7fe00000 - 0x80000000   (   2 MB)
    modules : 0x7f000000 - 0x7fe00000   (  14 MB)
      .text : 0x80008000 - 0x8058df74   (5656 kB)
      .init : 0x8058e000 - 0x805bde00   ( 192 kB)
      .data : 0x805be000 - 0x805fa7d8   ( 242 kB)
       .bss : 0x805fa7e0 - 0x806305a8   ( 216 kB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1 Hierarchical RCU implementation.
        RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
NR_IRQS:16 nr_irqs:16 16
Architected cp15 timer(s) running at 12.50MHz (phys).
Switching to timer-based delay loop
sched_clock: ARM arch timer >56 bits at 12500kHz, resolution 80ns
sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 4294967286ms
Console: colour dummy device 80x30
Calibrating delay loop (skipped), value calculated using timer frequency.. 25.00                                          BogoMIPS (lpj=125000)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
CPU0: update cpu_power 1024
CPU0: thread -1, cpu 0, socket 15, mpidr 80000f00 Setting up static identity map for 0x8044a3c0 - 0x8044a3f4
CPU1: Booted secondary processor
CPU1: update cpu_power 1024
CPU1: thread -1, cpu 1, socket 15, mpidr 80000f01 Brought up 2 CPUs
SMP: Total of 2 processors activated.
CPU: All CPU(s) started in HYP mode.
CPU: Virtualization extensions available.
devtmpfs: initialized
VFP support v0.3: implementor 41 architecture 2 part 30 variant 7 rev 5
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
cpuidle: using governor ladder
cpuidle: using governor menu
OF: no ranges; cannot translate
OF: no ranges; cannot translate
bio: create slab <bio-0> at 0
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb i2c i2c-0: IMX I2C adapter registered i2c i2c-1: IMX I2C adapter registered
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@l                                         inux.it>
PTP clock support registered
fsl-ifc 1530000.ifc: Freescale Integrated Flash Controller Switched to clocksource arch_sys_counter
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 4, 65536 bytes) TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 2, 24576 bytes) UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Trying to unpack rootfs image as initramfs...
rootfs image is not initramfs (no cpio magic); looks like an initrd Freeing initrd memory: 18700K (88001000 - 89244000)
NFS: Registering the id_resolver key type Key type id_resolver registered Key type id_legacy registered
jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
msgmni has been set to 2017
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 118, base_baud = 9375000) is a 16                                         550A
console [ttyS0] enabled
21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 118, base_baud = 9375000) is a 16                                         550A
serial: Freescale lpuart driver
2950000.serial: ttyLP0 at MMIO 0x2950000 (irq = 112, base_baud = 6250000) is a F                                         SL_LPUART
brd: module loaded
loop: module loaded
60000000.nor: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer ID 0x00008                                         9 Chip ID 0x00227e
Amd/Fujitsu Extended Query Table at 0x0040
  Amd/Fujitsu Extended Query version 1.3.
number of CFI chips: 1
4 ofpart partitions found on MTD device 60000000.nor Creating 4 MTD partitions on "60000000.nor":
0x000000000000-0x000000020000 : "NOR RCW Image"
0x000000020000-0x000000120000 : "NOR DTB Image"
0x000000120000-0x000000920000 : "NOR Linux Kernel Image"
0x000000920000-0x000003b20000 : "NOR Ramdisk Root File System"
6Freescale DSPI master initialized
CAN device driver interface
flexcan 2a70000.can: no ipg clock defined
flexcan: probe of 2a70000.can failed with error -2 flexcan 2a80000.can: no ipg clock defined
flexcan: probe of 2a80000.can failed with error -2
libphy: Freescale PowerQUICC MII Bus: probed mdio_bus mdio@2d24000: cannot get PHY at address 8 fsl-gianfar ethernet.6: enabled errata workarounds, flags: 0x4 fsl-gianfar ethernet.6 eth0: mac: 00:04:9f:ef:00:00 fsl-gianfar ethernet.6 eth0: Running with NAPI enabled fsl-gianfar ethernet.6 eth0: RX BD ring size for Q[0]: 256 fsl-gianfar ethernet.6 eth0: TX BD ring size for Q[0]: 256 fsl-gianfar ethernet.7: enabled errata workarounds, flags: 0x4 fsl-gianfar ethernet.7 eth1: mac: 00:04:9f:ef:01:01 fsl-gianfar ethernet.7 eth1: Running with NAPI enabled fsl-gianfar ethernet.7 eth1: RX BD ring size for Q[0]: 256 fsl-gianfar ethernet.7 eth1: TX BD ring size for Q[0]: 256 fsl-gianfar ethernet.8: enabled errata workarounds, flags: 0x4 fsl-gianfar ethernet.8 eth2: mac: 00:04:9f:ef:02:02 fsl-gianfar ethernet.8 eth2: Running with NAPI enabled fsl-gianfar ethernet.8 eth2: RX BD ring size for Q[0]: 256 fsl-gianfar ethernet.8 eth2: TX BD ring size for Q[0]: 256
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
xhci-hcd xhci-hcd.0.auto: xHCI Host Controller xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 1 xhci-hcd xhci-hcd.0.auto: irq 125, io mem 0x03100000 hub 1-0:1.0: USB hub found hub 1-0:1.0: 1 port detected xhci-hcd xhci-hcd.0.auto: xHCI Host Controller xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 2 hub 2-0:1.0: USB hub found hub 2-0:1.0: 1 port detected
usbcore: registered new interface driver usb-storage
mousedev: PS/2 mouse device common for all mice i2c /dev entries driver
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pltfm: SDHCI platform and OF driver helper
mmc0: SDHCI controller on 1560000.esdhc [1560000.esdhc] using ADMA Value in jrstart addr c0c0005c, value prev 0 new f caam 1700000.crypto: Instantiated RNG4 SH0 caam 1700000.crypto: Instantiated RNG4 SH1 caam 1700000.crypto: device ID = 0x0a140300 (Era 67108864) caam 1700000.crypto: job rings = 4, qi = 0 caam algorithms registered in /proc/crypto caam_jr 1710000.jr: registering rng-caam
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
sit: IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
can: controller area network core (rev 20120528 abi 9)
NET: Registered protocol family 29
can: raw protocol (rev 20120528)
Key type dns_resolver registered
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
RAMDISK: gzip image found at block 0
usb 1-1: new high-speed USB device number 2 using xhci-hcd hub 1-1:1.0: USB hub found hub 1-1:1.0: 4 ports detected usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd
usb 2-1: Parent hub missing LPM exit latency info.  Power management will be imp                                         acted.
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 4 ports detected
VFS: Mounted root (ext2 filesystem) on device 1:0.
devtmpfs: mounted
Freeing unused kernel memory: 188K (8058e000 - 805bd000)
INIT: version 2.88 booting
Starting udev
udevd[108]: starting version 182
Starting Bootlog daemon: bootlogd.
Populating dev cache
Configuring network interfaces... IPv6: ADDRCONF(NETDEV_UP): eth0: link is not r                                         eady
udhcpc (v1.21.1) started
Sending discover...
libphy: mdio@2d24000:02 - Link is Down
Sending discover...
libphy: mdio@2d24000:02 - Link is Up - 1000/Full
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready Sending discover...
Sending select for 10.193.20.30...
Lease of 10.193.20.30 obtained, lease time 14400
/etc/udhcpc.d/50default: Adding DNS 10.192.130.201
/etc/udhcpc.d/50default: Adding DNS 10.211.0.3
/etc/udhcpc.d/50default: Adding DNS 10.196.51.200 done.
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
hwclock: can't open '/dev/misc/rtc': No such file or directory Wed Jun 25 11:59:00 UTC 2014
hwclock: can't open '/dev/misc/rtc': No such file or directory Running postinst /etc/rpm-postinsts/100-sysvinit-inittab...
Running postinst /etc/rpm-postinsts/101-debianutils...
update-rc.d: /etc/init.d/run-postinsts exists during rc.d purge (continuing)  Removing any system startup links for run-postinsts ...
  /etc/rcS.d/S99run-postinsts
INIT: Entering runlevel: 5
Starting OpenBSD Secure Shell server: sshd
  generating ssh RSA key...
  generating ssh ECDSA key...
  generating ssh DSA key...

done.
hwclock: can't open '/dev/misc/rtc': No such file or directory Starting network benchmark server: netserver.
Starting system log daemon...0
Starting kernel log daemon...0
Starting internet superserver: xinetd.
Stopping Bootlog daemon: bootlogd.

Poky (Yocto Project Reference Distro) 1.5 ls1021atwr /dev/ttyS0

ls1021atwr login: root
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x30 0xb0 0xb1 0xb2 0xb3 0xb4 0xb5 0xb6 0xb7 0xb8 0xb9 0xba 0xbb 0xbc 0xbd 0xbe 0xbf i
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x30 0xb0 0xb1 0xb2 0xb3 0xb4 0xb5 0xb6 0xb7 0xb8 0xb9 0xba 0xbb 0xbc 0xbd 0xbe 0xbf i
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x30 0xb0 0xb1 0xb2 0xb3 0xb4 0xb5 0xb6 0xb7 0xb8 0xb9 0xba 0xbb 0xbc 0xbd 0xbe 0xbf i
root@ls1021atwr:~# i2cdump -y 1 0x52 i
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 10 11 12 13 14 15 16 17 17 38 0a 0b 0c 0d 0e 0f    ?????????8??????
10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f    ????????????????
20: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f    .???????????????
30: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf    ????????????????
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
root@ls1021atwr:~# i2cdump -y 1 0x52 i
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 10 11 12 13 14 15 16 17 17 38 0a 0b 0c 0d 0e 0f    ?????????8??????
10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f    ????????????????
20: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f    .???????????????
30: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf    ????????????????
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
root@ls1021atwr:~# i2cdump -y 1 0x52 i
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 10 11 12 13 14 15 16 17 17 38 0a 0b 0c 0d 0e 0f    ?????????8??????
10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f    ????????????????
20: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f    .???????????????
30: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf    ????????????????
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
root@ls1021atwr:~# i2cdump -y 1 0x52 i
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 10 11 12 13 14 15 16 17 17 38 0a 0b 0c 0d 0e 0f    ?????????8??????
10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f    ????????????????
20: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f    .???????????????
30: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf    ????????????????
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
root@ls1021atwr:~#


