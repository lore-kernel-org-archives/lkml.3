Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaJKLNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 07:13:48 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:17505
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752116AbaJKLNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 07:13:45 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v9 0/3] i2c: imx: add DMA support for freescale i2c driver 
Date: Sat, 11 Oct 2014 18:57:09 +0800
Message-ID: <1413025032-14958-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(120916001)(95666004)(81156004)(31966008)(21056001)(99396003)(104016003)(88136002)(26826002)(77156001)(102836001)(107046002)(20776003)(47776003)(85852003)(229853001)(64706001)(92566001)(92726001)(85306004)(93916002)(106466001)(105606002)(50466002)(86362001)(80022003)(76482002)(575784001)(36756003)(46102003)(44976005)(6806004)(87286001)(19580405001)(19580395003)(104166001)(97736003)(89996001)(50226001)(62966002)(23676002)(4396001)(33646002)(50986999)(87936001)(68736004)(84676001)(69596002)(19627235001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB373;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB373;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0361212EA8
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changed in v9: 
- seperate a patch for sort include headers alphabetically 
- some minor fixes for coding style. 

Changed in v8: 
- some minor fixes for coding style. 
- unsetting I2CR_DMAEN immediatelly when DMA failed. 

Changed in v7: 
- when waiting for transfer complete use schedule() instead of udelay(). 

Changed in v6: 
- changed the inappropriate print message. 
- rebase to the latest code. 

Changed in v5: 
- add "*chan_dev = dma->chan_using->device->dev" for code cleanup. 
- add the test logs. 

Changed in v4: 
- cancelled "i2c_imx->use_dma". 
- changed "Dma" to "DMA". 
- add Timeout handling for Transfer complete. 

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


The test log for i2c DMA support: 

Starting kernel ... 

Booting Linux on physical CPU 0xf00 
Linux version 3.12.0+ (yuany@titan) (gcc version 4.8.3 20131202 (prerelease) (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC 2013.11) ) #34 SMP Sat Oct 11 17:15:15 CST 2014 
CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=30c73c7d 
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache 
Machine: Freescale Layerscape LS1021A, model: LS1021A TWR Board 
Memory policy: ECC disabled, Data cache writealloc 
PERCPU: Embedded 7 pages/cpu @80e7a000 s7680 r8192 d12800 u32768 
Built 1 zonelists in Zone order, mobility grouping on. Total pages: 260096 
Kernel command line: root=/dev/ram rw console=ttyS0,115200 
PID hash table entries: 4096 (order: 2, 16384 bytes) 
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes) 
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes) 
Memory: 1014152K/1048576K available (4495K kernel code, 249K rwdata, 1352K rodata, 207K init, 224K bss, 34424K reserved, 0K highmem) 
Virtual kernel memory layout: 
vector : 0xffff0000 - 0xffff1000 ( 4 kB) 
fixmap : 0xfff00000 - 0xfffe0000 ( 896 kB) 
vmalloc : 0xc0800000 - 0xff000000 (1000 MB) 
lowmem : 0x80000000 - 0xc0000000 (1024 MB) 
pkmap : 0x7fe00000 - 0x80000000 ( 2 MB) 
modules : 0x7f000000 - 0x7fe00000 ( 14 MB) 
.text : 0x80008000 - 0x805bdf74 (5848 kB) 
.init : 0x805be000 - 0x805f1e00 ( 208 kB) 
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
Setting up static identity map for 0x80469420 - 0x80469454 
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
of_dma_request_slave_channel: dma-names property of node '/soc/i2c@2180000' missing or empty 
i2c i2c-0: can't use DMA 
i2c i2c-1: IMX I2C adapter registered 
i2c i2c-1: using dma0chan16 (tx) and dma0chan17 (rx) for DMA transfers 
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
Freeing initrd memory: 18704K (bdce9000 - bef2d000) 
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
fsl-gianfar ethernet.4 eth0: mac: 00:04:9f:03:45:e8 
fsl-gianfar ethernet.4 eth0: Running with NAPI enabled 
fsl-gianfar ethernet.4 eth0: RX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.4 eth0: TX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.5: enabled errata workarounds, flags: 0x4 
fsl-gianfar ethernet.5 eth1: mac: 00:04:9f:03:45:e9 
fsl-gianfar ethernet.5 eth1: Running with NAPI enabled 
fsl-gianfar ethernet.5 eth1: RX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.5 eth1: TX BD ring size for Q[0]: 256 
fsl-gianfar ethernet.6: enabled errata workarounds, flags: 0x4 
fsl-gianfar ethernet.6 eth2: mac: 00:04:9f:03:45:ea 
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
mmc0: new SDHC card at address 8415 
caam 1700000.crypto: Instantiated RNG4 SH1 
caam 1700000.crypto: device ID = 0x0a140300 (Era 67108864) 
caam 1700000.crypto: job rings = 4, qi = 0 
mmcblk0: mmc0:8415 SD04G 3.69 GiB 
caam algorithms registered in /proc/crypto 
mmcblk0: 
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
Freeing unused kernel memory: 204K (805be000 - 805f1000) 
INIT: version 2.88 booting 
Starting udev 
udevd[114]: starting version 182 
FAT-fs (mmcblk0): Volume was not properly unmounted. Some data may be corrupt. Please run fsck. 
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
Sending select for 10.193.20.87... 
Lease of 10.193.20.87 obtained, lease time 14400 
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
00: 55 55 55 55 aa aa aa aa ff ff ff ff ff ff ff ff UUUU????........ 
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
00: 55 55 55 55 aa aa aa aa ff ff ff ff ff ff ff ff UUUU????........ 
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
