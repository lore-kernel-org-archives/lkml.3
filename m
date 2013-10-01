Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3JAKyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 06:54:10 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1359 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab3JAKyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:54:07 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <524AA9C1.2000303@broadcom.com>
Date: Tue, 1 Oct 2013 12:53:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Roger Quadros" <rogerq@ti.com>
cc: "Tony Lindgren" <tony@atomide.com>, linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luciano Coelho" <coelho@ti.com>
Subject: Re: using mmc2 on panda [was: Regression 3.11-rc1: omap4panda:
 no usb and consequently no ethernet]
References: <51E7AA24.6080600@broadcom.com>
 <20130718085951.GT7656@atomide.com> <51E916C0.8080206@broadcom.com>
 <51E919CA.8060805@ti.com> <51E91B80.1050609@broadcom.com>
 <524A823F.6070209@broadcom.com> <524A9AB8.4010407@ti.com>
 <524A9BB2.2050503@ti.com>
In-Reply-To: <524A9BB2.2050503@ti.com>
X-WSS-ID: 7E5477B51R096320398-01-01
Content-Type: multipart/mixed;
 boundary=------------010507020003050701090906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------010507020003050701090906
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

On 10/01/2013 11:53 AM, Roger Quadros wrote:
> On 10/01/2013 12:49 PM, Roger Quadros wrote:
>> Hi Arend,
>>
>> On 10/01/2013 11:05 AM, Arend van Spriel wrote:
>>> On 07/19/2013 12:57 PM, Arend van Spriel wrote:
>>>> On 07/19/2013 12:49 PM, Roger Quadros wrote:
>>>>> On 07/19/2013 01:36 PM, Arend van Spriel wrote:
>>>>>> On 07/18/2013 10:59 AM, Tony Lindgren wrote:
>>>>>>> Then for the SDIO with device tree, take a look at the following
>>>>>>> patches:
>>>>>>>
>>>>>>> [PATCH 0/3] WLAN support for omap4 when booted with devicetree
>>>>>>> http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#
>>>>>>
>>>>>> I have been looking at the pandaboard patch in the series above and I
>>>>>> do have a question. Among other things the patch adds these dt entries.
>>>>>>
>>>>>> +            0x108 0x118    /* sdmmc5_clk.sdmmc5_clk INPUT_PULLUP |
>>>>>> MODE0 */
>>>>>> +            0x10a 0x118    /* sdmmc5_cmd.sdmmc5_cmd INPUT_PULLUP |
>>>>>> MODE0 */
>>>>>>
>>>>>> If I look at the similar names in the deceased board-omap4panda.c:
>>>>>>
>>>>>> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 |
>>>>>> OMAP_PIN_INPUT_PULLUP),
>>>>>> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 |
>>>>>> OMAP_PIN_INPUT_PULLUP),
>>>>>>
>>>>>> and in mux44xx.h:
>>>>>>
>>>>>> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CLK_OFFSET    0x0148
>>>>>> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CMD_OFFSET    0x014a
>>>>>>
>>>>>> So how did 0x0148 get 0x0108 in DT and 0x014a get 0x010a. There is
>>>>>> probably an explanation to it and it would help my understanding to
>>>>>> know where this difference comes from. Hope you can help me out here.
>>>>>>
>>>>>
>>>>> If you see omap4.dtsi, omap4_pmx_core starts at register address
>>>>> 0x4a100040.
>>>>>
>>>>> So, you need to subtract 0x40 from the offsets defined in mux44xx.h
>>>>> for pmx_core registers.
>>>>
>>>> That was what I was looking for. Thanks!
>>>
>>> Hi Roger,
>>>
>>> It has been a while, but I would like to pickup this thread. We have a couple of pandaboards used as test setup. These have an SDIO adapter hooked up to expansion connector A using MMC2. I have attached the patch file (just ignore platform_data stuff). Now on one board it works, but not for the other. I suspect a board issue so listing the two types that we use:
>>>
>>> PandaBoard rev A2 (dmesg: OMAP4430 ES2.1): works
>>> PandaBoardES rev B1 (dmesg: OMAP4460 ES1.1): nope
>>>
>>> Any hints for me.
>>
>> Does your PandaboardES have the WLAN chip (U4) mounted? If yes, how do you isolate
>> it from your external SDIO adapter?

On my 4460 board in front of me U4 is not populated, but U3 is (the TiWi 
thing).

>
> OK, just realized that the expansion connector uses different pads for MMC2. However, you still
> need to make sure that the other pins (connected to on board WLAN chip) are not muxed as MMC2.

I think Luciano added DT patches for on-board WLAN and it uses MMC5 if I 
am not mistaken(?). Attached are the dmesg logs of the two boards.

Regards,
Arend


