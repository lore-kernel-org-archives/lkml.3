Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3A3NOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:14:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3A3NOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:14:47 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LMi6Nqn4CIEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=R9VVX8XAUBkA:10 a=EUspDBNiAAAA:8 a=20KFwNOVAAAA:8 a=KKAkSRfTAAAA:8 a=S2HlMla5mwpLbh-h6zkA:9 a=PUjeQqilurYA:10 a=IG2fH9E8heMA:10 a=jEp0ucaQiEUA:10 a=d1UkCirQTqrwP9Uf:21 a=sw-Rv0923mWa7wCH:21 a=tRigK11qByyuL2ea:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359551685.17639.92.camel@gandalf.local.home>
Subject: Re: [BUG] snowball board locks up on boot
From: Steven Rostedt <rostedt@goodmis.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Date: Wed, 30 Jan 2013 08:14:45 -0500
In-Reply-To: <20130130090134.GR18212@gmail.com>
References: <1359047682.21576.154.camel@gandalf.local.home>
	 <CACRpkdZU80XB2GiDtc7nh0hgMpyVYesi+xwhndu50jGS1L=wiw@mail.gmail.com>
	 <20130130090134.GR18212@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 09:01 +0000, Lee Jones wrote:

> Can you provide your bootlog please Steven?
> 

Here's the bootlog after I reverted the patch and successfully booted:

Card did not respond to voltage select!
smc911x: detected LAN9221 controller
smc911x: phy initialized
smc911x: MAC 46:36:d8:d6:64:4c
BOOTP broadcast 1
BOOTP broadcast 2
*** Unhandled DHCP Option in OFFER/ACK: 2
*** Unhandled DHCP Option in OFFER/ACK: 28
*** Unhandled DHCP Option in OFFER/ACK: 2
*** Unhandled DHCP Option in OFFER/ACK: 28
DHCP client bound to address 192.168.23.75
Using smc911x-0 device
TFTP from server 192.168.23.10; our IP address is 192.168.23.75
Filename 'snowball/image'.
Load address: 0x100000
Loading: *#################################################################
	 #################################################################
	 #################################################################
	 #################################################################
	 ##################################
done
Bytes transferred = 4315824 (41dab0 hex)
## Booting kernel from Legacy Image at 00100000 ...
   Image Name:   Linux-3.8.0-rc4-test+
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4315760 Bytes =  4.1 MB
   Load Address: 00008000
   Entry Point:  00008000
   Loading Kernel Image ... OK
