Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3CGOk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:40:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57378 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3CGOk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:40:26 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: "Krishnamoorthy, Balaji T" <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: RE: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Thread-Topic: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Thread-Index: AQHOGuqV346jkMSBUUmpAvXZrfaGX5iaRamDgAABDLA=
Date: Thu, 7 Mar 2013 14:39:55 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC20C57@DBDE01.ent.ti.com>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
 <1362629799-22485-3-git-send-email-mporter@ti.com>
 <41fde401c8e646689123d7c6d3a2dffc@DLEE71.ent.ti.com>
 <20130307141235.GQ6209@beef>
In-Reply-To: <20130307141235.GQ6209@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of Porter, Matt
> Sent: Thursday, March 07, 2013 7:43 PM
> To: Hiremath, Vaibhav
> Cc: Krishnamoorthy, Balaji T; Chris Ball; Cousson, Benoit; Tony
> Lindgren; Russell King; Devicetree Discuss; Linux ARM Kernel List;
> Linux OMAP List; Linux Kernel Mailing List; Linux MMC List
> Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> 
> On Thu, Mar 07, 2013 at 05:29:24AM +0000, Vaibhav Hiremath wrote:
> > > -----Original Message-----
> > > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> > > owner@vger.kernel.org] On Behalf Of Porter, Matt
> > > Sent: Thursday, March 07, 2013 9:47 AM
> > > To: Krishnamoorthy, Balaji T; Chris Ball; Cousson, Benoit; Tony
> > > Lindgren; Russell King
> > > Cc: Devicetree Discuss; Linux ARM Kernel List; Linux OMAP List;
> Linux
> > > Kernel Mailing List; Linux MMC List
> > > Subject: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > >
> > > Adds AM33XX MMC support for am335x-bone, am335x-evm, and
> > > am335x-evmsk.
> > >
> > > Signed-off-by: Matt Porter <mporter@ti.com>
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > ---
> > >  arch/arm/boot/dts/am335x-bone.dts  |    7 +++++++
> > >  arch/arm/boot/dts/am335x-evm.dts   |    7 +++++++
> > >  arch/arm/boot/dts/am335x-evmsk.dts |    7 +++++++
> > >  arch/arm/boot/dts/am33xx.dtsi      |   28
> ++++++++++++++++++++++++++++
> > >  4 files changed, 49 insertions(+)
> > >
> > > diff --git a/arch/arm/boot/dts/am335x-bone.dts
> > > b/arch/arm/boot/dts/am335x-bone.dts
> > > index 11b240c..a154ce0 100644
> > > --- a/arch/arm/boot/dts/am335x-bone.dts
> > > +++ b/arch/arm/boot/dts/am335x-bone.dts
> > > @@ -120,6 +120,8 @@
> > >  		};
> > >
> > >  		ldo3_reg: regulator@5 {
> > > +			regulator-min-microvolt = <1800000>;
> > > +			regulator-max-microvolt = <3300000>;
> > >  			regulator-always-on;
> > >  		};
> > >
> > > @@ -136,3 +138,8 @@
> > >  &cpsw_emac1 {
> > >  	phy_id = <&davinci_mdio>, <1>;
> > >  };
> > > +
> > > +&mmc1 {
> > > +	status = "okay";
> > > +	vmmc-supply = <&ldo3_reg>;
> > > +};
> > > diff --git a/arch/arm/boot/dts/am335x-evm.dts
> > > b/arch/arm/boot/dts/am335x-evm.dts
> > > index d649644..2907da6 100644
> > > --- a/arch/arm/boot/dts/am335x-evm.dts
> > > +++ b/arch/arm/boot/dts/am335x-evm.dts
> > > @@ -232,6 +232,8 @@
> > >  		};
> > >
> > >  		vmmc_reg: regulator@12 {
> > > +			regulator-min-microvolt = <1800000>;
> > > +			regulator-max-microvolt = <3300000>;
> > >  			regulator-always-on;
> > >  		};
> > >  	};
> > > @@ -244,3 +246,8 @@
> > >  &cpsw_emac1 {
> > >  	phy_id = <&davinci_mdio>, <1>;
> > >  };
> > > +
> > > +&mmc1 {
> > > +	status = "okay";
> > > +	vmmc-supply = <&vmmc_reg>;
> > > +};
> > > diff --git a/arch/arm/boot/dts/am335x-evmsk.dts
> > > b/arch/arm/boot/dts/am335x-evmsk.dts
> > > index f5a6162..f050c46 100644
> > > --- a/arch/arm/boot/dts/am335x-evmsk.dts
> > > +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> > > @@ -244,7 +244,14 @@
> > >  		};
> > >
> > >  		vmmc_reg: regulator@12 {
> > > +			regulator-min-microvolt = <1800000>;
> > > +			regulator-max-microvolt = <3300000>;
> > >  			regulator-always-on;
> > >  		};
> > >  	};
> > >  };
> > > +
> > > +&mmc1 {
> > > +	status = "okay";
> > > +	vmmc-supply = <&vmmc_reg>;
> > > +};
> > > diff --git a/arch/arm/boot/dts/am33xx.dtsi
> > > b/arch/arm/boot/dts/am33xx.dtsi
> > > index c3c781a..e029eea 100644
> > > --- a/arch/arm/boot/dts/am33xx.dtsi
> > > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > > @@ -234,6 +234,34 @@
> > >  			status = "disabled";
> > >  		};
> > >
> > > +		mmc1: mmc@48060000 {
> > > +			compatible = "ti,omap3-hsmmc";
> > > +			ti,hwmods = "mmc1";
> > > +			ti,dual-volt;
> > > +			ti,needs-special-reset;
> > > +			dmas = <&edma 24
> > > +				&edma 25>;
> > > +			dma-names = "tx", "rx";
> > > +			status = "disabled";
> > > +		};
> > > +
> > > +		mmc2: mmc@481d8000 {
> > > +			compatible = "ti,omap3-hsmmc";
> > > +			ti,hwmods = "mmc2";
> > > +			ti,needs-special-reset;
> > > +			dmas = <&edma 2
> > > +				&edma 3>;
> > > +			dma-names = "tx", "rx";
> > > +			status = "disabled";
> > > +		};
> > > +
> > > +		mmc3: mmc@47810000 {
> > > +			compatible = "ti,omap3-hsmmc";
> > > +			ti,hwmods = "mmc3";
> > > +			ti,needs-special-reset;
> > > +			status = "disabled";
> > > +		};
> > Any specific reason why you did not add edma entry here as well?
> 
> Yes, I've answered this one before and I think this illustrates a need
> for a comment in the .dtsi. mmc3 edma event are on the crossbar and so
> the event that will be mapped is system-specific. Since Luca is still
> working on DT support for WiLink, there's no way to show an example of
> how this is used upstream as that's the only in-kernel user.
> 
> I have a test driver I've cited in the postings that shows how the
> crossbar is configured via the board .dts. It doesn't belong in the
> .dtsi, however, in this case. When WiLink DT support is ready we can
> have an entry in the am335x-evmsk.dts that shows this case.
> 
> > Also, I wonder why "interrupt" property is not coming here, I
> understand
> > That hwmod is filling the gap here; but I would still recommend you
> to complete
> > The DT node, as we only support DT boot.
> 
> Yeah, I only added needed properties so as to not confuse people as to
> where the interrupt resources are coming from. If you feel strongly
> about this I don't have a problem with adding unused data in the dts.
> I suppose this will help clear things to have a switch away from using
> the hwmod data.