--------------010507020003050701090906
Content-Type: text/plain;
 charset=utf-8;
 name=dmesg-4430.txt
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename=dmesg-4430.txt

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.11.0-wl-27553-g4a20162 (arend@arend-ubuntu-1) (gcc version 4.5.1 (Sourcery G++ Lite 2010.09-50) ) #5 SMP Mon Sep 23 10:42:07 CEST 2013
[    0.000000] CPU: ARMv7 Processor [411fc092] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic OMAP4 (Flattened Device Tree), model: TI OMAP4 PandaBoard
[    0.000000] cma: CMA: reserved 16 MiB at ae800000
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] On node 0 totalpages: 261888
[    0.000000] free_area_init_node: node 0, pgdat c08835c0, node_mem_map c0ded000
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 528 pages used for memmap
[    0.000000]   HighMem zone: 67328 pages, LIFO batch:15
[    0.000000] OMAP4430 ES2.1
[    0.000000] PERCPU: Embedded 9 pages/cpu @c1607000 s14208 r8192 d14464 u36864
[    0.000000] pcpu-alloc: s14208 r8192 d14464 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260368
[    0.000000] Kernel command line: root=/dev/mmcblk0p2 rootwait console=ttyO2,115200
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1007680K/1047552K available (5750K kernel code, 614K rwdata, 1952K rodata, 381K init, 5522K bss, 39872K reserved, 269312K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc078d9c8   (7703 kB)
[    0.000000]       .init : 0xc078e000 - 0xc07ed780   ( 382 kB)
[    0.000000]       .data : 0xc07ee000 - 0xc0887ae0   ( 615 kB)
[    0.000000]        .bss : 0xc0887ae0 - 0xc0dec5e8   (5523 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] OMAP clockevent source: timer1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] OMAP clocksource: 32k_counter at 32768 Hz
[    0.000000] smp_twd: clock not found -2
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
[    0.001983] Calibrating delay loop... 1191.11 BogoMIPS (lpj=5955584)
[    0.079528] pid_max: default: 32768 minimum: 301
[    0.080352] Security Framework initialized
[    0.080627] Mount-cache hash table entries: 512
[    0.097442] CPU: Testing write buffer coherency: ok
[    0.099487] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.099609] Calibrating local timer... 299.20MHz.
[    0.159698] Setting up static identity map for 0xc0577e20 - 0xc0577e90
[    0.159851] L310 cache controller enabled
[    0.159851] l2x0: 16 ways, CACHE_ID 0x410000c4, AUX_CTRL 0x7e470000, Cache size: 1048576 B
[    0.165496] CPU1: Booted secondary processor
[    0.199493] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.200134] Brought up 2 CPUs
[    0.200164] SMP: Total of 2 processors activated (2382.23 BogoMIPS).
[    0.200195] CPU: All CPU(s) started in SVC mode.
[    0.203094] devtmpfs: initialized
[    0.285430] pinctrl core: initialized pinctrl subsystem
[    0.289245] regulator-dummy: no parameters
[    0.292968] NET: Registered protocol family 16
[    0.301971] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.390624] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.391998] OMAP GPIO hardware version 0.1
[    0.393890] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.396484] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
[    0.399139] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
[    0.401733] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
[    0.404449] gpiochip_add: registered GPIOs 160 to 191 on device: gpio
[    0.406463] omap-gpmc 50000000.gpmc: error: clk_get
[    0.406524] omap-gpmc: probe of 50000000.gpmc failed with error -2
[    0.442108] No ATAGs?
[    0.442169] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
[    0.442169] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.447326] OMAP DMA hardware revision 0.0
[    0.450714] ARM PMU: not yet supported on OMAP4430 due to missing CTI driver
[    0.500152] bio: create slab <bio-0> at 0
[    0.503601] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM dummy slot
[    0.503631] edma-dma-engine: probe of edma-dma-engine.0 failed with error -5
[    0.568725] omap-dma-engine 4a056000.dma-controller: OMAP DMA engine driver
[    0.569946] of_get_named_gpio_flags exited with status 62
[    0.571105] hsusb1_reset: 3300 mV 
[    0.571563] of_get_named_gpio_flags exited with status 1
[    0.572265] hsusb1_vbus: 3300 mV 
[    0.579559] SCSI subsystem initialized
[    0.581390] usbcore: registered new interface driver usbfs
[    0.581787] usbcore: registered new interface driver hub
[    0.582336] usbcore: registered new device driver usb
[    0.585571] omap_i2c 48070000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c1_pins, deferring probe
[    0.585601] platform 48070000.i2c: Driver omap_i2c requests probe deferral
[    0.585693] omap_i2c 48072000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c2_pins, deferring probe
[    0.585723] platform 48072000.i2c: Driver omap_i2c requests probe deferral
[    0.585784] omap_i2c 48060000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c3_pins, deferring probe
[    0.585815] platform 48060000.i2c: Driver omap_i2c requests probe deferral
[    0.585906] omap_i2c 48350000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c4_pins, deferring probe
[    0.585937] platform 48350000.i2c: Driver omap_i2c requests probe deferral
[    0.592956] Switched to clocksource 32k_counter
[    0.721893] NET: Registered protocol family 2
[    0.724060] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.724456] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.727600] TCP: Hash tables configured (established 8192 bind 8192)
[    0.727935] TCP: reno registered
[    0.727966] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.728424] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.730010] NET: Registered protocol family 1
[    0.731506] RPC: Registered named UNIX socket transport module.
[    0.731536] RPC: Registered udp transport module.
[    0.731536] RPC: Registered tcp transport module.
[    0.731567] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.736053] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.736663] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
[    0.940246] bounce pool size: 64 pages
[    0.941040] VFS: Disk quotas dquot_6.5.2
[    0.941284] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.944152] NFS: Registering the id_resolver key type
[    0.944580] Key type id_resolver registered
[    0.944610] Key type id_legacy registered
[    0.944763] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.945434] msgmni has been set to 1474
[    0.948699] io scheduler noop registered
[    0.948730] io scheduler deadline registered
[    0.948852] io scheduler cfq registered (default)
[    0.950897] pinctrl-single 4a100040.pinmux: 203 pins at pa fc100040 size 406
[    0.951568] pinctrl-single 4a31e040.pinmux: 28 pins at pa fc31e040 size 56
[    0.955657] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.961456] omap_uart 4806a000.serial: did not get pins for uart0 error: -19
[    0.962677] 4806a000.serial: ttyO0 at MMIO 0x4806a000 (irq = 104) is a OMAP UART0
[    0.964691] omap_uart 4806c000.serial: did not get pins for uart1 error: -19
[    0.965148] 4806c000.serial: ttyO1 at MMIO 0x4806c000 (irq = 105) is a OMAP UART1
[    0.966308] omap_uart 48020000.serial: did not get pins for uart2 error: -19
[    0.966735] 48020000.serial: ttyO2 at MMIO 0x48020000 (irq = 106) is a OMAP UART2
[    1.739318] console [ttyO2] enabled
[    1.744628] omap_uart 4806e000.serial: did not get pins for uart3 error: -19
[    1.752807] 4806e000.serial: ttyO3 at MMIO 0x4806e000 (irq = 102) is a OMAP UART3
[    1.788665] brd: module loaded
[    1.807922] loop: module loaded
[    1.817199] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.836273] usbcore: registered new interface driver asix
[    1.842407] usbcore: registered new interface driver ax88179_178a
[    1.849273] usbcore: registered new interface driver cdc_ether
[    1.855865] usbcore: registered new interface driver r815x
[    1.862091] usbcore: registered new interface driver smsc95xx
[    1.868591] usbcore: registered new interface driver net1080
[    1.874999] usbcore: registered new interface driver cdc_subset
[    1.881652] usbcore: registered new interface driver zaurus
[    1.888061] usbcore: registered new interface driver cdc_ncm
[    1.895385] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.902343] ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
[    1.902404] ehci-omap: OMAP-EHCI Host Controller driver
[    1.978363] ehci-omap 4a064c00.ehci: failed to get phys phandle in /ocp/usbhshost@4a064000/ehci@4a064c00 node
[    1.978485] ehci-omap 4a064c00.ehci: EHCI Host Controller
[    1.986694] ehci-omap 4a064c00.ehci: new USB bus registered, assigned bus number 1
[    1.994842] ehci-omap 4a064c00.ehci: reset hcs_params 0x1313 dbg=0 cc=1 pcc=3 ordered ports=3
[    1.994873] ehci-omap 4a064c00.ehci: reset hcc_params 20016 thresh 1 uframes 256/512/1024 park LPM
[    1.996520] ehci-omap 4a064c00.ehci: park 0
[    1.996673] ehci-omap 4a064c00.ehci: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    1.996765] ehci-omap 4a064c00.ehci: irq 109, io mem 0x4a064c00
[    2.003112] ehci-omap 4a064c00.ehci: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    2.023345] ehci-omap 4a064c00.ehci: USB 2.0 started, EHCI 1.00
[    2.030395] usb usb1: default language 0x0409
[    2.030487] usb usb1: udev 1, busnum 1, minor = 0
[    2.030517] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.037780] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.045471] usb usb1: Product: EHCI Host Controller
[    2.050659] usb usb1: Manufacturer: Linux 3.11.0-wl-27553-g4a20162 ehci_hcd
[    2.058074] usb usb1: SerialNumber: 4a064c00.ehci
[    2.065490] usb usb1: usb_probe_device
[    2.065521] usb usb1: configuration #1 chosen from 1 choice
[    2.066101] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    2.067199] hub 1-0:1.0: usb_probe_interface
[    2.067230] hub 1-0:1.0: usb_probe_interface - got id
[    2.067291] hub 1-0:1.0: USB hub found
[    2.071411] hub 1-0:1.0: 3 ports detected
[    2.075714] hub 1-0:1.0: standalone hub
[    2.075744] hub 1-0:1.0: individual port power switching
[    2.075744] hub 1-0:1.0: individual port over-current protection
[    2.075775] hub 1-0:1.0: power on to power good time: 20ms
[    2.076141] hub 1-0:1.0: local power source is good
[    2.077514] hub 1-0:1.0: enabling power on all ports
[    2.079223] usbcore: registered new interface driver cdc_wdm
[    2.085754] usbcore: registered new interface driver usb-storage
[    2.092529] usbcore: registered new interface driver usbtest
[    2.100219] mousedev: PS/2 mouse device common for all mice
[    2.111053] i2c /dev entries driver
[    2.115112] Driver for 1-wire Dallas network protocol.
[    2.122070] of_get_named_gpio_flags exited with status 86
[    2.122467] ti-soc-thermal 4a002260.bandgap: failed to request fclock reference
[    2.130676] ti-soc-thermal: probe of 4a002260.bandgap failed with error -2
[    2.141540] omap_wdt: OMAP Watchdog Timer Rev 0x00: initial timeout 60 sec
[    2.151489] of_get_named_gpio_flags: can't parse gpios property
[    2.151519] of_get_named_gpio_flags: can't parse gpios property
[    2.152038] omap-dma-engine 4a056000.dma-controller: allocating channel for 62
[    2.159851] omap-dma-engine 4a056000.dma-controller: allocating channel for 61
[    2.167633] omap_hsmmc 4809c000.mmc: vmmc regulator missing
[    2.174102] omap-dma-engine 4a056000.dma-controller: freeing channel for 61
[    2.181518] omap-dma-engine 4a056000.dma-controller: freeing channel for 62
[    2.189025] platform 4809c000.mmc: Driver omap_hsmmc requests probe deferral
[    2.196624] of_get_named_gpio_flags: can't parse gpios property
[    2.196655] of_get_named_gpio_flags: can't parse gpios property
[    2.196899] omap-dma-engine 4a056000.dma-controller: allocating channel for 48
[    2.204620] omap-dma-engine 4a056000.dma-controller: allocating channel for 47
[    2.212341] omap_hsmmc 480b4000.mmc: vmmc regulator missing
[    2.218322] omap-dma-engine 4a056000.dma-controller: freeing channel for 47
[    2.225738] omap-dma-engine 4a056000.dma-controller: freeing channel for 48
[    2.233215] platform 480b4000.mmc: Driver omap_hsmmc requests probe deferral
[    2.240783] of_get_named_gpio_flags: can't parse gpios property
[    2.240814] of_get_named_gpio_flags: can't parse gpios property
[    2.241027] omap-dma-engine 4a056000.dma-controller: allocating channel for 60
[    2.248779] omap-dma-engine 4a056000.dma-controller: allocating channel for 59
[    2.256500] omap_hsmmc 480d5000.mmc: vmmc regulator missing
[    2.262481] omap-dma-engine 4a056000.dma-controller: freeing channel for 59
[    2.269897] omap-dma-engine 4a056000.dma-controller: freeing channel for 60
[    2.277862] ehci-omap 4a064c00.ehci: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.277923] hub 1-0:1.0: port 1: status 0501 change 0001
[    2.278900] of_get_named_gpio_flags exited with status 110
[    2.278930] of_get_named_gpio_flags exited with status 8
[    2.278961] of_get_named_gpio_flags exited with status 110
[    2.280426] of_get_named_gpio_flags exited with status 8
[    2.282379] ledtrig-cpu: registered to indicate activity on CPUs
[    2.289978] usbcore: registered new interface driver usbhid
[    2.295959] usbhid: USB HID core driver
[    2.301147] oprofile: using arm/armv7-ca9
[    2.306182] TCP: cubic registered
[    2.309722] Initializing XFRM netlink socket
[    2.314422] NET: Registered protocol family 17
[    2.319213] NET: Registered protocol family 15
[    2.324310] Key type dns_resolver registered
[    2.328948] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 1
[    2.338409] Power Management for TI OMAP4+ devices.
[    2.343902] Power Management for TI OMAP4.
[    2.348236] OMAP4 PM: u-boot >= v2012.07 is required for full PM support
[    2.355560] ThumbEE CPU extension supported.
[    2.368621] omap_i2c 48070000.i2c: bus 0 rev0.10 at 400 kHz
[    2.378997] Skipping twl internal clock init and using bootloader value (unknown osc rate)
[    2.390045] hub 1-0:1.0: state 7 ports 3 chg 0002 evt 0000
[    2.390228] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    2.391387] twl 0-0048: PIH (irq 39) chaining IRQs 416..436
[    2.399749] twl_rtc rtc.11: Power up reset detected.
[    2.406158] twl_rtc rtc.11: Enabling TWL-RTC
[    2.416503] twl_rtc rtc.11: rtc core: registered rtc.11 as rtc0
[    2.425750] VAUX1_6030: 1000 <--> 3000 mV at 1800 mV 
[    2.433685] VAUX2_6030: 1200 <--> 2800 mV at 1800 mV 
[    2.441680] VAUX3_6030: 1000 <--> 3000 mV at 1200 mV 
[    2.447235] ehci-omap 4a064c00.ehci: port 1 reset complete, port enabled
[    2.447235] ehci-omap 4a064c00.ehci: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.449981] VMMC: 1200 <--> 3000 mV at 3000 mV 
[    2.457458] VPP: 1800 <--> 2500 mV at 1900 mV 
[    2.464752] VUSIM: 1200 <--> 2900 mV at 1800 mV 
[    2.471710] VDAC: 1800 mV 
[    2.476440] VANA: 2100 mV 
[    2.481475] VCXIO: 1800 mV 
[    2.486572] VUSB: 3300 mV 
[    2.491699] V1V8: 1800 mV 
[    2.496917] V2V1: 2100 mV 
[    2.503540] usb 1-1: new high-speed USB device number 2 using ehci-omap
[    2.515808] of_get_named_gpio_flags exited with status 127
[    2.523925] omap_i2c 48072000.i2c: bus 1 rev0.10 at 400 kHz
[    2.532165] omap_i2c 48060000.i2c: bus 2 rev0.10 at 100 kHz
[    2.541290] omap_i2c 48350000.i2c: bus 3 rev0.10 at 400 kHz
[    2.547729] of_get_named_gpio_flags: can't parse gpios property
[    2.547729] of_get_named_gpio_flags: can't parse gpios property
[    2.548126] omap-dma-engine 4a056000.dma-controller: allocating channel for 62
[    2.555847] omap-dma-engine 4a056000.dma-controller: allocating channel for 61
[    2.562866] ehci-omap 4a064c00.ehci: port 1 reset complete, port enabled
[    2.563110] ehci-omap 4a064c00.ehci: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.567443] omap_hsmmc 4809c000.mmc: pins are not configured from the driver
[    2.616851] of_get_named_gpio_flags: can't parse gpios property
[    2.617340] of_get_named_gpio_flags: can't parse gpios property
[    2.617523] omap-dma-engine 4a056000.dma-controller: allocating channel for 48
[    2.625396] omap-dma-engine 4a056000.dma-controller: allocating channel for 47
[    2.634246] omap_hsmmc 480b4000.mmc: pins are not configured from the driver
[    2.667907] usb 1-1: udev 2, busnum 1, minor = 1
[    2.667968] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[    2.675109] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.684082] usb 1-1: usb_probe_device
[    2.684082] usb 1-1: configuration #1 chosen from 1 choice
[    2.684417] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    2.685363] hub 1-1:1.0: usb_probe_interface
[    2.685455] hub 1-1:1.0: usb_probe_interface - got id
[    2.685546] hub 1-1:1.0: USB hub found
[    2.689758] hub 1-1:1.0: 5 ports detected
[    2.694122] hub 1-1:1.0: compound device; port removable status: FRRRR
[    2.694183] hub 1-1:1.0: individual port power switching
[    2.694183] hub 1-1:1.0: individual port over-current protection
[    2.694915] hub 1-1:1.0: TT per port
[    2.694915] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.694976] hub 1-1:1.0: power on to power good time: 100ms
[    2.695648] hub 1-1:1.0: local power source is good
[    2.695678] twl_rtc rtc.11: setting system clock to 2000-01-01 00:00:00 UTC (946684800)
[    2.704193] hub 1-1:1.0: enabling power on all ports
[    2.707153] Waiting for root device /dev/mmcblk0p2...
[    2.831542] hub 1-1:1.0: port 1: status 0101 change 0001
[    2.949920] usb 1-1: link qh256-0001/edcddc80 start 1 [1/0 us]
[    2.950256] hub 1-1:1.0: state 7 ports 5 chg 0002 evt 0000
[    2.950683] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.037536] usb 1-1.1: new high-speed USB device number 3 using ehci-omap
[    3.183563] usb 1-1.1: udev 3, busnum 1, minor = 2
[    3.183563] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
[    3.190979] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.198883] mmc0: host does not support reading read-only switch. assuming write-enable.
[    3.200225] usb 1-1.1: usb_probe_device
[    3.200225] usb 1-1.1: configuration #1 chosen from 1 choice
[    3.202636] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    3.203369] smsc95xx 1-1.1:1.0: usb_probe_interface
[    3.203369] smsc95xx 1-1.1:1.0: usb_probe_interface - got id
[    3.203552] smsc95xx v1.0.4
[    3.212707] mmc0: new high speed SDHC card at address 0003
[    3.221191] mmcblk0: mmc0:0003 SD8GB 7.41 GiB 
[    3.231719]  mmcblk0: p1 p2
[    3.261138] mmc1: new high speed SDIO card at address 0001
[    3.583007] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 82:1a:d1:0e:6d:04
[    3.596343] hub 1-1:1.0: state 7 ports 5 chg 0000 evt 0002
[    3.689147] EXT3-fs (mmcblk0p2): recovery required on readonly filesystem
[    3.689147] EXT3-fs (mmcblk0p2): write access will be enabled during recovery
[    4.895690] kjournald starting.  Commit interval 5 seconds
[    4.918884] EXT3-fs (mmcblk0p2): recovery complete
[    4.924194] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
[    4.924224] VFS: Mounted root (ext3 filesystem) readonly on device 179:2.
[    4.950469] devtmpfs: mounted
[    4.950469] Freeing unused kernel memory: 380K (c078e000 - c07ed000)
[    5.077758] EXT3-fs (mmcblk0p2): using internal journal
[    7.591186] usb 1-1.1: link qh8-0001/edd43240 start 2 [1/0 us]
[    7.592041] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
[    9.003845] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xC9E1