OK

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x300
[    0.000000] Linux version 3.8.0-rc4-test+ (rostedt@goliath) (gcc version 4.5.2 (GCC) ) #278 SMP PREEMPT Thu Jan 24 11:54:10 EST 2013
[    0.000000] CPU: ARMv7 Processor [412fc091] revision 1 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Calao Systems Snowball platform
[    0.000000] Ignoring unrecognised tag 0x41000403
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] DB8500 v2.1 [0x008500b1]
[    0.000000] PERCPU: Embedded 9 pages/cpu @c1162000 s13376 r8192 d15296 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 206848
[    0.000000] Kernel command line: console=ttyAMA2,115200n8 vmalloc=256M root=/dev/mmcblk0p3 rootwait mem=128M@0 mali.mali_mem=32M@128M hwmem=168M@160M mem=48M@328M mem_issw=1M@383M mem=640M@384M
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 128MB 48MB 640MB = 816MB total
[    0.000000] Memory: 818568k/818568k available, 17016k reserved, 278528K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xef800000 - 0xff000000   ( 248 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef000000   ( 752 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0822024   (8297 kB)
[    0.000000]       .init : 0xc0823000 - 0xc0871440   ( 314 kB)
[    0.000000]       .data : 0xc0872000 - 0xc08cc5d0   ( 362 kB)
[    0.000000]        .bss : 0xc08cc5d0 - 0xc095a880   ( 569 kB)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] PRCMU firmware: U8500, version 3.4.9
[    0.000000] MTU0 clock rate: 133330000 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.000488] Calibrating delay loop... 1594.16 BogoMIPS (lpj=7970816)
[    0.090179] pid_max: default: 32768 minimum: 301
[    0.090393] Security Framework initialized
[    0.090484] AppArmor: AppArmor initialized
[    0.090606] Mount-cache hash table entries: 512
[    0.091705] Initializing cgroup subsys cpuacct
[    0.091796] CPU: Testing write buffer coherency: ok
[    0.091888] ftrace: allocating 20559 entries in 61 pages
[    0.137756] CPU0: thread -1, cpu 0, socket 3, mpidr 80000300
[    0.137878] Setting up static identity map for 0x5b6450 - 0x5b64a8
[    0.137939] L310 cache controller enabled
[    0.137969] l2x0: 8 ways, CACHE_ID 0x000000c0, AUX_CTRL 0x7ec60800, Cache size: 524288 B
[    0.238708] CPU1: Booted secondary processor
[    0.313140] CPU1: thread -1, cpu 1, socket 3, mpidr 80000301
[    0.313201] Brought up 2 CPUs
[    0.313201] SMP: Total of 2 processors activated (3588.09 BogoMIPS).
[    0.313934] devtmpfs: initialized
[    0.318908] pinctrl core: initialized pinctrl subsystem
[    0.320159] regulator-dummy: no parameters
[    0.321075] NET: Registered protocol family 16
[    0.321960] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.325164] gpio gpio.0: at address f812e000
[    0.326019] gpio gpio.1: at address f812e080
[    0.326812] gpio gpio.2: at address f800e000
[    0.327667] gpio gpio.3: at address f800e080
[    0.328460] gpio gpio.4: at address f800e100
[    0.329315] gpio gpio.5: at address f800e180
[    0.330200] gpio gpio.6: at address f811e000
[    0.331054] gpio gpio.7: at address f811e080
[    0.331939] gpio gpio.8: at address fa3fe000
[    0.333099] pinctrl-nomadik pinctrl-db8500: initialized Nomadik pin control driver
[    0.334991] ab8500-core ab8500-core.0: detected chip, AB8500 rev. 3.0
[    0.335052] ab8500-core ab8500-core.0: switch off cause(s) (0x20): 
[    0.335052]  "Battery level lower than power on reset threshold"
[    0.341369] DB8500 PRCMU initialized
[    0.344024] mop500_audio_init: Register platform-device 'snd-soc-mop500'.
[    0.344238] Initialize MSP I2S-devices.
[    0.344268] Register platform-device 'ux500-msp-i2s', id 0, irq 63
[    0.344451] Register platform-device 'ux500-msp-i2s', id 1, irq 94
[    0.344665] Register platform-device 'ux500-msp-i2s', id 2, irq 130
[    0.344848] Register platform-device 'ux500-msp-i2s', id 3, irq 94
[    0.345764] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
[    0.345794] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.346343] db8500-vape: no parameters
[    0.346679] db8500-varm: no parameters
[    0.346984] db8500-vmodem: no parameters
[    0.347259] db8500-vpll: no parameters
[    0.347534] db8500-vsmps1: no parameters
[    0.347808] db8500-vsmps2: no parameters
[    0.348114] db8500-vsmps3: no parameters
[    0.348388] db8500-vrf1: no parameters
[    0.348724] db8500-sva-mmdsp: no parameters
[    0.348999] db8500-sva-mmdsp-ret: no parameters
[    0.349273] db8500-sva-pipe: no parameters
[    0.349578] db8500-sia-mmdsp: no parameters
[    0.349853] db8500-sia-mmdsp-ret: no parameters
[    0.350128] db8500-sia-pipe: no parameters
[    0.350433] db8500-sga: no parameters
[    0.350463] db8500-sga: supplied by db8500-vape
[    0.351135] db8500-b2r2-mcde: no parameters
[    0.351165] db8500-b2r2-mcde: supplied by db8500-vape
[    0.351531] db8500-esram12: no parameters
[    0.351837] db8500-esram12-ret: no parameters
[    0.352111] db8500-esram34: no parameters
[    0.352386] db8500-esram34-ret: no parameters
[    0.352691] Serial: AMBA PL011 UART driver
[    0.352874] uart0: ttyAMA0 at MMIO 0x80120000 (irq = 43) is a PL011 rev3
[    0.353424] uart1: ttyAMA1 at MMIO 0x80121000 (irq = 51) is a PL011 rev3
[    0.353912] uart2: ttyAMA2 at MMIO 0x80007000 (irq = 58) is a PL011 rev3
[    0.901672] console [ttyAMA2] enabled
[    0.926879] bio: create slab <bio-0> at 0
[    0.931762] dma40 dma40.0: hardware revision: 3 @ 0x801c0000
[    0.937469] dma40 dma40.0: 7 of 8 physical DMA channels available
[    0.943603] dma40 dma40.0: [d40_phy_res_init] INFO: channel 4 is misconfigured (0)
[    0.951171] dma40 dma40.0: [d40_phy_res_init] INFO: channel 5 is misconfigured (0)
[    0.958740] dma40 dma40.0: [d40_phy_res_init] INFO: channel 6 is misconfigured (0)
[    0.982788] dma40 dma40.0: initialized
[    0.987060] EN-3V3: Failed to request enable GPIO337: -517
[    0.992767] reg-fixed-voltage reg-fixed-voltage.1: Failed to register regulator: -517
[    1.000610] platform reg-fixed-voltage.1: Driver reg-fixed-voltage requests probe deferral
[    1.010345] V-DISPLAY: 2500 <--> 2900 mV at 2500 mV 
[    1.015777] V-eMMC1: 1100 <--> 3300 mV at 2900 mV 
[    1.020935] V-MMC-SD: 1200 <--> 2910 mV at 2910 mV 
[    1.026184] V-INTCORE: at 1250 mV 
[    1.030029] V-TVOUT: 2000 mV 
[    1.033294] LDO-USB: 3300 mV 
[    1.036529] V-AUD: 2000 mV 
[    1.039672] V-AMIC1: 2050 mV 
[    1.042907] V-AMIC2: 2050 mV 
[    1.046173] V-DMIC: 1800 mV 
[    1.049346] V-CSI/DSI: 1200 mV 
[    1.052551] V-CSI/DSI: Failed to create debugfs directory
[    1.060028] SCSI subsystem initialized
[    1.063842] ssp-pl022 ssp0: ARM PL022 driver, device ID: 0x01080022
[    1.070190] ssp-pl022 ssp0: could not get default pinstate
[    1.075714] pl022: mapped registers from 0x80002000 to ef860000
[    1.081726] ssp-pl022 ssp0: setup for DMA on RX dma0chan0, TX dma0chan1
[    1.089843] usbcore: registered new interface driver usbfs
[    1.095520] usbcore: registered new interface driver hub
[    1.101043] usbcore: registered new device driver usb
[    1.106353] ab8500-usb ab8500-usb.0: AB8500 usb driver initialized
[    1.113372] nmk-i2c nmk-i2c.0: initialize Nomadik I2C0 at [mem 0x80004000-0x80004fff] on virtual base ef862000
[    1.123748] nmk-i2c nmk-i2c.1: initialize Nomadik I2C1 at [mem 0x80122000-0x80122fff] on virtual base ef864000
[    1.134094] nmk-i2c nmk-i2c.2: initialize Nomadik I2C2 at [mem 0x80128000-0x80128fff] on virtual base ef866000
[    1.144439] nmk-i2c nmk-i2c.3: initialize Nomadik I2C3 at [mem 0x80110000-0x80110fff] on virtual base ef868000
[    1.155792] Advanced Linux Sound Architecture Driver Initialized.
[    1.162902] Bluetooth: Core ver 2.16
[    1.166717] NET: Registered protocol family 31
[    1.171142] Bluetooth: HCI device and connection manager initialized
[    1.177520] Bluetooth: HCI socket layer initialized
[    1.182403] Bluetooth: L2CAP socket layer initialized
[    1.187469] Bluetooth: SCO socket layer initialized
[    1.192901] cfg80211: Calling CRDA to update world regulatory domain
[    1.199432] NetLabel: Initializing
[    1.202880] NetLabel:  domain hash size = 128
[    1.207244] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.212249] NetLabel:  unlabeled traffic allowed by default
[    1.219024] ab8500-charger ab8500-charger.0: falling back to legacy platform data
[    1.226623] ab8500-charger ab8500-charger.0: failed to get vddadc regulator
[    1.233673] platform ab8500-charger.0: Driver ab8500-charger requests probe deferral
[    1.241668] ab8500-btemp ab8500-btemp.0: falling back to legacy platform data
[    1.248992] ab8500-btemp ab8500-btemp.0: No fg found
[    1.253997] ab8500-btemp ab8500-btemp.0: ab8500_btemp_id get batctrl res failed
[    1.261291] ab8500-btemp ab8500-btemp.0: failed to identify the battery
[    1.277252] ab8500-fg ab8500-fg.0: falling back to legacy platform data
[    1.289733] Switching to clocksource dbx500-prcmu-timer
[    1.319610] AppArmor: AppArmor Filesystem Enabled
[    1.353912] NET: Registered protocol family 2
[    1.359039] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    1.366210] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    1.372833] TCP: Hash tables configured (established 8192 bind 8192)
[    1.379425] TCP: reno registered
[    1.382659] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.388671] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.395355] NET: Registered protocol family 1
[    1.400573] NetWinder Floating Point Emulator V0.97 (double precision)
[    1.407196] CPU PMU: probing PMU on CPU 0
[    1.411224] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
[    1.420837] audit: initializing netlink socket (disabled)
[    1.426269] type=2000 audit(1.130:1): initialized
[    1.445343] bounce pool size: 64 pages
[    1.449371] VFS: Disk quotas dquot_6.5.2
[    1.453430] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.460632] 9p: Installing v9fs 9p2000 file system support
[    1.466156] msgmni has been set to 1054
[    1.471069] io scheduler noop registered
[    1.474975] io scheduler deadline registered (default)
[    1.480285] io scheduler cfq registered
[    1.485229] uart-pl011 uart0: DMA channel TX dma0chan2
[    1.490417] uart-pl011 uart0: DMA channel RX dma0chan3
[    1.495544] uart-pl011 uart1: DMA channel TX dma0chan4
[    1.500732] uart-pl011 uart1: DMA channel RX dma0chan5
[    1.505889] uart-pl011 uart2: DMA channel TX dma0chan6
[    1.511047] uart-pl011 uart2: DMA channel RX dma0chan7
[    1.516540] [drm] Initialized drm 1.1.0 20060810
[    1.532897] brd: module loaded
[    1.542419] loop: module loaded
[    1.546844] tun: Universal TUN/TAP device driver, 1.6
[    1.551940] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.558898] smsc911x: Driver version 2008-10-21
[    1.563537] smsc911x smsc911x.0: Failed to get supply 'vdd33a': -517
[    1.570434] smsc911x smsc911x.0 (unregistered net_device): couldn't get regulators -517
[    1.578552] platform smsc911x.0: Driver smsc911x requests probe deferral
[    1.585449] PPP generic driver version 2.4.2
[    1.590209] PPP MPPE Compression module registered
[    1.595642] usbcore: registered new interface driver cdc_acm
[    1.601348] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    1.609405] Initializing USB Mass Storage driver...
[    1.614501] usbcore: registered new interface driver usb-storage
[    1.620574] USB Mass Storage support registered.
[    1.625183] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[    1.633972] input: AB8500 POn(PowerOn) Key as /devices/soc0/db8500-prcmu.0/ab8500-core.0/ab8500-poweron-key.0/input/input0
[    1.662811] ab8500-rtc ab8500-rtc.0: rtc core: registered ab8500-rtc as rtc0
[    1.670257] i2c /dev entries driver
[    1.675018] ab8500-chargalg ab8500-chargalg.0: falling back to legacy platform data
[    1.683166] ab8500-chargalg ab8500-chargalg.0: probe success
[    1.689331] device-mapper: uevent: version 1.0.3
[    1.694274] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    1.702789] Bluetooth: HCI UART driver ver 2.2
[    1.707336] cpufreq for DB8500 started
[    1.711151] db8500-cpufreq : Failed to get armss clk
[    1.716125] db8500-cpufreq : Failed to get armss clk
[    1.721435] cpuidle: using governor ladder
[    1.725677] cpuidle: using governor menu
[    1.730682] mmci-pl18x sdi4: Provided ocr_mask/setpower will not be used (using regulator instead)
[    1.739746] mmci-pl18x sdi4: mmc0: PL180 manf 80 rev4 at 0x80114000 irq 131,0 (pio)
[    1.747497] mmci-pl18x sdi4: DMA channels RX dma0chan24, TX dma0chan25
[    1.785675] mmci-pl18x sdi0: Provided ocr_mask/setpower will not be used (using regulator instead)
[    1.794799] mmci-pl18x sdi0: mmc1: PL180 manf 80 rev4 at 0x80126000 irq 92,0 (pio)
[    1.802520] mmci-pl18x sdi0: DMA channels RX dma0chan26, TX dma0chan27
[    1.846679] usbcore: registered new interface driver usbhid
[    1.852325] usbhid: USB HID core driver
[    1.857025] usbcore: registered new interface driver snd-usb-audio
[    1.864257] Netfilter messages via NETLINK v0.30.
[    1.869110] nf_conntrack version 0.5.0 (12790 buckets, 51160 max)
[    1.875488] ctnetlink v0.93: registering with nfnetlink.
[    1.881256] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.886688] TCP: cubic registered
[    1.890197] NET: Registered protocol family 10
[    1.895446] NET: Registered protocol family 17
[    1.900085] NET: Registered protocol family 15
[    1.904724] Bluetooth: RFCOMM TTY layer initialized
[    1.909729] Bluetooth: RFCOMM socket layer initialized
[    1.914886] Bluetooth: RFCOMM ver 1.11
[    1.918731] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.924072] Bluetooth: BNEP filters: protocol multicast
[    1.929351] mmc0: new high speed MMC card at address 0001
[    1.929382] Bluetooth: BNEP socket layer initialized
[    1.929382] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.929382] Bluetooth: HIDP socket layer initialized
[    1.929412] NET: Registered protocol family 35
[    1.955078] 9pnet: Installing 9P2000 support
[    1.955749] mmcblk0: mmc0:0001  3.53 GiB 
[    1.955963] mmcblk0boot0: mmc0:0001  partition 1 2.00 MiB
[    1.956176] mmcblk0boot1: mmc0:0001  partition 2 2.00 MiB
[    1.956390] mmcblk0rpmb: mmc0:0001  partition 3 128 KiB
[    1.979492] NET: Registered protocol family 37
[    1.984069] Key type dns_resolver registered
[    1.984100]  mmcblk0: p1 p2 p3
[    1.991577] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 2
[    1.999481] Registering SWP/SWPB emulation handler
[    2.007751] LDO-USB: disabling
[    2.010925] db8500-esram34: disabling
[    2.014648] db8500-esram12: disabling
[    2.018890] EN-3V3: Failed to request enable GPIO337: -517
[    2.024597] input: gpio-keys as /devices/soc0/gpio-keys/input/input1
[    2.024658] reg-fixed-voltage reg-fixed-voltage.1: Failed to register regulator: -517
[    2.024688] platform reg-fixed-voltage.1: Driver reg-fixed-voltage requests probe deferral
[    2.024780] ab8500-charger ab8500-charger.0: falling back to legacy platform data
[    2.024963] ab8500-charger ab8500-charger.0: failed to get vddadc regulator
[    2.024993] platform ab8500-charger.0: Driver ab8500-charger requests probe deferral
[    2.025054] smsc911x: Driver version 2008-10-21
[    2.025146] smsc911x smsc911x.0: Failed to get supply 'vdd33a': -517
[    2.025146] smsc911x smsc911x.0 (unregistered net_device): couldn't get regulators -517
[    2.025177] platform smsc911x.0: Driver smsc911x requests probe deferral
[    2.095001]  mmcblk0boot1: unknown partition table
[    2.100128] EN-3V3: Failed to request enable GPIO337: -517
[    2.106201] reg-fixed-voltage reg-fixed-voltage.1: Failed to register regulator: -517
[    2.114379] platform reg-fixed-voltage.1: Driver reg-fixed-voltage requests probe deferral
[    2.122802] ab8500-charger ab8500-charger.0: falling back to legacy platform data
[    2.122833] ab8500-rtc ab8500-rtc.0: setting system clock to 2013-01-24 17:10:21 UTC (1359047421)
[    2.122955] ALSA device list:
[    2.122955]   No soundcards found.
[    2.145721]  mmcblk0boot0: unknown partition table
[    2.150878] ab8500-charger ab8500-charger.0: failed to get vddadc regulator
[    2.158020] platform ab8500-charger.0: Driver ab8500-charger requests probe deferral
[    2.165832] smsc911x: Driver version 2008-10-21
[    2.170532] smsc911x smsc911x.0: Failed to get supply 'vdd33a': -517
[    2.176910] smsc911x smsc911x.0 (unregistered net_device): couldn't get regulators -517
[    2.184967] platform smsc911x.0: Driver smsc911x requests probe deferral
[    2.185119] EXT3-fs (mmcblk0p3): error: couldn't mount because of unsupported optional features (240)
[    2.186431] EXT2-fs (mmcblk0p3): error: couldn't mount because of unsupported optional features (244)
[    2.210479] EN-3V3: Failed to request enable GPIO337: -517
[    2.216278] reg-fixed-voltage reg-fixed-voltage.1: Failed to register regulator: -517
[    2.224121] platform reg-fixed-voltage.1: Driver reg-fixed-voltage requests probe deferral
[    2.604156] EXT4-fs (mmcblk0p3): warning: maximal mount count reached, running e2fsck is recommended
[    2.618927] EXT4-fs (mmcblk0p3): recovery complete
[    2.631408] EXT4-fs (mmcblk0p3): mounted filesystem with ordered data mode. Opts: (null)
[    2.639587] VFS: Mounted root (ext4 filesystem) on device 179:3.
[    2.650085] devtmpfs: mounted
[    2.653350] Freeing init memory: 312K
[    3.095977] init: ureadahead main process (692) terminated with status 5
[    3.983581] mmci-pl18x sdi4: error during DMA transfer!
[    3.988952] mmcblk0rpmb: error -110 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
[    3.998840] mmcblk0rpmb: retrying using single block read
[    4.412017] mmci-pl18x sdi4: error during DMA transfer!
[    4.417358] mmcblk0rpmb: error -110 transferring data, sector 8, nr 8, cmd response 0x900, card status 0xb00
[    4.427429] mmcblk0rpmb: retrying using single block read
[    4.842041] mmci-pl18x sdi4: error during DMA transfer!
[    4.847381] mmcblk0rpmb: error -110 transferring data, sector 24, nr 8, cmd response 0x900, card status 0xb00
[    4.857360] mmcblk0rpmb: retrying using single block read
[    5.272949] mmci-pl18x sdi4: error during DMA transfer!
[    5.278289] mmcblk0rpmb: error -110 transferring data, sector 56, nr 8, cmd response 0x900, card status 0xb00
[    5.288269] mmcblk0rpmb: retrying using single block read
[    5.703063] mmci-pl18x sdi4: error during DMA transfer!
[    5.708404] mmcblk0rpmb: error -110 transferring data, sector 120, nr 8, cmd response 0x900, card status 0xb00
[    5.718475] mmcblk0rpmb: retrying using single block read
[    6.132965] mmci-pl18x sdi4: error during DMA transfer!
[    6.138336] mmcblk0rpmb: error -110 transferring data, sector 64, nr 8, cmd response 0x900, card status 0xb00
[    6.148315] mmcblk0rpmb: retrying using single block read
[    6.563507] mmci-pl18x sdi4: error during DMA transfer!
[    6.568847] mmcblk0rpmb: error -110 transferring data, sector 16, nr 8, cmd response 0x900, card status 0xb00
[    6.579071] mmcblk0rpmb: retrying using single block read
[    6.994110] mmci-pl18x sdi4: error during DMA transfer!
[    6.999450] mmcblk0rpmb: error -110 transferring data, sector 128, nr 8, cmd response 0x900, card status 0xb00
[    7.009521] mmcblk0rpmb: retrying using single block read
[    7.424499] mmci-pl18x sdi4: error during DMA transfer!
[    7.429870] mmcblk0rpmb: error -110 transferring data, sector 32, nr 8, cmd response 0x900, card status 0xb00
[    7.439819] mmcblk0rpmb: retrying using single block read
[    7.472686] mmcblk0boot0: r/w command failed, status = 0x80000900
[    7.478851] end_request: I/O error, dev mmcblk0boot0, sector 3832
[    7.484954] Buffer I/O error on device mmcblk0boot0, logical block 479
 * Starting mDNS/DNS-SD daemon[74G[ OK ]
 * Starting configure network device security[74G[ OK ]
[   11.248016] mmci-pl18x sdi4: error during DMA transfer!
[   11.253417] mmcblk0rpmb: error -110 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
[   11.792541] mmci-pl18x sdi4: error during DMA transfer!
[   11.797973] mmcblk0rpmb: error -110 transferring data, sector 24, nr 8, cmd response 0x900, card status 0xb00
[   12.237579] mmci-pl18x sdi4: error during DMA transfer!
[   12.242980] mmcblk0rpmb: error -110 transferring data, sector 8, nr 8, cmd response 0x900, card status 0xb00
 * Starting Mount network filesystems[74G[ OK ]
 * Starting Upstart job to start rpcbind on boot only[74G[ OK ]
 * Starting Failsafe Boot Delay[74G[ OK ]
 * Stopping Upstart job to start rpcbind on boot only[74G[ OK ]
 * Starting Bridge socket events into upstart[74G[ OK ]
[   12.788513] mmci-pl18x sdi4: error during DMA transfer!
[   12.793945] mmcblk0rpmb: error -110 transferring data, sector 56, nr 8, cmd response 0x900, card status 0xb00
[   12.823486] mmcblk0boot0: r/w command failed, status = 0x80000900
[   12.836425] end_request: I/O error, dev mmcblk0boot0, sector 3832
[   12.842529] Buffer I/O error on device mmcblk0boot0, logical block 479
 * Stopping Mount network filesystems[74G[ OK ]
 * Starting RPC portmapper replacement[74G[ OK ]
 * Starting Start this job to wait until rpcbind is started or fails to start[74G[ OK ]
 * Stopping Start this job to wait until rpcbind is started or fails to start[74G[ OK ]
 * Stopping rpcsec_gss daemon[74G[ OK ]
[   13.397216] mmci-pl18x sdi4: error during DMA transfer!
[   13.402618] mmcblk0rpmb: error -110 transferring data, sector 120, nr 8, cmd response 0x900, card status 0xb00
[   14.008239] mmci-pl18x sdi4: error during DMA transfer!
[   14.013610] mmcblk0rpmb: error -110 transferring data, sector 64, nr 8, cmd response 0x900, card status 0xb00
[   14.463684] mmci-pl18x sdi4: error during DMA transfer!
[   14.469177] mmcblk0rpmb: error -110 transferring data, sector 16, nr 8, cmd response 0x900, card status 0xb00
[   14.911254] mmci-pl18x sdi4: error during DMA transfer!
[   14.916625] mmcblk0rpmb: error -110 transferring data, sector 128, nr 8, cmd response 0x900, card status 0xb00
[   15.366241] mmci-pl18x sdi4: error during DMA transfer!
[   15.371612] mmcblk0rpmb: error -110 transferring data, sector 32, nr 8, cmd response 0x900, card status 0xb00
[   15.831939] mmci-pl18x sdi4: error during DMA transfer!
[   15.837341] mmcblk0rpmb: error -110 transferring data, sector 0, nr 8, cmd response 0x900, card status 0xb00
 * Starting NSM status monitor[74G[ OK ]
 * Stopping Failsafe Boot Delay[74G[ OK ]
 * Starting System V initialisation compatibility[74G[ OK ]
 * Starting configure network device[74G[ OK ]
 * Stopping cold plug devices[74G[ OK ]
 * Stopping log initial device creation[74G[ OK ]
[   16.339935]  gadget: no file given for LUN0
[   16.417297] g_multi musb-hdrc.0.auto: failed to start g_multi: -22

Last login: Thu Jan 24 17:09:11 UTC 2013 on tty1
speech-dispatcher disabled; edit /etc/default/speech-dispatcher
Checking for running unattended-upgrades: 
Welcome to Linaro 12.02 (GNU/Linux 3.8.0-rc4-test+ armv7l)

 * Documentation:  https://wiki.linaro.org/

New release '12.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

*** /dev/mmcblk0p3 will be checked for errors at next reboot ***

 * Starting bluetooth       [80G root@linaro-ubuntu-desktop:~# [74G[ OK ]
 [33m*[39;49m PulseAudio configured for per-user sessions
saned disabled; edit /etc/default/saned


-- Steve

