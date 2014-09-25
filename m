Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaIYJFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:05:15 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:32480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751902AbaIYJFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:05:04 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v8 0/2] i2c: imx: add DMA support for freescale i2c driver 
Date: Thu, 25 Sep 2014 16:11:27 +0800
Message-ID: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(21056001)(83072002)(85306004)(85852003)(64706001)(87936001)(88136002)(87286001)(84676001)(50986999)(23676002)(36756003)(77156001)(47776003)(62966002)(31966008)(92566001)(95666004)(89996001)(50466002)(104016003)(46102003)(79102003)(80022003)(90102001)(19580395003)(6806004)(68736004)(92726001)(106466001)(33646002)(81342003)(83322001)(19580405001)(50226001)(86362001)(97736003)(102836001)(4396001)(10300001)(105606002)(107046002)(104166001)(44976005)(20776003)(93916002)(74662003)(74502003)(99396003)(76482002)(229853001)(81542003)(77982003)(120916001)(575784001)(19627235001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB378;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB378;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changed in v8:
- some minor fixes for coding style.
- unsetting I2CR_DMAEN immediatelly when failed in DMA mode.

Changed in v7:
- when  waiting for transfer complete use schedule() instead of udelay().

Changed in v6:
- changed the inappropriate print message.
- rebase to the latest code.

Changed in v5:
- add "*chan_dev = dma->chan_using->device->dev" for code cleanup.
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



U-Boot 2014.01-00711-g3ba5dca (Sep 24 2014 - 14:47:07) 

CPU: Freescale LayerScape UnknownE, Version: 1.0, (0x87080310) 
Clock Configuration: 
CPU0(ARMV7):500 MHz, 
Bus:300 MHz, DDR:800 MHz (1600 MT/s data rate), 
Reset Configuration Word (RCW): 
00000000: 06080005 00000000 00000000 00000000 
00000010: 20000000 00407900 e0025a00 21046000 
00000020: 00000000 00000000 00000000 00038000 
00000030: 00080000 881b7540 00000000 00000000 
Board: LS1021ATWR 
CPLD: V1.1 
PCBA: V2.0 
VBank: 0 
I2C: ready 
DRAM: 1 GiB (DDR3, 32-bit, CL=10.5, ECC off) 
Using SERDES1 Protocol: 32 (0x20) 
Flash: 128 MiB 
MMC: FSL_SDHC: 0 
EEPROM: NXID v1 
Not a microcode 
In: serial 
Out: serial 
Err: serial 
SATA link 0 timeout. 
AHCI 0001.0300 1 slots 1 ports ? Gbps 0x1 impl SATA mode 
flags: 64bit ncq pm clo only pmp fbss pio slum part ccc 
scanning bus for devices... 
Found 0 device(s). 
Net: eTSEC1 is in sgmii mode. 
eTSEC2 is in sgmii mode. 
eTSEC1, eTSEC2 [PRIME], eTSEC3 
Hit any key to stop autoboot: 0 
=> run bigboot 
Speed: 1000, full duplex 
BOOTP broadcast 1 
BOOTP broadcast 2 
*** Unhandled DHCP Option in OFFER/ACK: 44 
*** Unhandled DHCP Option in OFFER/ACK: 46 
BOOTP broadcast 3 
*** Unhandled DHCP Option in OFFER/ACK: 44 
*** Unhandled DHCP Option in OFFER/ACK: 46 
*** Unhandled DHCP Option in OFFER/ACK: 44 
*** Unhandled DHCP Option in OFFER/ACK: 46 
DHCP client bound to address 10.193.20.8 
Using eTSEC2 device 
TFTP from server 10.193.20.106; our IP address is 10.193.20.8 
Filename 'yuanyao/uImage.ls1'. 
Load address: 0x82000000 
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
########################### 
2.2 MiB/s 
done 
Bytes transferred = 6456672 (628560 hex) 
Speed: 1000, full duplex 
Using eTSEC2 device 
TFTP from server 10.193.20.106; our IP address is 10.193.20.8 
Filename 'yuanyao/ls1021a-twr.dtb'. 
Load address: 0x8f000000 
Loading: ##### 
1.9 MiB/s 
done 
Bytes transferred = 22160 (5690 hex) 
Speed: 1000, full duplex 
Using eTSEC2 device 
TFTP from server 10.193.20.106; our IP address is 10.193.20.8 
Filename 'yuanyao/Ramdisk.uboot'. 
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
##################################### 
2.2 MiB/s 
done 
Bytes transferred = 19156457 (1244de9 hex) 
## Booting kernel from Legacy Image at 82000000 ... 
Image Name: Linux Kernel 
Image Type: ARM Linux Kernel Image (uncompressed) 
Data Size: 6456608 Bytes = 6.2 MiB 
Load Address: 80008000 
Entry Point: 80008000 
Verifying Checksum ... OK 
## Loading init Ramdisk from Legacy Image at 88000000 ... 
Image Name: fsl-image-core-ls1021atwr-201406 
Image Type: ARM Linux RAMDisk Image (gzip compressed) 
Data Size: 19156393 Bytes = 18.3 MiB 
Load Address: 00000000 
Entry Point: 00000000 
Verifying Checksum ... OK 
## Flattened Device Tree blob at 8f000000 
Booting using the fdt blob at 0x8f000000 
Loading Kernel Image ... OK 
Using Device Tree in place at 8f000000, end 8f00868f 

Starting kernel ... 

Booting Linux on physical CPU 0xf00 
Linux version 3.12.0+ (b46683@rock) (gcc version 4.8.3 20131202 (prerelease) (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC 2013.11) ) #343 SMP Thu Sep 25 15:41:03 CST 2014 
CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=30c73c7d 
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache 
Machine: Freescale Layerscape LS1021A, model: LS1021A TWR Board 
Memory policy: ECC disabled, Data cache writealloc 
PERCPU: Embedded 7 pages/cpu @89a57000 s7680 r8192 d12800 u32768 
Built 1 zonelists in Zone order, mobility grouping on. Total pages: 260096 
Kernel command line: root=/dev/ram0 rw console=ttyS0,115200 
PID hash table entries: 4096 (order: 2, 16384 bytes) 
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes) 
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes) 
Memory: 1014148K/1048576K available (4491K kernel code, 249K rwdata, 1352K rodata, 207K init, 224K bss, 34428K reserved, 0K highmem) 
Virtual kernel memory layout: 
vector : 0xffff0000 - 0xffff1000 ( 4 kB) 
fixmap : 0xfff00000 - 0xfffe0000 ( 896 kB) 
vmalloc : 0xc0800000 - 0xff000000 (1000 MB) 
lowmem : 0x80000000 - 0xc0000000 (1024 MB) 
pkmap : 0x7fe00000 - 0x80000000 ( 2 MB) 
modules : 0x7f000000 - 0x7fe00000 ( 14 MB) 
.text : 0x80008000 - 0x805bcf74 (5844 kB) 
.init : 0x805bd000 - 0x805f0e00 ( 208 kB) 
.data : 0x805f2000 - 0x80630518 ( 250 kB) 
.bss : 0x80630520 - 0x80668628 ( 225 kB) 
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1 
Hierarchical RCU implementation. 
RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2. 
NR_IRQS:16 nr_irqs:16 16 
Architected cp15 timer(s) running at 12.50MHz (phys). 
Switching to timer-based delay loop 
sched_clock: ARM arch timer >56 bits at 12500kHz, resolution 80ns 
sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 4294967286ms 
Console: colour dummy device 80x30 
Calibrating delay loop (skipped), value calculated using timer frequency.. 25.00 BogoMIPS (lpj=125000) 
pid_max: default: 32768 minimum: 301 
Mount-cache hash table entries: 512 
CPU: Testing write buffer coherency: ok 
CPU0: update cpu_power 1024 
CPU0: thread -1, cpu 0, socket 15, mpidr 80000f00 
Setting up static identity map for 0x804691e8 - 0x8046921c 
CPU1: Booted secondary processor 
CPU1: update cpu_power 1024 
CPU1: thread -1, cpu 1, socket 15, mpidr 80000f01 
Brought up 2 CPUs 
SMP: Total of 2 processors activated. 
CPU: All CPU(s) started in HYP mode. 
CPU: Virtualization extensions available. 
devtmpfs: initialized 
VFP support v0.3: implementor 41 architecture 2 part 30 variant 7 rev 5 
NET: Registered protocol family 16 
DMA: preallocated 256 KiB pool for atomic coherent allocations 
cpuidle: using governor ladder 
cpuidle: using governor menu 
irq: no irq domain found for /soc/uqe@2400000/qeic@80 ! 
irq: no irq domain found for /soc/uqe@2400000/qeic@80 ! 
bio: create slab <bio-0> at 0 
layerscape-pcie 3400000.pcie: PCI host bridge to bus 0000:00 
pci_bus 0000:00: root bus resource [bus 00-ff] 
pci_bus 0000:00: root bus resource [io 0x4010000000-0x401000ffff] 
pci_bus 0000:00: root bus resource [mem 0x4100000000-0x41ffffffff] (bus address [0x00000000-0xffffffff]) 
PCI: bus0: Fast back to back transfers disabled 
PCI: bus1: Fast back to back transfers enabled 
pci 0000:00:00.0: BAR 0: assigned [mem 0x4100000000-0x4100ffffff 64bit] 
pci 0000:00:00.0: BAR 6: assigned [mem 0x4101000000-0x4101ffffff pref] 
pci 0000:00:00.0: PCI bridge to [bus 01] 
pci 0000:00:00.0: PCI bridge to [bus 01] 
layerscape-pcie 3500000.pcie: PCI host bridge to bus 0001:00 
pci_bus 0001:00: root bus resource [bus 00-ff] 
pci_bus 0001:00: root bus resource [io 0x4810000000-0x481000ffff] (bus address [0x480fff0000-0x480fffffff]) 
pci_bus 0001:00: root bus resource [mem 0x4900000000-0x49ffffffff] (bus address [0x00000000-0xffffffff]) 
PCI: bus0: Fast back to back transfers disabled 
PCI: bus1: Fast back to back transfers enabled 
pci 0001:00:00.0: BAR 0: assigned [mem 0x4900000000-0x4900ffffff 64bit] 
pci 0001:00:00.0: BAR 6: assigned [mem 0x4901000000-0x4901ffffff pref] 
pci 0001:00:00.0: PCI bridge to [bus 01] 
pci 0000:00:00.0: PCI bridge to [bus 01] 
pci 0001:00:00.0: PCI bridge to [bus 01] 
vgaarb: loaded 
SCSI subsystem initialized 
usbcore: registered new interface driver usbfs 
usbcore: registered new interface driver hub 
usbcore: registered new device driver usb 
i2c i2c-0: IMX I2C adapter registered 
i2c i2c-0: using dma0chan16 (tx) and dma0chan17 (rx) for DMA transfers 
i2c i2c-1: IMX I2C adapter registered 
i2c i2c-1: using dma0chan18 (tx) and dma0chan19 (rx) for DMA transfers 
i2c i2c-2: IMX I2C adapter registered 
of_dma_request_slave_channel: dma-names property of node '/soc/i2c@21a0000' missing or empty 
i2c i2c-2: can't use DMA 
pps_core: LinuxPPS API ver. 1 registered 
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it> 
PTP clock support registered 
fsl-ifc 1530000.ifc: Freescale Integrated Flash Controller 
Switched to clocksource arch_sys_counter 
NET: Registered protocol family 2 
TCP established hash table entries: 8192 (order: 4, 65536 bytes) 
TCP bind hash table entries: 8192 (order: 5, 163840 bytes) 
TCP: Hash tables configured (established 8192 bind 8192) 
TCP: reno registered 
UDP hash table entries: 512 (order: 2, 24576 bytes) 
UDP-Lite hash table entries: 512 (order: 2, 24576 bytes) 
NET: Registered protocol family 1 
RPC: Registered named UNIX socket transport module. 
RPC: Registered udp transport module. 
RPC: Registered tcp transport module. 
RPC: Registered tcp NFSv4.1 backchannel transport module. 
Trying to unpack rootfs image as initramfs... 
rootfs image is not initramfs (no cpio magic); looks like an initrd 
Freeing initrd memory: 18700K (88001000 - 89244000) 
NFS: Registering the id_resolver key type 
Key type id_resolver registered 
Key type id_legacy registered 
jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc. 
msgmni has been set to 2017 
io scheduler noop registered 
io scheduler deadline registered 
io scheduler cfq registered (default) 
sii902x: probe of 1-0039 failed with error -1 
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled 
21c0500.serial: ttyS0 at MMIO 0x21c0500 (irq = 118, base_baud = 9375000) is a Freescale 16550 FIFO64 
console [ttyS0] enabled 
21c0600.serial: ttyS1 at MMIO 0x21c0600 (irq = 118, base_baud = 9375000) is a Freescale 16550 FIFO64 
of_serial 2402000.ucc: clk or clock-frequency not defined 
of_serial: probe of 2402000.ucc failed with error -2 
of_serial 2402200.ucc: clk or clock-frequency not defined 
of_serial: probe of 2402200.ucc failed with error -2 
serial: Freescale lpuart driver 
2950000.serial: ttyLP0 at MMIO 0x2950000 (irq = 112, base_baud = 6250000) is a FSL_LPUART 
brd: module loaded 
loop: module loaded 
60000000.nor: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer ID 0x000089 Chip ID 0x00227e 
Amd/Fujitsu Extended Query Table at 0x0040 
Amd/Fujitsu Extended Query version 1.3. 
number of CFI chips: 1 
4 ofpart partitions found on MTD device 60000000.nor 
Creating 4 MTD partitions on "60000000.nor": 
0x000000000000-0x000000020000 : "NOR RCW Image" 
0x000000020000-0x000000120000 : "NOR DTB Image" 
0x000000120000-0x000000920000 : "NOR Linux Kernel Image" 
0x000000920000-0x000003b20000 : "NOR Ramdisk Root File System" 
6Freescale DSPI master initialized 
CAN device driver interface 
flexcan 2a70000.can: device registered (reg_base=c081a000, irq=158) 
flexcan 2a80000.can: device registered (reg_base=c081c000, irq=159) 
libphy: Freescale PowerQUICC MII Bus: probed 
fsl-gianfar ethernet.4: enabled errata workarounds, flags: 0x4 
fsl-gianfar ethernet.4 eth0: mac: 00:04:9f:ef:00:00 
fsl-gianfar ethernet.4 eth0: Running with NAPI enabled 
fsl-gianfar ethernet.4 eth0: RX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.4 eth0: TX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.5: enabled errata workarounds, flags: 0x4 
fsl-gianfar ethernet.5 eth1: mac: 00:04:9f:ef:01:01 
fsl-gianfar ethernet.5 eth1: Running with NAPI enabled 
fsl-gianfar ethernet.5 eth1: RX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.5 eth1: TX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.6: enabled errata workarounds, flags: 0x4 
fsl-gianfar ethernet.6 eth2: mac: 00:04:9f:ef:02:02 
fsl-gianfar ethernet.6 eth2: Running with NAPI enabled 
fsl-gianfar ethernet.6 eth2: RX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.6 eth2: TX BD ring size for Q[0]: 256 
pps pps0: new PPS source ptp0 
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI 
e1000: Copyright (c) 1999-2006 Intel Corporation. 
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k 
e1000e: Copyright(c) 1999 - 2013 Intel Corporation. 
xhci-hcd xhci-hcd.0.auto: xHCI Host Controller 
xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 1 
xhci-hcd xhci-hcd.0.auto: irq 125, io mem 0x03100000 
hub 1-0:1.0: USB hub found 
hub 1-0:1.0: 1 port detected 
xhci-hcd xhci-hcd.0.auto: xHCI Host Controller 
xhci-hcd xhci-hcd.0.auto: new USB bus registered, assigned bus number 2 
hub 2-0:1.0: USB hub found 
hub 2-0:1.0: 1 port detected 
usbcore: registered new interface driver usb-storage 
mousedev: PS/2 mouse device common for all mice 
i2c /dev entries driver 
sdhci: Secure Digital Host Controller Interface driver 
sdhci: Copyright(c) Pierre Ossman 
sdhci-pltfm: SDHCI platform and OF driver helper 
mmc0: SDHCI controller on 1560000.esdhc [1560000.esdhc] using ADMA 
Value in jrstart addr c0e0005c, value prev 0 new f 
caam 1700000.crypto: Instantiated RNG4 SH0 
caam 1700000.crypto: Instantiated RNG4 SH1 
caam 1700000.crypto: device ID = 0x0a140300 (Era 67108864) 
caam 1700000.crypto: job rings = 4, qi = 0 
caam algorithms registered in /proc/crypto 
caam_jr 1710000.jr: registering rng-caam 
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
usb 1-1: new high-speed USB device number 2 using xhci-hcd 
hub 1-1:1.0: USB hub found 
hub 1-1:1.0: 4 ports detected 
usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd 
usb 2-1: Parent hub missing LPM exit latency info. Power management will be impacted. 
hub 2-1:1.0: USB hub found 
hub 2-1:1.0: 4 ports detected 
VFS: Mounted root (ext2 filesystem) on device 1:0. 
devtmpfs: mounted 
Freeing unused kernel memory: 204K (805bd000 - 805f0000) 
INIT: version 2.88 booting 
Starting udev 
udevd[114]: starting version 182 
Starting Bootlog daemon: bootlogd. 
Populating dev cache 
Configuring network interfaces... IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready 
udhcpc (v1.21.1) started 
Sending discover... 
libphy: mdio@2d24000:02 - Link is Down 
Sending discover... 
libphy: mdio@2d24000:02 - Link is Up - 1000/Full 
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready 
Sending discover... 
Sending select for 10.193.20.6... 
Lease of 10.193.20.6 obtained, lease time 14400 
/etc/udhcpc.d/50default: Adding DNS 10.192.130.201 
/etc/udhcpc.d/50default: Adding DNS 10.211.0.3 
/etc/udhcpc.d/50default: Adding DNS 10.196.51.200 
done. 
net.ipv4.conf.default.rp_filter = 1 
net.ipv4.conf.all.rp_filter = 1 
hwclock: can't open '/dev/misc/rtc': No such file or directory 
Wed Jun 25 11:59:00 UTC 2014 
hwclock: can't open '/dev/misc/rtc': No such file or directory 
Running postinst /etc/rpm-postinsts/100-sysvinit-inittab... 
Running postinst /etc/rpm-postinsts/101-debianutils... 
update-rc.d: /etc/init.d/run-postinsts exists during rc.d purge (continuing) 
Removing any system startup links for run-postinsts ... 
/etc/rcS.d/S99run-postinsts 
INIT: Entering runlevel: 5 
Starting OpenBSD Secure Shell server: sshd 
generating ssh RSA key... 
generating ssh ECDSA key... 
generating ssh DSA key... 
done. 
hwclock: can't open '/dev/misc/rtc': No such file or directory 
Starting network benchmark server: netserver. 
Starting system log daemon...0 
Starting kernel log daemon...0 
Starting internet superserver: xinetd. 
Stopping Bootlog daemon: bootlogd. 

