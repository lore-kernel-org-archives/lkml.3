Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaIZTDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:03:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36690 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753770AbaIZTDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:03:12 -0400
Date: Fri, 26 Sep 2014 21:03:08 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Ezaul Zillmer <ezaulzillmer@gmail.com>
Cc: linux-sunxi@googlegroups.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        maxime.ripard@free-electrons.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, rzk333@gmail.com,
        yassinjaffer@gmail.com, quitte@gmail.com
Subject: Re: [PATCH v4 0/2] mtd: nand: add sunxi NAND flash controller
 support
Message-ID: <20140926210308.716c019b@bbrezillon>
In-Reply-To: <9855a145-713d-4481-9c4e-94b30dd39a3c@googlegroups.com>
References: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
	<9855a145-713d-4481-9c4e-94b30dd39a3c@googlegroups.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 11:11:18 -0700 (PDT)
Ezaul Zillmer <ezaulzillmer@gmail.com> wrote:

> Good afternoon everyone 
> 
> I've been doing some test patches Emilio López 
> 
> dma: sun4i: Add support for the DMA engine on sun [457] i SoCs 
> spi: sun4i: add DMA support 
> ARM: sun7i: Add node to Represent the DMA controller 
> ARM: sun7i: enable DMA on SPI 
> 
> But Patches Boris BREZILLON 
> Add the sunxi NAND Flash Controller V5 
> 
> Result I have is this:
> 
> Image Name:   Linux-3.16.0-rc6
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 3.16.0-rc6-g40a77a5-dirty (root@vbi7) (gcc 
> version 4.7.2 (Debian 4.7.2-5) ) #3 SMP Fri Sep 26 11:56:35 BRT 2014
> [    0.000000] CPU: ARMv7 Processor [410fc074] revision 4 (ARMv7), 
> cr=30c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing 
> instruction cache
> [    0.000000] Machine model: Cubietech Cubieboard2
> [    0.000000] Forcing write-allocate cache policy for SMP
> [    0.000000] Memory policy: Data cache writealloc
> [    0.000000] psci: probing for conduit method from DT.
> [    0.000000] psci: Using PSCI v0.1 Function IDs from DT
> [    0.000000] PERCPU: Embedded 7 pages/cpu @eefd0000 s7936 r8192 d12544 
> u32768
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
>  Total pages: 260624
> [    0.000000] Kernel command line: console=tty0 console=ttyS0,115200 
> hdmi.audio=EDID:0 disp.screen0_output_mode=EDID:1280x800p60 
> root=/dev/mmcblk0p1 rootfstype=ext4 0
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
> bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
> bytes)
> [    0.000000] Memory: 1026836K/1048576K available (8121K kernel code, 779K 
> rwdata, 2716K rodata, 595K init, 321K bss, 21740K reserved, 270336K highmem)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
> [    0.000000]     fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
> [    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
> [    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
> [    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
> [    0.000000]       .text : 0xc0008000 - 0xc0a9d7c0   (10838 kB)
> [    0.000000]       .init : 0xc0a9e000 - 0xc0b32f00   ( 596 kB)
> [    0.000000]       .data : 0xc0b34000 - 0xc0bf6c48   ( 780 kB)
> [    0.000000]        .bss : 0xc0bf6c50 - 0xc0c47070   ( 322 kB)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] Architected cp15 timer(s) running at 24.00MHz (phys).
> [    0.000007] sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every 
> 2863311519744ns
> [    0.000014] Switching to timer-based delay loop
> [    0.001052] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 
> 178956969942ns
> [    0.001378] sched_clock: 32 bits at 160MHz, resolution 6ns, wraps every 
> 26843545593ns
> [    0.001587] Console: colour dummy device 80x30
> [    0.002002] console [tty0] enabled
> [    0.002035] Calibrating delay loop (skipped), value calculated using 
> timer frequency.. 48.00 BogoMIPS (lpj=240000)
> [    0.002063] pid_max: default: 32768 minimum: 301
> [    0.002197] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.002220] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 
> bytes)
> [    0.002811] CPU: Testing write buffer coherency: ok
> [    0.003090] /cpus/cpu@0 missing clock-frequency property
> [    0.003119] /cpus/cpu@1 missing clock-frequency property
> [    0.003140] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> [    0.003311] Setting up static identity map for 0x407b1ec0 - 0x407b1f58
> [    0.005296] CPU1: Booted secondary processor
> [    0.005341] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> [    0.005426] Brought up 2 CPUs
> [    0.005476] SMP: Total of 2 processors activated.
> [    0.005490] CPU: All CPU(s) started in HYP mode.
> [    0.005501] CPU: Virtualization extensions available.
> [    0.006172] devtmpfs: initialized
> [    0.010413] VFP support v0.3: implementor 41 architecture 2 part 30 
> variant 7 rev 4
> [    0.010862] pinctrl core: initialized pinctrl subsystem
> [    0.011360] regulator-dummy: no parameters
> [    0.017149] NET: Registered protocol family 16
> [    0.017683] DMA: preallocated 256 KiB pool for atomic coherent 
> allocations
> [    0.026000] Serial: AMBA PL011 UART driver
> [    0.039029] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM 
> dummy slot
> [    0.039082] edma-dma-engine: probe of edma-dma-engine.0 failed with 
> error -5
> [    0.039546] reg-fixed-voltage ahci-5v: could not find pctldev for node 
> /soc@01c00000/pinctrl@01c20800/ahci_pwr_pin@0, deferring probe
> [    0.039585] platform ahci-5v: Driver reg-fixed-voltage requests probe 
> deferral
> [    0.039621] reg-fixed-voltage usb1-vbus: could not find pctldev for node 
> /soc@01c00000/pinctrl@01c20800/usb1_vbus_pin@0, deferring probe
> [    0.039650] platform usb1-vbus: Driver reg-fixed-voltage requests probe 
> deferral
> [    0.039681] reg-fixed-voltage usb2-vbus: could not find pctldev for node 
> /soc@01c00000/pinctrl@01c20800/usb2_vbus_pin@0, deferring probe
> [    0.039710] platform usb2-vbus: Driver reg-fixed-voltage requests probe 
> deferral
> [    0.039899] vcc3v0: 3000 mV
> [    0.040216] vcc3v3: 3300 mV
> [    0.041627] SCSI subsystem initialized
> [    0.042259] usbcore: registered new interface driver usbfs
> [    0.042343] usbcore: registered new interface driver hub
> [    0.042466] usbcore: registered new device driver usb
> [    0.043205] pps_core: LinuxPPS API ver. 1 registered
> [    0.043225] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo 
> Giometti <giometti@linux.it>
> [    0.043268] PTP clock support registered
> [    0.043360] EDAC MC: Ver: 3.0.0
> [    0.044601] Bluetooth: Core ver 2.19
> [    0.044676] NET: Registered protocol family 31
> [    0.044691] Bluetooth: HCI device and connection manager initialized
> [    0.044718] Bluetooth: HCI socket layer initialized
> [    0.044737] Bluetooth: L2CAP socket layer initialized
> [    0.044773] Bluetooth: SCO socket layer initialized
> [    0.045283] Switched to clocksource arch_sys_counter
> [    0.045659] FS-Cache: Loaded
> [    0.055161] NET: Registered protocol family 2
> [    0.055906] TCP established hash table entries: 8192 (order: 3, 32768 
> bytes)
> [    0.056001] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.056130] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.056214] TCP: reno registered
> [    0.056236] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.056296] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.056557] NET: Registered protocol family 1
> [    0.056921] RPC: Registered named UNIX socket transport module.
> [    0.056951] RPC: Registered udp transport module.
> [    0.056965] RPC: Registered tcp transport module.
> [    0.056978] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.057745] kvm [1]: Using HYP init bounce page @6e1ef000
> [    0.058071] kvm [1]: interrupt-controller@1c84000 IRQ25
> [    0.058278] kvm [1]: timer IRQ27
> [    0.058317] kvm [1]: Hyp mode initialized successfully
> [    0.059885] futex hash table entries: 512 (order: 3, 32768 bytes)
> [    0.060498] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.070185] VFS: Disk quotas dquot_6.5.2
> [    0.070444] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.072364] FS-Cache: Netfs 'nfs' registered for caching
> [    0.072989] NFS: Registering the id_resolver key type
> [    0.073059] Key type id_resolver registered
> [    0.073075] Key type id_legacy registered
> [    0.073103] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> [    0.073135] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [    0.073686] FS-Cache: Netfs 'cifs' registered for caching
> [    0.074116] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
> [    0.074506] fuse init (API version 7.23)
> [    0.075114] msgmni has been set to 1477
> [    0.076386] bounce: pool size: 64 pages
> [    0.076674] Block layer SCSI generic (bsg) driver version 0.4 loaded 
> (major 250)
> [    0.076708] io scheduler noop registered
> [    0.076727] io scheduler deadline registered
> [    0.076933] io scheduler cfq registered (default)
> [    0.077552] platform 1c13400.phy: Driver sun4i-usb-phy requests probe 
> deferral
> [    0.080305] sun7i-a20-pinctrl 1c20800.pinctrl: initialized sunXi PIO 
> driver
> [    0.080827] gpio-sch311xI/O address 0x002e already in use
> [    0.080850] gpio-sch311xI/O address 0x004e already in use
> [    0.080865] gpio-sch311xI/O address 0x162e already in use
> [    0.080879] gpio-sch311xI/O address 0x164e already in use
> [    0.082490] ipmi message handler version 39.2
> [    0.082543] ipmi device interface
> [    0.082701] IPMI System Interface driver.
> [    0.082749] ipmi_si: Unable to find any System Interface(s)
> [    0.082782] IPMI Watchdog: driver initialized
> [    0.082804] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via 
> sys_reboot.
> [    0.090613] xenfs: not registering filesystem on non-xen platform
> [    0.147908] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
> [    0.150995] console [ttyS0] disabled
> [    0.171179] 1c28000.serial: ttyS0 at MMIO 0x1c28000 (irq = 33, base_baud 
> = 1500000) is a U6_16550A
> [    0.968467] console [ttyS0] enabled
> [    0.972364] Serial: IMX driver
> [    0.976408] serial: Freescale lpuart driver
> [    0.981436] [drm] Initialized drm 1.1.0 20060810
> [    0.996285] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
> [    1.002491] drbd: built-in
> [    1.005199] drbd: registered as block device major 147
> [    1.011934] platform 1c18000.sata: Driver ahci-sunxi requests probe 
> deferral
> [    1.019707] SSFDC read-only Flash Translation layer
> [    1.047215] nand: Could not find valid JEDEC parameter page; aborting
> [    1.053679] nand: device found, Manufacturer ID: 0xec, Chip ID: 0xd7
> [    1.060066] nand: Samsung NAND 4GiB 3,3V 8-bit
> [    1.064513] nand: 4096MiB, MLC, page size: 8192, OOB size: 640
> [    1.070444] sunxi_nand 1c03000.nand: failed to init nand chips
> [    1.076380] sunxi_nand: probe of 1c03000.nand failed with error -22
> 
> 
> What could I do to fix this error? 
> will be I did something wrong? 

First of all, what platform (board/SoC) are you testing on ?
Can you paste your dts/dtsi files ?
Can you add some traces in sunxi_nand_chip_init so that we can figure
out where it fails ?


Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
