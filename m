Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3A3Nrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:47:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32037 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3A3Nrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:47:40 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LMi6Nqn4CIEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=R9VVX8XAUBkA:10 a=QLqrdQrQ5vLs8G5c7RAA:9 a=PUjeQqilurYA:10 a=FgV73IYTkG9pQaTd:21 a=f1te8Ig8srl3mg4B:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359553659.17639.95.camel@gandalf.local.home>
Subject: Re: [BUG] snowball board locks up on boot
From: Steven Rostedt <rostedt@goodmis.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Date: Wed, 30 Jan 2013 08:47:39 -0500
In-Reply-To: <1359551685.17639.92.camel@gandalf.local.home>
References: <1359047682.21576.154.camel@gandalf.local.home>
	 <CACRpkdZU80XB2GiDtc7nh0hgMpyVYesi+xwhndu50jGS1L=wiw@mail.gmail.com>
	 <20130130090134.GR18212@gmail.com>
	 <1359551685.17639.92.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 08:14 -0500, Steven Rostedt wrote:
> On Wed, 2013-01-30 at 09:01 +0000, Lee Jones wrote:
> 
> > Can you provide your bootlog please Steven?
> > 
> 
> Here's the bootlog after I reverted the patch and successfully booted:
> 

And here's the bootlog before I reverted. Actually, this log is from my
bisect log, where it found the bad commit:

tartup failed
EMMC: 0, MMC: 1
In:    serial
Out:   serial
Err:   serial
Net:   smc911x-0
Hit any key to stop autoboot:  3  2  1  0 
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
	 ########################
done
Bytes transferred = 4169048 (3f9d58 hex)
## Booting kernel from Legacy Image at 00100000 ...
   Image Name:   Linux-3.6.0-rc3-test+
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4168984 Bytes =  4 MB
   Load Address: 00008000
   Entry Point:  00008000
   Loading Kernel Image ... OK