Its not true, if you specify interrupt property in the DTS file
It is being used. Please refer to the omap_device.c file. I am pasting
Comments from code for your reference -


389         /*
390          * Non-DT Boot:
391          *   Here, pdev->num_resources = 0, and we should get all the
392          *   resources from hwmod.
393          *
394          * DT Boot:
395          *   OF framework will construct the resource structure (currently
396          *   does for MEM & IRQ resource) and we should respect/use these
397          *   resources, killing hwmod dependency.
398          *   If pdev->num_resources > 0, we assume that MEM & IRQ resources
399          *   have been allocated by OF layer already (through DTB).
400          *   As preparation for the future we examine the OF provided resources
401          *   to see if we have DMA resources provided already. In this case
402          *   there is no need to update the resources for the device, we use the
403          *   OF provided ones.
404          *
405          * TODO: Once DMA resource is available from OF layer, we should
406          *   kill filling any resources from hwmod.
407          */


> 
> > I will test the whole patch series today and update you.
> 
I just booted up the EVM with all the patches you have submitted recently,
There are two issues I can see,

1. Stack dump from MMC driver.
This happens because you do not have "interrupt" property mentioned
In the dts file. I have added "interrupt" property and dump went away.

2. And MMC rootFS mount is __not__ working for me.

3. I get following error message - 

