Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaETHNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:13:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60472 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaETHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:13:30 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 20 May 2014 09:13:08 +0200
Message-ID: <CAH9NwWf8gOmtmcQhD-4RvirdHqFg2GFmcX=dxpcatVpXUSvDsg@mail.gmail.com>
Subject: I/O error, dev mmcblk0
To: linux-mmc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I updated from a 3.14 kernel to 3.15-rc5 kernel and have from time to
time some problems.
With the 3.14 kernel kernel I have never seen this problem - I am
using this device to do some
vivante gpu driver development.

debian@arm:~$ dmesg (I removed drm.debug messages)
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc5+ (debian@arm) (gcc version
4.6.3 (Debian 4.6.3-14) ) #6 SMP Thu May 15 20:05:36 UTC 2014
[    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] Machine model: Freescale i.MX6 Quad SABRE Lite Board
[    0.000000] cma: CMA: reserved 16 MiB at 3e800000
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] On node 0 totalpages: 262144
[    0.000000] free_area_init_node: node 0, pgdat c0812d40,
node_mem_map edff1000
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 528 pages used for memmap
[    0.000000]   HighMem zone: 67584 pages, LIFO batch:15
[    0.000000] PERCPU: Embedded 9 pages/cpu @edfaf000 s13760 r8192 d14912 u36864
[    0.000000] pcpu-alloc: s13760 r8192 d14912 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 260624
[    0.000000] Kernel command line: console=ttymxc1,115200n8
console=tty0 vivante.reglog=1 loglevel=7 drm.debug=7
root=/dev/mmcblk0p2 ro rootfstype=ext4 rootwait fixrtc video=
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] allocated 2097152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Memory: 1011580K/1048576K available (5506K kernel code,
325K rwdata, 2072K rodata, 341K init, 970K bss, 36996K reserved,
270336K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc076ed1c   (7580 kB)
[    0.000000]       .init : 0xc076f000 - 0xc07c45c0   ( 342 kB)
[    0.000000]       .data : 0xc07c6000 - 0xc0817578   ( 326 kB)
[    0.000000]        .bss : 0xc0817578 - 0xc0909f28   ( 971 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] L310 cache controller enabled
[    0.000000] l2x0: 16 ways, CACHE_ID 0x410000c7, AUX_CTRL
0x32070000, Cache size: 1024 kB
[    0.000000] Switching to timer-based delay loop
[    0.000007] sched_clock: 32 bits at 66MHz, resolution 15ns, wraps
every 65075262448ns
[    0.000642] Console: colour dummy device 80x30
[    0.001015] console [tty0] enabled
[    0.001041] Calibrating delay loop (skipped), value calculated
using timer frequency.. 132.00 BogoMIPS (lpj=660000)
[    0.001071] pid_max: default: 32768 minimum: 301
[    0.001152] Security Framework initialized
[    0.001172] Yama: becoming mindful.
[    0.001327] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001349] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001969] Initializing cgroup subsys memory
[    0.002000] Initializing cgroup subsys devices
[    0.002019] Initializing cgroup subsys freezer
[    0.002035] Initializing cgroup subsys net_cls
[    0.002049] Initializing cgroup subsys blkio
[    0.002064] Initializing cgroup subsys perf_event
[    0.002123] CPU: Testing write buffer coherency: ok
[    0.002419] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.002487] Setting up static identity map for 0x10531df0 - 0x10531e48
[    0.004313] CPU1: Booted secondary processor
[    0.004337] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.005169] CPU2: Booted secondary processor
[    0.005194] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.006049] CPU3: Booted secondary processor
[    0.006074] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.006181] Brought up 4 CPUs
[    0.006253] SMP: Total of 4 processors activated.
[    0.006268] CPU: All CPU(s) started in SVC mode.
[    0.006966] devtmpfs: initialized
[    0.010852] VFP support v0.3: implementor 41 architecture 3 part 30
variant 9 rev 4
[    0.011690] pinctrl core: initialized pinctrl subsystem
[    0.012015] regulator-dummy: no parameters
[    0.020376] NET: Registered protocol family 16
[    0.023056] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.023710] cpuidle: using governor ladder
[    0.023729] cpuidle: using governor menu
[    0.023958] CPU identified as i.MX6Q, silicon rev 1.0
[    0.031472] vdd1p1: 800 <--> 1375 mV at 1100 mV
[    0.031864] vdd3p0: 2800 <--> 3150 mV at 3000 mV
[    0.032260] vdd2p5: 2000 <--> 2750 mV at 2400 mV
[    0.032654] vddarm: 725 <--> 1450 mV at 1100 mV
[    0.033060] vddpu: 725 <--> 1450 mV at 1100 mV
[    0.033460] vddsoc: 725 <--> 1450 mV at 1175 mV
[    0.040630] No ATAGs?
[    0.040664] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1
watchpoint registers.
[    0.040692] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.041150] imx6q-pinctrl 20e0000.iomuxc: initialized IMX pinctrl driver
[    0.050861] 2P5V: 2500 mV
[    0.051115] 3P3V: 3300 mV
[    0.051374] usb_otg_vbus: 5000 mV
[    0.054501] SCSI subsystem initialized
[    0.054704] libata version 3.00 loaded.
[    0.055005] usbcore: registered new interface driver usbfs
[    0.055081] usbcore: registered new interface driver hub
[    0.055219] usbcore: registered new device driver usb
[    0.056858] i2c i2c-0: IMX I2C adapter registered
[    0.056991] pps_core: LinuxPPS API ver. 1 registered
[    0.057009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.057045] PTP clock support registered
[    0.057096] EDAC MC: Ver: 3.0.0
[    0.057746] Advanced Linux Sound Architecture Driver Initialized.
[    0.058545] Switched to clocksource mxc_timer1
[    0.087324] NET: Registered protocol family 2
[    0.087907] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.088003] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.088156] TCP: Hash tables configured (established 8192 bind 8192)
[    0.088252] TCP: reno registered
[    0.088273] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.088340] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.088624] NET: Registered protocol family 1
[    0.089262] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver,
7 counters available
[    0.090853] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.091019] audit: initializing netlink subsys (disabled)
[    0.091077] audit: type=2000 audit(0.079:1): initialized
[    0.243036] bounce pool size: 64 pages
[    0.248480] VFS: Disk quotas dquot_6.5.2
[    0.248702] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.250200] fuse init (API version 7.23)
[    0.250667] msgmni has been set to 1479
[    0.251805] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 250)
[    0.251955] io scheduler noop registered
[    0.251977] io scheduler deadline registered
[    0.252147] io scheduler cfq registered (default)
[    0.252614] imx-weim 21b8000.weim: Driver registered.
[    0.258776] imx-sdma 20ec000.sdma: initialized
[    0.259255] imx-sdma 20ec000.sdma: firmware not found
[    0.334408] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.335930] Serial: IMX driver
[    0.336282] 2020000.serial: ttymxc0 at MMIO 0x2020000 (irq = 58,
base_baud = 5000000) is a IMX
[    0.336923] 21e8000.serial: ttymxc1 at MMIO 0x21e8000 (irq = 59,
base_baud = 5000000) is a IMX
[    1.022362] console [ttymxc1] enabled
[    1.026925] serial: Freescale lpuart driver
[    1.031691] [drm] Initialized drm 1.1.0 20060810
[    1.036335] [drm:drm_usb_init]
[    1.036410] usbcore: registered new interface driver udl
[    1.041846] [drm:tda998x_init]
[    1.045365] ahci-imx 2200000.sata: SSS flag set, parallel bus scan disabled
[    1.052404] ahci-imx 2200000.sata: AHCI 0001.0300 32 slots 1 ports
3 Gbps 0x1 impl platform mode
[    1.061238] ahci-imx 2200000.sata: flags: ncq sntf stag pm led clo
only pmp pio slum part ccc apst
[    1.071803] scsi0 : ahci_platform
[    1.075493] ata1: SATA max UDMA/133 mmio [mem
0x02200000-0x02203fff] port 0x100 irq 71
[    1.085901] m25p80 spi0.0: sst25vf016b (2048 Kbytes)
[    1.091556] spi_imx 2008000.ecspi: probed
[    1.096760] 2188000.ethernet supply phy not found, using dummy regulator
[    1.122769] libphy: fec_enet_mii_bus: probed
[    1.127634] fec 2188000.ethernet eth0: registered PHC device 0
[    1.134341] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.140995] usbcore: registered new interface driver usb-storage
[    1.148962] ci_hdrc ci_hdrc.0: doesn't support gadget
[    1.154167] ci_hdrc ci_hdrc.0: EHCI Host Controller
[    1.159337] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 1
[    1.178577] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
[    1.184235] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.191073] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.198319] usb usb1: Product: EHCI Host Controller
[    1.203230] usb usb1: Manufacturer: Linux 3.15.0-rc5+ ehci_hcd
[    1.209092] usb usb1: SerialNumber: ci_hdrc.0
[    1.214159] hub 1-0:1.0: USB hub found
[    1.217974] hub 1-0:1.0: 1 port detected
[    1.222454] 2184200.usb supply vbus not found, using dummy regulator
[    1.230061] ci_hdrc ci_hdrc.1: doesn't support gadget
[    1.235143] ci_hdrc ci_hdrc.1: EHCI Host Controller
[    1.240298] ci_hdrc ci_hdrc.1: new USB bus registered, assigned bus number 2
[    1.258576] ci_hdrc ci_hdrc.1: USB 2.0 started, EHCI 1.00
[    1.264209] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.271045] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.278291] usb usb2: Product: EHCI Host Controller
[    1.283203] usb usb2: Manufacturer: Linux 3.15.0-rc5+ ehci_hcd
[    1.289068] usb usb2: SerialNumber: ci_hdrc.1
[    1.294079] hub 2-0:1.0: USB hub found
[    1.297891] hub 2-0:1.0: 1 port detected
[    1.302816] mousedev: PS/2 mouse device common for all mice
[    1.309135] snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered
20cc034.snvs-rtc-lp as rtc0
[    1.317512] i2c /dev entries driver
[    1.321568] imx_thermal tempmon.8: invalid sensor calibration data
[    1.327776] imx_thermal tempmon.8: failed to get sensor data
[    1.333565] imx_thermal: probe of tempmon.8 failed with error -22
[    1.340283] imx2-wdt 20bc000.wdog: IMX2+ Watchdog Timer enabled.
timeout=60s (nowayout=1)
[    1.348879] sdhci: Secure Digital Host Controller Interface driver
[    1.355079] sdhci: Copyright(c) Pierre Ossman
[    1.359488] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.366111] sdhci-esdhc-imx 2198000.usdhc: could not get ultra high
speed state, work on normal mode
[    1.375320] mmc0: no vqmmc regulator found
[    1.418574] mmc0: SDHCI controller on 2198000.usdhc [2198000.usdhc]
using ADMA
[    1.428584] ata1: SATA link down (SStatus 0 SControl 300)
[    1.429479] sdhci-esdhc-imx 219c000.usdhc: could not get ultra high
speed state, work on normal mode
[    1.430502] mmc1: no vqmmc regulator found
[    1.468563] mmc1: SDHCI controller on 219c000.usdhc [219c000.usdhc]
using ADMA
[    1.476154] ledtrig-cpu: registered to indicate activity on CPUs
[    1.482287] hidraw: raw HID events driver (C) Jiri Kosina
[    1.488449] usbcore: registered new interface driver usbhid
[    1.494063] usbhid: USB HID core driver
[    1.499158] ashmem: initialized
[    1.501752] mmc0: new high speed SDHC card at address aaaa
[    1.502179] mmcblk0: mmc0:aaaa SU32G 29.7 GiB
[    1.513585]  mmcblk0: p1 p2
[    1.514140] imx-ipuv3 2400000.ipu: IPUv3H probed
[    1.514629] imx-ipuv3 2800000.ipu: IPUv3H probed
[    1.604972] Console: switching to colour frame buffer device 128x48
[    1.636875] [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
[    1.643804] oprofile: using arm/armv7-ca9
[    1.648070] TCP: cubic registered
[    1.652013] NET: Registered protocol family 10
[    1.657417] mip6: Mobile IPv6
[    1.660470] NET: Registered protocol family 17
[    1.664994] openvswitch: Open vSwitch switching datapath
[    1.671521] ThumbEE CPU extension supported.
[    1.675876] Registering SWP/SWPB emulation handler
[    1.681358] registered taskstats version 1
[    1.688202] [drm:tilcdc_drm_init] init
[    1.689012] snvs_rtc 20cc034.snvs-rtc-lp: setting system clock to
2014-05-19 14:04:02 UTC (1400508242)
[    1.708688] ALSA device list:
[    1.714318]   No soundcards found.
[    1.731688] EXT4-fs (mmcblk0p2): mounted filesystem with ordered
data mode. Opts: (null)
[    1.742513] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
[    1.760970] devtmpfs: mounted
[    1.766893] Freeing unused kernel memory: 340K (c076f000 - c07c4000)
[    1.779104] usb 2-1: New USB device found, idVendor=0424, idProduct=2513
[    1.788488] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.799695] hub 2-1:1.0: USB hub found
[    1.806601] hub 2-1:1.0: 3 ports detected
[    2.626337] udevd[188]: starting version 175
[    2.885489] vivante: module is from the staging directory, the
quality is unknown, you have been warned.
[    3.025893] imx-sgtl5000 sound.15: ASoC: CPU DAI (null) not registered
[    3.037540] imx-sgtl5000 sound.15: snd_soc_register_card failed (-517)
[    3.048433] platform sound.15: Driver imx-sgtl5000 requests probe deferral
[    3.101883] imx-sgtl5000 sound.15: ASoC: CODEC (null) not registered
[    3.113326] imx-sgtl5000 sound.15: snd_soc_register_card failed (-517)
[    3.125517] platform sound.15: Driver imx-sgtl5000 requests probe deferral
[    3.232577] sgtl5000 0-000a: sgtl5000 revision 0x11
[    3.273367] 0-000a: 1200 mV normal
[    3.280126] sgtl5000 0-000a: Using internal LDO instead of VDDD
[    3.304355] imx-sgtl5000 sound.15: sgtl5000 <-> 2028000.ssi mapping ok
[    4.173390] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
[    4.343237] EXT4-fs (mmcblk0p2): re-mounted. Opts: errors=remount-ro
[    6.366377] EXT4-fs (mmcblk0p1): mounting ext2 file system using
the ext4 subsystem
[    6.382823] EXT4-fs (mmcblk0p1): mounted filesystem without
journal. Opts: (null)
[    6.514072] random: nonblocking pool is initialized
[    7.639035] fec 2188000.ethernet eth0: Freescale FEC PHY driver
[Generic PHY] (mii_bus:phy_addr=2188000.ethernet:06, irq=-1)
[    7.653407] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.639006] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full -
flow control rx/tx
[   12.649770] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[61045.127803] mmcblk0: error -110 transferring data, sector 13343312,
nr 56, cmd response 0x900, card status 0xb00
[61045.138408] mmcblk0: retrying using single block read
[61050.566891] mmcblk0: error -110 transferring data, sector 13343312,
nr 56, cmd response 0x900, card status 0x0
[61050.577255] end_request: I/O error, dev mmcblk0, sector 13343312
[61056.006761] mmcblk0: error -110 transferring data, sector 13343313,
nr 55, cmd response 0x900, card status 0x0
[61056.017122] end_request: I/O error, dev mmcblk0, sector 13343313
[61061.446631] mmcblk0: error -110 transferring data, sector 13343314,
nr 54, cmd response 0x900, card status 0x0
[61061.456990] end_request: I/O error, dev mmcblk0, sector 13343314
[61066.886491] mmcblk0: error -110 transferring data, sector 13343315,
nr 53, cmd response 0x900, card status 0x0
[61066.896822] end_request: I/O error, dev mmcblk0, sector 13343315
[61072.326311] mmcblk0: error -110 transferring data, sector 13343316,
nr 52, cmd response 0x900, card status 0x0
[61072.336637] end_request: I/O error, dev mmcblk0, sector 13343316
[61077.766135] mmcblk0: error -110 transferring data, sector 13343317,
nr 51, cmd response 0x900, card status 0x0
[61077.776492] end_request: I/O error, dev mmcblk0, sector 13343317
[61083.205993] mmcblk0: error -110 transferring data, sector 13343318,
nr 50, cmd response 0x900, card status 0x0
[61083.216356] end_request: I/O error, dev mmcblk0, sector 13343318
[61088.645864] mmcblk0: error -110 transferring data, sector 13343319,
nr 49, cmd response 0x900, card status 0x0
[61088.656220] end_request: I/O error, dev mmcblk0, sector 13343319
[61094.085721] mmcblk0: error -110 transferring data, sector 13343320,
nr 48, cmd response 0x900, card status 0x0
[61094.096078] end_request: I/O error, dev mmcblk0, sector 13343320
[61099.525558] mmcblk0: error -110 transferring data, sector 13343321,
nr 47, cmd response 0x900, card status 0x0
[61099.535887] end_request: I/O error, dev mmcblk0, sector 13343321
[61104.965394] mmcblk0: error -110 transferring data, sector 13343322,
nr 46, cmd response 0x900, card status 0x0
[61104.975753] end_request: I/O error, dev mmcblk0, sector 13343322
[61110.405255] mmcblk0: error -110 transferring data, sector 13343323,
nr 45, cmd response 0x900, card status 0x0
[61110.415611] end_request: I/O error, dev mmcblk0, sector 13343323
[61115.845100] mmcblk0: error -110 transferring data, sector 13343324,
nr 44, cmd response 0x900, card status 0x0
[61115.855453] end_request: I/O error, dev mmcblk0, sector 13343324
[61121.284941] mmcblk0: error -110 transferring data, sector 13343325,
nr 43, cmd response 0x900, card status 0x0
[61121.295296] end_request: I/O error, dev mmcblk0, sector 13343325
[61126.724774] mmcblk0: error -110 transferring data, sector 13343326,
nr 42, cmd response 0x900, card status 0x0
[61126.735104] end_request: I/O error, dev mmcblk0, sector 13343326
[61132.164597] mmcblk0: error -110 transferring data, sector 13343327,
nr 41, cmd response 0x900, card status 0x0
[61132.174953] end_request: I/O error, dev mmcblk0, sector 13343327
[61137.604442] mmcblk0: error -110 transferring data, sector 13343328,
nr 40, cmd response 0x900, card status 0x0
[61137.614798] end_request: I/O error, dev mmcblk0, sector 13343328
[61143.044298] mmcblk0: error -110 transferring data, sector 13343329,
nr 39, cmd response 0x900, card status 0x0
[61143.054656] end_request: I/O error, dev mmcblk0, sector 13343329
[61148.484157] mmcblk0: error -110 transferring data, sector 13343330,
nr 38, cmd response 0x900, card status 0x0
[61148.494518] end_request: I/O error, dev mmcblk0, sector 13343330
[61153.924018] mmcblk0: error -110 transferring data, sector 13343331,
nr 37, cmd response 0x900, card status 0x0
[61153.934360] end_request: I/O error, dev mmcblk0, sector 13343331
[61159.363875] mmcblk0: error -110 transferring data, sector 13343332,
nr 36, cmd response 0x900, card status 0x0
[61159.383722] end_request: I/O error, dev mmcblk0, sector 13343332
[61164.822855] mmcblk0: error -110 transferring data, sector 13343333,
nr 35, cmd response 0x900, card status 0x0
[61164.842984] end_request: I/O error, dev mmcblk0, sector 13343333
[61170.282383] mmcblk0: error -110 transferring data, sector 13343334,
nr 34, cmd response 0x900, card status 0x0
[61170.302738] end_request: I/O error, dev mmcblk0, sector 13343334
[61175.742194] mmcblk0: error -110 transferring data, sector 13343335,
nr 33, cmd response 0x900, card status 0x0
[61175.762467] end_request: I/O error, dev mmcblk0, sector 13343335
[61181.201893] mmcblk0: error -110 transferring data, sector 13343336,
nr 32, cmd response 0x900, card status 0x0
[61181.222191] end_request: I/O error, dev mmcblk0, sector 13343336
[61186.661624] mmcblk0: error -110 transferring data, sector 13343337,
nr 31, cmd response 0x900, card status 0x0
[61186.681916] end_request: I/O error, dev mmcblk0, sector 13343337
[61192.121331] mmcblk0: error -110 transferring data, sector 13343338,
nr 30, cmd response 0x900, card status 0x0
[61192.141623] end_request: I/O error, dev mmcblk0, sector 13343338
[61197.581043] mmcblk0: error -110 transferring data, sector 13343339,
nr 29, cmd response 0x900, card status 0x0
[61197.601332] end_request: I/O error, dev mmcblk0, sector 13343339
[61200.258380] INFO: task kworker/u8:0:6 blocked for more than 120 seconds.
[61200.275214]       Tainted: G         C    3.15.0-rc5+ #6
[61200.290514] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[61200.308331] kworker/u8:0    D c0529ec8     0     6      2 0x00000000
[61200.324672] Workqueue: writeback bdi_writeback_workfn (flush-179:0)
[61200.340925] [<c0529ec8>] (__schedule) from [<c052a190>]
(io_schedule+0xa4/0x118)
[61200.358160] [<c052a190>] (io_schedule) from [<c01bb4e0>]
(sleep_on_shadow_bh+0x8/0x10)
[61200.375850] [<c01bb4e0>] (sleep_on_shadow_bh) from [<c052a814>]
(__wait_on_bit+0x54/0xa0)
[61200.393763] [<c052a814>] (__wait_on_bit) from [<c052a8d8>]
(out_of_line_wait_on_bit+0x78/0x84)
[61200.412058] [<c052a8d8>] (out_of_line_wait_on_bit) from
[<c01bd784>] (do_get_write_access+0x2a0/0x478)
[61200.431031] [<c01bd784>] (do_get_write_access) from [<c01bda8c>]
(jbd2_journal_get_write_access+0x24/0x38)
[61200.450326] [<c01bda8c>] (jbd2_journal_get_write_access) from
[<c01a5b2c>] (__ext4_journal_get_write_access+0x54/0x64)
[61200.470687] [<c01a5b2c>] (__ext4_journal_get_write_access) from
[<c01ac438>] (ext4_mb_mark_diskspace_used+0x68/0x48c)
[61200.490931] [<c01ac438>] (ext4_mb_mark_diskspace_used) from
[<c01ad8d4>] (ext4_mb_new_blocks+0x2d4/0x580)
[61200.510111] [<c01ad8d4>] (ext4_mb_new_blocks) from [<c01a393c>]
(ext4_ext_map_blocks+0xc08/0x10ac)
[61200.528322] [<c01a393c>] (ext4_ext_map_blocks) from [<c017dfd8>]
(ext4_map_blocks+0x2cc/0x48c)
[61200.541723] [<c017dfd8>] (ext4_map_blocks) from [<c01824bc>]
(mpage_map_and_submit_extent+0x140/0x684)
[61200.555792] [<c01824bc>] (mpage_map_and_submit_extent) from
[<c0182ee4>] (ext4_writepages+0x4e4/0x684)
[61200.569843] [<c0182ee4>] (ext4_writepages) from [<c00d8ae4>]
(do_writepages+0x24/0x38)
[61200.582457] [<c00d8ae4>] (do_writepages) from [<c013420c>]
(__writeback_single_inode+0x8c/0x260)
[61200.595935] [<c013420c>] (__writeback_single_inode) from
[<c0135e90>] (writeback_sb_inodes+0x238/0x3a4)
[61200.610002] [<c0135e90>] (writeback_sb_inodes) from [<c0136058>]
(__writeback_inodes_wb+0x5c/0xa4)
[61200.623623] [<c0136058>] (__writeback_inodes_wb) from [<c0136218>]
(wb_writeback+0x178/0x2f0)
[61200.636775] [<c0136218>] (wb_writeback) from [<c0136684>]
(bdi_writeback_workfn+0x1e8/0x428)
[61200.649828] [<c0136684>] (bdi_writeback_workfn) from [<c003af80>]
(process_one_work+0x274/0x3f4)
[61200.663193] [<c003af80>] (process_one_work) from [<c003b364>]
(worker_thread+0x238/0x360)
[61200.675933] [<c003b364>] (worker_thread) from [<c0040bdc>]
(kthread+0xdc/0xf0)
[61200.687673] [<c0040bdc>] (kthread) from [<c000da98>]
(ret_from_fork+0x14/0x3c)
[61200.699372] INFO: task kworker/u8:2:51 blocked for more than 120 seconds.
[61200.710580]       Tainted: G         C    3.15.0-rc5+ #6
[61200.720263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[61200.732470] kworker/u8:2    D c0529ec8     0    51      2 0x00000000
[61200.743212] Workqueue: kmmcd mmc_rescan
[61200.751345] [<c0529ec8>] (__schedule) from [<c03d54bc>]
(__mmc_claim_host+0xb8/0x180)
[61200.763469] [<c03d54bc>] (__mmc_claim_host) from [<c03db5dc>]
(mmc_sd_detect+0x24/0x70)
[61200.775727] [<c03db5dc>] (mmc_sd_detect) from [<c03d733c>]
(mmc_rescan+0x94/0x2c8)
[61200.787528] [<c03d733c>] (mmc_rescan) from [<c003af80>]
(process_one_work+0x274/0x3f4)
[61200.799641] [<c003af80>] (process_one_work) from [<c003b364>]
(worker_thread+0x238/0x360)
[61200.811982] [<c003b364>] (worker_thread) from [<c0040bdc>]
(kthread+0xdc/0xf0)
[61200.823330] [<c0040bdc>] (kthread) from [<c000da98>]
(ret_from_fork+0x14/0x3c)
[61200.834627] INFO: task jbd2/mmcblk0p2-:69 blocked for more than 120 seconds.
[61200.845706]       Tainted: G         C    3.15.0-rc5+ #6
[61200.854997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[61200.866804] jbd2/mmcblk0p2- D c0529ec8     0    69      2 0x00000000
[61200.877155] [<c0529ec8>] (__schedule) from [<c052a190>]
(io_schedule+0xa4/0x118)
[61200.888491] [<c052a190>] (io_schedule) from [<c013b648>]
(sleep_on_buffer+0x8/0x10)
[61200.900067] [<c013b648>] (sleep_on_buffer) from [<c052a814>]
(__wait_on_bit+0x54/0xa0)
[61200.911872] [<c052a814>] (__wait_on_bit) from [<c052a8d8>]
(out_of_line_wait_on_bit+0x78/0x84)
[61200.924396] [<c052a8d8>] (out_of_line_wait_on_bit) from
[<c01bf10c>] (jbd2_journal_commit_transaction+0xd20/0x1648)
[61200.938809] [<c01bf10c>] (jbd2_journal_commit_transaction) from
[<c01c3948>] (kjournald2+0xb8/0x284)
[61200.951907] [<c01c3948>] (kjournald2) from [<c0040bdc>] (kthread+0xdc/0xf0)
[61200.962805] [<c0040bdc>] (kthread) from [<c000da98>]
(ret_from_fork+0x14/0x3c)
[61203.040790] mmcblk0: error -110 transferring data, sector 13343340,
nr 28, cmd response 0x900, card status 0x0
[61203.058818] end_request: I/O error, dev mmcblk0, sector 13343340
[61208.496035] mmcblk0: error -110 transferring data, sector 13343341,
nr 27, cmd response 0x900, card status 0x0
[61208.514157] end_request: I/O error, dev mmcblk0, sector 13343341

greets
--
Christian Gmeiner, MSc

https://soundcloud.com/christian-gmeiner