OK

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0
[    0.000000] Linux version 3.6.0-rc3-test+ (rostedt@goliath) (gcc version 4.5.2 (GCC) ) #272 SMP PREEMPT Thu Jan 24 09:37:12 EST 2013
[    0.000000] CPU: ARMv7 Processor [412fc091] revision 1 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Calao Systems Snowball platform
[    0.000000] Ignoring unrecognised tag 0x41000403
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] DB8500 v2.1 [0x008500b1]
[    0.000000] PERCPU: Embedded 9 pages/cpu @c1111000 s13184 r8192 d15488 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 206848
[    0.000000] Kernel command line: console=ttyAMA2,115200n8 vmalloc=256M root=/dev/mmcblk0p3 rootwait mem=128M@0 mali.mali_mem=32M@128M hwmem=168M@160M mem=48M@328M mem_issw=1M@383M mem=640M@384M
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 128MB 48MB 640MB = 816MB total
[    0.000000] Memory: 818892k/818892k available, 16692k reserved, 278528K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xef800000 - 0xff000000   ( 248 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef000000   ( 752 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc07c6344   (7929 kB)
[    0.000000]       .init : 0xc07c7000 - 0xc0813380   ( 305 kB)
[    0.000000]       .data : 0xc0814000 - 0xc087b850   ( 415 kB)
[    0.000000]        .bss : 0xc087b874 - 0xc0909028   ( 566 kB)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:670
[    0.000000] PRCMU firmware: U8500, version 3.4.9
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.000457] Calibrating delay loop... 1594.16 BogoMIPS (lpj=7970816)
[    0.090026] pid_max: default: 32768 minimum: 301
[    0.090240] Security Framework initialized
[    0.090332] AppArmor: AppArmor initialized
[    0.090454] Mount-cache hash table entries: 512
[    0.091888] Initializing cgroup subsys cpuacct
[    0.091979] CPU: Testing write buffer coherency: ok
[    0.092041] ftrace: allocating 20089 entries in 59 pages
[    0.135833] CPU0: thread -1, cpu 0, socket 3, mpidr 80000300
[    0.135894] smp_twd: clock not found: -2
[    0.135894] Calibrating local timer... 399.10MHz.
[    0.190032] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
[    0.190185] Setting up static identity map for 0x577a68 - 0x577ac0
[    0.190216] L310 cache controller enabled
[    0.190216] l2x0: 8 ways, CACHE_ID 0x410000c5, AUX_CTRL 0x7e060800, Cache size: 524288 B
[    0.250549] CPU1: Booted secondary processor
[    0.339965] CPU1: thread -1, cpu 1, socket 3, mpidr 80000301
[    0.340087] Brought up 2 CPUs
[    0.340087] SMP: Total of 2 processors activated (3188.32 BogoMIPS).
[    0.340942] devtmpfs: initialized
[    0.346435] pinctrl core: initialized pinctrl subsystem
[    0.347686] dummy: 
[    0.348632] NET: Registered protocol family 16
[    0.349487] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.352569] gpio gpio.0: at address f812e000
[    0.353149] gpio gpio.1: at address f812e080
[    0.353729] gpio gpio.2: at address f800e000
[    0.354309] gpio gpio.3: at address f800e080
[    0.354858] gpio gpio.4: at address f800e100
[    0.355438] gpio gpio.5: at address f800e180
[    0.356018] gpio gpio.6: at address f811e000
[    0.356597] gpio gpio.7: at address f811e080
[    0.357177] gpio gpio.8: at address fa3fe000
[    0.358398] pinctrl-nomadik pinctrl-db8500: initialized Nomadik pin control driver
[    0.360229] ab8500-core ab8500-core.0: detected chip, AB8500 rev. 3.0
[    0.360290] ab8500-core ab8500-core.0: switch off cause(s) (0x20): 
[    0.360290]  "Battery level lower than power on reset threshold"
[    0.365112] DB8500 PRCMU initialized
[    0.366302] mop500_msp_init: Register platform-device 'snd-soc-u8500'.
[    0.366485] Initialize MSP I2S-devices.
[    0.366516] Register platform-device 'ux500-msp-i2s', id 0, irq 63
[    0.366729] Register platform-device 'ux500-msp-i2s', id 1, irq 94
[    0.366912] Register platform-device 'ux500-msp-i2s', id 2, irq 130
[    0.367095] Register platform-device 'ux500-msp-i2s', id 3, irq 94
[    0.367401] mop500_msp_init: Register platform-device 'ux500-pcm'
[    0.368286] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
[    0.368316] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.368865] db8500-vape: 
[    0.369171] db8500-varm: 
[    0.369476] db8500-vmodem: 
[    0.369750] db8500-vpll: 
[    0.370208] db8500-vsmps1: 
[    0.370483] db8500-vsmps2: 
[    0.370758] db8500-vsmps3: 
[    0.371032] db8500-vrf1: 
[    0.371307] db8500-sva-mmdsp: 
[    0.371582] db8500-sva-mmdsp-ret: 
[    0.371856] db8500-sva-pipe: 
[    0.372131] db8500-sia-mmdsp: 
[    0.372406] db8500-sia-mmdsp-ret: 
[    0.372680] db8500-sia-pipe: 
[    0.372955] db8500-sga: 
[    0.372985] db8500-sga: supplied by db8500-vape
[    0.373291] db8500-b2r2-mcde: 
[    0.373321] db8500-b2r2-mcde: supplied by db8500-vape
[    0.373626] db8500-esram12: 
[    0.373931] db8500-esram12-ret: 
[    0.374206] db8500-esram34: 
[    0.374511] db8500-esram34-ret: 
[    0.374786] Serial: AMBA PL011 UART driver
[    0.374969] uart0: ttyAMA0 at MMIO 0x80120000 (irq = 43) is a PL011 rev3
[    0.375396] uart-pl011 uart1: could not get default pinstate
[    0.375427] uart1: ttyAMA1 at MMIO 0x80121000 (irq = 51) is a PL011 rev3
[    0.375793] uart-pl011 uart2: could not get default pinstate
[    0.375823] uart2: ttyAMA2 at MMIO 0x80007000 (irq = 58) is a PL011 rev3
[    0.922393] console [ttyAMA2] enabled
[    0.946716] bio: create slab <bio-0> at 0


And this is where the board would lock up.

-- Steve