[    2.118207] omap_hsmmc mmc.3: unable to obtain RX DMA engine channel 25




I haven’t debugged it yet, just thought I should report it before 
Proceeding further.


Boot Log:
======================================

U-Boot# mmc rescan 0
U-Boot# fatload mmc 0 82000000 uImage
reading uImage
4026992 bytes read in 441 ms (8.7 MiB/s)
U-Boot# fatload mmc 0 81000000 am335x-evm.dtb
reading am335x-evm.dtb
11371 bytes read in 10 ms (1.1 MiB/s)
U-Boot# run mmcargs
U-Boot# bootm 82000000 - 81000000
## Booting kernel from Legacy Image at 82000000 ...
   Image Name:   Linux
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4026928 Bytes = 3.8 MiB
   Load Address: 80008000
   Entry Point:  80008000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 81000000
   Booting using the fdt blob at 0x81000000
   Loading Kernel Image ... OK
OK
   Using Device Tree in place at 81000000, end 81005c6a

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.9.0-rc1-00122-g106e3c6 (XXX@psplinux064) (gcc version 4.5.3 20110311 (prerelease) (GCC) ) #2 SMP Thu Mar 7 16:57:39 IST 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x EVM
[    0.000000] cma: CMA: reserved 16 MiB at ae800000
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES2.0 (neon )
[    0.000000] PERCPU: Embedded 9 pages/cpu @c181d000 s13632 r8192 d15040 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260368
[    0.000000] Kernel command line: console=ttyO0,115200n8 root=/dev/mmcblk0p2 ro rootfstype=ext3 rootwait ip=none
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 1023MB = 1023MB total
[    0.000000] Memory: 1008260k/1008260k available, 40316k reserved, 269312K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc071fa34   (7263 kB)
[    0.000000]       .init : 0xc0720000 - 0xc0775540   ( 342 kB)
[    0.000000]       .data : 0xc0776000 - 0xc080f0e0   ( 613 kB)
[    0.000000]        .bss : 0xc080f0e0 - 0xc0d6a348   (5485 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=2 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 24000000 Hz
[    0.000000] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
[    0.000000] OMAP clocksource: GPTIMER2 at 24000000 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000989] Calibrating delay loop... 530.84 BogoMIPS (lpj=2654208)
[    0.109762] pid_max: default: 32768 minimum: 301
[    0.110250] Security Framework initialized
[    0.110399] Mount-cache hash table entries: 512
[    0.121898] CPU: Testing write buffer coherency: ok
[    0.123398] CPU0: thread -1, cpu 0, socket -1, mpidr 0
[    0.123476] Setting up static identity map for 0xc0510518 - 0xc0510588
[    0.126105] Brought up 1 CPUs
[    0.126130] SMP: Total of 1 processors activated (530.84 BogoMIPS).
[    0.126142] CPU: All CPU(s) started in SVC mode.
[    0.129134] devtmpfs: initialized
[    0.199323] pinctrl core: initialized pinctrl subsystem
[    0.205505] regulator-dummy: no parameters
[    0.209247] NET: Registered protocol family 16
[    0.217051] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.236271] platform 49000000.edma: alias fck already exists
[    0.236311] platform 49000000.edma: alias fck already exists
[    0.236333] platform 49000000.edma: alias fck already exists
[    0.241486] OMAP GPIO hardware version 0.1
[    0.265045] No ATAGs?
[    0.265073] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.271061] Serial: AMBA PL011 UART driver
[    0.329077] bio: create slab <bio-0> at 0
[    0.406141] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.408010] vbat: 5000 mV
[    0.409244] lis3_reg: no parameters
[    0.417237] SCSI subsystem initialized
[    0.419384] usbcore: registered new interface driver usbfs
[    0.420409] usbcore: registered new interface driver hub
[    0.421312] usbcore: registered new device driver usb
[    0.423218] omap_i2c 44e0b000.i2c: did not get pins for i2c error: -19
[    0.425064] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
[    0.427105] tps65910 0-002d: No interrupt support, no core IRQ
[    0.433470] vrtc: 1800 mV
[    0.433880] vrtc: supplied by vbat
[    0.437014] vio: at 1500 mV
[    0.437157] vio: supplied by vbat
[    0.440177] vdd_mpu: 912 <--> 1312 mV at 1262 mV
[    0.440331] vdd_mpu: supplied by vbat
[    0.443151] vdd_core: 912 <--> 1150 mV at 1137 mV
[    0.443293] vdd_core: supplied by vbat
[    0.445806] vdd3: 5000 mV
[    0.448346] vdig1: at 1800 mV
[    0.448486] vdig1: supplied by vbat
[    0.451824] vdig2: at 1800 mV
[    0.451967] vdig2: supplied by vbat
[    0.454524] vpll: at 1800 mV
[    0.454652] vpll: supplied by vbat
[    0.457185] vdac: at 1800 mV
[    0.457311] vdac: supplied by vbat
[    0.459975] vaux1: at 1800 mV
[    0.460112] vaux1: supplied by vbat
[    0.462698] vaux2: at 3300 mV
[    0.462830] vaux2: supplied by vbat
[    0.465339] vaux33: at 3300 mV
[    0.465466] vaux33: supplied by vbat
[    0.467947] vmmc:  omap_i2c 4802a000.i2c: did not get pins for i2c error: -19
[    0.471641] omap_i2c 4802a000.i2c: bus 1 rev0.11 at 100 kHz
[    0.482881] Switching to clocksource gp_timer
[    0.607600] NET: Registered protocol family 2
[    0.609603] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.609956] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.613521] TCP: Hash tables configured (established 8192 bind 8192)
[    0.613821] TCP: reno registered
[    0.613863] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.614323] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.615553] NET: Registered protocol family 1
[    0.617700] RPC: Registered named UNIX socket transport module.
[    0.617727] RPC: Registered udp transport module.
[    0.617739] RPC: Registered tcp transport module.
[    0.617752] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.618827] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.619316] CPU PMU: probing PMU on CPU 0
[    0.619350] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.776940] bounce pool size: 64 pages
[    0.777782] VFS: Disk quotas dquot_6.5.2
[    0.777995] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.780682] NFS: Registering the id_resolver key type
[    0.781239] Key type id_resolver registered
[    0.781263] Key type id_legacy registered
[    0.781406] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.781933] msgmni has been set to 1475
[    0.785529] io scheduler noop registered
[    0.785553] io scheduler deadline registered
[    0.785652] io scheduler cfq registered (default)
[    0.787072] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.791600] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.798575] omap_uart 44e09000.serial: did not get pins for uart0 error: -19
[    0.799200] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    1.549008] console [ttyO0] enabled
[    1.586206] brd: module loaded
[    1.608954] loop: module loaded
[    1.617979] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.626230] OneNAND driver initializing
[    1.636711] usbcore: registered new interface driver asix
[    1.642874] usbcore: registered new interface driver ax88179_178a
[    1.650170] usbcore: registered new interface driver cdc_ether
[    1.657216] usbcore: registered new interface driver smsc95xx
[    1.663954] usbcore: registered new interface driver net1080
[    1.670358] usbcore: registered new interface driver cdc_subset
[    1.677253] usbcore: registered new interface driver zaurus
[    1.683851] usbcore: registered new interface driver cdc_ncm
[    1.691998] usbcore: registered new interface driver cdc_wdm
[    1.698149] Initializing USB Mass Storage driver...
[    1.703927] usbcore: registered new interface driver usb-storage
[    1.710287] USB Mass Storage support registered.
[    1.715804] usbcore: registered new interface driver usbtest
[    1.724258] mousedev: PS/2 mouse device common for all mice
[    1.735860] omap_rtc 44e3e000.rtc: rtc core: registered 44e3e000.rtc as rtc0
[    1.745083] i2c /dev entries driver
[    1.751902] Driver for 1-wire Dallas network protocol.
[    1.762053] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.773746] omap-dma-engine omap-dma-engine: allocating channel for 25
[    1.780741] BUG: spinlock bad magic on CPU#0, swapper/0/1
[    1.786477]  lock: dma_chan_lock+0x0/0x20, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[    1.795523] [<c001acb8>] (unwind_backtrace+0x0/0xf0) from [<c02d4838>] (do_raw_spin_lock+0x15c/0x19c)
[    1.805284] [<c02d4838>] (do_raw_spin_lock+0x15c/0x19c) from [<c050a93c>] (_raw_spin_lock_irqsave+0x4c/0x58)
[    1.815692] [<c050a93c>] (_raw_spin_lock_irqsave+0x4c/0x58) from [<c0040450>] (omap_request_dma+0x24/0x1b8)
[    1.826014] [<c0040450>] (omap_request_dma+0x24/0x1b8) from [<c02ffca8>] (omap_dma_alloc_chan_resources+0x3c/0x50)
[    1.836970] [<c02ffca8>] (omap_dma_alloc_chan_resources+0x3c/0x50) from [<c02fdfc8>] (dma_chan_get+0x5c/0xfc)
[    1.847457] [<c02fdfc8>] (dma_chan_get+0x5c/0xfc) from [<c02fe6fc>] (__dma_request_channel+0xfc/0x1c0)
[    1.857322] [<c02fe6fc>] (__dma_request_channel+0xfc/0x1c0) from [<c0422398>] (omap_hsmmc_probe+0x38c/0x908)
[    1.867732] [<c0422398>] (omap_hsmmc_probe+0x38c/0x908) from [<c0339dc4>] (platform_drv_probe+0x18/0x1c)
[    1.877767] [<c0339dc4>] (platform_drv_probe+0x18/0x1c) from [<c0338a68>] (really_probe+0x74/0x200)
[    1.887342] [<c0338a68>] (really_probe+0x74/0x200) from [<c0338d0c>] (driver_probe_device+0x30/0x48)
[    1.897010] [<c0338d0c>] (driver_probe_device+0x30/0x48) from [<c0338db8>] (__driver_attach+0x94/0x98)
[    1.906860] [<c0338db8>] (__driver_attach+0x94/0x98) from [<c0337424>] (bus_for_each_dev+0x64/0x88)
[    1.916433] [<c0337424>] (bus_for_each_dev+0x64/0x88) from [<c03383a8>] (bus_add_driver+0x1c0/0x240)
[    1.926098] [<c03383a8>] (bus_add_driver+0x1c0/0x240) from [<c03392ec>] (driver_register+0x78/0x144)
[    1.935758] [<c03392ec>] (driver_register+0x78/0x144) from [<c00086a4>] (do_one_initcall+0x34/0x180)
[    1.945432] [<c00086a4>] (do_one_initcall+0x34/0x180) from [<c07208f8>] (kernel_init_freeable+0xfc/0x1c8)
[    1.955553] [<c07208f8>] (kernel_init_freeable+0xfc/0x1c8) from [<c0502664>] (kernel_init+0x8/0xe4)
[    1.965139] [<c0502664>] (kernel_init+0x8/0xe4) from [<c00133f0>] (ret_from_fork+0x14/0x24)
[    1.974061] omap_hsmmc mmc.3: unable to obtain RX DMA engine channel 25
[    1.982218] ledtrig-cpu: registered to indicate activity on CPUs
[    1.989997] usbcore: registered new interface driver usbhid
[    1.995997] usbhid: USB HID core driver
[    2.001076] oprofile: using arm/armv7
[    2.005481] TCP: cubic registered
[    2.008992] Initializing XFRM netlink socket
[    2.013601] NET: Registered protocol family 17
[    2.018370] NET: Registered protocol family 15
[    2.023292] Key type dns_resolver registered
[    2.027918] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    2.036074] ThumbEE CPU extension supported.
[    2.103314] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.109789] davinci_mdio 4a101000.mdio: detected phy mask fffffffe
[    2.117400] libphy: 4a101000.mdio: probed
[    2.121661] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver unknown
[    2.130442] Random MACID = aa:e0:1c:4f:40:25
[    2.137280] of_get_named_gpio_flags exited with status 2
[    2.143115] of_get_named_gpio_flags exited with status 3
[    2.149951] input: volume_keys.7 as /devices/volume_keys.7/input/input0
[    2.158349] omap_rtc 44e3e000.rtc: setting system clock to 2000-01-01 00:00:01 UTC (946684801)
[    2.168602] Waiting for root device /dev/mmcblk0p2...


Thanks.
Vaibhav