Poky (Yocto Project Reference Distro) 1.5 ls1021atwr /dev/ttyS0 

ls1021atwr login: root 
root@ls1021atwr:~# i2cdump -y 1 0x52 i 
0 1 2 3 4 5 6 7 8 9 a b c d e f 0123456789abcdef 
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
root@ls1021atwr:~# i2cdump -y 1 0x52 
No size specified (using byte-data access) 
0 1 2 3 4 5 6 7 8 9 a b c d e f 0123456789abcdef 
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x00 0xa0 0xa1 0xa2 0xa3 0xa4 0xa5 0xa6 0xa7 0xa8 0xa9 0xaa 0xab 0xac 0xad 0xae 0xaf i 
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x10 0xb0 0xb1 0xb2 0xb3 0xb4 0xb5 0xb6 0xb7 0xb8 0xb9 0xba 0xbb 0xbc 0xbd 0xbe 0xbf i 
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x20 0xc0 0xc1 0xc2 0xc3 0xc4 0xc5 0xc6 0xc7 0xc8 0xc9 0xca 0xcb 0xcc 0xcd 0xce 0xcf i 
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x30 0xd0 0xd1 0xd2 0xd3 0xd4 0xd5 0xd6 0xd7 0xd8 0xd9 0xda 0xdb 0xdc 0xdd 0xde 0xdf i 
root@ls1021atwr:~# i2cset -f -y 1 0x52 0x40 0xe0 0xe1 0xe2 0xe3 0xe4 0xe5 0xe6 0xe7 0xe8 0xe9 0xea 0xeb 0xec 0xed 0xee 0xef i 
root@ls1021atwr:~# i2cdump -y 1 0x52 i 
0 1 2 3 4 5 6 7 8 9 a b c d e f 0123456789abcdef 
00: a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af ???????????????? 
10: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf ???????????????? 
20: c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf ???????????????? 
30: d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df ???????????????? 
40: e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef ???????????????? 
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
root@ls1021atwr:~# i2cdump -y 1 0x52 
No size specified (using byte-data access) 
0 1 2 3 4 5 6 7 8 9 a b c d e f 0123456789abcdef 
00: a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af ???????????????? 
10: b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf ???????????????? 
20: c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf ???????????????? 
30: d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df ???????????????? 
40: e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef ???????????????? 
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ................ 
root@ls1021atwr:~# 