--------------010507020003050701090906
Content-Type: text/plain;
 charset=utf-8;
 name=dmesg-4460.txt
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename=dmesg-4460.txt

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.11.0-wl-27553-g4a20162 (arend@arend-ubuntu-1) (gcc version 4.5.1 (Sourcery G++ Lite 2010.09-50) ) #5 SMP Mon Sep 23 10:42:07 CEST 2013
[    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic OMAP4 (Flattened Device Tree), model: TI OMAP4 PandaBoard
[    0.000000] cma: CMA: reserved 16 MiB at ae800000
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] On node 0 totalpages: 261888
[    0.000000] free_area_init_node: node 0, pgdat c08835c0, node_mem_map c0ded000
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 528 pages used for memmap
[    0.000000]   HighMem zone: 67328 pages, LIFO batch:15
[    0.000000] OMAP4460 ES1.1
[    0.000000] PERCPU: Embedded 9 pages/cpu @c1607000 s14208 r8192 d14464 u36864
[    0.000000] pcpu-alloc: s14208 r8192 d14464 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260368
[    0.000000] Kernel command line: root=/dev/mmcblk0p2 rootwait console=ttyO2,115200
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1007680K/1047552K available (5750K kernel code, 614K rwdata, 1952K rodata, 381K init, 5522K bss, 39872K reserved, 269312K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc078d9c8   (7703 kB)
[    0.000000]       .init : 0xc078e000 - 0xc07ed780   ( 382 kB)
[    0.000000]       .data : 0xc07ee000 - 0xc0887ae0   ( 615 kB)
[    0.000000]        .bss : 0xc0887ae0 - 0xc0dec5e8   (5523 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] OMAP clockevent source: timer1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] OMAP clocksource: 32k_counter at 32768 Hz
[    0.000000] smp_twd: clock not found -2
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
[    0.001464] Calibrating delay loop... 1391.00 BogoMIPS (lpj=6955008)
[    0.079711] pid_max: default: 32768 minimum: 301
[    0.080291] Security Framework initialized
[    0.080474] Mount-cache hash table entries: 512
[    0.094055] CPU: Testing write buffer coherency: ok
[    0.095550] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.095550] Calibrating local timer... 348.95MHz.
[    0.149810] Setting up static identity map for 0xc0577e20 - 0xc0577e90
[    0.149902] L310 cache controller enabled
[    0.149932] l2x0: 16 ways, CACHE_ID 0x410000c7, AUX_CTRL 0x7e470000, Cache size: 1048576 B
[    0.154510] CPU1: Booted secondary processor
[    0.189636] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.190185] Brought up 2 CPUs
[    0.190185] SMP: Total of 2 processors activated (2782.00 BogoMIPS).
[    0.190216] CPU: All CPU(s) started in SVC mode.
[    0.192626] devtmpfs: initialized
[    0.269989] pinctrl core: initialized pinctrl subsystem
[    0.273193] regulator-dummy: no parameters
[    0.275939] NET: Registered protocol family 16
[    0.283630] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.359100] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.360321] OMAP GPIO hardware version 0.1
[    0.361907] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.364105] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
[    0.366302] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
[    0.368469] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
[    0.370819] gpiochip_add: registered GPIOs 160 to 191 on device: gpio
[    0.372528] omap-gpmc 50000000.gpmc: error: clk_get
[    0.372589] omap-gpmc: probe of 50000000.gpmc failed with error -2
[    0.402313] No ATAGs?
[    0.402374] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
[    0.402374] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.406616] OMAP DMA hardware revision 0.0
[    0.451843] bio: create slab <bio-0> at 0
[    0.454681] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM dummy slot
[    0.454711] edma-dma-engine: probe of edma-dma-engine.0 failed with error -5
[    0.509704] omap-dma-engine 4a056000.dma-controller: OMAP DMA engine driver
[    0.510681] of_get_named_gpio_flags exited with status 62
[    0.511657] hsusb1_reset: 3300 mV 
[    0.512054] of_get_named_gpio_flags exited with status 1
[    0.512573] hsusb1_vbus: 3300 mV 
[    0.518157] SCSI subsystem initialized
[    0.520385] usbcore: registered new interface driver usbfs
[    0.520721] usbcore: registered new interface driver hub
[    0.521209] usbcore: registered new device driver usb
[    0.523864] omap_i2c 48070000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c1_pins, deferring probe
[    0.523895] platform 48070000.i2c: Driver omap_i2c requests probe deferral
[    0.523956] omap_i2c 48072000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c2_pins, deferring probe
[    0.523986] platform 48072000.i2c: Driver omap_i2c requests probe deferral
[    0.524047] omap_i2c 48060000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c3_pins, deferring probe
[    0.524078] platform 48060000.i2c: Driver omap_i2c requests probe deferral
[    0.524139] omap_i2c 48350000.i2c: could not find pctldev for node /ocp/pinmux@4a100040/pinmux_i2c4_pins, deferring probe
[    0.524169] platform 48350000.i2c: Driver omap_i2c requests probe deferral
[    0.530059] Switched to clocksource 32k_counter
[    0.640991] NET: Registered protocol family 2
[    0.642700] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.643035] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.645721] TCP: Hash tables configured (established 8192 bind 8192)
[    0.645965] TCP: reno registered
[    0.646026] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.646392] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.647674] NET: Registered protocol family 1
[    0.649017] RPC: Registered named UNIX socket transport module.
[    0.649017] RPC: Registered udp transport module.
[    0.649047] RPC: Registered tcp transport module.
[    0.649047] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.652954] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.653472] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
[    0.826812] bounce pool size: 64 pages
[    0.827392] VFS: Disk quotas dquot_6.5.2
[    0.827606] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.829925] NFS: Registering the id_resolver key type
[    0.830383] Key type id_resolver registered
[    0.830413] Key type id_legacy registered
[    0.830535] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.831085] msgmni has been set to 1474
[    0.833831] io scheduler noop registered
[    0.833862] io scheduler deadline registered
[    0.833953] io scheduler cfq registered (default)
[    0.835632] pinctrl-single 4a100040.pinmux: 203 pins at pa fc100040 size 406
[    0.836181] pinctrl-single 4a31e040.pinmux: 28 pins at pa fc31e040 size 56
[    0.839416] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.844390] omap_uart 4806a000.serial: did not get pins for uart0 error: -19
[    0.845367] 4806a000.serial: ttyO0 at MMIO 0x4806a000 (irq = 104) is a OMAP UART0
[    0.846771] omap_uart 4806c000.serial: did not get pins for uart1 error: -19
[    0.847229] 4806c000.serial: ttyO1 at MMIO 0x4806c000 (irq = 105) is a OMAP UART1
[    0.848358] omap_uart 48020000.serial: did not get pins for uart2 error: -19
[    0.848724] 48020000.serial: ttyO2 at MMIO 0x48020000 (irq = 106) is a OMAP UART2
[    1.607757] console [ttyO2] enabled
[    1.612915] omap_uart 4806e000.serial: did not get pins for uart3 error: -19
[    1.621002] 4806e000.serial: ttyO3 at MMIO 0x4806e000 (irq = 102) is a OMAP UART3
[    1.652893] brd: module loaded
[    1.669586] loop: module loaded
[    1.677947] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.695129] usbcore: registered new interface driver asix
[    1.701202] usbcore: registered new interface driver ax88179_178a
[    1.707916] usbcore: registered new interface driver cdc_ether
[    1.714416] usbcore: registered new interface driver r815x
[    1.720550] usbcore: registered new interface driver smsc95xx
[    1.726898] usbcore: registered new interface driver net1080
[    1.733215] usbcore: registered new interface driver cdc_subset
[    1.739746] usbcore: registered new interface driver zaurus
[    1.746002] usbcore: registered new interface driver cdc_ncm
[    1.753173] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.760070] ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
[    1.760101] ehci-omap: OMAP-EHCI Host Controller driver
[    1.835815] ehci-omap 4a064c00.ehci: failed to get phys phandle in /ocp/usbhshost@4a064000/ehci@4a064c00 node
[    1.835937] ehci-omap 4a064c00.ehci: EHCI Host Controller
[    1.843627] ehci-omap 4a064c00.ehci: new USB bus registered, assigned bus number 1
[    1.851684] ehci-omap 4a064c00.ehci: reset hcs_params 0x1313 dbg=0 cc=1 pcc=3 ordered ports=3
[    1.851715] ehci-omap 4a064c00.ehci: reset hcc_params 20016 thresh 1 uframes 256/512/1024 park LPM
[    1.852996] ehci-omap 4a064c00.ehci: park 0
[    1.853118] ehci-omap 4a064c00.ehci: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    1.853179] ehci-omap 4a064c00.ehci: irq 109, io mem 0x4a064c00
[    1.859436] ehci-omap 4a064c00.ehci: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    1.870056] ehci-omap 4a064c00.ehci: USB 2.0 started, EHCI 1.00
[    1.877044] usb usb1: default language 0x0409
[    1.877136] usb usb1: udev 1, busnum 1, minor = 0
[    1.877136] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.884338] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.891967] usb usb1: Product: EHCI Host Controller
[    1.897094] usb usb1: Manufacturer: Linux 3.11.0-wl-27553-g4a20162 ehci_hcd
[    1.904449] usb usb1: SerialNumber: 4a064c00.ehci
[    1.911437] usb usb1: usb_probe_device
[    1.911437] usb usb1: configuration #1 chosen from 1 choice
[    1.911926] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    1.912811] hub 1-0:1.0: usb_probe_interface
[    1.912841] hub 1-0:1.0: usb_probe_interface - got id
[    1.912902] hub 1-0:1.0: USB hub found
[    1.916961] hub 1-0:1.0: 3 ports detected
[    1.921203] hub 1-0:1.0: standalone hub
[    1.921234] hub 1-0:1.0: individual port power switching
[    1.921234] hub 1-0:1.0: individual port over-current protection
[    1.921264] hub 1-0:1.0: power on to power good time: 20ms
[    1.921569] hub 1-0:1.0: local power source is good
[    1.922760] hub 1-0:1.0: enabling power on all ports
[    1.924285] usbcore: registered new interface driver cdc_wdm
[    1.930664] usbcore: registered new interface driver usb-storage
[    1.937316] usbcore: registered new interface driver usbtest
[    1.944946] mousedev: PS/2 mouse device common for all mice
[    1.954742] i2c /dev entries driver
[    1.958679] Driver for 1-wire Dallas network protocol.
[    1.965454] of_get_named_gpio_flags exited with status 86
[    1.969299] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.978729] of_get_named_gpio_flags: can't parse gpios property
[    1.978729] of_get_named_gpio_flags: can't parse gpios property
[    1.979125] omap-dma-engine 4a056000.dma-controller: allocating channel for 62
[    1.986846] omap-dma-engine 4a056000.dma-controller: allocating channel for 61
[    1.994537] omap_hsmmc 4809c000.mmc: vmmc regulator missing
[    2.000671] omap-dma-engine 4a056000.dma-controller: freeing channel for 61
[    2.008026] omap-dma-engine 4a056000.dma-controller: freeing channel for 62
[    2.015441] platform 4809c000.mmc: Driver omap_hsmmc requests probe deferral
[    2.023254] of_get_named_gpio_flags: can't parse gpios property
[    2.023254] of_get_named_gpio_flags: can't parse gpios property
[    2.023468] omap-dma-engine 4a056000.dma-controller: allocating channel for 48
[    2.031127] omap-dma-engine 4a056000.dma-controller: allocating channel for 47
[    2.038787] omap_hsmmc 480b4000.mmc: vmmc regulator missing
[    2.044708] omap-dma-engine 4a056000.dma-controller: freeing channel for 47
[    2.052062] omap-dma-engine 4a056000.dma-controller: freeing channel for 48
[    2.059478] platform 480b4000.mmc: Driver omap_hsmmc requests probe deferral
[    2.066986] of_get_named_gpio_flags: can't parse gpios property
[    2.067016] of_get_named_gpio_flags: can't parse gpios property
[    2.067199] omap-dma-engine 4a056000.dma-controller: allocating channel for 60
[    2.074859] omap-dma-engine 4a056000.dma-controller: allocating channel for 59
[    2.082550] omap_hsmmc 480d5000.mmc: vmmc regulator missing
[    2.088439] omap-dma-engine 4a056000.dma-controller: freeing channel for 59
[    2.095794] omap-dma-engine 4a056000.dma-controller: freeing channel for 60
[    2.103576] ehci-omap 4a064c00.ehci: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.103607] hub 1-0:1.0: port 1: status 0501 change 0001
[    2.104553] of_get_named_gpio_flags exited with status 110
[    2.104553] of_get_named_gpio_flags exited with status 8
[    2.104583] of_get_named_gpio_flags exited with status 110
[    2.105743] of_get_named_gpio_flags exited with status 8
[    2.107360] ledtrig-cpu: registered to indicate activity on CPUs
[    2.114715] usbcore: registered new interface driver usbhid
[    2.120605] usbhid: USB HID core driver
[    2.125549] oprofile: using arm/armv7-ca9
[    2.130401] TCP: cubic registered
[    2.133880] Initializing XFRM netlink socket
[    2.138488] NET: Registered protocol family 17
[    2.143249] NET: Registered protocol family 15
[    2.148223] Key type dns_resolver registered
[    2.152801] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
[    2.161926] Power Management for TI OMAP4+ devices.
[    2.167114] Power Management for TI OMAP4.
[    2.171630] OMAP4 PM: u-boot >= v2012.07 is required for full PM support
[    2.178833] ThumbEE CPU extension supported.
[    2.190155] omap_i2c 48070000.i2c: bus 0 rev0.11 at 400 kHz
[    2.200531] Skipping twl internal clock init and using bootloader value (unknown osc rate)
[    2.210021] hub 1-0:1.0: state 7 ports 3 chg 0002 evt 0000
[    2.210784] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    2.212005] twl 0-0048: PIH (irq 39) chaining IRQs 416..436
[    2.219635] twl_rtc rtc.11: Power up reset detected.
[    2.225982] twl_rtc rtc.11: Enabling TWL-RTC
[    2.235412] twl_rtc rtc.11: rtc core: registered rtc.11 as rtc0
[    2.244262] VAUX1_6030: 1000 <--> 3000 mV at 2800 mV 
[    2.251800] VAUX2_6030: 1200 <--> 2800 mV at 1800 mV 
[    2.259246] VAUX3_6030: 1000 <--> 3000 mV at 1200 mV 
[    2.260009] ehci-omap 4a064c00.ehci: port 1 reset complete, port enabled
[    2.260345] ehci-omap 4a064c00.ehci: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.266723] VMMC: 1200 <--> 3000 mV at 3000 mV 
[    2.273651] VPP: 1800 <--> 2500 mV at 1900 mV 
[    2.280517] VUSIM: 1200 <--> 2900 mV at 1800 mV 
[    2.287200] VDAC: 1800 mV 
[    2.291656] VANA: 2100 mV 
[    2.296478] VCXIO: 1800 mV 
[    2.301055] VUSB: 3300 mV 
[    2.305847] V1V8: 1800 mV 
[    2.310882] V2V1: 2100 mV 
[    2.320098] usb 1-1: new high-speed USB device number 2 using ehci-omap
[    2.327392] of_get_named_gpio_flags exited with status 127
[    2.334442] omap_i2c 48072000.i2c: bus 1 rev0.11 at 400 kHz
[    2.342742] omap_i2c 48060000.i2c: bus 2 rev0.11 at 100 kHz
[    2.351623] omap_i2c 48350000.i2c: bus 3 rev0.11 at 400 kHz
[    2.357910] of_get_named_gpio_flags: can't parse gpios property
[    2.357910] of_get_named_gpio_flags: can't parse gpios property
[    2.358062] omap-dma-engine 4a056000.dma-controller: allocating channel for 62
[    2.365997] omap-dma-engine 4a056000.dma-controller: allocating channel for 61
[    2.377075] omap_hsmmc 4809c000.mmc: pins are not configured from the driver
[    2.385070] ehci-omap 4a064c00.ehci: port 1 reset complete, port enabled
[    2.385223] ehci-omap 4a064c00.ehci: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.429504] of_get_named_gpio_flags: can't parse gpios property
[    2.429504] of_get_named_gpio_flags: can't parse gpios property
[    2.429687] omap-dma-engine 4a056000.dma-controller: allocating channel for 48
[    2.437713] omap-dma-engine 4a056000.dma-controller: allocating channel for 47
[    2.446838] omap_hsmmc 480b4000.mmc: pins are not configured from the driver
[    2.477966] usb 1-1: udev 2, busnum 1, minor = 1
[    2.477966] usb 1-1: New USB device found, idVendor=0424, idProduct=9514
[    2.485260] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.493804] usb 1-1: usb_probe_device
[    2.493927] usb 1-1: configuration #1 chosen from 1 choice
[    2.494140] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    2.494842] hub 1-1:1.0: usb_probe_interface
[    2.495025] hub 1-1:1.0: usb_probe_interface - got id
[    2.495025] hub 1-1:1.0: USB hub found
[    2.495025] hub 1-1:1.0: 5 ports detected
[    2.499969] hub 1-1:1.0: compound device; port removable status: FRRRR
[    2.503662] hub 1-1:1.0: individual port power switching
[    2.503662] hub 1-1:1.0: individual port over-current protection
[    2.503753] hub 1-1:1.0: TT per port
[    2.504150] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.504150] hub 1-1:1.0: power on to power good time: 100ms
[    2.504821] hub 1-1:1.0: local power source is good
[    2.504821] hub 1-1:1.0: enabling power on all ports
[    2.514099] twl_rtc rtc.11: setting system clock to 2000-01-01 00:00:00 UTC (946684800)
[    2.526214] Waiting for root device /dev/mmcblk0p2...
[    2.618835] hub 1-1:1.0: port 1: status 0101 change 0001
[    2.832550] usb 1-1: link qh256-0001/edd31b00 start 1 [1/0 us]
[    2.832580] hub 1-1:1.0: state 7 ports 5 chg 0002 evt 0000
[    2.833618] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    2.948486] usb 1-1.1: new high-speed USB device number 3 using ehci-omap
[    2.991729] mmc0: host does not support reading read-only switch. assuming write-enable.
[    3.002410] mmc0: new high speed SDHC card at address 0003
[    3.010467] mmcblk0: mmc0:0003 SD8GB 7.41 GiB 
[    3.019744]  mmcblk0: p1 p2
[    3.060180] EXT3-fs (mmcblk0p2): recovery required on readonly filesystem
[    3.067413] EXT3-fs (mmcblk0p2): write access will be enabled during recovery
[    3.090789] usb 1-1.1: udev 3, busnum 1, minor = 2
[    3.090789] usb 1-1.1: New USB device found, idVendor=0424, idProduct=ec00
[    3.098266] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.107055] usb 1-1.1: usb_probe_device
[    3.107055] usb 1-1.1: configuration #1 chosen from 1 choice
[    3.109252] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    3.109802] smsc95xx 1-1.1:1.0: usb_probe_interface
[    3.109802] smsc95xx 1-1.1:1.0: usb_probe_interface - got id
[    3.109985] smsc95xx v1.0.4
[    3.230041] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 9a:1b:56:a2:3a:20
[    3.242462] hub 1-1:1.0: state 7 ports 5 chg 0000 evt 0002
[    4.016113] kjournald starting.  Commit interval 5 seconds
[    4.420196] EXT3-fs (mmcblk0p2): recovery complete
[    4.420196] EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
[    4.432708] VFS: Mounted root (ext3 filesystem) readonly on device 179:2.
[    4.445373] devtmpfs: mounted
[    4.445831] Freeing unused kernel memory: 380K (c078e000 - c07ed000)
[    4.756530] EXT3-fs (mmcblk0p2): using internal journal
[    7.207397] usb 1-1.1: link qh8-0001/eddccf00 start 2 [1/0 us]
[    7.207946] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
[    8.385925] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex, lpa 0xC9E1

--------------010507020003050701090906--

