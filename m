Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808Ab3IXGfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:35:18 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50566 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3IXGfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:35:13 -0400
Subject: Re: [[PATCH] 0/3] imx-dma: fixes
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
In-Reply-To: <20130923041953.GA17188@intel.com>
References: <1379426168-31989-1-git-send-email-m.grzeschik@pengutronix.de>
	 <20130923041953.GA17188@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Sep 2013 08:35:03 +0200
Message-ID: <1380004503.6145.16.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 09:49 +0530, Vinod Koul wrote:
> On Tue, Sep 17, 2013 at 03:56:05PM +0200, Michael Grzeschik wrote:
> > Hello,
> > 
> > this series is solving some lockdep issues in the imx-dma code.
> > There are some list_head and deadlock issues in the code,
> > that is running the implementation into unsafe situations.
> Thanks for this, I have trying to fix this with testing done by Christoph. I had
> similar set of fixes
> 
> Christoph can you pls try runnning this on your setup and check and we can apply
> these

Thanks for the update, I added Michaels imx-dma patchset to Kernel
3.4.62 and gave it a shot:

In contrast to DMA-disabled, a 'dd' copy still results in a hung:

   dd if=/dev/zero of=/mnt/dd-test.bin count=102400 bs=1K

Please see the full log from boot to hung with DEBUG enabled below.
With 2.6.31, copying to an SD-Card with DMA enabled works flawlessly,
this log is also below.

Michael, any ideas? I suppose you have the same board?

Thanks
 -- Christoph


***********************************************************
* dma_sdcard_hang_3.4.62_with_patches.txt :               *
***********************************************************

barebox 2012.09.0-dirty #1 Tue Jun 11 10:34:01 CEST 2013


Board: Phytec phyCard-i.MX27
registered netconsole as cs1
NAND device: Manufacturer ID: 0x2c, Chip ID: 0xa1 (Micron NAND 128MiB 1,8V 8-bit), page size: 2048, OOB size: 64
Bad block table found at page 65472, version 0x01
Bad block table found at page 65408, version 0x01
imx-mmc@mci0: registered as mci0
imxfb@imxfb0: i.MX Framebuffer driver
Malloc space: 0xa7300000 -> 0xa7cfffff (size 10 MB)
Stack space : 0xa72f8000 -> 0xa7300000 (size 32 kB)
running /env/bin/init...
No valid bmp file
bmp: illegal bits per pixel value: 65535

Hit any key to stop autoboot:  0
set parameter: Invalid argument
phy0: Link is up - 100/Full
DHCP client bound to address 172.16.21.13
TFTP from server 172.16.21.1 ('uImage-pca100' -> '/image')
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        ###############
booting kernel from /image
   Image Name:   Linux-3.4.62-00066-g5658d13-dirt
   Created:      2013-09-24   6:08:35 UTC
   OS:           Linux
   Architecture: ARM
   Type:         Kernel Image
   Compression:  uncompressed
   Data Size:    3072040 Bytes =  2.9 MB
   Load Address: a0008000
   Entry Point:  a0008000
commandline: mem=126M console=ttymxc0,115200 video=imxfb:Primeview-PD050VL1 mt9v022.sensor_type=colour pca100_usb_phy_usb3340=1 ip=dhcp root=/dev/nfs mtdparts=mxc_nand:512k(barebox)ro,128k(bareboxenv),1408k(splash),4M(kernel),-(root)
arch_number: 2149
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0
[    0.000000] Linux version 3.4.62-00066-g5658d13-dirty (honschu@mars) (gcc version 4.6.2 (OSELAS.Toolchain-2011.11.2) ) #257 PREEMPT Tue Sep 24 08:08:31 CEST 2013
[    0.000000] CPU: ARM926EJ-S [41069264] revision 4 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: phyCARD-i.MX27
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32004
[    0.000000] Kernel command line: mem=126M console=ttymxc0,115200 video=imxfb:Primeview-PD050VL1 mt9v022.sensor_type=colour pca100_usb_phy_usb3340=1 ip=dhcp root=/dev/nfs mtdparts=mxc_nand:512k(barebox)ro,128k(bareboxenv),1408k(splash),4M(kernel),-(root)
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Memory: 126MB = 126MB total
[    0.000000] Memory: 117188k/117188k available, 11836k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc8000000 - 0xff000000   ( 880 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc7e00000   ( 126 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .text : 0xc0008000 - 0xc04f2a00   (5035 kB)
[    0.000000]       .init : 0xc04f3000 - 0xc0515000   ( 136 kB)
[    0.000000]       .data : 0xc0516000 - 0xc0559e80   ( 272 kB)
[    0.000000]        .bss : 0xc0559ea4 - 0xc0a6a338   (5186 kB)
[    0.000000] NR_IRQS:336
[    0.000000] MXC IRQ initialized
[    0.000000] CPU identified as i.MX27, silicon rev 2.1
[    0.000000] sched_clock: 32 bits at 66MHz, resolution 15ns, wraps every 64585ms
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
[    0.002258] Calibrating delay loop... 199.06 BogoMIPS (lpj=995328)
[    0.071156] pid_max: default: 32768 minimum: 301
[    0.072600] Mount-cache hash table entries: 512
[    0.082584] CPU: Testing write buffer coherency: ok
[    0.085042] Setting up static identity map for 0xa03a0178 - 0xa03a01d0
[    0.095477] devtmpfs: initialized
[    0.108632] NET: Registered protocol family 16
[    0.138608] gpiochip_add: registered GPIOs 0 to 31 on device: imx21-gpio.0
[    0.145037] gpiochip_add: registered GPIOs 32 to 63 on device: imx21-gpio.1
[    0.149666] gpiochip_add: registered GPIOs 64 to 95 on device: imx21-gpio.2
[    0.154978] gpiochip_add: registered GPIOs 96 to 127 on device: imx21-gpio.3
[    0.159682] gpiochip_add: registered GPIOs 128 to 159 on device: imx21-gpio.4
[    0.164876] gpiochip_add: registered GPIOs 160 to 191 on device: imx21-gpio.5
[    0.401554] bio: create slab <bio-0> at 0
[    0.453575] SCSI subsystem initialized
[    0.461986] usbcore: registered new interface driver usbfs
[    0.463813] usbcore: registered new interface driver hub
[    0.466592] usbcore: registered new device driver usb
[    0.489265] Linux video capture interface: v2.00
[    0.518808] DMA-API: preallocated 4096 debug entries
[    0.518854] DMA-API: debugging enabled by kernel config
[    0.518988] Switching to clocksource mxc_timer1
[    0.710519] NET: Registered protocol family 2
[    0.712385] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.717864] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    0.718675] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    0.723983] TCP: Hash tables configured (established 4096 bind 4096)
[    0.724251] TCP: reno registered
[    0.724338] UDP hash table entries: 64 (order: 0, 5120 bytes)
[    0.725065] UDP-Lite hash table entries: 64 (order: 0, 5120 bytes)
[    0.727292] NET: Registered protocol family 1
[    0.731621] RPC: Registered named UNIX socket transport module.
[    0.731679] RPC: Registered udp transport module.
[    0.731717] RPC: Registered tcp transport module.
[    0.731753] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.733679] i.MXC CPU frequency driver
[    0.766135] Initializing RT-Tester: OK
[    0.955771] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.958185] msgmni has been set to 228
[    0.966355] io scheduler noop registered (default)
[    0.966408] start plist test
[    0.981581] end plist test
[    0.983733] Serial: IMX driver
[    0.985181] imx21-uart.0: ttymxc0 at MMIO 0x1000a000 (irq = 20) is a IMX
[    1.445276] console [ttymxc0] enabled
[    1.456037] at24 1-0052: 4096 byte at24 EEPROM, writable, 32 bytes/write
[    1.480439] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xa1 (Micron NAND 128MiB 1,8V 8-bit)
[    1.491417] Bad block table found at page 65472, version 0x01
[    1.498675] Bad block table found at page 65408, version 0x01
[    1.507814] 5 cmdlinepart partitions found on MTD device mxc_nand
[    1.514527] Creating 5 MTD partitions on "mxc_nand":
[    1.519744] 0x000000000000-0x000000080000 : "barebox"
[    1.542676] 0x000000080000-0x0000000a0000 : "bareboxenv"
[    1.560356] 0x0000000a0000-0x000000200000 : "splash"
[    1.577144] 0x000000200000-0x000000600000 : "kernel"
[    1.595037] 0x000000600000-0x000008000000 : "root"
[    1.624556] spi_imx imx27-cspi.0: master is unqueued, this is deprecated
[    1.632265] spi_imx imx27-cspi.0: probed
[    1.661335] fec_enet_mii_bus: probed
[    1.672725] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.680171] mxc-ehci mxc-ehci.2: initializing i.MX USB Controller
[    1.719771] mxc-ehci mxc-ehci.2: Freescale On-Chip EHCI Host Controller
[    1.731698] mxc-ehci mxc-ehci.2: new USB bus registered, assigned bus number 1
[    1.769477] mxc-ehci mxc-ehci.2: irq 55, io mem 0x10024400
[    1.789684] mxc-ehci mxc-ehci.2: USB 2.0 started, EHCI 1.00
[    1.809413] hub 1-0:1.0: USB hub found
[    1.813661] hub 1-0:1.0: 1 port detected
[    1.823137] Initializing USB Mass Storage driver...
[    1.830304] usbcore: registered new interface driver usb-storage
[    1.836358] USB Mass Storage support registered.
[    1.846486] mousedev: PS/2 mouse device common for all mice
[    1.855481] rtc-pcf8563 0-0051: chip found, driver version 0.4.3
[    1.869083] rtc-pcf8563 0-0051: low voltage detected, date/time is not reliable.
[    1.876777] rtc-pcf8563 0-0051: retrieved date/time is not valid.
[    1.886027] rtc-pcf8563 0-0051: rtc core: registered rtc-pcf8563 as rtc0
[    1.894529] i2c /dev entries driver
[    1.918481] mxc_vpu mxc_vpu: VPU firmware version 2.2.5
[    1.929069] mxc_vpu mxc_vpu: registered
[    1.934887] Driver for 1-wire Dallas network protocol.
[    1.963229] i.MX SDHC driver
[    1.981654] pca9530 0-0060: setting platform data
[    2.041773] usbcore: registered new interface driver usbhid
[    2.047393] usbhid: USB HID core driver
[    2.053012] oprofile: hardware counters not available
[    2.058106] oprofile: using timer interrupt.
[    2.080810] TCP: cubic registered
[    2.085777] NET: Registered protocol family 10
[    2.107356] NET: Registered protocol family 17
[    2.129485] can: controller area network core (rev 20090105 abi 8)
[    2.136722] NET: Registered protocol family 29
[    2.173411] imx-fb imx-fb.0: i.MX Framebuffer driver
[    2.213968] mmc0: host does not support reading read-only switch. assuming write-enable.
[    2.227218] mmc0: new SD card at address b368
[    2.232090] rtc-pcf8563 0-0051: low voltage detected, date/time is not reliable.
[    2.252034] rtc-pcf8563 0-0051: retrieved date/time is not valid.
[    2.258191] rtc-pcf8563 0-0051: hctosys: invalid date/time
[    2.266457] mmcblk0: mmc0:b368 NCard 1.86 GiB
[    2.312573]  mmcblk0: p1
[    2.323336] eth0: Freescale FEC PHY driver [Generic PHY] (mii_bus:phy_addr=imx27-fec-1:00, irq=-1)
[    2.350267] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.322184] PHY: imx27-fec-1:00 - Link is Up - 100/Full
[    4.330544] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    4.356260] Sending DHCP requests ., OK
[    4.380282] IP-Config: Got DHCP answer from 172.16.21.1, my address is 172.16.21.13
[    4.396553] IP-Config: Complete:
[    4.400361]      device=eth0, addr=172.16.21.13, mask=255.255.255.0, gw=172.16.21.1
[    4.412529]      host=172.16.21.13, domain=example.org, nis-domain=(none)
[    4.419694]      bootserver=172.16.21.1, rootserver=172.16.21.1, rootpath=/srv/nfs/pca100_ptx
[    4.428174]      nameserver0=85.214.20.141, nameserver1=213.73.91.35
[    4.483783] VFS: Mounted root (nfs filesystem) on device 0:13.
[    4.493858] devtmpfs: mounted
[    4.498496] Freeing init memory: 136K
init started: BusyBox v1.18.5 (2013-01-17 19:53:34 CET)
starting pid 445, tty '/dev/console': '/etc/init.d/rcS'
mounting filesystems...done.
running rc.d services...
starting udev
creating static nodes
starting udevd...[    6.982946] udevd[468]: starting version 181
done
[    7.985531] Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
waiting for devices...done
syslogd starting
Starting system message bus: dbus.
starting sshd...done
Starting telnetd...
loading modules
sound not supported, skipping mixer state
starting network interfaces...
lighttpd: starting
lighttpd: done
/usr/sbin/pure-ftpd
pure-ftpd: starting pure-ftpd: /usr/sbin/pure-ftpd
/usr/sbin/pure-uploadscript
pure-ftpd: starting upload helper daemon...
done

***  PHYTEC BSP PD12.1.0 based on OSELAS(R)  ***

starting pid 555, tty '/dev/console': '/sbin/getty -L 115200 ttymxc0 vt100'


       _            ____    _    ____  ____
 _ __ | |__  _   _ / ___|  / `  |  _ `|  _ `
| '_ `| '_ `| | | | |     / _ ` | |_) | | | |
| |_) | | | | |_| | |___ / ___ `|  _ <| |_| |
| .__/|_| |_|`__, |`____/_/   `_`_| `_`____/
|_|          |___/


OSELAS(R)-phyCARD / phyCARD-S2012.09.0
ptxdist-2012.03.0/2013-14-17T20:14:23+0100

phyCARD login: root
root@phyCARD:~ uname -a
Linux phyCARD 3.4.62-00066-g5658d13-dirty #257 PREEMPT Tue Sep 24 08:08:31 CEST 2013 armv5tejl GNU/Linux
root@phyCARD:~ mount /dev/mmcblk0p1 /mnt
root@phyCARD:~ echo 8 > /proc/sys/kernel/printk
root@phyCARD:~ time dd if=/dev/zero of=/mnt/dd-test.bin count=102400 bs=1K
[   55.491782] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.503155] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527000, src 0x10014038, size 0x00000200
[   55.512587] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.519226] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.525695] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.532165] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.543538] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527200, src 0x10014038, size 0x00000200
[   55.552970] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.559104] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.565640] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.572226] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.583599] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527400, src 0x10014038, size 0x00000200
[   55.593032] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.599449] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.605911] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.612160] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.623532] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527600, src 0x10014038, size 0x00000200
[   55.632965] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.639090] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.645556] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.651823] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.663195] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527800, src 0x10014038, size 0x00000200
[   55.672628] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.678996] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.685458] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.691763] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.703141] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527a00, src 0x10014038, size 0x00000200
[   55.712573] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.718691] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.725152] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.731432] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.742804] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527c00, src 0x10014038, size 0x00000200
[   55.752236] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.758610] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.765072] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.771370] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.782742] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5527e00, src 0x10014038, size 0x00000200
[   55.792173] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.798291] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.804749] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.811533] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.822908] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525000, src 0x10014038, size 0x00000200
[   55.832340] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.838715] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.845179] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.851493] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.862866] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525200, src 0x10014038, size 0x00000200
[   55.872297] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.878414] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.884873] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.891159] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.902531] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525400, src 0x10014038, size 0x00000200
[   55.911965] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.918315] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.924775] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.931077] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.942450] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525600, src 0x10014038, size 0x00000200
[   55.951881] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.957983] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   55.964439] imx-dma imx-dma: imxdma_disable_hw channel 0
[   55.970733] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   55.982107] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525800, src 0x10014038, size 0x00000200
[   55.991539] imx-dma imx-dma: imxdma_enable_hw channel 0
[   55.997874] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.004326] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.010629] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.022001] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525a00, src 0x10014038, size 0x00000200
[   56.031432] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.037540] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.043995] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.050746] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.062117] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525c00, src 0x10014038, size 0x00000200
[   56.071550] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.077910] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.084367] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.091149] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.102520] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5525e00, src 0x10014038, size 0x00000200
[   56.111955] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.118081] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.124545] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.131019] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.142393] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523000, src 0x10014038, size 0x00000200
[   56.151824] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.158193] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.164659] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.170977] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.182351] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523200, src 0x10014038, size 0x00000200
[   56.191784] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.197905] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.204362] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.210647] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.222019] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523400, src 0x10014038, size 0x00000200
[   56.231450] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.237811] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.244276] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.250586] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.261959] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523600, src 0x10014038, size 0x00000200
[   56.271392] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.277508] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.283964] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.290269] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.301642] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523800, src 0x10014038, size 0x00000200
[   56.311074] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.317440] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.323901] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.330205] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.341577] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523a00, src 0x10014038, size 0x00000200
[   56.351019] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.357134] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.363596] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.371364] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.382738] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523c00, src 0x10014038, size 0x00000200
[   56.392170] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.398525] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.404985] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.411281] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.422653] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5523e00, src 0x10014038, size 0x00000200
[   56.432086] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.438204] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.444658] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.451243] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.462617] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528000, src 0x10014038, size 0x00000200
[   56.472047] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.478422] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.484879] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.491191] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.502569] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528200, src 0x10014038, size 0x00000200
[   56.512001] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.518111] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.524567] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.530866] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.542241] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528400, src 0x10014038, size 0x00000200
[   56.551673] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.558042] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.564499] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.570795] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.582172] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528600, src 0x10014038, size 0x00000200
[   56.591605] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.598051] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.604516] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.610933] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.622310] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528800, src 0x10014038, size 0x00000200
[   56.631745] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.638117] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.644583] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.651260] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.662634] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528a00, src 0x10014038, size 0x00000200
[   56.672065] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.678185] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.684650] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.690939] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.702312] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528c00, src 0x10014038, size 0x00000200
[   56.711744] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.718108] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.724566] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.730866] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.742242] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5528e00, src 0x10014038, size 0x00000200
[   56.751676] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.757810] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.764271] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.770696] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.782070] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552a000, src 0x10014038, size 0x00000200
[   56.791503] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.797865] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.804326] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.810652] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.822028] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552a200, src 0x10014038, size 0x00000200
[   56.831461] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.837606] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.844069] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.850340] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.861713] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552a400, src 0x10014038, size 0x00000200
[   56.871147] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.877549] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.884008] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.890263] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.901634] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552a600, src 0x10014038, size 0x00000200
[   56.911068] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.917214] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.923675] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.930259] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.941630] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552a800, src 0x10014038, size 0x00000200
[   56.951060] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.957466] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   56.963928] imx-dma imx-dma: imxdma_disable_hw channel 0
[   56.970179] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   56.981550] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552aa00, src 0x10014038, size 0x00000200
[   56.990984] imx-dma imx-dma: imxdma_enable_hw channel 0
[   56.997312] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.003775] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.010113] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.021484] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ac00, src 0x10014038, size 0x00000200
[   57.030916] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.037317] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.043777] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.050249] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.061620] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ae00, src 0x10014038, size 0x00000200
[   57.071050] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.077188] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.083646] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.090187] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.101562] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552c000, src 0x10014038, size 0x00000200
[   57.110996] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.117404] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.123865] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.130191] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.141566] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552c200, src 0x10014038, size 0x00000200
[   57.150999] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.157147] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.163606] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.170045] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.181419] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552c400, src 0x10014038, size 0x00000200
[   57.190852] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.197246] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.203711] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.210625] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.221999] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552c600, src 0x10014038, size 0x00000200
[   57.231429] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.237584] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.244042] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.250330] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.261702] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552c800, src 0x10014038, size 0x00000200
[   57.271137] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.277540] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.284007] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.290299] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.301670] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ca00, src 0x10014038, size 0x00000200
[   57.311104] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.317251] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.323713] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.329999] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.341374] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552cc00, src 0x10014038, size 0x00000200
[   57.350807] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.357184] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.363668] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.370223] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.381597] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ce00, src 0x10014038, size 0x00000200
[   57.391029] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.397158] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.403616] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.410176] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.421554] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552e000, src 0x10014038, size 0x00000200
[   57.430984] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.437351] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.443812] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.450123] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.461502] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552e200, src 0x10014038, size 0x00000200
[   57.470938] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.477070] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.483528] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.490336] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.501712] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552e400, src 0x10014038, size 0x00000200
[   57.511142] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.517514] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.523977] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.530274] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.541647] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552e600, src 0x10014038, size 0x00000200
[   57.551080] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.557223] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.563682] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.569963] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.581335] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552e800, src 0x10014038, size 0x00000200
[   57.590767] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.597155] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.603693] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.610350] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.621726] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ea00, src 0x10014038, size 0x00000200
[   57.631161] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.637313] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.643774] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.650074] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.661446] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ec00, src 0x10014038, size 0x00000200
[   57.670881] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.677272] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.683738] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.690048] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.701420] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa552ee00, src 0x10014038, size 0x00000200
[   57.710853] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.716994] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.723453] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.730053] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.741423] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530000, src 0x10014038, size 0x00000200
[   57.750854] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.757245] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.763714] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.770390] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.781762] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530200, src 0x10014038, size 0x00000200
[   57.791194] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.797350] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.803810] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.810107] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.821479] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530400, src 0x10014038, size 0x00000200
[   57.830921] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.837318] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.843776] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.850071] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.861445] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530600, src 0x10014038, size 0x00000200
[   57.870878] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.877023] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.883475] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.889926] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.901301] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530800, src 0x10014038, size 0x00000200
[   57.910734] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.917113] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.923571] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.930004] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.941379] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530a00, src 0x10014038, size 0x00000200
[   57.950812] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.956979] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   57.963436] imx-dma imx-dma: imxdma_disable_hw channel 0
[   57.969884] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   57.981256] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530c00, src 0x10014038, size 0x00000200
[   57.990687] imx-dma imx-dma: imxdma_enable_hw channel 0
[   57.997074] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.003535] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.009986] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.021357] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5530e00, src 0x10014038, size 0x00000200
[   58.030786] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.036932] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.043389] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.050848] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.062223] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532000, src 0x10014038, size 0x00000200
[   58.071652] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.078044] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.084502] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.091476] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.102851] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532200, src 0x10014038, size 0x00000200
[   58.112284] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.118425] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.124878] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.131158] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.142532] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532400, src 0x10014038, size 0x00000200
[   58.151962] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.158341] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.164805] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.171098] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.182471] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532600, src 0x10014038, size 0x00000200
[   58.191903] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.198038] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.204496] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.210794] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.222170] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532800, src 0x10014038, size 0x00000200
[   58.231602] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.237985] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.244446] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.250760] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.262136] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532a00, src 0x10014038, size 0x00000200
[   58.271568] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.277701] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.284159] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.290450] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.301824] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532c00, src 0x10014038, size 0x00000200
[   58.311256] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.317637] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.324101] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.330724] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.342099] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5532e00, src 0x10014038, size 0x00000200
[   58.351531] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.357673] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.364133] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.371533] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.382907] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534000, src 0x10014038, size 0x00000200
[   58.392339] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.398716] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.405179] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.411475] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.422850] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534200, src 0x10014038, size 0x00000200
[   58.432282] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.438415] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.444875] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.451126] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.462497] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534400, src 0x10014038, size 0x00000200
[   58.471932] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.478312] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.484775] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.491045] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.502414] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534600, src 0x10014038, size 0x00000200
[   58.511845] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.517979] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.524437] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.530696] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.542067] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534800, src 0x10014038, size 0x00000200
[   58.551502] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.557883] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.564340] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.570636] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.582008] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534a00, src 0x10014038, size 0x00000200
[   58.591439] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.597567] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.604026] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.611085] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.622461] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534c00, src 0x10014038, size 0x00000200
[   58.631892] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.638273] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.644733] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.651137] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.662510] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5534e00, src 0x10014038, size 0x00000200
[   58.671943] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.678093] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.684555] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.690995] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.702364] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536000, src 0x10014038, size 0x00000200
[   58.711796] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.718186] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.724646] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.730978] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.742352] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536200, src 0x10014038, size 0x00000200
[   58.751785] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.757917] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.764379] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.770665] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.782036] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536400, src 0x10014038, size 0x00000200
[   58.791469] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.797850] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.804309] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.810621] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.821995] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536600, src 0x10014038, size 0x00000200
[   58.831428] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.837558] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.844017] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.850316] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.861689] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536800, src 0x10014038, size 0x00000200
[   58.871121] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.877472] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.883939] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.890602] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.901978] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536a00, src 0x10014038, size 0x00000200
[   58.911411] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.917532] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.923989] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.930286] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.941664] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536c00, src 0x10014038, size 0x00000200
[   58.951099] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.957449] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   58.963907] imx-dma imx-dma: imxdma_disable_hw channel 0
[   58.970206] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   58.981583] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5536e00, src 0x10014038, size 0x00000200
[   58.991015] imx-dma imx-dma: imxdma_enable_hw channel 0
[   58.997139] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.003598] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.010152] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.021526] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538000, src 0x10014038, size 0x00000200
[   59.030956] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.037331] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.043790] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.050290] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.061663] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538200, src 0x10014038, size 0x00000200
[   59.071093] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.077220] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.083675] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.089966] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.101338] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538400, src 0x10014038, size 0x00000200
[   59.110774] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.117147] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.123612] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.130041] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.141414] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538600, src 0x10014038, size 0x00000200
[   59.150846] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.156984] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.163441] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.170241] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.181616] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538800, src 0x10014038, size 0x00000200
[   59.191048] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.197426] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.203893] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.210199] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.221575] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538a00, src 0x10014038, size 0x00000200
[   59.231007] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.237137] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.243597] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.250024] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.261400] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538c00, src 0x10014038, size 0x00000200
[   59.270832] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.277212] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.283676] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.289971] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.301346] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5538e00, src 0x10014038, size 0x00000200
[   59.310788] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.316914] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.323369] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.329954] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.341329] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553a000, src 0x10014038, size 0x00000200
[   59.350762] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.357145] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.363606] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.370286] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.381660] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553a200, src 0x10014038, size 0x00000200
[   59.391091] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.397226] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.403678] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.409954] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.421324] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553a400, src 0x10014038, size 0x00000200
[   59.430756] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.437148] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.443607] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.450428] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.461804] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553a600, src 0x10014038, size 0x00000200
[   59.471234] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.477388] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.483845] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.490138] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.501509] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553a800, src 0x10014038, size 0x00000200
[   59.510940] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.517341] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.523799] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.530089] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.541462] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553aa00, src 0x10014038, size 0x00000200
[   59.550896] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.557030] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.563486] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.569915] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.581286] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ac00, src 0x10014038, size 0x00000200
[   59.590717] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.597099] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.603562] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.609991] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.621368] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ae00, src 0x10014038, size 0x00000200
[   59.630798] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.637282] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.643748] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.650343] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.661719] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553c000, src 0x10014038, size 0x00000200
[   59.671152] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.677562] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.684025] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.690354] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.701727] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553c200, src 0x10014038, size 0x00000200
[   59.711160] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.717333] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.723791] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.730451] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.741827] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553c400, src 0x10014038, size 0x00000200
[   59.751260] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.757668] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.764131] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.770416] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.781789] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553c600, src 0x10014038, size 0x00000200
[   59.791222] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.797366] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.803823] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.810081] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.821455] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553c800, src 0x10014038, size 0x00000200
[   59.830890] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.837278] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.843736] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.849992] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.861365] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ca00, src 0x10014038, size 0x00000200
[   59.870796] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.876939] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.883398] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.889815] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.901188] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553cc00, src 0x10014038, size 0x00000200
[   59.910621] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.917004] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.923466] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.929880] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.941251] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ce00, src 0x10014038, size 0x00000200
[   59.950682] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.956816] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   59.963274] imx-dma imx-dma: imxdma_disable_hw channel 0
[   59.969861] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   59.981234] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553e000, src 0x10014038, size 0x00000200
[   59.990665] imx-dma imx-dma: imxdma_enable_hw channel 0
[   59.997052] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.003514] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.010308] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.021680] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553e200, src 0x10014038, size 0x00000200
[   60.031111] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.037260] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.043714] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.050591] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.061962] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553e400, src 0x10014038, size 0x00000200
[   60.071392] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.077897] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.084360] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.090796] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.102169] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553e600, src 0x10014038, size 0x00000200
[   60.111603] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.117748] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.124207] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.130504] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.141877] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553e800, src 0x10014038, size 0x00000200
[   60.151309] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.157694] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.164157] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.170455] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.181830] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ea00, src 0x10014038, size 0x00000200
[   60.191264] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.197403] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.203863] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.210151] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.221523] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ec00, src 0x10014038, size 0x00000200
[   60.230956] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.237346] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.243812] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.250115] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.261492] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa553ee00, src 0x10014038, size 0x00000200
[   60.270923] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.277068] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.283548] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.290309] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.301683] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540000, src 0x10014038, size 0x00000200
[   60.311117] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.317504] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.323971] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.330299] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.341672] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540200, src 0x10014038, size 0x00000200
[   60.351105] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.357234] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.363971] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.372028] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.383404] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540400, src 0x10014038, size 0x00000200
[   60.392838] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.399264] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.405727] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.412019] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.423397] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540600, src 0x10014038, size 0x00000200
[   60.432828] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.438971] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.445434] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.451732] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.463107] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540800, src 0x10014038, size 0x00000200
[   60.472543] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.478913] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.485378] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.491682] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.503054] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540a00, src 0x10014038, size 0x00000200
[   60.512487] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.519422] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.526037] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.532699] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70fbc00 sgcount=1 total length=512 dev_addr=0x10014038 (dev2mem)
[   60.544075] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0xa5540c00, src 0x10014038, size 0x00000200
[   60.553508] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.567170] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.573637] imx-dma imx-dma: imxdma_disable_hw channel 0
[   60.579646] imx-dma imx-dma: imxdma_xfer_desc channel: 0 sg=c70ff000 sgcount=8 total length=32768 dev_addr=0x10014038 (mem2dev)
[   60.591192] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0x10014038, src 0xa5527000, size 0x00001000
[   60.600624] imx-dma imx-dma: imxdma_enable_hw channel 0
[   60.605887] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0x10014038, src 0xa5525000, size 0x00001000
[   60.795424] imx-dma imx-dma: dma_irq_handler called, disr=0x00000001
[   60.801857] imx-dma imx-dma:  imxdma_sg_next channel: 0 dst 0x10014038, src 0xa5523000, size 0x00001000
[   61.290221] imx-dma imx-dma: channel 0: watchdog timeout!
[   90.939820] INFO: task mmcqd/0:440 blocked for more than 30 seconds.
[   90.946285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   90.954794] mmcqd/0         D c039a5e4     0   440      2 0x00000000
[   90.961763] [<c039a5e4>] (__schedule+0x220/0x590) from [<c03987ec>] (schedule_timeout+0x154/0x1bc)
[   90.971193] [<c03987ec>] (schedule_timeout+0x154/0x1bc) from [<c039a27c>] (wait_for_common+0xac/0x150)
[   90.980970] [<c039a27c>] (wait_for_common+0xac/0x150) from [<c028323c>] (mmc_wait_for_req_done+0x1c/0x74)
[   90.991001] [<c028323c>] (mmc_wait_for_req_done+0x1c/0x74) from [<c0283e64>] (mmc_start_req+0x54/0x118)
[   91.000864] [<c0283e64>] (mmc_start_req+0x54/0x118) from [<c028ef08>] (mmc_blk_issue_rw_rq+0x64/0x380)
[   91.010631] [<c028ef08>] (mmc_blk_issue_rw_rq+0x64/0x380) from [<c028f3d4>] (mmc_blk_issue_rq+0x1b0/0x484)
[   91.021197] [<c028f3d4>] (mmc_blk_issue_rq+0x1b0/0x484) from [<c0290674>] (mmc_queue_thread+0x58/0xf4)
[   91.030792] [<c0290674>] (mmc_queue_thread+0x58/0xf4) from [<c0032d00>] (kthread+0x84/0x90)
[   91.039403] [<c0032d00>] (kthread+0x84/0x90) from [<c0009834>] (kernel_thread_exit+0x0/0x8)
[   91.047810] no locks held by mmcqd/0/440.
[   91.052116] INFO: task dd:566 blocked for more than 30 seconds.
[   91.058076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   91.066086] dd              D c039a5e4     0   566    565 0x00000000
[   91.072759] [<c039a5e4>] (__schedule+0x220/0x590) from [<c039aa80>] (io_schedule+0x60/0x94)
[   91.081357] [<c039aa80>] (io_schedule+0x60/0x94) from [<c00c59d0>] (sleep_on_buffer+0x8/0x10)
[   91.090413] [<c00c59d0>] (sleep_on_buffer+0x8/0x10) from [<c039891c>] (__wait_on_bit+0x74/0xb8)
[   91.099384] [<c039891c>] (__wait_on_bit+0x74/0xb8) from [<c03989c4>] (out_of_line_wait_on_bit+0x64/0x70)
[   91.108971] [<c03989c4>] (out_of_line_wait_on_bit+0x64/0x70) from [<c00c80f0>] (__bread+0xc0/0xdc)
[   91.118181] [<c00c80f0>] (__bread+0xc0/0xdc) from [<c011a8bc>] (fat_ent_bread+0x58/0xc4)
[   91.126500] [<c011a8bc>] (fat_ent_bread+0x58/0xc4) from [<c011aa9c>] (fat_ent_read+0xf4/0x204)
[   91.135335] [<c011aa9c>] (fat_ent_read+0xf4/0x204) from [<c011ac10>] (fat_free_clusters+0x64/0x318)
[   91.144604] [<c011ac10>] (fat_free_clusters+0x64/0x318) from [<c011b7e8>] (fat_truncate_blocks+0x1f4/0x294)
[   91.154570] [<c011b7e8>] (fat_truncate_blocks+0x1f4/0x294) from [<c011bab0>] (fat_setattr+0x228/0x380)
[   91.164379] [<c011bab0>] (fat_setattr+0x228/0x380) from [<c00b6704>] (notify_change+0x164/0x2cc)
[   91.173445] [<c00b6704>] (notify_change+0x164/0x2cc) from [<c009b070>] (do_truncate+0x78/0x94)
[   91.182296] [<c009b070>] (do_truncate+0x78/0x94) from [<c00aa6dc>] (do_last.isra.33+0x4fc/0x6c0)
[   91.191311] [<c00aa6dc>] (do_last.isra.33+0x4fc/0x6c0) from [<c00aaaa0>] (path_openat+0xb8/0x38c)
[   91.200410] [<c00aaaa0>] (path_openat+0xb8/0x38c) from [<c00aae5c>] (do_filp_open+0x2c/0x80)
[   91.208925] [<c00aae5c>] (do_filp_open+0x2c/0x80) from [<c009bc04>] (do_sys_open+0xe8/0x180)
[   91.217589] [<c009bc04>] (do_sys_open+0xe8/0x180) from [<c0008ec0>] (ret_fast_syscall+0x0/0x38)
[   91.226485] 3 locks held by dd/566:
[   91.230366]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<c009b064>] do_truncate+0x6c/0x94
[   91.239444]  #1:  (&ei->truncate_lock){+.+...}, at: [<c011ba98>] fat_setattr+0x210/0x380
[   91.247723]  #2:  (&sbi->fat_lock){+.+...}, at: [<c011abfc>] fat_free_clusters+0x50/0x318




***********************************************************
* dma_sdcard_2.6.31_good.txt                              *
***********************************************************

Hit any key to stop autoboot:  0
set parameter: Invalid argument
phy0: Link is up - 100/Full
DHCP client bound to address 172.16.21.13
TFTP from server 172.16.21.1 ('uImage-pca100' -> '/image')
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        #################################################################
        ###
booting kernel from /image
   Image Name:   Linux-2.6.31.6-00070-gcaef21d-di
   Created:      2013-09-17   9:17:43 UTC
   OS:           Linux
   Architecture: ARM
   Type:         Kernel Image
   Compression:  uncompressed
   Data Size:    2015264 Bytes =  1.9 MB
   Load Address: a0008000
   Entry Point:  a0008000
commandline: console=ttymxc0,115200 video=imxfb:Primeview-PD050VL1 mt9v022.sensor_type=colour ip=dhcp root=/dev/nfs mtdparts=mxc_nand:512k(barebox)ro,128k(bareboxenv),1408k(splash),4M(kernel),-(root)
arch_number: 2149
Uncompressing Linux................................................................................................................................ done, booting the kernel.
[    0.000000] Linux version 2.6.31.6-00070-gcaef21d-dirty (honschu@mars) (gcc version 4.6.2 (OSELAS.Toolchain-2011.11.2) ) #243 PREEMPT Tue Sep 17 11:17:40 CEST 2013
[    0.000000] CPU: ARM926EJ-S [41069264] revision 4 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: phyCARD-i.MX27
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: console=ttymxc0,115200 video=imxfb:Primeview-PD050VL1 mt9v022.sensor_type=colour ip=dhcp root=/dev/nfs mtdparts=mxc_nand:512k(barebox)ro,128k(bareboxenv),1408k(splash),4M(kernel),-(root)
[    0.000000] Unknown boot option `mt9v022.sensor_type=colour': ignoring
[    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 125552KB available (3628K code, 380K data, 104K init, 0K highmem)
[    0.000000] NR_IRQS:272
[    0.000000] MXC GPIO hardware
[    0.000000] MXC IRQ initialized
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Calibrating delay loop... 199.06 BogoMIPS (lpj=995328)
[    0.200000] Mount-cache hash table entries: 512
[    0.200000] CPU: Testing write buffer coherency: ok
[    0.210000] NET: Registered protocol family 16
[    0.260000] bio: create slab <bio-0> at 0
[    0.270000] SCSI subsystem initialized
[    0.270000] usbcore: registered new interface driver usbfs
[    0.270000] usbcore: registered new interface driver hub
[    0.270000] usbcore: registered new device driver usb
[    0.290000] NET: Registered protocol family 2
[    0.290000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.290000] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    0.290000] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[    0.290000] TCP: Hash tables configured (established 4096 bind 4096)
[    0.290000] TCP reno registered
[    0.290000] NET: Registered protocol family 1
[    0.300000] i.MX27 CPU frequency change support initialized 133000 399000
[    0.320000] JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.320000] msgmni has been set to 245
[    0.320000] io scheduler noop registered (default)
[    0.320000] i.MX Framebuffer driver
[    0.380000] Serial: IMX driver
[    0.380000] imx-uart.0: ttymxc0 at MMIO 0x1000a000 (irq = 20) is a IMX
[    0.380000] console [ttymxc0] enabled
[    0.620000] FEC Ethernet Driver
[    0.620000] fec: PHY @ 0x0, ID 0x00221613 -- KS8721BL
[    0.630000] NAND device: Manufacturer ID: 0x20, Chip ID: 0xa1 (ST Micro NAND 128MiB 1,8V 8-bit)
[    0.640000] Scanning device for bad blocks
[    0.980000] Bad eraseblock 1022 at 0x000007fc0000
[    0.990000] Bad eraseblock 1023 at 0x000007fe0000
[    0.990000] RedBoot partition parsing not available
[    1.000000] 5 cmdlinepart partitions found on MTD device mxc_nand
[    1.000000] Creating 5 MTD partitions on "mxc_nand":
[    1.010000] 0x000000000000-0x000000080000 : "barebox"
[    1.020000] 0x000000080000-0x0000000a0000 : "bareboxenv"
[    1.030000] 0x0000000a0000-0x000000200000 : "splash"
[    1.030000] 0x000000200000-0x000000600000 : "kernel"
[    1.040000] 0x000000600000-0x000008000000 : "root"
[    1.050000] spi_imx spi_imx.0: chipselect 1 already in use
[    1.060000] spi_imx spi_imx.0: probed
[    1.070000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.070000] Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
[    1.080000] mice: PS/2 mouse device common for all mice
[    1.090000] i2c /dev entries driver
[    1.100000] at24 1-0052: 4096 byte at24 EEPROM (writable)
[    1.100000] rtc-pcf8563 1-0051: chip found, driver version 0.4.3
[    1.110000] rtc-pcf8563 1-0051: rtc core: registered rtc-pcf8563 as rtc0
[    1.120000] i.MX SDHC driver
[    1.130000] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.140000] ALSA device list:
[    1.140000]   No soundcards found.
[    1.140000] oprofile: using timer interrupt.
[    1.150000] TCP cubic registered
[    1.150000] NET: Registered protocol family 17
[    1.160000] can: controller area network core (rev 20090105 abi 8)
[    1.160000] NET: Registered protocol family 29
[    1.170000] RPC: Registered udp transport module.
[    1.170000] RPC: Registered tcp transport module.
[    1.180000] pca100 camera: No GPIO expander on camera found
[    1.190000] rtc-pcf8563 1-0051: pcf8563_get_datetime: read error
[    1.200000] rtc-pcf8563 1-0051: hctosys: unable to read the hardware clock
[    1.210000] WM9711/WM9712 SoC Audio Codec 0.4
[    1.210000] asoc: AC97 HiFi <-> imx-ssi.0 mapping ok
[    1.220000] pca100_ac97_cold_reset
[    1.240000] pca100_ac97_warm_reset
[    1.260000] WM9712 AC97 reset failed
[    1.260000] Failed to reset WM9712: AC97 link error
[    1.360000] mmc0: host does not support reading read-only switch. assuming write-enable.
[    1.370000] mmc0: new SDHC card at address e624
[    1.370000] mmcblk0: mmc0:e624 SU16G 14.8 GiB
[    1.380000]  mmcblk0:
[    1.390000]  p1 p2
[    1.770000] eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.
[    2.780000] Sending DHCP requests .., OK
[    5.180000] IP-Config: Got DHCP answer from 172.16.21.1, my address is 172.16.21.13
[    5.190000] IP-Config: Complete:
[    5.190000]      device=eth0, addr=172.16.21.13, mask=255.255.255.0, gw=172.16.21.1,
[    5.200000]      host=172.16.21.13, domain=example.org, nis-domain=(none),
[    5.200000]      bootserver=172.16.21.1, rootserver=172.16.21.1, rootpath=/srv/nfs/pca100_ptx_2.6.31
[    5.210000] Looking up port of RPC 100003/2 on 172.16.21.1
[    5.230000] Looking up port of RPC 100005/1 on 172.16.21.1
[    5.240000] VFS: Mounted root (nfs filesystem) on device 0:13.
[    5.250000] Freeing init memory: 104K
init started: BusyBox v1.13.4 (2010-02-10 14:49:43 CET)
mounting filesystems...done.
running rc.d services...
starting udev
mounting tmpfs at /dev
creating static nodes
starting udevd...done
waiting for devices...done
syslogd starting
Starting system message bus: dbus.
starting sshd...done
Starting telnetd...
restoring mixer state.../usr/sbin/alsactl: load_state:1608: No soundcards found...
done
starting network interfaces...
ip: RTNETLINK answers: File exists
lighttpd: starting
lighttpd: done
/usr/sbin/pure-ftpd
pure-ftpd: starting pure-ftpd: /usr/sbin/pure-ftpd
/usr/sbin/pure-uploadscript
pure-ftpd: starting upload helper daemon...
done
loading modules
    usb-storage
FATAL: Could not load /lib/modules/2.6.31.6-00070-gcaef21d-dirty/modules.dep: No such file or directory
    mx27_camera
FATAL: Could not load /lib/modules/2.6.31.6-00070-gcaef21d-dirty/modules.dep: No such file or directory

OSELAS(R)-phyCARD (PTXdist-1.99.19-1/2010-02-10T15:33:59+0100)

       _            ____    _    ____  ____
 _ __ | |__  _   _ / ___|  / \  |  _ \|  _ \
| '_ \| '_ \| | | | |     / _ \ | |_) | | | |
| |_) | | | | |_| | |___ / ___ \|  _ <| |_| |
| .__/|_| |_|\__, |\____/_/   \_\_| \_\____/
|_|          |___/



***  PHYTEC BSP PD09.2.0R3 based on OSELAS(R)  ***


phyCARD login: root
root@phyCARD:~ uname -a
Linux phyCARD 2.6.31.6-00070-gcaef21d-dirty #243 PREEMPT Tue Sep 17 11:17:40 CEST 2013 armv5tejl unknown
root@phyCARD:~ echo 8 > /proc/sys/kernel/printk
root@phyCARD:~ mount /dev/mmcblk0p1 /mnt
[   24.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=1024 dev_addr=0x10014038 for read
[   24.460000] imxdma0: next sg chunk dst 0xa7358400, src 0x10014038, size 0x00000400
[   24.460000] imxdma0: imx_dma_enable
[   24.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.470000] imxdma0: imx_dma_disable
[   24.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=1024 dev_addr=0x10014038 for read
[   24.490000] imxdma0: next sg chunk dst 0xa7358400, src 0x10014038, size 0x00000400
[   24.500000] imxdma0: imx_dma_enable
[   24.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.500000] imxdma0: imx_dma_disable
[   24.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   24.520000] imxdma0: next sg chunk dst 0xa7358000, src 0x10014038, size 0x00000200
[   24.530000] imxdma0: imx_dma_enable
[   24.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.540000] imxdma0: imx_dma_disable
[   24.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   24.550000] imxdma0: next sg chunk dst 0xa7358200, src 0x10014038, size 0x00000200
[   24.560000] imxdma0: imx_dma_enable
[   24.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.570000] imxdma0: imx_dma_disable
[   24.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   24.580000] imxdma0: next sg chunk dst 0xa0761000, src 0x10014038, size 0x00000200
[   24.590000] imxdma0: imx_dma_enable
[   24.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.600000] imxdma0: imx_dma_disable
[   24.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   24.610000] imxdma0: next sg chunk dst 0xa7366600, src 0x10014038, size 0x00000200
[   24.620000] imxdma0: imx_dma_enable
[   24.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.630000] imxdma0: imx_dma_disable
[   24.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   24.640000] imxdma0: next sg chunk dst 0xa739d000, src 0x10014038, size 0x00000200
[   24.650000] imxdma0: imx_dma_enable
[   24.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.660000] imxdma0: imx_dma_disable
[   24.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   24.670000] imxdma0: next sg chunk dst 0xa7377200, src 0x10014038, size 0x00000200
[   24.680000] imxdma0: imx_dma_enable
[   24.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   24.700000] imxdma0: imx_dma_disable
root@phyCARD:~
root@phyCARD:~ time dd if=/dev/zero of=/mnt/dd-test.bin count=500 bs=1K
[   49.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.540000] imxdma0: next sg chunk dst 0xa73a1c00, src 0x10014038, size 0x00000200
[   49.550000] imxdma0: imx_dma_enable
[   49.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.560000] imxdma0: imx_dma_disable
[   49.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.570000] imxdma0: next sg chunk dst 0xa73a1e00, src 0x10014038, size 0x00000200
[   49.580000] imxdma0: imx_dma_enable
[   49.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.590000] imxdma0: imx_dma_disable
[   49.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.600000] imxdma0: next sg chunk dst 0xa73a2000, src 0x10014038, size 0x00000200
[   49.610000] imxdma0: imx_dma_enable
[   49.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.620000] imxdma0: imx_dma_disable
[   49.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.630000] imxdma0: next sg chunk dst 0xa73a2200, src 0x10014038, size 0x00000200
[   49.640000] imxdma0: imx_dma_enable
[   49.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.650000] imxdma0: imx_dma_disable
[   49.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.660000] imxdma0: next sg chunk dst 0xa73a2400, src 0x10014038, size 0x00000200
[   49.670000] imxdma0: imx_dma_enable
[   49.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.680000] imxdma0: imx_dma_disable
[   49.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.690000] imxdma0: next sg chunk dst 0xa73a2600, src 0x10014038, size 0x00000200
[   49.700000] imxdma0: imx_dma_enable
[   49.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.710000] imxdma0: imx_dma_disable
[   49.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.720000] imxdma0: next sg chunk dst 0xa73a2800, src 0x10014038, size 0x00000200
[   49.730000] imxdma0: imx_dma_enable
[   49.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.740000] imxdma0: imx_dma_disable
[   49.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.760000] imxdma0: next sg chunk dst 0xa73a2a00, src 0x10014038, size 0x00000200
[   49.760000] imxdma0: imx_dma_enable
[   49.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.770000] imxdma0: imx_dma_disable
[   49.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.790000] imxdma0: next sg chunk dst 0xa73a2c00, src 0x10014038, size 0x00000200
[   49.790000] imxdma0: imx_dma_enable
[   49.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.800000] imxdma0: imx_dma_disable
[   49.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.820000] imxdma0: next sg chunk dst 0xa73a2e00, src 0x10014038, size 0x00000200
[   49.830000] imxdma0: imx_dma_enable
[   49.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.830000] imxdma0: imx_dma_disable
[   49.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.850000] imxdma0: next sg chunk dst 0xa73a5000, src 0x10014038, size 0x00000200
[   49.860000] imxdma0: imx_dma_enable
[   49.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.870000] imxdma0: imx_dma_disable
[   49.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.880000] imxdma0: next sg chunk dst 0xa73a5200, src 0x10014038, size 0x00000200
[   49.890000] imxdma0: imx_dma_enable
[   49.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.900000] imxdma0: imx_dma_disable
[   49.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.910000] imxdma0: next sg chunk dst 0xa73a5400, src 0x10014038, size 0x00000200
[   49.920000] imxdma0: imx_dma_enable
[   49.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.930000] imxdma0: imx_dma_disable
[   49.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.940000] imxdma0: next sg chunk dst 0xa73a5600, src 0x10014038, size 0x00000200
[   49.950000] imxdma0: imx_dma_enable
[   49.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.960000] imxdma0: imx_dma_disable
[   49.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   49.970000] imxdma0: next sg chunk dst 0xa73a5800, src 0x10014038, size 0x00000200
[   49.980000] imxdma0: imx_dma_enable
[   49.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   49.990000] imxdma0: imx_dma_disable
[   49.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.000000] imxdma0: next sg chunk dst 0xa73a5a00, src 0x10014038, size 0x00000200
[   50.010000] imxdma0: imx_dma_enable
[   50.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.020000] imxdma0: imx_dma_disable
[   50.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.030000] imxdma0: next sg chunk dst 0xa73a5c00, src 0x10014038, size 0x00000200
[   50.040000] imxdma0: imx_dma_enable
[   50.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.050000] imxdma0: imx_dma_disable
[   50.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.070000] imxdma0: next sg chunk dst 0xa73a5e00, src 0x10014038, size 0x00000200
[   50.070000] imxdma0: imx_dma_enable
[   50.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.080000] imxdma0: imx_dma_disable
[   50.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.100000] imxdma0: next sg chunk dst 0xa73a7000, src 0x10014038, size 0x00000200
[   50.100000] imxdma0: imx_dma_enable
[   50.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.110000] imxdma0: imx_dma_disable
[   50.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.130000] imxdma0: next sg chunk dst 0xa73a7200, src 0x10014038, size 0x00000200
[   50.140000] imxdma0: imx_dma_enable
[   50.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.140000] imxdma0: imx_dma_disable
[   50.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.160000] imxdma0: next sg chunk dst 0xa73a7400, src 0x10014038, size 0x00000200
[   50.170000] imxdma0: imx_dma_enable
[   50.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.180000] imxdma0: imx_dma_disable
[   50.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.190000] imxdma0: next sg chunk dst 0xa73a7600, src 0x10014038, size 0x00000200
[   50.200000] imxdma0: imx_dma_enable
[   50.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.210000] imxdma0: imx_dma_disable
[   50.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.220000] imxdma0: next sg chunk dst 0xa73a7800, src 0x10014038, size 0x00000200
[   50.230000] imxdma0: imx_dma_enable
[   50.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.240000] imxdma0: imx_dma_disable
[   50.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.250000] imxdma0: next sg chunk dst 0xa73a7a00, src 0x10014038, size 0x00000200
[   50.260000] imxdma0: imx_dma_enable
[   50.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.270000] imxdma0: imx_dma_disable
[   50.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.280000] imxdma0: next sg chunk dst 0xa73a7c00, src 0x10014038, size 0x00000200
[   50.290000] imxdma0: imx_dma_enable
[   50.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.300000] imxdma0: imx_dma_disable
[   50.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.310000] imxdma0: next sg chunk dst 0xa73a7e00, src 0x10014038, size 0x00000200
[   50.320000] imxdma0: imx_dma_enable
[   50.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.330000] imxdma0: imx_dma_disable
[   50.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.340000] imxdma0: next sg chunk dst 0xa73a9000, src 0x10014038, size 0x00000200
[   50.350000] imxdma0: imx_dma_enable
[   50.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.360000] imxdma0: imx_dma_disable
[   50.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.380000] imxdma0: next sg chunk dst 0xa73a9200, src 0x10014038, size 0x00000200
[   50.380000] imxdma0: imx_dma_enable
[   50.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.390000] imxdma0: imx_dma_disable
[   50.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.410000] imxdma0: next sg chunk dst 0xa73a9400, src 0x10014038, size 0x00000200
[   50.410000] imxdma0: imx_dma_enable
[   50.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.420000] imxdma0: imx_dma_disable
[   50.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.440000] imxdma0: next sg chunk dst 0xa73a9600, src 0x10014038, size 0x00000200
[   50.450000] imxdma0: imx_dma_enable
[   50.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.460000] imxdma0: imx_dma_disable
[   50.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.470000] imxdma0: next sg chunk dst 0xa73a9800, src 0x10014038, size 0x00000200
[   50.480000] imxdma0: imx_dma_enable
[   50.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.490000] imxdma0: imx_dma_disable
[   50.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.500000] imxdma0: next sg chunk dst 0xa73a9a00, src 0x10014038, size 0x00000200
[   50.510000] imxdma0: imx_dma_enable
[   50.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.520000] imxdma0: imx_dma_disable
[   50.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.530000] imxdma0: next sg chunk dst 0xa73a9c00, src 0x10014038, size 0x00000200
[   50.540000] imxdma0: imx_dma_enable
[   50.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.550000] imxdma0: imx_dma_disable
[   50.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.560000] imxdma0: next sg chunk dst 0xa73a9e00, src 0x10014038, size 0x00000200
[   50.570000] imxdma0: imx_dma_enable
[   50.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.580000] imxdma0: imx_dma_disable
[   50.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.590000] imxdma0: next sg chunk dst 0xa73ab000, src 0x10014038, size 0x00000200
[   50.600000] imxdma0: imx_dma_enable
[   50.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.610000] imxdma0: imx_dma_disable
[   50.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.620000] imxdma0: next sg chunk dst 0xa73ab200, src 0x10014038, size 0x00000200
[   50.630000] imxdma0: imx_dma_enable
[   50.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.640000] imxdma0: imx_dma_disable
[   50.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.650000] imxdma0: next sg chunk dst 0xa73ab400, src 0x10014038, size 0x00000200
[   50.660000] imxdma0: imx_dma_enable
[   50.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.670000] imxdma0: imx_dma_disable
[   50.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.690000] imxdma0: next sg chunk dst 0xa73ab600, src 0x10014038, size 0x00000200
[   50.690000] imxdma0: imx_dma_enable
[   50.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.700000] imxdma0: imx_dma_disable
[   50.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.720000] imxdma0: next sg chunk dst 0xa73ab800, src 0x10014038, size 0x00000200
[   50.720000] imxdma0: imx_dma_enable
[   50.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.730000] imxdma0: imx_dma_disable
[   50.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.750000] imxdma0: next sg chunk dst 0xa73aba00, src 0x10014038, size 0x00000200
[   50.760000] imxdma0: imx_dma_enable
[   50.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.760000] imxdma0: imx_dma_disable
[   50.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.780000] imxdma0: next sg chunk dst 0xa73abc00, src 0x10014038, size 0x00000200
[   50.790000] imxdma0: imx_dma_enable
[   50.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.800000] imxdma0: imx_dma_disable
[   50.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.810000] imxdma0: next sg chunk dst 0xa73abe00, src 0x10014038, size 0x00000200
[   50.820000] imxdma0: imx_dma_enable
[   50.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.830000] imxdma0: imx_dma_disable
[   50.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.840000] imxdma0: next sg chunk dst 0xa73ad000, src 0x10014038, size 0x00000200
[   50.850000] imxdma0: imx_dma_enable
[   50.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.860000] imxdma0: imx_dma_disable
[   50.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.870000] imxdma0: next sg chunk dst 0xa73ad200, src 0x10014038, size 0x00000200
[   50.880000] imxdma0: imx_dma_enable
[   50.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.890000] imxdma0: imx_dma_disable
[   50.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.900000] imxdma0: next sg chunk dst 0xa73ad400, src 0x10014038, size 0x00000200
[   50.910000] imxdma0: imx_dma_enable
[   50.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.920000] imxdma0: imx_dma_disable
[   50.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.930000] imxdma0: next sg chunk dst 0xa73ad600, src 0x10014038, size 0x00000200
[   50.940000] imxdma0: imx_dma_enable
[   50.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.950000] imxdma0: imx_dma_disable
[   50.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   50.960000] imxdma0: next sg chunk dst 0xa73ad800, src 0x10014038, size 0x00000200
[   50.970000] imxdma0: imx_dma_enable
[   50.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   50.980000] imxdma0: imx_dma_disable
[   50.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.000000] imxdma0: next sg chunk dst 0xa73ada00, src 0x10014038, size 0x00000200
[   51.000000] imxdma0: imx_dma_enable
[   51.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.010000] imxdma0: imx_dma_disable
[   51.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.030000] imxdma0: next sg chunk dst 0xa73adc00, src 0x10014038, size 0x00000200
[   51.030000] imxdma0: imx_dma_enable
[   51.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.040000] imxdma0: imx_dma_disable
[   51.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.060000] imxdma0: next sg chunk dst 0xa73ade00, src 0x10014038, size 0x00000200
[   51.070000] imxdma0: imx_dma_enable
[   51.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.070000] imxdma0: imx_dma_disable
[   51.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.090000] imxdma0: next sg chunk dst 0xa73af000, src 0x10014038, size 0x00000200
[   51.100000] imxdma0: imx_dma_enable
[   51.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.110000] imxdma0: imx_dma_disable
[   51.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.120000] imxdma0: next sg chunk dst 0xa73af200, src 0x10014038, size 0x00000200
[   51.130000] imxdma0: imx_dma_enable
[   51.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.140000] imxdma0: imx_dma_disable
[   51.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.150000] imxdma0: next sg chunk dst 0xa73af400, src 0x10014038, size 0x00000200
[   51.160000] imxdma0: imx_dma_enable
[   51.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.170000] imxdma0: imx_dma_disable
[   51.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.180000] imxdma0: next sg chunk dst 0xa73af600, src 0x10014038, size 0x00000200
[   51.190000] imxdma0: imx_dma_enable
[   51.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.200000] imxdma0: imx_dma_disable
[   51.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.210000] imxdma0: next sg chunk dst 0xa73af800, src 0x10014038, size 0x00000200
[   51.220000] imxdma0: imx_dma_enable
[   51.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.230000] imxdma0: imx_dma_disable
[   51.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.240000] imxdma0: next sg chunk dst 0xa73afa00, src 0x10014038, size 0x00000200
[   51.250000] imxdma0: imx_dma_enable
[   51.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.260000] imxdma0: imx_dma_disable
[   51.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.270000] imxdma0: next sg chunk dst 0xa73afc00, src 0x10014038, size 0x00000200
[   51.280000] imxdma0: imx_dma_enable
[   51.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.290000] imxdma0: imx_dma_disable
[   51.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.310000] imxdma0: next sg chunk dst 0xa73afe00, src 0x10014038, size 0x00000200
[   51.310000] imxdma0: imx_dma_enable
[   51.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.320000] imxdma0: imx_dma_disable
[   51.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.340000] imxdma0: next sg chunk dst 0xa73b1000, src 0x10014038, size 0x00000200
[   51.340000] imxdma0: imx_dma_enable
[   51.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.350000] imxdma0: imx_dma_disable
[   51.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.370000] imxdma0: next sg chunk dst 0xa73b1200, src 0x10014038, size 0x00000200
[   51.380000] imxdma0: imx_dma_enable
[   51.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.390000] imxdma0: imx_dma_disable
[   51.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.400000] imxdma0: next sg chunk dst 0xa73b1400, src 0x10014038, size 0x00000200
[   51.410000] imxdma0: imx_dma_enable
[   51.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.420000] imxdma0: imx_dma_disable
[   51.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.430000] imxdma0: next sg chunk dst 0xa73b1600, src 0x10014038, size 0x00000200
[   51.440000] imxdma0: imx_dma_enable
[   51.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.450000] imxdma0: imx_dma_disable
[   51.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.460000] imxdma0: next sg chunk dst 0xa73b1800, src 0x10014038, size 0x00000200
[   51.470000] imxdma0: imx_dma_enable
[   51.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.480000] imxdma0: imx_dma_disable
[   51.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.490000] imxdma0: next sg chunk dst 0xa73b1a00, src 0x10014038, size 0x00000200
[   51.500000] imxdma0: imx_dma_enable
[   51.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.510000] imxdma0: imx_dma_disable
[   51.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.520000] imxdma0: next sg chunk dst 0xa73b1c00, src 0x10014038, size 0x00000200
[   51.530000] imxdma0: imx_dma_enable
[   51.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.540000] imxdma0: imx_dma_disable
[   51.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.550000] imxdma0: next sg chunk dst 0xa73b1e00, src 0x10014038, size 0x00000200
[   51.560000] imxdma0: imx_dma_enable
[   51.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.570000] imxdma0: imx_dma_disable
[   51.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.590000] imxdma0: next sg chunk dst 0xa73b3000, src 0x10014038, size 0x00000200
[   51.590000] imxdma0: imx_dma_enable
[   51.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.600000] imxdma0: imx_dma_disable
[   51.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.620000] imxdma0: next sg chunk dst 0xa73b3200, src 0x10014038, size 0x00000200
[   51.620000] imxdma0: imx_dma_enable
[   51.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.630000] imxdma0: imx_dma_disable
[   51.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.650000] imxdma0: next sg chunk dst 0xa73b3400, src 0x10014038, size 0x00000200
[   51.650000] imxdma0: imx_dma_enable
[   51.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.660000] imxdma0: imx_dma_disable
[   51.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.680000] imxdma0: next sg chunk dst 0xa73b3600, src 0x10014038, size 0x00000200
[   51.690000] imxdma0: imx_dma_enable
[   51.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.700000] imxdma0: imx_dma_disable
[   51.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.710000] imxdma0: next sg chunk dst 0xa73b3800, src 0x10014038, size 0x00000200
[   51.720000] imxdma0: imx_dma_enable
[   51.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.730000] imxdma0: imx_dma_disable
[   51.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.740000] imxdma0: next sg chunk dst 0xa73b3a00, src 0x10014038, size 0x00000200
[   51.750000] imxdma0: imx_dma_enable
[   51.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.760000] imxdma0: imx_dma_disable
[   51.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.770000] imxdma0: next sg chunk dst 0xa73b3c00, src 0x10014038, size 0x00000200
[   51.780000] imxdma0: imx_dma_enable
[   51.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.790000] imxdma0: imx_dma_disable
[   51.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.800000] imxdma0: next sg chunk dst 0xa73b3e00, src 0x10014038, size 0x00000200
[   51.810000] imxdma0: imx_dma_enable
[   51.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.820000] imxdma0: imx_dma_disable
[   51.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.830000] imxdma0: next sg chunk dst 0xa73b5000, src 0x10014038, size 0x00000200
[   51.840000] imxdma0: imx_dma_enable
[   51.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.850000] imxdma0: imx_dma_disable
[   51.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.860000] imxdma0: next sg chunk dst 0xa73b5200, src 0x10014038, size 0x00000200
[   51.870000] imxdma0: imx_dma_enable
[   51.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.880000] imxdma0: imx_dma_disable
[   51.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.900000] imxdma0: next sg chunk dst 0xa73b5400, src 0x10014038, size 0x00000200
[   51.900000] imxdma0: imx_dma_enable
[   51.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.910000] imxdma0: imx_dma_disable
[   51.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.930000] imxdma0: next sg chunk dst 0xa73b5600, src 0x10014038, size 0x00000200
[   51.930000] imxdma0: imx_dma_enable
[   51.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.940000] imxdma0: imx_dma_disable
[   51.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.960000] imxdma0: next sg chunk dst 0xa73b5800, src 0x10014038, size 0x00000200
[   51.960000] imxdma0: imx_dma_enable
[   51.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   51.970000] imxdma0: imx_dma_disable
[   51.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   51.990000] imxdma0: next sg chunk dst 0xa73b5a00, src 0x10014038, size 0x00000200
[   52.000000] imxdma0: imx_dma_enable
[   52.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.010000] imxdma0: imx_dma_disable
[   52.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.020000] imxdma0: next sg chunk dst 0xa73b5c00, src 0x10014038, size 0x00000200
[   52.030000] imxdma0: imx_dma_enable
[   52.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.040000] imxdma0: imx_dma_disable
[   52.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.050000] imxdma0: next sg chunk dst 0xa73b5e00, src 0x10014038, size 0x00000200
[   52.060000] imxdma0: imx_dma_enable
[   52.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.070000] imxdma0: imx_dma_disable
[   52.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.080000] imxdma0: next sg chunk dst 0xa73b7000, src 0x10014038, size 0x00000200
[   52.090000] imxdma0: imx_dma_enable
[   52.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.100000] imxdma0: imx_dma_disable
[   52.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.110000] imxdma0: next sg chunk dst 0xa73b7200, src 0x10014038, size 0x00000200
[   52.120000] imxdma0: imx_dma_enable
[   52.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.130000] imxdma0: imx_dma_disable
[   52.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.140000] imxdma0: next sg chunk dst 0xa73b7400, src 0x10014038, size 0x00000200
[   52.150000] imxdma0: imx_dma_enable
[   52.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.160000] imxdma0: imx_dma_disable
[   52.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.170000] imxdma0: next sg chunk dst 0xa73b7600, src 0x10014038, size 0x00000200
[   52.180000] imxdma0: imx_dma_enable
[   52.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.190000] imxdma0: imx_dma_disable
[   52.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.210000] imxdma0: next sg chunk dst 0xa73b7800, src 0x10014038, size 0x00000200
[   52.210000] imxdma0: imx_dma_enable
[   52.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.220000] imxdma0: imx_dma_disable
[   52.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.240000] imxdma0: next sg chunk dst 0xa73b7a00, src 0x10014038, size 0x00000200
[   52.240000] imxdma0: imx_dma_enable
[   52.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.250000] imxdma0: imx_dma_disable
[   52.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.270000] imxdma0: next sg chunk dst 0xa73b7c00, src 0x10014038, size 0x00000200
[   52.280000] imxdma0: imx_dma_enable
[   52.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.280000] imxdma0: imx_dma_disable
[   52.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.300000] imxdma0: next sg chunk dst 0xa73b7e00, src 0x10014038, size 0x00000200
[   52.310000] imxdma0: imx_dma_enable
[   52.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.320000] imxdma0: imx_dma_disable
[   52.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.330000] imxdma0: next sg chunk dst 0xa73b9000, src 0x10014038, size 0x00000200
[   52.340000] imxdma0: imx_dma_enable
[   52.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.350000] imxdma0: imx_dma_disable
[   52.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.360000] imxdma0: next sg chunk dst 0xa73b9200, src 0x10014038, size 0x00000200
[   52.370000] imxdma0: imx_dma_enable
[   52.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.380000] imxdma0: imx_dma_disable
[   52.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.390000] imxdma0: next sg chunk dst 0xa73b9400, src 0x10014038, size 0x00000200
[   52.400000] imxdma0: imx_dma_enable
[   52.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.410000] imxdma0: imx_dma_disable
[   52.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.420000] imxdma0: next sg chunk dst 0xa73b9600, src 0x10014038, size 0x00000200
[   52.430000] imxdma0: imx_dma_enable
[   52.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.440000] imxdma0: imx_dma_disable
[   52.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.450000] imxdma0: next sg chunk dst 0xa73b9800, src 0x10014038, size 0x00000200
[   52.460000] imxdma0: imx_dma_enable
[   52.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.470000] imxdma0: imx_dma_disable
[   52.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.480000] imxdma0: next sg chunk dst 0xa73b9a00, src 0x10014038, size 0x00000200
[   52.490000] imxdma0: imx_dma_enable
[   52.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.500000] imxdma0: imx_dma_disable
[   52.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.520000] imxdma0: next sg chunk dst 0xa73b9c00, src 0x10014038, size 0x00000200
[   52.520000] imxdma0: imx_dma_enable
[   52.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.530000] imxdma0: imx_dma_disable
[   52.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.550000] imxdma0: next sg chunk dst 0xa73b9e00, src 0x10014038, size 0x00000200
[   52.550000] imxdma0: imx_dma_enable
[   52.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.560000] imxdma0: imx_dma_disable
[   52.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.580000] imxdma0: next sg chunk dst 0xa73bb000, src 0x10014038, size 0x00000200
[   52.590000] imxdma0: imx_dma_enable
[   52.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.590000] imxdma0: imx_dma_disable
[   52.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.610000] imxdma0: next sg chunk dst 0xa73bb200, src 0x10014038, size 0x00000200
[   52.620000] imxdma0: imx_dma_enable
[   52.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.630000] imxdma0: imx_dma_disable
[   52.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.640000] imxdma0: next sg chunk dst 0xa73bb400, src 0x10014038, size 0x00000200
[   52.650000] imxdma0: imx_dma_enable
[   52.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.660000] imxdma0: imx_dma_disable
[   52.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.670000] imxdma0: next sg chunk dst 0xa73bb600, src 0x10014038, size 0x00000200
[   52.680000] imxdma0: imx_dma_enable
[   52.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.690000] imxdma0: imx_dma_disable
[   52.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.700000] imxdma0: next sg chunk dst 0xa73bb800, src 0x10014038, size 0x00000200
[   52.710000] imxdma0: imx_dma_enable
[   52.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.720000] imxdma0: imx_dma_disable
[   52.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.730000] imxdma0: next sg chunk dst 0xa73bba00, src 0x10014038, size 0x00000200
[   52.740000] imxdma0: imx_dma_enable
[   52.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.750000] imxdma0: imx_dma_disable
[   52.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.760000] imxdma0: next sg chunk dst 0xa73bbc00, src 0x10014038, size 0x00000200
[   52.770000] imxdma0: imx_dma_enable
[   52.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.780000] imxdma0: imx_dma_disable
[   52.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.790000] imxdma0: next sg chunk dst 0xa73bbe00, src 0x10014038, size 0x00000200
[   52.800000] imxdma0: imx_dma_enable
[   52.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.810000] imxdma0: imx_dma_disable
[   52.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.830000] imxdma0: next sg chunk dst 0xa73bd000, src 0x10014038, size 0x00000200
[   52.830000] imxdma0: imx_dma_enable
[   52.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.840000] imxdma0: imx_dma_disable
[   52.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.860000] imxdma0: next sg chunk dst 0xa73bd200, src 0x10014038, size 0x00000200
[   52.860000] imxdma0: imx_dma_enable
[   52.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.870000] imxdma0: imx_dma_disable
[   52.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.890000] imxdma0: next sg chunk dst 0xa73bd400, src 0x10014038, size 0x00000200
[   52.900000] imxdma0: imx_dma_enable
[   52.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.900000] imxdma0: imx_dma_disable
[   52.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.920000] imxdma0: next sg chunk dst 0xa73bd600, src 0x10014038, size 0x00000200
[   52.930000] imxdma0: imx_dma_enable
[   52.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.940000] imxdma0: imx_dma_disable
[   52.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.950000] imxdma0: next sg chunk dst 0xa73bd800, src 0x10014038, size 0x00000200
[   52.960000] imxdma0: imx_dma_enable
[   52.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   52.970000] imxdma0: imx_dma_disable
[   52.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   52.980000] imxdma0: next sg chunk dst 0xa73bda00, src 0x10014038, size 0x00000200
[   52.990000] imxdma0: imx_dma_enable
[   52.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.000000] imxdma0: imx_dma_disable
[   53.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.010000] imxdma0: next sg chunk dst 0xa73bdc00, src 0x10014038, size 0x00000200
[   53.020000] imxdma0: imx_dma_enable
[   53.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.030000] imxdma0: imx_dma_disable
[   53.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.040000] imxdma0: next sg chunk dst 0xa73bde00, src 0x10014038, size 0x00000200
[   53.050000] imxdma0: imx_dma_enable
[   53.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.060000] imxdma0: imx_dma_disable
[   53.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.070000] imxdma0: next sg chunk dst 0xa73bf000, src 0x10014038, size 0x00000200
[   53.080000] imxdma0: imx_dma_enable
[   53.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.090000] imxdma0: imx_dma_disable
[   53.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.100000] imxdma0: next sg chunk dst 0xa73bf200, src 0x10014038, size 0x00000200
[   53.110000] imxdma0: imx_dma_enable
[   53.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.120000] imxdma0: imx_dma_disable
[   53.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.140000] imxdma0: next sg chunk dst 0xa73bf400, src 0x10014038, size 0x00000200
[   53.140000] imxdma0: imx_dma_enable
[   53.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.150000] imxdma0: imx_dma_disable
[   53.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.170000] imxdma0: next sg chunk dst 0xa73bf600, src 0x10014038, size 0x00000200
[   53.170000] imxdma0: imx_dma_enable
[   53.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.180000] imxdma0: imx_dma_disable
[   53.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.200000] imxdma0: next sg chunk dst 0xa73bf800, src 0x10014038, size 0x00000200
[   53.200000] imxdma0: imx_dma_enable
[   53.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.210000] imxdma0: imx_dma_disable
[   53.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.230000] imxdma0: next sg chunk dst 0xa73bfa00, src 0x10014038, size 0x00000200
[   53.240000] imxdma0: imx_dma_enable
[   53.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.250000] imxdma0: imx_dma_disable
[   53.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.260000] imxdma0: next sg chunk dst 0xa73bfc00, src 0x10014038, size 0x00000200
[   53.270000] imxdma0: imx_dma_enable
[   53.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.280000] imxdma0: imx_dma_disable
[   53.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.290000] imxdma0: next sg chunk dst 0xa73bfe00, src 0x10014038, size 0x00000200
[   53.300000] imxdma0: imx_dma_enable
[   53.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.310000] imxdma0: imx_dma_disable
[   53.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.320000] imxdma0: next sg chunk dst 0xa73c1000, src 0x10014038, size 0x00000200
[   53.330000] imxdma0: imx_dma_enable
[   53.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.340000] imxdma0: imx_dma_disable
[   53.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.350000] imxdma0: next sg chunk dst 0xa73c1200, src 0x10014038, size 0x00000200
[   53.360000] imxdma0: imx_dma_enable
[   53.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.370000] imxdma0: imx_dma_disable
[   53.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.380000] imxdma0: next sg chunk dst 0xa73c1400, src 0x10014038, size 0x00000200
[   53.390000] imxdma0: imx_dma_enable
[   53.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.400000] imxdma0: imx_dma_disable
[   53.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.410000] imxdma0: next sg chunk dst 0xa73c1600, src 0x10014038, size 0x00000200
[   53.420000] imxdma0: imx_dma_enable
[   53.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.430000] imxdma0: imx_dma_disable
[   53.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.450000] imxdma0: next sg chunk dst 0xa73c1800, src 0x10014038, size 0x00000200
[   53.450000] imxdma0: imx_dma_enable
[   53.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.460000] imxdma0: imx_dma_disable
[   53.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.480000] imxdma0: next sg chunk dst 0xa73c1a00, src 0x10014038, size 0x00000200
[   53.480000] imxdma0: imx_dma_enable
[   53.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.490000] imxdma0: imx_dma_disable
[   53.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.510000] imxdma0: next sg chunk dst 0xa73c1c00, src 0x10014038, size 0x00000200
[   53.520000] imxdma0: imx_dma_enable
[   53.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.520000] imxdma0: imx_dma_disable
[   53.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.540000] imxdma0: next sg chunk dst 0xa73c1e00, src 0x10014038, size 0x00000200
[   53.550000] imxdma0: imx_dma_enable
[   53.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.560000] imxdma0: imx_dma_disable
[   53.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.570000] imxdma0: next sg chunk dst 0xa73c3000, src 0x10014038, size 0x00000200
[   53.580000] imxdma0: imx_dma_enable
[   53.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.590000] imxdma0: imx_dma_disable
[   53.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.600000] imxdma0: next sg chunk dst 0xa73c3200, src 0x10014038, size 0x00000200
[   53.610000] imxdma0: imx_dma_enable
[   53.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.620000] imxdma0: imx_dma_disable
[   53.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.630000] imxdma0: next sg chunk dst 0xa73c3400, src 0x10014038, size 0x00000200
[   53.640000] imxdma0: imx_dma_enable
[   53.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.650000] imxdma0: imx_dma_disable
[   53.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.660000] imxdma0: next sg chunk dst 0xa73c3600, src 0x10014038, size 0x00000200
[   53.670000] imxdma0: imx_dma_enable
[   53.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.680000] imxdma0: imx_dma_disable
[   53.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.690000] imxdma0: next sg chunk dst 0xa73c3800, src 0x10014038, size 0x00000200
[   53.700000] imxdma0: imx_dma_enable
[   53.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.710000] imxdma0: imx_dma_disable
[   53.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.720000] imxdma0: next sg chunk dst 0xa73c3a00, src 0x10014038, size 0x00000200
[   53.730000] imxdma0: imx_dma_enable
[   53.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.740000] imxdma0: imx_dma_disable
[   53.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.760000] imxdma0: next sg chunk dst 0xa73c3c00, src 0x10014038, size 0x00000200
[   53.760000] imxdma0: imx_dma_enable
[   53.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.770000] imxdma0: imx_dma_disable
[   53.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.790000] imxdma0: next sg chunk dst 0xa73c3e00, src 0x10014038, size 0x00000200
[   53.790000] imxdma0: imx_dma_enable
[   53.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.800000] imxdma0: imx_dma_disable
[   53.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.820000] imxdma0: next sg chunk dst 0xa73c5000, src 0x10014038, size 0x00000200
[   53.820000] imxdma0: imx_dma_enable
[   53.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.830000] imxdma0: imx_dma_disable
[   53.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.850000] imxdma0: next sg chunk dst 0xa73c5200, src 0x10014038, size 0x00000200
[   53.860000] imxdma0: imx_dma_enable
[   53.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.870000] imxdma0: imx_dma_disable
[   53.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.880000] imxdma0: next sg chunk dst 0xa73c5400, src 0x10014038, size 0x00000200
[   53.890000] imxdma0: imx_dma_enable
[   53.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.900000] imxdma0: imx_dma_disable
[   53.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.910000] imxdma0: next sg chunk dst 0xa73c5600, src 0x10014038, size 0x00000200
[   53.920000] imxdma0: imx_dma_enable
[   53.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.930000] imxdma0: imx_dma_disable
[   53.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.940000] imxdma0: next sg chunk dst 0xa73c5800, src 0x10014038, size 0x00000200
[   53.950000] imxdma0: imx_dma_enable
[   53.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.960000] imxdma0: imx_dma_disable
[   53.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   53.970000] imxdma0: next sg chunk dst 0xa73c5a00, src 0x10014038, size 0x00000200
[   53.980000] imxdma0: imx_dma_enable
[   53.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   53.990000] imxdma0: imx_dma_disable
[   53.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.000000] imxdma0: next sg chunk dst 0xa73c5c00, src 0x10014038, size 0x00000200
[   54.010000] imxdma0: imx_dma_enable
[   54.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.020000] imxdma0: imx_dma_disable
[   54.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.030000] imxdma0: next sg chunk dst 0xa73c5e00, src 0x10014038, size 0x00000200
[   54.040000] imxdma0: imx_dma_enable
[   54.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.050000] imxdma0: imx_dma_disable
[   54.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.070000] imxdma0: next sg chunk dst 0xa73c7000, src 0x10014038, size 0x00000200
[   54.070000] imxdma0: imx_dma_enable
[   54.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.080000] imxdma0: imx_dma_disable
[   54.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.100000] imxdma0: next sg chunk dst 0xa73c7200, src 0x10014038, size 0x00000200
[   54.100000] imxdma0: imx_dma_enable
[   54.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.110000] imxdma0: imx_dma_disable
[   54.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.130000] imxdma0: next sg chunk dst 0xa73c7400, src 0x10014038, size 0x00000200
[   54.140000] imxdma0: imx_dma_enable
[   54.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.150000] imxdma0: imx_dma_disable
[   54.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.160000] imxdma0: next sg chunk dst 0xa73c7600, src 0x10014038, size 0x00000200
[   54.170000] imxdma0: imx_dma_enable
[   54.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.180000] imxdma0: imx_dma_disable
[   54.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.190000] imxdma0: next sg chunk dst 0xa73c7800, src 0x10014038, size 0x00000200
[   54.200000] imxdma0: imx_dma_enable
[   54.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.210000] imxdma0: imx_dma_disable
[   54.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.220000] imxdma0: next sg chunk dst 0xa73c7a00, src 0x10014038, size 0x00000200
[   54.230000] imxdma0: imx_dma_enable
[   54.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.240000] imxdma0: imx_dma_disable
[   54.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.250000] imxdma0: next sg chunk dst 0xa73c7c00, src 0x10014038, size 0x00000200
[   54.260000] imxdma0: imx_dma_enable
[   54.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.270000] imxdma0: imx_dma_disable
[   54.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.280000] imxdma0: next sg chunk dst 0xa73c7e00, src 0x10014038, size 0x00000200
[   54.290000] imxdma0: imx_dma_enable
[   54.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.300000] imxdma0: imx_dma_disable
[   54.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.310000] imxdma0: next sg chunk dst 0xa73c9000, src 0x10014038, size 0x00000200
[   54.320000] imxdma0: imx_dma_enable
[   54.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.330000] imxdma0: imx_dma_disable
[   54.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.350000] imxdma0: next sg chunk dst 0xa73c9200, src 0x10014038, size 0x00000200
[   54.350000] imxdma0: imx_dma_enable
[   54.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.360000] imxdma0: imx_dma_disable
[   54.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.380000] imxdma0: next sg chunk dst 0xa73c9400, src 0x10014038, size 0x00000200
[   54.380000] imxdma0: imx_dma_enable
[   54.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.390000] imxdma0: imx_dma_disable
[   54.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.410000] imxdma0: next sg chunk dst 0xa73c9600, src 0x10014038, size 0x00000200
[   54.410000] imxdma0: imx_dma_enable
[   54.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.420000] imxdma0: imx_dma_disable
[   54.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.440000] imxdma0: next sg chunk dst 0xa73c9800, src 0x10014038, size 0x00000200
[   54.450000] imxdma0: imx_dma_enable
[   54.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.460000] imxdma0: imx_dma_disable
[   54.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.470000] imxdma0: next sg chunk dst 0xa73c9a00, src 0x10014038, size 0x00000200
[   54.480000] imxdma0: imx_dma_enable
[   54.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.490000] imxdma0: imx_dma_disable
[   54.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.500000] imxdma0: next sg chunk dst 0xa73c9c00, src 0x10014038, size 0x00000200
[   54.510000] imxdma0: imx_dma_enable
[   54.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.520000] imxdma0: imx_dma_disable
[   54.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.530000] imxdma0: next sg chunk dst 0xa73c9e00, src 0x10014038, size 0x00000200
[   54.540000] imxdma0: imx_dma_enable
[   54.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.550000] imxdma0: imx_dma_disable
[   54.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.560000] imxdma0: next sg chunk dst 0xa73cb000, src 0x10014038, size 0x00000200
[   54.570000] imxdma0: imx_dma_enable
[   54.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.580000] imxdma0: imx_dma_disable
[   54.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.590000] imxdma0: next sg chunk dst 0xa73cb200, src 0x10014038, size 0x00000200
[   54.600000] imxdma0: imx_dma_enable
[   54.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.610000] imxdma0: imx_dma_disable
[   54.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.620000] imxdma0: next sg chunk dst 0xa73cb400, src 0x10014038, size 0x00000200
[   54.630000] imxdma0: imx_dma_enable
[   54.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.640000] imxdma0: imx_dma_disable
[   54.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.660000] imxdma0: next sg chunk dst 0xa73cb600, src 0x10014038, size 0x00000200
[   54.660000] imxdma0: imx_dma_enable
[   54.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.670000] imxdma0: imx_dma_disable
[   54.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.690000] imxdma0: next sg chunk dst 0xa73cb800, src 0x10014038, size 0x00000200
[   54.690000] imxdma0: imx_dma_enable
[   54.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.700000] imxdma0: imx_dma_disable
[   54.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.720000] imxdma0: next sg chunk dst 0xa73cba00, src 0x10014038, size 0x00000200
[   54.720000] imxdma0: imx_dma_enable
[   54.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.730000] imxdma0: imx_dma_disable
[   54.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.750000] imxdma0: next sg chunk dst 0xa73cbc00, src 0x10014038, size 0x00000200
[   54.760000] imxdma0: imx_dma_enable
[   54.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.770000] imxdma0: imx_dma_disable
[   54.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.780000] imxdma0: next sg chunk dst 0xa73cbe00, src 0x10014038, size 0x00000200
[   54.790000] imxdma0: imx_dma_enable
[   54.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.800000] imxdma0: imx_dma_disable
[   54.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.810000] imxdma0: next sg chunk dst 0xa73cd000, src 0x10014038, size 0x00000200
[   54.820000] imxdma0: imx_dma_enable
[   54.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.830000] imxdma0: imx_dma_disable
[   54.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.840000] imxdma0: next sg chunk dst 0xa73cd200, src 0x10014038, size 0x00000200
[   54.850000] imxdma0: imx_dma_enable
[   54.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.860000] imxdma0: imx_dma_disable
[   54.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.870000] imxdma0: next sg chunk dst 0xa73cd400, src 0x10014038, size 0x00000200
[   54.880000] imxdma0: imx_dma_enable
[   54.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.890000] imxdma0: imx_dma_disable
[   54.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.900000] imxdma0: next sg chunk dst 0xa73cd600, src 0x10014038, size 0x00000200
[   54.910000] imxdma0: imx_dma_enable
[   54.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.920000] imxdma0: imx_dma_disable
[   54.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.930000] imxdma0: next sg chunk dst 0xa73cd800, src 0x10014038, size 0x00000200
[   54.940000] imxdma0: imx_dma_enable
[   54.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.950000] imxdma0: imx_dma_disable
[   54.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   54.970000] imxdma0: next sg chunk dst 0xa73cda00, src 0x10014038, size 0x00000200
[   54.970000] imxdma0: imx_dma_enable
[   54.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   54.980000] imxdma0: imx_dma_disable
[   54.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.000000] imxdma0: next sg chunk dst 0xa73cdc00, src 0x10014038, size 0x00000200
[   55.000000] imxdma0: imx_dma_enable
[   55.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.010000] imxdma0: imx_dma_disable
[   55.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.030000] imxdma0: next sg chunk dst 0xa73cde00, src 0x10014038, size 0x00000200
[   55.030000] imxdma0: imx_dma_enable
[   55.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.040000] imxdma0: imx_dma_disable
[   55.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.060000] imxdma0: next sg chunk dst 0xa73cf000, src 0x10014038, size 0x00000200
[   55.070000] imxdma0: imx_dma_enable
[   55.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.080000] imxdma0: imx_dma_disable
[   55.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.090000] imxdma0: next sg chunk dst 0xa73cf200, src 0x10014038, size 0x00000200
[   55.100000] imxdma0: imx_dma_enable
[   55.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.110000] imxdma0: imx_dma_disable
[   55.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.120000] imxdma0: next sg chunk dst 0xa73cf400, src 0x10014038, size 0x00000200
[   55.130000] imxdma0: imx_dma_enable
[   55.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.140000] imxdma0: imx_dma_disable
[   55.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.150000] imxdma0: next sg chunk dst 0xa73cf600, src 0x10014038, size 0x00000200
[   55.160000] imxdma0: imx_dma_enable
[   55.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.170000] imxdma0: imx_dma_disable
[   55.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.180000] imxdma0: next sg chunk dst 0xa73cf800, src 0x10014038, size 0x00000200
[   55.190000] imxdma0: imx_dma_enable
[   55.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.200000] imxdma0: imx_dma_disable
[   55.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   55.210000] imxdma0: next sg chunk dst 0xa73cfa00, src 0x10014038, size 0x00000200
[   55.220000] imxdma0: imx_dma_enable
[   55.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.230000] imxdma0: imx_dma_disable
[   55.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for write
[   55.250000] imxdma0: next sg chunk dst 0x10014038, src 0xa7358200, size 0x00000200
[   55.260000] imxdma0: imx_dma_enable
[   55.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.270000] imxdma0: imx_dma_disable
[   55.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   55.280000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a1c00, size 0x00001000
[   55.290000] imxdma0: imx_dma_enable
[   55.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.290000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a2c00, size 0x00000400
[   55.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.300000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a5000, size 0x00001000
[   55.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.320000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a7000, size 0x00001000
[   55.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.330000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a9000, size 0x00001000
[   55.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.340000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ab000, size 0x00001000
[   55.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.360000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ad000, size 0x00001000
[   55.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.380000] imxdma0: next sg chunk dst 0x10014038, src 0xa73af000, size 0x00001000
[   55.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.390000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b1000, size 0x00000c00
[   55.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.410000] imxdma0: imx_dma_disable
[   55.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   55.420000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b1c00, size 0x00000400
[   55.430000] imxdma0: imx_dma_enable
[   55.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.440000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b3000, size 0x00001000
[   55.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.450000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b5000, size 0x00001000
[   55.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.460000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b7000, size 0x00001000
[   55.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.480000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b9000, size 0x00001000
[   55.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.490000] imxdma0: next sg chunk dst 0x10014038, src 0xa73bb000, size 0x00001000
[   55.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.500000] imxdma0: next sg chunk dst 0x10014038, src 0xa73bd000, size 0x00001000
[   55.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.520000] imxdma0: next sg chunk dst 0x10014038, src 0xa73bf000, size 0x00001000
[   55.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.530000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c1000, size 0x00000c00
[   55.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.550000] imxdma0: imx_dma_disable
[   55.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=28160 dev_addr=0x10014038 for write
[   55.570000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c1c00, size 0x00000400
[   55.570000] imxdma0: imx_dma_enable
[   55.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.580000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c3000, size 0x00001000
[   55.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.590000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c5000, size 0x00001000
[   55.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.600000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c7000, size 0x00001000
[   55.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.620000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c9000, size 0x00001000
[   55.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.630000] imxdma0: next sg chunk dst 0x10014038, src 0xa73cb000, size 0x00001000
[   55.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.640000] imxdma0: next sg chunk dst 0x10014038, src 0xa73cd000, size 0x00001000
[   55.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.660000] imxdma0: next sg chunk dst 0x10014038, src 0xa73cf000, size 0x00000a00
[   55.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.680000] imxdma0: imx_dma_disable
[   55.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   55.690000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a3c00, size 0x00001000
[   55.700000] imxdma0: imx_dma_enable
[   55.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.700000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a4c00, size 0x00000400
[   55.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.720000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a6000, size 0x00001000
[   55.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.730000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a8000, size 0x00001000
[   55.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.740000] imxdma0: next sg chunk dst 0x10014038, src 0xa73aa000, size 0x00001000
[   55.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.760000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ac000, size 0x00001000
[   55.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.770000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ae000, size 0x00001000
[   55.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.790000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b0000, size 0x00001000
[   55.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.800000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b2000, size 0x00000c00
[   55.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.820000] imxdma0: imx_dma_disable
[   55.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   55.840000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b2c00, size 0x00000400
[   55.840000] imxdma0: imx_dma_enable
[   55.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.850000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b4000, size 0x00001000
[   55.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.860000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b6000, size 0x00001000
[   55.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.870000] imxdma0: next sg chunk dst 0x10014038, src 0xa73b8000, size 0x00001000
[   55.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.890000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ba000, size 0x00001000
[   55.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.900000] imxdma0: next sg chunk dst 0x10014038, src 0xa73bc000, size 0x00001000
[   55.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.910000] imxdma0: next sg chunk dst 0x10014038, src 0xa73be000, size 0x00001000
[   55.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.930000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c0000, size 0x00001000
[   55.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.940000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c2000, size 0x00000c00
[   55.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.960000] imxdma0: imx_dma_disable
[   55.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=28160 dev_addr=0x10014038 for write
[   55.980000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c2c00, size 0x00000400
[   55.980000] imxdma0: imx_dma_enable
[   55.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   55.990000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c4000, size 0x00001000
[   56.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.000000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c6000, size 0x00001000
[   56.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.010000] imxdma0: next sg chunk dst 0x10014038, src 0xa73c8000, size 0x00001000
[   56.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.030000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ca000, size 0x00001000
[   56.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.040000] imxdma0: next sg chunk dst 0x10014038, src 0xa73cc000, size 0x00001000
[   56.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.060000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ce000, size 0x00001000
[   56.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.070000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d0000, size 0x00000a00
[   56.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.090000] imxdma0: imx_dma_disable
[   56.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.100000] imxdma0: next sg chunk dst 0xa73cfc00, src 0x10014038, size 0x00000200
[   56.110000] imxdma0: imx_dma_enable
[   56.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.120000] imxdma0: imx_dma_disable
[   56.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.130000] imxdma0: next sg chunk dst 0xa73cfe00, src 0x10014038, size 0x00000200
[   56.140000] imxdma0: imx_dma_enable
[   56.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.150000] imxdma0: imx_dma_disable
[   56.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.160000] imxdma0: next sg chunk dst 0xa73d1000, src 0x10014038, size 0x00000200
[   56.170000] imxdma0: imx_dma_enable
[   56.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.180000] imxdma0: imx_dma_disable
[   56.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.200000] imxdma0: next sg chunk dst 0xa73d1200, src 0x10014038, size 0x00000200
[   56.200000] imxdma0: imx_dma_enable
[   56.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.210000] imxdma0: imx_dma_disable
[   56.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.230000] imxdma0: next sg chunk dst 0xa73d1400, src 0x10014038, size 0x00000200
[   56.230000] imxdma0: imx_dma_enable
[   56.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.240000] imxdma0: imx_dma_disable
[   56.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.260000] imxdma0: next sg chunk dst 0xa73d1600, src 0x10014038, size 0x00000200
[   56.270000] imxdma0: imx_dma_enable
[   56.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.280000] imxdma0: imx_dma_disable
[   56.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.290000] imxdma0: next sg chunk dst 0xa73d1800, src 0x10014038, size 0x00000200
[   56.300000] imxdma0: imx_dma_enable
[   56.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.310000] imxdma0: imx_dma_disable
[   56.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.320000] imxdma0: next sg chunk dst 0xa73d1a00, src 0x10014038, size 0x00000200
[   56.330000] imxdma0: imx_dma_enable
[   56.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.340000] imxdma0: imx_dma_disable
[   56.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.350000] imxdma0: next sg chunk dst 0xa73d1c00, src 0x10014038, size 0x00000200
[   56.360000] imxdma0: imx_dma_enable
[   56.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.370000] imxdma0: imx_dma_disable
[   56.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.380000] imxdma0: next sg chunk dst 0xa73d1e00, src 0x10014038, size 0x00000200
[   56.390000] imxdma0: imx_dma_enable
[   56.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.400000] imxdma0: imx_dma_disable
[   56.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.410000] imxdma0: next sg chunk dst 0xa73d3000, src 0x10014038, size 0x00000200
[   56.420000] imxdma0: imx_dma_enable
[   56.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.430000] imxdma0: imx_dma_disable
[   56.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.440000] imxdma0: next sg chunk dst 0xa73d3200, src 0x10014038, size 0x00000200
[   56.450000] imxdma0: imx_dma_enable
[   56.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.460000] imxdma0: imx_dma_disable
[   56.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.480000] imxdma0: next sg chunk dst 0xa73d3400, src 0x10014038, size 0x00000200
[   56.480000] imxdma0: imx_dma_enable
[   56.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.490000] imxdma0: imx_dma_disable
[   56.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.510000] imxdma0: next sg chunk dst 0xa73d3600, src 0x10014038, size 0x00000200
[   56.510000] imxdma0: imx_dma_enable
[   56.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.520000] imxdma0: imx_dma_disable
[   56.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.540000] imxdma0: next sg chunk dst 0xa73d3800, src 0x10014038, size 0x00000200
[   56.540000] imxdma0: imx_dma_enable
[   56.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.550000] imxdma0: imx_dma_disable
[   56.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.570000] imxdma0: next sg chunk dst 0xa73d3a00, src 0x10014038, size 0x00000200
[   56.580000] imxdma0: imx_dma_enable
[   56.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.590000] imxdma0: imx_dma_disable
[   56.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.600000] imxdma0: next sg chunk dst 0xa73d3c00, src 0x10014038, size 0x00000200
[   56.610000] imxdma0: imx_dma_enable
[   56.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.620000] imxdma0: imx_dma_disable
[   56.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.630000] imxdma0: next sg chunk dst 0xa73d3e00, src 0x10014038, size 0x00000200
[   56.640000] imxdma0: imx_dma_enable
[   56.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.650000] imxdma0: imx_dma_disable
[   56.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.660000] imxdma0: next sg chunk dst 0xa73d5000, src 0x10014038, size 0x00000200
[   56.670000] imxdma0: imx_dma_enable
[   56.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.680000] imxdma0: imx_dma_disable
[   56.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.690000] imxdma0: next sg chunk dst 0xa73d5200, src 0x10014038, size 0x00000200
[   56.700000] imxdma0: imx_dma_enable
[   56.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.710000] imxdma0: imx_dma_disable
[   56.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.720000] imxdma0: next sg chunk dst 0xa73d5400, src 0x10014038, size 0x00000200
[   56.730000] imxdma0: imx_dma_enable
[   56.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.740000] imxdma0: imx_dma_disable
[   56.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.750000] imxdma0: next sg chunk dst 0xa73d5600, src 0x10014038, size 0x00000200
[   56.760000] imxdma0: imx_dma_enable
[   56.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.770000] imxdma0: imx_dma_disable
[   56.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.790000] imxdma0: next sg chunk dst 0xa73d5800, src 0x10014038, size 0x00000200
[   56.790000] imxdma0: imx_dma_enable
[   56.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.800000] imxdma0: imx_dma_disable
[   56.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.820000] imxdma0: next sg chunk dst 0xa73d5a00, src 0x10014038, size 0x00000200
[   56.820000] imxdma0: imx_dma_enable
[   56.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.830000] imxdma0: imx_dma_disable
[   56.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.850000] imxdma0: next sg chunk dst 0xa73d5c00, src 0x10014038, size 0x00000200
[   56.850000] imxdma0: imx_dma_enable
[   56.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.860000] imxdma0: imx_dma_disable
[   56.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.880000] imxdma0: next sg chunk dst 0xa73d5e00, src 0x10014038, size 0x00000200
[   56.890000] imxdma0: imx_dma_enable
[   56.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.900000] imxdma0: imx_dma_disable
[   56.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.910000] imxdma0: next sg chunk dst 0xa73d7000, src 0x10014038, size 0x00000200
[   56.920000] imxdma0: imx_dma_enable
[   56.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.930000] imxdma0: imx_dma_disable
[   56.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.940000] imxdma0: next sg chunk dst 0xa73d7200, src 0x10014038, size 0x00000200
[   56.950000] imxdma0: imx_dma_enable
[   56.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.960000] imxdma0: imx_dma_disable
[   56.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   56.970000] imxdma0: next sg chunk dst 0xa73d7400, src 0x10014038, size 0x00000200
[   56.980000] imxdma0: imx_dma_enable
[   56.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   56.990000] imxdma0: imx_dma_disable
[   56.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.000000] imxdma0: next sg chunk dst 0xa73d7600, src 0x10014038, size 0x00000200
[   57.010000] imxdma0: imx_dma_enable
[   57.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.020000] imxdma0: imx_dma_disable
[   57.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.030000] imxdma0: next sg chunk dst 0xa73d7800, src 0x10014038, size 0x00000200
[   57.040000] imxdma0: imx_dma_enable
[   57.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.050000] imxdma0: imx_dma_disable
[   57.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.060000] imxdma0: next sg chunk dst 0xa73d7a00, src 0x10014038, size 0x00000200
[   57.070000] imxdma0: imx_dma_enable
[   57.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.080000] imxdma0: imx_dma_disable
[   57.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.090000] imxdma0: next sg chunk dst 0xa73d7c00, src 0x10014038, size 0x00000200
[   57.100000] imxdma0: imx_dma_enable
[   57.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.110000] imxdma0: imx_dma_disable
[   57.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.130000] imxdma0: next sg chunk dst 0xa73d7e00, src 0x10014038, size 0x00000200
[   57.130000] imxdma0: imx_dma_enable
[   57.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.140000] imxdma0: imx_dma_disable
[   57.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.160000] imxdma0: next sg chunk dst 0xa73d9000, src 0x10014038, size 0x00000200
[   57.160000] imxdma0: imx_dma_enable
[   57.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.170000] imxdma0: imx_dma_disable
[   57.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.190000] imxdma0: next sg chunk dst 0xa73d9200, src 0x10014038, size 0x00000200
[   57.200000] imxdma0: imx_dma_enable
[   57.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.210000] imxdma0: imx_dma_disable
[   57.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.220000] imxdma0: next sg chunk dst 0xa73d9400, src 0x10014038, size 0x00000200
[   57.230000] imxdma0: imx_dma_enable
[   57.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.240000] imxdma0: imx_dma_disable
[   57.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.250000] imxdma0: next sg chunk dst 0xa73d9600, src 0x10014038, size 0x00000200
[   57.260000] imxdma0: imx_dma_enable
[   57.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.270000] imxdma0: imx_dma_disable
[   57.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.280000] imxdma0: next sg chunk dst 0xa73d9800, src 0x10014038, size 0x00000200
[   57.290000] imxdma0: imx_dma_enable
[   57.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.300000] imxdma0: imx_dma_disable
[   57.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.310000] imxdma0: next sg chunk dst 0xa73d9a00, src 0x10014038, size 0x00000200
[   57.320000] imxdma0: imx_dma_enable
[   57.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.330000] imxdma0: imx_dma_disable
[   57.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.340000] imxdma0: next sg chunk dst 0xa73d9c00, src 0x10014038, size 0x00000200
[   57.350000] imxdma0: imx_dma_enable
[   57.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.360000] imxdma0: imx_dma_disable
[   57.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.370000] imxdma0: next sg chunk dst 0xa73d9e00, src 0x10014038, size 0x00000200
[   57.380000] imxdma0: imx_dma_enable
[   57.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.390000] imxdma0: imx_dma_disable
[   57.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.410000] imxdma0: next sg chunk dst 0xa73db000, src 0x10014038, size 0x00000200
[   57.410000] imxdma0: imx_dma_enable
[   57.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.420000] imxdma0: imx_dma_disable
[   57.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.440000] imxdma0: next sg chunk dst 0xa73db200, src 0x10014038, size 0x00000200
[   57.440000] imxdma0: imx_dma_enable
[   57.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.450000] imxdma0: imx_dma_disable
[   57.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.470000] imxdma0: next sg chunk dst 0xa73db400, src 0x10014038, size 0x00000200
[   57.470000] imxdma0: imx_dma_enable
[   57.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.480000] imxdma0: imx_dma_disable
[   57.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.500000] imxdma0: next sg chunk dst 0xa73db600, src 0x10014038, size 0x00000200
[   57.510000] imxdma0: imx_dma_enable
[   57.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.520000] imxdma0: imx_dma_disable
[   57.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.530000] imxdma0: next sg chunk dst 0xa73db800, src 0x10014038, size 0x00000200
[   57.540000] imxdma0: imx_dma_enable
[   57.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.550000] imxdma0: imx_dma_disable
[   57.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.560000] imxdma0: next sg chunk dst 0xa73dba00, src 0x10014038, size 0x00000200
[   57.570000] imxdma0: imx_dma_enable
[   57.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.580000] imxdma0: imx_dma_disable
[   57.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.590000] imxdma0: next sg chunk dst 0xa73dbc00, src 0x10014038, size 0x00000200
[   57.600000] imxdma0: imx_dma_enable
[   57.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.610000] imxdma0: imx_dma_disable
[   57.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.620000] imxdma0: next sg chunk dst 0xa73dbe00, src 0x10014038, size 0x00000200
[   57.630000] imxdma0: imx_dma_enable
[   57.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.640000] imxdma0: imx_dma_disable
[   57.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.650000] imxdma0: next sg chunk dst 0xa73dd000, src 0x10014038, size 0x00000200
[   57.660000] imxdma0: imx_dma_enable
[   57.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.670000] imxdma0: imx_dma_disable
[   57.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.680000] imxdma0: next sg chunk dst 0xa73dd200, src 0x10014038, size 0x00000200
[   57.690000] imxdma0: imx_dma_enable
[   57.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.700000] imxdma0: imx_dma_disable
[   57.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.720000] imxdma0: next sg chunk dst 0xa73dd400, src 0x10014038, size 0x00000200
[   57.720000] imxdma0: imx_dma_enable
[   57.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.730000] imxdma0: imx_dma_disable
[   57.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.750000] imxdma0: next sg chunk dst 0xa73dd600, src 0x10014038, size 0x00000200
[   57.750000] imxdma0: imx_dma_enable
[   57.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.760000] imxdma0: imx_dma_disable
[   57.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.780000] imxdma0: next sg chunk dst 0xa73dd800, src 0x10014038, size 0x00000200
[   57.780000] imxdma0: imx_dma_enable
[   57.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.790000] imxdma0: imx_dma_disable
[   57.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.810000] imxdma0: next sg chunk dst 0xa73dda00, src 0x10014038, size 0x00000200
[   57.820000] imxdma0: imx_dma_enable
[   57.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.830000] imxdma0: imx_dma_disable
[   57.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.840000] imxdma0: next sg chunk dst 0xa73ddc00, src 0x10014038, size 0x00000200
[   57.850000] imxdma0: imx_dma_enable
[   57.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.860000] imxdma0: imx_dma_disable
[   57.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.870000] imxdma0: next sg chunk dst 0xa73dde00, src 0x10014038, size 0x00000200
[   57.880000] imxdma0: imx_dma_enable
[   57.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.890000] imxdma0: imx_dma_disable
[   57.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.900000] imxdma0: next sg chunk dst 0xa73df000, src 0x10014038, size 0x00000200
[   57.910000] imxdma0: imx_dma_enable
[   57.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.920000] imxdma0: imx_dma_disable
[   57.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.930000] imxdma0: next sg chunk dst 0xa73df200, src 0x10014038, size 0x00000200
[   57.940000] imxdma0: imx_dma_enable
[   57.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.950000] imxdma0: imx_dma_disable
[   57.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.960000] imxdma0: next sg chunk dst 0xa73df400, src 0x10014038, size 0x00000200
[   57.970000] imxdma0: imx_dma_enable
[   57.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   57.980000] imxdma0: imx_dma_disable
[   57.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   57.990000] imxdma0: next sg chunk dst 0xa73df600, src 0x10014038, size 0x00000200
[   58.000000] imxdma0: imx_dma_enable
[   58.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.010000] imxdma0: imx_dma_disable
[   58.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.030000] imxdma0: next sg chunk dst 0xa73df800, src 0x10014038, size 0x00000200
[   58.030000] imxdma0: imx_dma_enable
[   58.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.040000] imxdma0: imx_dma_disable
[   58.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.060000] imxdma0: next sg chunk dst 0xa73dfa00, src 0x10014038, size 0x00000200
[   58.060000] imxdma0: imx_dma_enable
[   58.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.070000] imxdma0: imx_dma_disable
[   58.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.090000] imxdma0: next sg chunk dst 0xa73dfc00, src 0x10014038, size 0x00000200
[   58.100000] imxdma0: imx_dma_enable
[   58.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.110000] imxdma0: imx_dma_disable
[   58.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.120000] imxdma0: next sg chunk dst 0xa73dfe00, src 0x10014038, size 0x00000200
[   58.130000] imxdma0: imx_dma_enable
[   58.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.140000] imxdma0: imx_dma_disable
[   58.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.150000] imxdma0: next sg chunk dst 0xa73e1000, src 0x10014038, size 0x00000200
[   58.160000] imxdma0: imx_dma_enable
[   58.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.170000] imxdma0: imx_dma_disable
[   58.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.180000] imxdma0: next sg chunk dst 0xa73e1200, src 0x10014038, size 0x00000200
[   58.190000] imxdma0: imx_dma_enable
[   58.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.200000] imxdma0: imx_dma_disable
[   58.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.210000] imxdma0: next sg chunk dst 0xa73e1400, src 0x10014038, size 0x00000200
[   58.220000] imxdma0: imx_dma_enable
[   58.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.230000] imxdma0: imx_dma_disable
[   58.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.240000] imxdma0: next sg chunk dst 0xa73e1600, src 0x10014038, size 0x00000200
[   58.250000] imxdma0: imx_dma_enable
[   58.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.260000] imxdma0: imx_dma_disable
[   58.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.270000] imxdma0: next sg chunk dst 0xa73e1800, src 0x10014038, size 0x00000200
[   58.280000] imxdma0: imx_dma_enable
[   58.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.290000] imxdma0: imx_dma_disable
[   58.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.310000] imxdma0: next sg chunk dst 0xa73e1a00, src 0x10014038, size 0x00000200
[   58.310000] imxdma0: imx_dma_enable
[   58.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.320000] imxdma0: imx_dma_disable
[   58.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.340000] imxdma0: next sg chunk dst 0xa73e1c00, src 0x10014038, size 0x00000200
[   58.340000] imxdma0: imx_dma_enable
[   58.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.350000] imxdma0: imx_dma_disable
[   58.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.370000] imxdma0: next sg chunk dst 0xa73e1e00, src 0x10014038, size 0x00000200
[   58.370000] imxdma0: imx_dma_enable
[   58.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.380000] imxdma0: imx_dma_disable
[   58.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.400000] imxdma0: next sg chunk dst 0xa73e3000, src 0x10014038, size 0x00000200
[   58.410000] imxdma0: imx_dma_enable
[   58.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.420000] imxdma0: imx_dma_disable
[   58.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.430000] imxdma0: next sg chunk dst 0xa73e3200, src 0x10014038, size 0x00000200
[   58.440000] imxdma0: imx_dma_enable
[   58.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.450000] imxdma0: imx_dma_disable
[   58.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.460000] imxdma0: next sg chunk dst 0xa73e3400, src 0x10014038, size 0x00000200
[   58.470000] imxdma0: imx_dma_enable
[   58.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.480000] imxdma0: imx_dma_disable
[   58.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.490000] imxdma0: next sg chunk dst 0xa73e3600, src 0x10014038, size 0x00000200
[   58.500000] imxdma0: imx_dma_enable
[   58.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.510000] imxdma0: imx_dma_disable
[   58.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.520000] imxdma0: next sg chunk dst 0xa73e3800, src 0x10014038, size 0x00000200
[   58.530000] imxdma0: imx_dma_enable
[   58.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.540000] imxdma0: imx_dma_disable
[   58.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.550000] imxdma0: next sg chunk dst 0xa73e3a00, src 0x10014038, size 0x00000200
[   58.560000] imxdma0: imx_dma_enable
[   58.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.570000] imxdma0: imx_dma_disable
[   58.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.580000] imxdma0: next sg chunk dst 0xa73e3c00, src 0x10014038, size 0x00000200
[   58.590000] imxdma0: imx_dma_enable
[   58.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.600000] imxdma0: imx_dma_disable
[   58.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.620000] imxdma0: next sg chunk dst 0xa73e3e00, src 0x10014038, size 0x00000200
[   58.620000] imxdma0: imx_dma_enable
[   58.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.630000] imxdma0: imx_dma_disable
[   58.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.650000] imxdma0: next sg chunk dst 0xa73e5000, src 0x10014038, size 0x00000200
[   58.650000] imxdma0: imx_dma_enable
[   58.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.660000] imxdma0: imx_dma_disable
[   58.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.680000] imxdma0: next sg chunk dst 0xa73e5200, src 0x10014038, size 0x00000200
[   58.690000] imxdma0: imx_dma_enable
[   58.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.690000] imxdma0: imx_dma_disable
[   58.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.710000] imxdma0: next sg chunk dst 0xa73e5400, src 0x10014038, size 0x00000200
[   58.720000] imxdma0: imx_dma_enable
[   58.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.730000] imxdma0: imx_dma_disable
[   58.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.740000] imxdma0: next sg chunk dst 0xa73e5600, src 0x10014038, size 0x00000200
[   58.750000] imxdma0: imx_dma_enable
[   58.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.760000] imxdma0: imx_dma_disable
[   58.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.770000] imxdma0: next sg chunk dst 0xa73e5800, src 0x10014038, size 0x00000200
[   58.780000] imxdma0: imx_dma_enable
[   58.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.790000] imxdma0: imx_dma_disable
[   58.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.800000] imxdma0: next sg chunk dst 0xa73e5a00, src 0x10014038, size 0x00000200
[   58.810000] imxdma0: imx_dma_enable
[   58.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.820000] imxdma0: imx_dma_disable
[   58.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.830000] imxdma0: next sg chunk dst 0xa73e5c00, src 0x10014038, size 0x00000200
[   58.840000] imxdma0: imx_dma_enable
[   58.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.850000] imxdma0: imx_dma_disable
[   58.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.860000] imxdma0: next sg chunk dst 0xa73e5e00, src 0x10014038, size 0x00000200
[   58.870000] imxdma0: imx_dma_enable
[   58.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.880000] imxdma0: imx_dma_disable
[   58.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.890000] imxdma0: next sg chunk dst 0xa73e7000, src 0x10014038, size 0x00000200
[   58.900000] imxdma0: imx_dma_enable
[   58.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.910000] imxdma0: imx_dma_disable
[   58.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.930000] imxdma0: next sg chunk dst 0xa73e7200, src 0x10014038, size 0x00000200
[   58.930000] imxdma0: imx_dma_enable
[   58.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.940000] imxdma0: imx_dma_disable
[   58.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.960000] imxdma0: next sg chunk dst 0xa73e7400, src 0x10014038, size 0x00000200
[   58.960000] imxdma0: imx_dma_enable
[   58.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   58.970000] imxdma0: imx_dma_disable
[   58.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   58.990000] imxdma0: next sg chunk dst 0xa73e7600, src 0x10014038, size 0x00000200
[   58.990000] imxdma0: imx_dma_enable
[   59.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.000000] imxdma0: imx_dma_disable
[   59.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.020000] imxdma0: next sg chunk dst 0xa73e7800, src 0x10014038, size 0x00000200
[   59.030000] imxdma0: imx_dma_enable
[   59.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.040000] imxdma0: imx_dma_disable
[   59.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.050000] imxdma0: next sg chunk dst 0xa73e7a00, src 0x10014038, size 0x00000200
[   59.060000] imxdma0: imx_dma_enable
[   59.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.070000] imxdma0: imx_dma_disable
[   59.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.080000] imxdma0: next sg chunk dst 0xa73e7c00, src 0x10014038, size 0x00000200
[   59.090000] imxdma0: imx_dma_enable
[   59.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.100000] imxdma0: imx_dma_disable
[   59.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.110000] imxdma0: next sg chunk dst 0xa73e7e00, src 0x10014038, size 0x00000200
[   59.120000] imxdma0: imx_dma_enable
[   59.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.130000] imxdma0: imx_dma_disable
[   59.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.140000] imxdma0: next sg chunk dst 0xa73e9000, src 0x10014038, size 0x00000200
[   59.150000] imxdma0: imx_dma_enable
[   59.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.160000] imxdma0: imx_dma_disable
[   59.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.170000] imxdma0: next sg chunk dst 0xa73e9200, src 0x10014038, size 0x00000200
[   59.180000] imxdma0: imx_dma_enable
[   59.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.190000] imxdma0: imx_dma_disable
[   59.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.200000] imxdma0: next sg chunk dst 0xa73e9400, src 0x10014038, size 0x00000200
[   59.210000] imxdma0: imx_dma_enable
[   59.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.220000] imxdma0: imx_dma_disable
[   59.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.240000] imxdma0: next sg chunk dst 0xa73e9600, src 0x10014038, size 0x00000200
[   59.240000] imxdma0: imx_dma_enable
[   59.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.250000] imxdma0: imx_dma_disable
[   59.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.270000] imxdma0: next sg chunk dst 0xa73e9800, src 0x10014038, size 0x00000200
[   59.270000] imxdma0: imx_dma_enable
[   59.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.280000] imxdma0: imx_dma_disable
[   59.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.300000] imxdma0: next sg chunk dst 0xa73e9a00, src 0x10014038, size 0x00000200
[   59.300000] imxdma0: imx_dma_enable
[   59.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.310000] imxdma0: imx_dma_disable
[   59.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.330000] imxdma0: next sg chunk dst 0xa73e9c00, src 0x10014038, size 0x00000200
[   59.340000] imxdma0: imx_dma_enable
[   59.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.350000] imxdma0: imx_dma_disable
[   59.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.360000] imxdma0: next sg chunk dst 0xa73e9e00, src 0x10014038, size 0x00000200
[   59.370000] imxdma0: imx_dma_enable
[   59.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.380000] imxdma0: imx_dma_disable
[   59.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.390000] imxdma0: next sg chunk dst 0xa73eb000, src 0x10014038, size 0x00000200
[   59.400000] imxdma0: imx_dma_enable
[   59.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.410000] imxdma0: imx_dma_disable
[   59.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.420000] imxdma0: next sg chunk dst 0xa73eb200, src 0x10014038, size 0x00000200
[   59.430000] imxdma0: imx_dma_enable
[   59.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.440000] imxdma0: imx_dma_disable
[   59.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.450000] imxdma0: next sg chunk dst 0xa73eb400, src 0x10014038, size 0x00000200
[   59.460000] imxdma0: imx_dma_enable
[   59.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.470000] imxdma0: imx_dma_disable
[   59.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.480000] imxdma0: next sg chunk dst 0xa73eb600, src 0x10014038, size 0x00000200
[   59.490000] imxdma0: imx_dma_enable
[   59.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.500000] imxdma0: imx_dma_disable
[   59.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.510000] imxdma0: next sg chunk dst 0xa73eb800, src 0x10014038, size 0x00000200
[   59.520000] imxdma0: imx_dma_enable
[   59.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.530000] imxdma0: imx_dma_disable
[   59.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.550000] imxdma0: next sg chunk dst 0xa73eba00, src 0x10014038, size 0x00000200
[   59.550000] imxdma0: imx_dma_enable
[   59.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.560000] imxdma0: imx_dma_disable
[   59.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.580000] imxdma0: next sg chunk dst 0xa73ebc00, src 0x10014038, size 0x00000200
[   59.580000] imxdma0: imx_dma_enable
[   59.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.590000] imxdma0: imx_dma_disable
[   59.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.610000] imxdma0: next sg chunk dst 0xa73ebe00, src 0x10014038, size 0x00000200
[   59.610000] imxdma0: imx_dma_enable
[   59.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.620000] imxdma0: imx_dma_disable
[   59.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.640000] imxdma0: next sg chunk dst 0xa73ed000, src 0x10014038, size 0x00000200
[   59.650000] imxdma0: imx_dma_enable
[   59.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.660000] imxdma0: imx_dma_disable
[   59.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.670000] imxdma0: next sg chunk dst 0xa73ed200, src 0x10014038, size 0x00000200
[   59.680000] imxdma0: imx_dma_enable
[   59.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.690000] imxdma0: imx_dma_disable
[   59.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.700000] imxdma0: next sg chunk dst 0xa73ed400, src 0x10014038, size 0x00000200
[   59.710000] imxdma0: imx_dma_enable
[   59.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.720000] imxdma0: imx_dma_disable
[   59.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.730000] imxdma0: next sg chunk dst 0xa73ed600, src 0x10014038, size 0x00000200
[   59.740000] imxdma0: imx_dma_enable
[   59.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.750000] imxdma0: imx_dma_disable
[   59.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.760000] imxdma0: next sg chunk dst 0xa73ed800, src 0x10014038, size 0x00000200
[   59.770000] imxdma0: imx_dma_enable
[   59.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.780000] imxdma0: imx_dma_disable
[   59.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.790000] imxdma0: next sg chunk dst 0xa73eda00, src 0x10014038, size 0x00000200
[   59.800000] imxdma0: imx_dma_enable
[   59.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.810000] imxdma0: imx_dma_disable
[   59.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.820000] imxdma0: next sg chunk dst 0xa73edc00, src 0x10014038, size 0x00000200
[   59.830000] imxdma0: imx_dma_enable
[   59.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.840000] imxdma0: imx_dma_disable
[   59.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.860000] imxdma0: next sg chunk dst 0xa73ede00, src 0x10014038, size 0x00000200
[   59.860000] imxdma0: imx_dma_enable
[   59.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.870000] imxdma0: imx_dma_disable
[   59.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.890000] imxdma0: next sg chunk dst 0xa73ef000, src 0x10014038, size 0x00000200
[   59.890000] imxdma0: imx_dma_enable
[   59.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.900000] imxdma0: imx_dma_disable
[   59.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.920000] imxdma0: next sg chunk dst 0xa73ef200, src 0x10014038, size 0x00000200
[   59.920000] imxdma0: imx_dma_enable
[   59.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.930000] imxdma0: imx_dma_disable
[   59.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.950000] imxdma0: next sg chunk dst 0xa73ef400, src 0x10014038, size 0x00000200
[   59.960000] imxdma0: imx_dma_enable
[   59.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   59.970000] imxdma0: imx_dma_disable
[   59.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   59.980000] imxdma0: next sg chunk dst 0xa73ef600, src 0x10014038, size 0x00000200
[   59.990000] imxdma0: imx_dma_enable
[   59.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.000000] imxdma0: imx_dma_disable
[   60.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.010000] imxdma0: next sg chunk dst 0xa73ef800, src 0x10014038, size 0x00000200
[   60.020000] imxdma0: imx_dma_enable
[   60.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.030000] imxdma0: imx_dma_disable
[   60.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.040000] imxdma0: next sg chunk dst 0xa73efa00, src 0x10014038, size 0x00000200
[   60.050000] imxdma0: imx_dma_enable
[   60.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.060000] imxdma0: imx_dma_disable
[   60.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.070000] imxdma0: next sg chunk dst 0xa73efc00, src 0x10014038, size 0x00000200
[   60.080000] imxdma0: imx_dma_enable
[   60.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.090000] imxdma0: imx_dma_disable
[   60.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.100000] imxdma0: next sg chunk dst 0xa73efe00, src 0x10014038, size 0x00000200
[   60.110000] imxdma0: imx_dma_enable
[   60.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.120000] imxdma0: imx_dma_disable
[   60.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.130000] imxdma0: next sg chunk dst 0xa73f1000, src 0x10014038, size 0x00000200
[   60.140000] imxdma0: imx_dma_enable
[   60.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.150000] imxdma0: imx_dma_disable
[   60.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.170000] imxdma0: next sg chunk dst 0xa73f1200, src 0x10014038, size 0x00000200
[   60.170000] imxdma0: imx_dma_enable
[   60.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.180000] imxdma0: imx_dma_disable
[   60.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.200000] imxdma0: next sg chunk dst 0xa73f1400, src 0x10014038, size 0x00000200
[   60.200000] imxdma0: imx_dma_enable
[   60.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.210000] imxdma0: imx_dma_disable
[   60.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.230000] imxdma0: next sg chunk dst 0xa73f1600, src 0x10014038, size 0x00000200
[   60.240000] imxdma0: imx_dma_enable
[   60.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.240000] imxdma0: imx_dma_disable
[   60.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.260000] imxdma0: next sg chunk dst 0xa73f1800, src 0x10014038, size 0x00000200
[   60.270000] imxdma0: imx_dma_enable
[   60.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.280000] imxdma0: imx_dma_disable
[   60.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.290000] imxdma0: next sg chunk dst 0xa73f1a00, src 0x10014038, size 0x00000200
[   60.300000] imxdma0: imx_dma_enable
[   60.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.310000] imxdma0: imx_dma_disable
[   60.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.320000] imxdma0: next sg chunk dst 0xa73f1c00, src 0x10014038, size 0x00000200
[   60.330000] imxdma0: imx_dma_enable
[   60.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.340000] imxdma0: imx_dma_disable
[   60.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.350000] imxdma0: next sg chunk dst 0xa73f1e00, src 0x10014038, size 0x00000200
[   60.360000] imxdma0: imx_dma_enable
[   60.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.370000] imxdma0: imx_dma_disable
[   60.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.380000] imxdma0: next sg chunk dst 0xa73f3000, src 0x10014038, size 0x00000200
[   60.390000] imxdma0: imx_dma_enable
[   60.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.400000] imxdma0: imx_dma_disable
[   60.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.410000] imxdma0: next sg chunk dst 0xa73f3200, src 0x10014038, size 0x00000200
[   60.420000] imxdma0: imx_dma_enable
[   60.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.430000] imxdma0: imx_dma_disable
[   60.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.440000] imxdma0: next sg chunk dst 0xa73f3400, src 0x10014038, size 0x00000200
[   60.450000] imxdma0: imx_dma_enable
[   60.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.460000] imxdma0: imx_dma_disable
[   60.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.480000] imxdma0: next sg chunk dst 0xa73f3600, src 0x10014038, size 0x00000200
[   60.480000] imxdma0: imx_dma_enable
[   60.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.490000] imxdma0: imx_dma_disable
[   60.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.510000] imxdma0: next sg chunk dst 0xa73f3800, src 0x10014038, size 0x00000200
[   60.510000] imxdma0: imx_dma_enable
[   60.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.520000] imxdma0: imx_dma_disable
[   60.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.540000] imxdma0: next sg chunk dst 0xa73f3a00, src 0x10014038, size 0x00000200
[   60.550000] imxdma0: imx_dma_enable
[   60.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.560000] imxdma0: imx_dma_disable
[   60.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.570000] imxdma0: next sg chunk dst 0xa73f3c00, src 0x10014038, size 0x00000200
[   60.580000] imxdma0: imx_dma_enable
[   60.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.590000] imxdma0: imx_dma_disable
[   60.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.600000] imxdma0: next sg chunk dst 0xa73f3e00, src 0x10014038, size 0x00000200
[   60.610000] imxdma0: imx_dma_enable
[   60.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.620000] imxdma0: imx_dma_disable
[   60.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.630000] imxdma0: next sg chunk dst 0xa73f5000, src 0x10014038, size 0x00000200
[   60.640000] imxdma0: imx_dma_enable
[   60.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.650000] imxdma0: imx_dma_disable
[   60.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.660000] imxdma0: next sg chunk dst 0xa73f5200, src 0x10014038, size 0x00000200
[   60.670000] imxdma0: imx_dma_enable
[   60.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.680000] imxdma0: imx_dma_disable
[   60.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.690000] imxdma0: next sg chunk dst 0xa73f5400, src 0x10014038, size 0x00000200
[   60.700000] imxdma0: imx_dma_enable
[   60.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.710000] imxdma0: imx_dma_disable
[   60.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.720000] imxdma0: next sg chunk dst 0xa73f5600, src 0x10014038, size 0x00000200
[   60.730000] imxdma0: imx_dma_enable
[   60.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.740000] imxdma0: imx_dma_disable
[   60.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.750000] imxdma0: next sg chunk dst 0xa73f5800, src 0x10014038, size 0x00000200
[   60.760000] imxdma0: imx_dma_enable
[   60.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.770000] imxdma0: imx_dma_disable
[   60.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.790000] imxdma0: next sg chunk dst 0xa73f5a00, src 0x10014038, size 0x00000200
[   60.790000] imxdma0: imx_dma_enable
[   60.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.800000] imxdma0: imx_dma_disable
[   60.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.820000] imxdma0: next sg chunk dst 0xa73f5c00, src 0x10014038, size 0x00000200
[   60.820000] imxdma0: imx_dma_enable
[   60.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.830000] imxdma0: imx_dma_disable
[   60.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.850000] imxdma0: next sg chunk dst 0xa73f5e00, src 0x10014038, size 0x00000200
[   60.860000] imxdma0: imx_dma_enable
[   60.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.870000] imxdma0: imx_dma_disable
[   60.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.880000] imxdma0: next sg chunk dst 0xa73f7000, src 0x10014038, size 0x00000200
[   60.890000] imxdma0: imx_dma_enable
[   60.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.900000] imxdma0: imx_dma_disable
[   60.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.910000] imxdma0: next sg chunk dst 0xa73f7200, src 0x10014038, size 0x00000200
[   60.920000] imxdma0: imx_dma_enable
[   60.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.930000] imxdma0: imx_dma_disable
[   60.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.940000] imxdma0: next sg chunk dst 0xa73f7400, src 0x10014038, size 0x00000200
[   60.950000] imxdma0: imx_dma_enable
[   60.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.960000] imxdma0: imx_dma_disable
[   60.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   60.970000] imxdma0: next sg chunk dst 0xa73f7600, src 0x10014038, size 0x00000200
[   60.980000] imxdma0: imx_dma_enable
[   60.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   60.990000] imxdma0: imx_dma_disable
[   60.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.000000] imxdma0: next sg chunk dst 0xa73f7800, src 0x10014038, size 0x00000200
[   61.010000] imxdma0: imx_dma_enable
[   61.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.020000] imxdma0: imx_dma_disable
[   61.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.030000] imxdma0: next sg chunk dst 0xa73f7a00, src 0x10014038, size 0x00000200
[   61.040000] imxdma0: imx_dma_enable
[   61.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.050000] imxdma0: imx_dma_disable
[   61.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.070000] imxdma0: next sg chunk dst 0xa73f7c00, src 0x10014038, size 0x00000200
[   61.070000] imxdma0: imx_dma_enable
[   61.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.080000] imxdma0: imx_dma_disable
[   61.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.100000] imxdma0: next sg chunk dst 0xa73f7e00, src 0x10014038, size 0x00000200
[   61.100000] imxdma0: imx_dma_enable
[   61.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.110000] imxdma0: imx_dma_disable
[   61.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.130000] imxdma0: next sg chunk dst 0xa73f9000, src 0x10014038, size 0x00000200
[   61.130000] imxdma0: imx_dma_enable
[   61.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.140000] imxdma0: imx_dma_disable
[   61.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.160000] imxdma0: next sg chunk dst 0xa73f9200, src 0x10014038, size 0x00000200
[   61.170000] imxdma0: imx_dma_enable
[   61.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.180000] imxdma0: imx_dma_disable
[   61.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.190000] imxdma0: next sg chunk dst 0xa73f9400, src 0x10014038, size 0x00000200
[   61.200000] imxdma0: imx_dma_enable
[   61.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.210000] imxdma0: imx_dma_disable
[   61.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.220000] imxdma0: next sg chunk dst 0xa73f9600, src 0x10014038, size 0x00000200
[   61.230000] imxdma0: imx_dma_enable
[   61.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.240000] imxdma0: imx_dma_disable
[   61.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.250000] imxdma0: next sg chunk dst 0xa73f9800, src 0x10014038, size 0x00000200
[   61.260000] imxdma0: imx_dma_enable
[   61.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.270000] imxdma0: imx_dma_disable
[   61.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.280000] imxdma0: next sg chunk dst 0xa73f9a00, src 0x10014038, size 0x00000200
[   61.290000] imxdma0: imx_dma_enable
[   61.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.300000] imxdma0: imx_dma_disable
[   61.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.310000] imxdma0: next sg chunk dst 0xa73f9c00, src 0x10014038, size 0x00000200
[   61.320000] imxdma0: imx_dma_enable
[   61.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.330000] imxdma0: imx_dma_disable
[   61.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.340000] imxdma0: next sg chunk dst 0xa73f9e00, src 0x10014038, size 0x00000200
[   61.350000] imxdma0: imx_dma_enable
[   61.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.360000] imxdma0: imx_dma_disable
[   61.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.380000] imxdma0: next sg chunk dst 0xa73fb000, src 0x10014038, size 0x00000200
[   61.380000] imxdma0: imx_dma_enable
[   61.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.390000] imxdma0: imx_dma_disable
[   61.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.410000] imxdma0: next sg chunk dst 0xa73fb200, src 0x10014038, size 0x00000200
[   61.410000] imxdma0: imx_dma_enable
[   61.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.420000] imxdma0: imx_dma_disable
[   61.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.440000] imxdma0: next sg chunk dst 0xa73fb400, src 0x10014038, size 0x00000200
[   61.450000] imxdma0: imx_dma_enable
[   61.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.450000] imxdma0: imx_dma_disable
[   61.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.470000] imxdma0: next sg chunk dst 0xa73fb600, src 0x10014038, size 0x00000200
[   61.480000] imxdma0: imx_dma_enable
[   61.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.490000] imxdma0: imx_dma_disable
[   61.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.500000] imxdma0: next sg chunk dst 0xa73fb800, src 0x10014038, size 0x00000200
[   61.510000] imxdma0: imx_dma_enable
[   61.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.520000] imxdma0: imx_dma_disable
[   61.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.530000] imxdma0: next sg chunk dst 0xa73fba00, src 0x10014038, size 0x00000200
[   61.540000] imxdma0: imx_dma_enable
[   61.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.550000] imxdma0: imx_dma_disable
[   61.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.560000] imxdma0: next sg chunk dst 0xa73fbc00, src 0x10014038, size 0x00000200
[   61.570000] imxdma0: imx_dma_enable
[   61.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.580000] imxdma0: imx_dma_disable
[   61.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.590000] imxdma0: next sg chunk dst 0xa73fbe00, src 0x10014038, size 0x00000200
[   61.600000] imxdma0: imx_dma_enable
[   61.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.610000] imxdma0: imx_dma_disable
[   61.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.620000] imxdma0: next sg chunk dst 0xa73fd000, src 0x10014038, size 0x00000200
[   61.630000] imxdma0: imx_dma_enable
[   61.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.640000] imxdma0: imx_dma_disable
[   61.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.650000] imxdma0: next sg chunk dst 0xa73fd200, src 0x10014038, size 0x00000200
[   61.660000] imxdma0: imx_dma_enable
[   61.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.670000] imxdma0: imx_dma_disable
[   61.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.690000] imxdma0: next sg chunk dst 0xa73fd400, src 0x10014038, size 0x00000200
[   61.690000] imxdma0: imx_dma_enable
[   61.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.700000] imxdma0: imx_dma_disable
[   61.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.720000] imxdma0: next sg chunk dst 0xa73fd600, src 0x10014038, size 0x00000200
[   61.720000] imxdma0: imx_dma_enable
[   61.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.730000] imxdma0: imx_dma_disable
[   61.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.750000] imxdma0: next sg chunk dst 0xa73fd800, src 0x10014038, size 0x00000200
[   61.760000] imxdma0: imx_dma_enable
[   61.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.770000] imxdma0: imx_dma_disable
[   61.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.780000] imxdma0: next sg chunk dst 0xa73fda00, src 0x10014038, size 0x00000200
[   61.790000] imxdma0: imx_dma_enable
[   61.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.800000] imxdma0: imx_dma_disable
[   61.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.810000] imxdma0: next sg chunk dst 0xa73fdc00, src 0x10014038, size 0x00000200
[   61.820000] imxdma0: imx_dma_enable
[   61.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.830000] imxdma0: imx_dma_disable
[   61.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.840000] imxdma0: next sg chunk dst 0xa73fde00, src 0x10014038, size 0x00000200
[   61.850000] imxdma0: imx_dma_enable
[   61.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.860000] imxdma0: imx_dma_disable
[   61.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.870000] imxdma0: next sg chunk dst 0xa73ff000, src 0x10014038, size 0x00000200
[   61.880000] imxdma0: imx_dma_enable
[   61.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.890000] imxdma0: imx_dma_disable
[   61.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.900000] imxdma0: next sg chunk dst 0xa73ff200, src 0x10014038, size 0x00000200
[   61.910000] imxdma0: imx_dma_enable
[   61.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.920000] imxdma0: imx_dma_disable
[   61.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.930000] imxdma0: next sg chunk dst 0xa73ff400, src 0x10014038, size 0x00000200
[   61.940000] imxdma0: imx_dma_enable
[   61.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.950000] imxdma0: imx_dma_disable
[   61.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   61.960000] imxdma0: next sg chunk dst 0xa73ff600, src 0x10014038, size 0x00000200
[   61.970000] imxdma0: imx_dma_enable
[   61.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   61.980000] imxdma0: imx_dma_disable
[   61.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.000000] imxdma0: next sg chunk dst 0xa73ff800, src 0x10014038, size 0x00000200
[   62.000000] imxdma0: imx_dma_enable
[   62.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.010000] imxdma0: imx_dma_disable
[   62.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.030000] imxdma0: next sg chunk dst 0xa73ffa00, src 0x10014038, size 0x00000200
[   62.030000] imxdma0: imx_dma_enable
[   62.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.040000] imxdma0: imx_dma_disable
[   62.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.060000] imxdma0: next sg chunk dst 0xa73ffc00, src 0x10014038, size 0x00000200
[   62.070000] imxdma0: imx_dma_enable
[   62.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.080000] imxdma0: imx_dma_disable
[   62.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.090000] imxdma0: next sg chunk dst 0xa73ffe00, src 0x10014038, size 0x00000200
[   62.100000] imxdma0: imx_dma_enable
[   62.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.110000] imxdma0: imx_dma_disable
[   62.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.120000] imxdma0: next sg chunk dst 0xa6c01000, src 0x10014038, size 0x00000200
[   62.130000] imxdma0: imx_dma_enable
[   62.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.140000] imxdma0: imx_dma_disable
[   62.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.150000] imxdma0: next sg chunk dst 0xa6c01200, src 0x10014038, size 0x00000200
[   62.160000] imxdma0: imx_dma_enable
[   62.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.170000] imxdma0: imx_dma_disable
[   62.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.180000] imxdma0: next sg chunk dst 0xa6c01400, src 0x10014038, size 0x00000200
[   62.190000] imxdma0: imx_dma_enable
[   62.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.200000] imxdma0: imx_dma_disable
[   62.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.210000] imxdma0: next sg chunk dst 0xa6c01600, src 0x10014038, size 0x00000200
[   62.220000] imxdma0: imx_dma_enable
[   62.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.230000] imxdma0: imx_dma_disable
[   62.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.240000] imxdma0: next sg chunk dst 0xa6c01800, src 0x10014038, size 0x00000200
[   62.250000] imxdma0: imx_dma_enable
[   62.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.260000] imxdma0: imx_dma_disable
[   62.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.280000] imxdma0: next sg chunk dst 0xa6c01a00, src 0x10014038, size 0x00000200
[   62.280000] imxdma0: imx_dma_enable
[   62.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.290000] imxdma0: imx_dma_disable
[   62.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.310000] imxdma0: next sg chunk dst 0xa6c01c00, src 0x10014038, size 0x00000200
[   62.310000] imxdma0: imx_dma_enable
[   62.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.320000] imxdma0: imx_dma_disable
[   62.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.340000] imxdma0: next sg chunk dst 0xa6c01e00, src 0x10014038, size 0x00000200
[   62.340000] imxdma0: imx_dma_enable
[   62.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.350000] imxdma0: imx_dma_disable
[   62.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.370000] imxdma0: next sg chunk dst 0xa6c03000, src 0x10014038, size 0x00000200
[   62.380000] imxdma0: imx_dma_enable
[   62.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.390000] imxdma0: imx_dma_disable
[   62.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.400000] imxdma0: next sg chunk dst 0xa6c03200, src 0x10014038, size 0x00000200
[   62.410000] imxdma0: imx_dma_enable
[   62.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.420000] imxdma0: imx_dma_disable
[   62.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.430000] imxdma0: next sg chunk dst 0xa6c03400, src 0x10014038, size 0x00000200
[   62.440000] imxdma0: imx_dma_enable
[   62.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.450000] imxdma0: imx_dma_disable
[   62.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.460000] imxdma0: next sg chunk dst 0xa6c03600, src 0x10014038, size 0x00000200
[   62.470000] imxdma0: imx_dma_enable
[   62.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.480000] imxdma0: imx_dma_disable
[   62.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.490000] imxdma0: next sg chunk dst 0xa6c03800, src 0x10014038, size 0x00000200
[   62.500000] imxdma0: imx_dma_enable
[   62.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.510000] imxdma0: imx_dma_disable
[   62.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.520000] imxdma0: next sg chunk dst 0xa6c03a00, src 0x10014038, size 0x00000200
[   62.530000] imxdma0: imx_dma_enable
[   62.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.540000] imxdma0: imx_dma_disable
[   62.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.550000] imxdma0: next sg chunk dst 0xa6c03c00, src 0x10014038, size 0x00000200
[   62.560000] imxdma0: imx_dma_enable
[   62.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.570000] imxdma0: imx_dma_disable
[   62.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.590000] imxdma0: next sg chunk dst 0xa6c03e00, src 0x10014038, size 0x00000200
[   62.590000] imxdma0: imx_dma_enable
[   62.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.600000] imxdma0: imx_dma_disable
[   62.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.620000] imxdma0: next sg chunk dst 0xa6c05000, src 0x10014038, size 0x00000200
[   62.620000] imxdma0: imx_dma_enable
[   62.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.630000] imxdma0: imx_dma_disable
[   62.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.650000] imxdma0: next sg chunk dst 0xa6c05200, src 0x10014038, size 0x00000200
[   62.650000] imxdma0: imx_dma_enable
[   62.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.660000] imxdma0: imx_dma_disable
[   62.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.680000] imxdma0: next sg chunk dst 0xa6c05400, src 0x10014038, size 0x00000200
[   62.690000] imxdma0: imx_dma_enable
[   62.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.700000] imxdma0: imx_dma_disable
[   62.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.710000] imxdma0: next sg chunk dst 0xa6c05600, src 0x10014038, size 0x00000200
[   62.720000] imxdma0: imx_dma_enable
[   62.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.730000] imxdma0: imx_dma_disable
[   62.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.740000] imxdma0: next sg chunk dst 0xa6c05800, src 0x10014038, size 0x00000200
[   62.750000] imxdma0: imx_dma_enable
[   62.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.760000] imxdma0: imx_dma_disable
[   62.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.770000] imxdma0: next sg chunk dst 0xa6c05a00, src 0x10014038, size 0x00000200
[   62.780000] imxdma0: imx_dma_enable
[   62.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.790000] imxdma0: imx_dma_disable
[   62.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.800000] imxdma0: next sg chunk dst 0xa6c05c00, src 0x10014038, size 0x00000200
[   62.810000] imxdma0: imx_dma_enable
[   62.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.820000] imxdma0: imx_dma_disable
[   62.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.830000] imxdma0: next sg chunk dst 0xa6c05e00, src 0x10014038, size 0x00000200
[   62.840000] imxdma0: imx_dma_enable
[   62.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.850000] imxdma0: imx_dma_disable
[   62.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.860000] imxdma0: next sg chunk dst 0xa6c07000, src 0x10014038, size 0x00000200
[   62.870000] imxdma0: imx_dma_enable
[   62.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.880000] imxdma0: imx_dma_disable
[   62.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.900000] imxdma0: next sg chunk dst 0xa6c07200, src 0x10014038, size 0x00000200
[   62.900000] imxdma0: imx_dma_enable
[   62.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.910000] imxdma0: imx_dma_disable
[   62.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.930000] imxdma0: next sg chunk dst 0xa6c07400, src 0x10014038, size 0x00000200
[   62.930000] imxdma0: imx_dma_enable
[   62.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.940000] imxdma0: imx_dma_disable
[   62.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.960000] imxdma0: next sg chunk dst 0xa6c07600, src 0x10014038, size 0x00000200
[   62.960000] imxdma0: imx_dma_enable
[   62.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   62.970000] imxdma0: imx_dma_disable
[   62.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   62.990000] imxdma0: next sg chunk dst 0xa6c07800, src 0x10014038, size 0x00000200
[   63.000000] imxdma0: imx_dma_enable
[   63.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.010000] imxdma0: imx_dma_disable
[   63.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.020000] imxdma0: next sg chunk dst 0xa6c07a00, src 0x10014038, size 0x00000200
[   63.030000] imxdma0: imx_dma_enable
[   63.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.040000] imxdma0: imx_dma_disable
[   63.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.050000] imxdma0: next sg chunk dst 0xa6c07c00, src 0x10014038, size 0x00000200
[   63.060000] imxdma0: imx_dma_enable
[   63.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.070000] imxdma0: imx_dma_disable
[   63.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.080000] imxdma0: next sg chunk dst 0xa6c07e00, src 0x10014038, size 0x00000200
[   63.090000] imxdma0: imx_dma_enable
[   63.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.100000] imxdma0: imx_dma_disable
[   63.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.110000] imxdma0: next sg chunk dst 0xa6c09000, src 0x10014038, size 0x00000200
[   63.120000] imxdma0: imx_dma_enable
[   63.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.130000] imxdma0: imx_dma_disable
[   63.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.140000] imxdma0: next sg chunk dst 0xa6c09200, src 0x10014038, size 0x00000200
[   63.150000] imxdma0: imx_dma_enable
[   63.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.160000] imxdma0: imx_dma_disable
[   63.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.170000] imxdma0: next sg chunk dst 0xa6c09400, src 0x10014038, size 0x00000200
[   63.180000] imxdma0: imx_dma_enable
[   63.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.190000] imxdma0: imx_dma_disable
[   63.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.210000] imxdma0: next sg chunk dst 0xa6c09600, src 0x10014038, size 0x00000200
[   63.210000] imxdma0: imx_dma_enable
[   63.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.220000] imxdma0: imx_dma_disable
[   63.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.240000] imxdma0: next sg chunk dst 0xa6c09800, src 0x10014038, size 0x00000200
[   63.240000] imxdma0: imx_dma_enable
[   63.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.250000] imxdma0: imx_dma_disable
[   63.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.270000] imxdma0: next sg chunk dst 0xa6c09a00, src 0x10014038, size 0x00000200
[   63.270000] imxdma0: imx_dma_enable
[   63.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.280000] imxdma0: imx_dma_disable
[   63.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.300000] imxdma0: next sg chunk dst 0xa6c09c00, src 0x10014038, size 0x00000200
[   63.310000] imxdma0: imx_dma_enable
[   63.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.320000] imxdma0: imx_dma_disable
[   63.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.330000] imxdma0: next sg chunk dst 0xa6c09e00, src 0x10014038, size 0x00000200
[   63.340000] imxdma0: imx_dma_enable
[   63.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.350000] imxdma0: imx_dma_disable
[   63.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.360000] imxdma0: next sg chunk dst 0xa6c0b000, src 0x10014038, size 0x00000200
[   63.370000] imxdma0: imx_dma_enable
[   63.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.380000] imxdma0: imx_dma_disable
[   63.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.390000] imxdma0: next sg chunk dst 0xa6c0b200, src 0x10014038, size 0x00000200
[   63.400000] imxdma0: imx_dma_enable
[   63.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.410000] imxdma0: imx_dma_disable
[   63.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.420000] imxdma0: next sg chunk dst 0xa6c0b400, src 0x10014038, size 0x00000200
[   63.430000] imxdma0: imx_dma_enable
[   63.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.440000] imxdma0: imx_dma_disable
[   63.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.450000] imxdma0: next sg chunk dst 0xa6c0b600, src 0x10014038, size 0x00000200
[   63.460000] imxdma0: imx_dma_enable
[   63.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.470000] imxdma0: imx_dma_disable
[   63.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.480000] imxdma0: next sg chunk dst 0xa6c0b800, src 0x10014038, size 0x00000200
[   63.490000] imxdma0: imx_dma_enable
[   63.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.500000] imxdma0: imx_dma_disable
[   63.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.520000] imxdma0: next sg chunk dst 0xa6c0ba00, src 0x10014038, size 0x00000200
[   63.520000] imxdma0: imx_dma_enable
[   63.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.530000] imxdma0: imx_dma_disable
[   63.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.550000] imxdma0: next sg chunk dst 0xa6c0bc00, src 0x10014038, size 0x00000200
[   63.550000] imxdma0: imx_dma_enable
[   63.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.560000] imxdma0: imx_dma_disable
[   63.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.580000] imxdma0: next sg chunk dst 0xa6c0be00, src 0x10014038, size 0x00000200
[   63.580000] imxdma0: imx_dma_enable
[   63.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.590000] imxdma0: imx_dma_disable
[   63.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.610000] imxdma0: next sg chunk dst 0xa6c0d000, src 0x10014038, size 0x00000200
[   63.620000] imxdma0: imx_dma_enable
[   63.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.630000] imxdma0: imx_dma_disable
[   63.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.640000] imxdma0: next sg chunk dst 0xa6c0d200, src 0x10014038, size 0x00000200
[   63.650000] imxdma0: imx_dma_enable
[   63.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.660000] imxdma0: imx_dma_disable
[   63.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.670000] imxdma0: next sg chunk dst 0xa6c0d400, src 0x10014038, size 0x00000200
[   63.680000] imxdma0: imx_dma_enable
[   63.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.690000] imxdma0: imx_dma_disable
[   63.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.700000] imxdma0: next sg chunk dst 0xa6c0d600, src 0x10014038, size 0x00000200
[   63.710000] imxdma0: imx_dma_enable
[   63.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.720000] imxdma0: imx_dma_disable
[   63.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.730000] imxdma0: next sg chunk dst 0xa6c0d800, src 0x10014038, size 0x00000200
[   63.740000] imxdma0: imx_dma_enable
[   63.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.750000] imxdma0: imx_dma_disable
[   63.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.760000] imxdma0: next sg chunk dst 0xa6c0da00, src 0x10014038, size 0x00000200
[   63.770000] imxdma0: imx_dma_enable
[   63.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.780000] imxdma0: imx_dma_disable
[   63.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.790000] imxdma0: next sg chunk dst 0xa6c0dc00, src 0x10014038, size 0x00000200
[   63.800000] imxdma0: imx_dma_enable
[   63.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.810000] imxdma0: imx_dma_disable
[   63.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.830000] imxdma0: next sg chunk dst 0xa6c0de00, src 0x10014038, size 0x00000200
[   63.830000] imxdma0: imx_dma_enable
[   63.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.840000] imxdma0: imx_dma_disable
[   63.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.860000] imxdma0: next sg chunk dst 0xa6c0f000, src 0x10014038, size 0x00000200
[   63.860000] imxdma0: imx_dma_enable
[   63.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.870000] imxdma0: imx_dma_disable
[   63.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.890000] imxdma0: next sg chunk dst 0xa6c0f200, src 0x10014038, size 0x00000200
[   63.900000] imxdma0: imx_dma_enable
[   63.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.900000] imxdma0: imx_dma_disable
[   63.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.920000] imxdma0: next sg chunk dst 0xa6c0f400, src 0x10014038, size 0x00000200
[   63.930000] imxdma0: imx_dma_enable
[   63.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.940000] imxdma0: imx_dma_disable
[   63.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.950000] imxdma0: next sg chunk dst 0xa6c0f600, src 0x10014038, size 0x00000200
[   63.960000] imxdma0: imx_dma_enable
[   63.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   63.970000] imxdma0: imx_dma_disable
[   63.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   63.980000] imxdma0: next sg chunk dst 0xa6c0f800, src 0x10014038, size 0x00000200
[   63.990000] imxdma0: imx_dma_enable
[   63.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.000000] imxdma0: imx_dma_disable
[   64.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.010000] imxdma0: next sg chunk dst 0xa6c0fa00, src 0x10014038, size 0x00000200
[   64.020000] imxdma0: imx_dma_enable
[   64.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.030000] imxdma0: imx_dma_disable
[   64.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.040000] imxdma0: next sg chunk dst 0xa6c0fc00, src 0x10014038, size 0x00000200
[   64.050000] imxdma0: imx_dma_enable
[   64.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.060000] imxdma0: imx_dma_disable
[   64.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.070000] imxdma0: next sg chunk dst 0xa6c0fe00, src 0x10014038, size 0x00000200
[   64.080000] imxdma0: imx_dma_enable
[   64.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.090000] imxdma0: imx_dma_disable
[   64.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.100000] imxdma0: next sg chunk dst 0xa6c11000, src 0x10014038, size 0x00000200
[   64.110000] imxdma0: imx_dma_enable
[   64.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.120000] imxdma0: imx_dma_disable
[   64.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.140000] imxdma0: next sg chunk dst 0xa6c11200, src 0x10014038, size 0x00000200
[   64.140000] imxdma0: imx_dma_enable
[   64.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.150000] imxdma0: imx_dma_disable
[   64.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.170000] imxdma0: next sg chunk dst 0xa6c11400, src 0x10014038, size 0x00000200
[   64.170000] imxdma0: imx_dma_enable
[   64.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.180000] imxdma0: imx_dma_disable
[   64.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.200000] imxdma0: next sg chunk dst 0xa6c11600, src 0x10014038, size 0x00000200
[   64.210000] imxdma0: imx_dma_enable
[   64.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.220000] imxdma0: imx_dma_disable
[   64.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.230000] imxdma0: next sg chunk dst 0xa6c11800, src 0x10014038, size 0x00000200
[   64.240000] imxdma0: imx_dma_enable
[   64.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.250000] imxdma0: imx_dma_disable
[   64.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.260000] imxdma0: next sg chunk dst 0xa6c11a00, src 0x10014038, size 0x00000200
[   64.270000] imxdma0: imx_dma_enable
[   64.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.280000] imxdma0: imx_dma_disable
[   64.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.290000] imxdma0: next sg chunk dst 0xa6c11c00, src 0x10014038, size 0x00000200
[   64.300000] imxdma0: imx_dma_enable
[   64.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.310000] imxdma0: imx_dma_disable
[   64.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.320000] imxdma0: next sg chunk dst 0xa6c11e00, src 0x10014038, size 0x00000200
[   64.330000] imxdma0: imx_dma_enable
[   64.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.340000] imxdma0: imx_dma_disable
[   64.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.350000] imxdma0: next sg chunk dst 0xa6c13000, src 0x10014038, size 0x00000200
[   64.360000] imxdma0: imx_dma_enable
[   64.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.370000] imxdma0: imx_dma_disable
[   64.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.380000] imxdma0: next sg chunk dst 0xa6c13200, src 0x10014038, size 0x00000200
[   64.390000] imxdma0: imx_dma_enable
[   64.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.400000] imxdma0: imx_dma_disable
[   64.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.420000] imxdma0: next sg chunk dst 0xa6c13400, src 0x10014038, size 0x00000200
[   64.420000] imxdma0: imx_dma_enable
[   64.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.430000] imxdma0: imx_dma_disable
[   64.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.450000] imxdma0: next sg chunk dst 0xa6c13600, src 0x10014038, size 0x00000200
[   64.450000] imxdma0: imx_dma_enable
[   64.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.460000] imxdma0: imx_dma_disable
[   64.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.480000] imxdma0: next sg chunk dst 0xa6c13800, src 0x10014038, size 0x00000200
[   64.480000] imxdma0: imx_dma_enable
[   64.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.490000] imxdma0: imx_dma_disable
[   64.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.510000] imxdma0: next sg chunk dst 0xa6c13a00, src 0x10014038, size 0x00000200
[   64.520000] imxdma0: imx_dma_enable
[   64.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.530000] imxdma0: imx_dma_disable
[   64.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.540000] imxdma0: next sg chunk dst 0xa6c13c00, src 0x10014038, size 0x00000200
[   64.550000] imxdma0: imx_dma_enable
[   64.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.560000] imxdma0: imx_dma_disable
[   64.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.570000] imxdma0: next sg chunk dst 0xa6c13e00, src 0x10014038, size 0x00000200
[   64.580000] imxdma0: imx_dma_enable
[   64.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.590000] imxdma0: imx_dma_disable
[   64.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.600000] imxdma0: next sg chunk dst 0xa6c15000, src 0x10014038, size 0x00000200
[   64.610000] imxdma0: imx_dma_enable
[   64.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.620000] imxdma0: imx_dma_disable
[   64.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.630000] imxdma0: next sg chunk dst 0xa6c15200, src 0x10014038, size 0x00000200
[   64.640000] imxdma0: imx_dma_enable
[   64.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.650000] imxdma0: imx_dma_disable
[   64.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.660000] imxdma0: next sg chunk dst 0xa6c15400, src 0x10014038, size 0x00000200
[   64.670000] imxdma0: imx_dma_enable
[   64.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.680000] imxdma0: imx_dma_disable
[   64.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.690000] imxdma0: next sg chunk dst 0xa6c15600, src 0x10014038, size 0x00000200
[   64.700000] imxdma0: imx_dma_enable
[   64.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.710000] imxdma0: imx_dma_disable
[   64.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.730000] imxdma0: next sg chunk dst 0xa6c15800, src 0x10014038, size 0x00000200
[   64.730000] imxdma0: imx_dma_enable
[   64.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.740000] imxdma0: imx_dma_disable
[   64.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.760000] imxdma0: next sg chunk dst 0xa6c15a00, src 0x10014038, size 0x00000200
[   64.760000] imxdma0: imx_dma_enable
[   64.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.770000] imxdma0: imx_dma_disable
[   64.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.790000] imxdma0: next sg chunk dst 0xa6c15c00, src 0x10014038, size 0x00000200
[   64.790000] imxdma0: imx_dma_enable
[   64.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.800000] imxdma0: imx_dma_disable
[   64.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.820000] imxdma0: next sg chunk dst 0xa6c15e00, src 0x10014038, size 0x00000200
[   64.830000] imxdma0: imx_dma_enable
[   64.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.840000] imxdma0: imx_dma_disable
[   64.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.850000] imxdma0: next sg chunk dst 0xa6c17000, src 0x10014038, size 0x00000200
[   64.860000] imxdma0: imx_dma_enable
[   64.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.870000] imxdma0: imx_dma_disable
[   64.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.880000] imxdma0: next sg chunk dst 0xa6c17200, src 0x10014038, size 0x00000200
[   64.890000] imxdma0: imx_dma_enable
[   64.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.900000] imxdma0: imx_dma_disable
[   64.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.910000] imxdma0: next sg chunk dst 0xa6c17400, src 0x10014038, size 0x00000200
[   64.920000] imxdma0: imx_dma_enable
[   64.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.930000] imxdma0: imx_dma_disable
[   64.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.940000] imxdma0: next sg chunk dst 0xa6c17600, src 0x10014038, size 0x00000200
[   64.950000] imxdma0: imx_dma_enable
[   64.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.960000] imxdma0: imx_dma_disable
[   64.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   64.970000] imxdma0: next sg chunk dst 0xa6c17800, src 0x10014038, size 0x00000200
[   64.980000] imxdma0: imx_dma_enable
[   64.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   64.990000] imxdma0: imx_dma_disable
[   64.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.000000] imxdma0: next sg chunk dst 0xa6c17a00, src 0x10014038, size 0x00000200
[   65.010000] imxdma0: imx_dma_enable
[   65.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.020000] imxdma0: imx_dma_disable
[   65.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.030000] imxdma0: next sg chunk dst 0xa6c17c00, src 0x10014038, size 0x00000200
[   65.040000] imxdma0: imx_dma_enable
[   65.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.050000] imxdma0: imx_dma_disable
[   65.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.070000] imxdma0: next sg chunk dst 0xa6c17e00, src 0x10014038, size 0x00000200
[   65.070000] imxdma0: imx_dma_enable
[   65.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.080000] imxdma0: imx_dma_disable
[   65.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.100000] imxdma0: next sg chunk dst 0xa6c19000, src 0x10014038, size 0x00000200
[   65.100000] imxdma0: imx_dma_enable
[   65.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.110000] imxdma0: imx_dma_disable
[   65.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.130000] imxdma0: next sg chunk dst 0xa6c19200, src 0x10014038, size 0x00000200
[   65.140000] imxdma0: imx_dma_enable
[   65.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.150000] imxdma0: imx_dma_disable
[   65.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.160000] imxdma0: next sg chunk dst 0xa6c19400, src 0x10014038, size 0x00000200
[   65.170000] imxdma0: imx_dma_enable
[   65.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.180000] imxdma0: imx_dma_disable
[   65.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.190000] imxdma0: next sg chunk dst 0xa6c19600, src 0x10014038, size 0x00000200
[   65.200000] imxdma0: imx_dma_enable
[   65.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.210000] imxdma0: imx_dma_disable
[   65.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.220000] imxdma0: next sg chunk dst 0xa6c19800, src 0x10014038, size 0x00000200
[   65.230000] imxdma0: imx_dma_enable
[   65.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.240000] imxdma0: imx_dma_disable
[   65.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.250000] imxdma0: next sg chunk dst 0xa6c19a00, src 0x10014038, size 0x00000200
[   65.260000] imxdma0: imx_dma_enable
[   65.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.270000] imxdma0: imx_dma_disable
[   65.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.280000] imxdma0: next sg chunk dst 0xa6c19c00, src 0x10014038, size 0x00000200
[   65.290000] imxdma0: imx_dma_enable
[   65.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.300000] imxdma0: imx_dma_disable
[   65.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.310000] imxdma0: next sg chunk dst 0xa6c19e00, src 0x10014038, size 0x00000200
[   65.320000] imxdma0: imx_dma_enable
[   65.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.330000] imxdma0: imx_dma_disable
[   65.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.350000] imxdma0: next sg chunk dst 0xa6c1b000, src 0x10014038, size 0x00000200
[   65.350000] imxdma0: imx_dma_enable
[   65.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.360000] imxdma0: imx_dma_disable
[   65.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.380000] imxdma0: next sg chunk dst 0xa6c1b200, src 0x10014038, size 0x00000200
[   65.380000] imxdma0: imx_dma_enable
[   65.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.390000] imxdma0: imx_dma_disable
[   65.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.410000] imxdma0: next sg chunk dst 0xa6c1b400, src 0x10014038, size 0x00000200
[   65.420000] imxdma0: imx_dma_enable
[   65.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.420000] imxdma0: imx_dma_disable
[   65.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.440000] imxdma0: next sg chunk dst 0xa6c1b600, src 0x10014038, size 0x00000200
[   65.450000] imxdma0: imx_dma_enable
[   65.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.460000] imxdma0: imx_dma_disable
[   65.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.470000] imxdma0: next sg chunk dst 0xa6c1b800, src 0x10014038, size 0x00000200
[   65.480000] imxdma0: imx_dma_enable
[   65.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.490000] imxdma0: imx_dma_disable
[   65.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.500000] imxdma0: next sg chunk dst 0xa6c1ba00, src 0x10014038, size 0x00000200
[   65.510000] imxdma0: imx_dma_enable
[   65.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.520000] imxdma0: imx_dma_disable
[   65.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.530000] imxdma0: next sg chunk dst 0xa6c1bc00, src 0x10014038, size 0x00000200
[   65.540000] imxdma0: imx_dma_enable
[   65.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.550000] imxdma0: imx_dma_disable
[   65.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.560000] imxdma0: next sg chunk dst 0xa6c1be00, src 0x10014038, size 0x00000200
[   65.570000] imxdma0: imx_dma_enable
[   65.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.580000] imxdma0: imx_dma_disable
[   65.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.590000] imxdma0: next sg chunk dst 0xa6c1d000, src 0x10014038, size 0x00000200
[   65.600000] imxdma0: imx_dma_enable
[   65.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.610000] imxdma0: imx_dma_disable
[   65.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.620000] imxdma0: next sg chunk dst 0xa6c1d200, src 0x10014038, size 0x00000200
[   65.630000] imxdma0: imx_dma_enable
[   65.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.640000] imxdma0: imx_dma_disable
[   65.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.660000] imxdma0: next sg chunk dst 0xa6c1d400, src 0x10014038, size 0x00000200
[   65.660000] imxdma0: imx_dma_enable
[   65.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.670000] imxdma0: imx_dma_disable
[   65.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.690000] imxdma0: next sg chunk dst 0xa6c1d600, src 0x10014038, size 0x00000200
[   65.690000] imxdma0: imx_dma_enable
[   65.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.700000] imxdma0: imx_dma_disable
[   65.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.720000] imxdma0: next sg chunk dst 0xa6c1d800, src 0x10014038, size 0x00000200
[   65.720000] imxdma0: imx_dma_enable
[   65.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.730000] imxdma0: imx_dma_disable
[   65.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.750000] imxdma0: next sg chunk dst 0xa6c1da00, src 0x10014038, size 0x00000200
[   65.760000] imxdma0: imx_dma_enable
[   65.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.770000] imxdma0: imx_dma_disable
[   65.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.780000] imxdma0: next sg chunk dst 0xa6c1dc00, src 0x10014038, size 0x00000200
[   65.790000] imxdma0: imx_dma_enable
[   65.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.800000] imxdma0: imx_dma_disable
[   65.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.810000] imxdma0: next sg chunk dst 0xa6c1de00, src 0x10014038, size 0x00000200
[   65.820000] imxdma0: imx_dma_enable
[   65.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.830000] imxdma0: imx_dma_disable
[   65.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.840000] imxdma0: next sg chunk dst 0xa6c1f000, src 0x10014038, size 0x00000200
[   65.850000] imxdma0: imx_dma_enable
[   65.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.860000] imxdma0: imx_dma_disable
[   65.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.870000] imxdma0: next sg chunk dst 0xa6c1f200, src 0x10014038, size 0x00000200
[   65.880000] imxdma0: imx_dma_enable
[   65.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.890000] imxdma0: imx_dma_disable
[   65.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.900000] imxdma0: next sg chunk dst 0xa6c1f400, src 0x10014038, size 0x00000200
[   65.910000] imxdma0: imx_dma_enable
[   65.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.920000] imxdma0: imx_dma_disable
[   65.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.930000] imxdma0: next sg chunk dst 0xa6c1f600, src 0x10014038, size 0x00000200
[   65.940000] imxdma0: imx_dma_enable
[   65.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.950000] imxdma0: imx_dma_disable
[   65.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   65.970000] imxdma0: next sg chunk dst 0xa6c1f800, src 0x10014038, size 0x00000200
[   65.970000] imxdma0: imx_dma_enable
[   65.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   65.980000] imxdma0: imx_dma_disable
[   65.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.000000] imxdma0: next sg chunk dst 0xa6c1fa00, src 0x10014038, size 0x00000200
[   66.000000] imxdma0: imx_dma_enable
[   66.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.010000] imxdma0: imx_dma_disable
[   66.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.030000] imxdma0: next sg chunk dst 0xa6c1fc00, src 0x10014038, size 0x00000200
[   66.030000] imxdma0: imx_dma_enable
[   66.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.040000] imxdma0: imx_dma_disable
[   66.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.060000] imxdma0: next sg chunk dst 0xa6c1fe00, src 0x10014038, size 0x00000200
[   66.070000] imxdma0: imx_dma_enable
[   66.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.080000] imxdma0: imx_dma_disable
[   66.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.090000] imxdma0: next sg chunk dst 0xa6c21000, src 0x10014038, size 0x00000200
[   66.100000] imxdma0: imx_dma_enable
[   66.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.110000] imxdma0: imx_dma_disable
[   66.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.120000] imxdma0: next sg chunk dst 0xa6c21200, src 0x10014038, size 0x00000200
[   66.130000] imxdma0: imx_dma_enable
[   66.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.140000] imxdma0: imx_dma_disable
[   66.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.150000] imxdma0: next sg chunk dst 0xa6c21400, src 0x10014038, size 0x00000200
[   66.160000] imxdma0: imx_dma_enable
[   66.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.170000] imxdma0: imx_dma_disable
[   66.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.180000] imxdma0: next sg chunk dst 0xa6c21600, src 0x10014038, size 0x00000200
[   66.190000] imxdma0: imx_dma_enable
[   66.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.200000] imxdma0: imx_dma_disable
[   66.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.210000] imxdma0: next sg chunk dst 0xa6c21800, src 0x10014038, size 0x00000200
[   66.220000] imxdma0: imx_dma_enable
[   66.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.230000] imxdma0: imx_dma_disable
[   66.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.240000] imxdma0: next sg chunk dst 0xa6c21a00, src 0x10014038, size 0x00000200
[   66.250000] imxdma0: imx_dma_enable
[   66.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.260000] imxdma0: imx_dma_disable
[   66.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.280000] imxdma0: next sg chunk dst 0xa6c21c00, src 0x10014038, size 0x00000200
[   66.280000] imxdma0: imx_dma_enable
[   66.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.290000] imxdma0: imx_dma_disable
[   66.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.310000] imxdma0: next sg chunk dst 0xa6c21e00, src 0x10014038, size 0x00000200
[   66.310000] imxdma0: imx_dma_enable
[   66.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.320000] imxdma0: imx_dma_disable
[   66.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.340000] imxdma0: next sg chunk dst 0xa6c23000, src 0x10014038, size 0x00000200
[   66.350000] imxdma0: imx_dma_enable
[   66.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.360000] imxdma0: imx_dma_disable
[   66.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.370000] imxdma0: next sg chunk dst 0xa6c23200, src 0x10014038, size 0x00000200
[   66.380000] imxdma0: imx_dma_enable
[   66.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.390000] imxdma0: imx_dma_disable
[   66.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.400000] imxdma0: next sg chunk dst 0xa6c23400, src 0x10014038, size 0x00000200
[   66.410000] imxdma0: imx_dma_enable
[   66.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.420000] imxdma0: imx_dma_disable
[   66.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.430000] imxdma0: next sg chunk dst 0xa6c23600, src 0x10014038, size 0x00000200
[   66.440000] imxdma0: imx_dma_enable
[   66.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.450000] imxdma0: imx_dma_disable
[   66.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.460000] imxdma0: next sg chunk dst 0xa6c23800, src 0x10014038, size 0x00000200
[   66.470000] imxdma0: imx_dma_enable
[   66.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.480000] imxdma0: imx_dma_disable
[   66.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.490000] imxdma0: next sg chunk dst 0xa6c23a00, src 0x10014038, size 0x00000200
[   66.500000] imxdma0: imx_dma_enable
[   66.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.510000] imxdma0: imx_dma_disable
[   66.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.520000] imxdma0: next sg chunk dst 0xa6c23c00, src 0x10014038, size 0x00000200
[   66.530000] imxdma0: imx_dma_enable
[   66.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.540000] imxdma0: imx_dma_disable
[   66.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.550000] imxdma0: next sg chunk dst 0xa6c23e00, src 0x10014038, size 0x00000200
[   66.560000] imxdma0: imx_dma_enable
[   66.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.570000] imxdma0: imx_dma_disable
[   66.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.590000] imxdma0: next sg chunk dst 0xa6c25000, src 0x10014038, size 0x00000200
[   66.590000] imxdma0: imx_dma_enable
[   66.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.600000] imxdma0: imx_dma_disable
[   66.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.620000] imxdma0: next sg chunk dst 0xa6c25200, src 0x10014038, size 0x00000200
[   66.620000] imxdma0: imx_dma_enable
[   66.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.630000] imxdma0: imx_dma_disable
[   66.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.650000] imxdma0: next sg chunk dst 0xa6c25400, src 0x10014038, size 0x00000200
[   66.660000] imxdma0: imx_dma_enable
[   66.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.660000] imxdma0: imx_dma_disable
[   66.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.680000] imxdma0: next sg chunk dst 0xa6c25600, src 0x10014038, size 0x00000200
[   66.690000] imxdma0: imx_dma_enable
[   66.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.700000] imxdma0: imx_dma_disable
[   66.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.710000] imxdma0: next sg chunk dst 0xa6c25800, src 0x10014038, size 0x00000200
[   66.720000] imxdma0: imx_dma_enable
[   66.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.730000] imxdma0: imx_dma_disable
[   66.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.740000] imxdma0: next sg chunk dst 0xa6c25a00, src 0x10014038, size 0x00000200
[   66.750000] imxdma0: imx_dma_enable
[   66.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.760000] imxdma0: imx_dma_disable
[   66.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.770000] imxdma0: next sg chunk dst 0xa6c25c00, src 0x10014038, size 0x00000200
[   66.780000] imxdma0: imx_dma_enable
[   66.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.790000] imxdma0: imx_dma_disable
[   66.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.800000] imxdma0: next sg chunk dst 0xa6c25e00, src 0x10014038, size 0x00000200
[   66.810000] imxdma0: imx_dma_enable
[   66.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.820000] imxdma0: imx_dma_disable
[   66.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.830000] imxdma0: next sg chunk dst 0xa6c27000, src 0x10014038, size 0x00000200
[   66.840000] imxdma0: imx_dma_enable
[   66.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.850000] imxdma0: imx_dma_disable
[   66.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.860000] imxdma0: next sg chunk dst 0xa6c27200, src 0x10014038, size 0x00000200
[   66.870000] imxdma0: imx_dma_enable
[   66.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.880000] imxdma0: imx_dma_disable
[   66.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.900000] imxdma0: next sg chunk dst 0xa6c27400, src 0x10014038, size 0x00000200
[   66.900000] imxdma0: imx_dma_enable
[   66.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.910000] imxdma0: imx_dma_disable
[   66.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.930000] imxdma0: next sg chunk dst 0xa6c27600, src 0x10014038, size 0x00000200
[   66.930000] imxdma0: imx_dma_enable
[   66.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.940000] imxdma0: imx_dma_disable
[   66.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.960000] imxdma0: next sg chunk dst 0xa6c27800, src 0x10014038, size 0x00000200
[   66.970000] imxdma0: imx_dma_enable
[   66.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   66.980000] imxdma0: imx_dma_disable
[   66.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   66.990000] imxdma0: next sg chunk dst 0xa6c27a00, src 0x10014038, size 0x00000200
[   67.000000] imxdma0: imx_dma_enable
[   67.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.010000] imxdma0: imx_dma_disable
[   67.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.020000] imxdma0: next sg chunk dst 0xa6c27c00, src 0x10014038, size 0x00000200
[   67.030000] imxdma0: imx_dma_enable
[   67.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.040000] imxdma0: imx_dma_disable
[   67.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.050000] imxdma0: next sg chunk dst 0xa6c27e00, src 0x10014038, size 0x00000200
[   67.060000] imxdma0: imx_dma_enable
[   67.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.070000] imxdma0: imx_dma_disable
[   67.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.080000] imxdma0: next sg chunk dst 0xa6c29000, src 0x10014038, size 0x00000200
[   67.090000] imxdma0: imx_dma_enable
[   67.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.100000] imxdma0: imx_dma_disable
[   67.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.110000] imxdma0: next sg chunk dst 0xa6c29200, src 0x10014038, size 0x00000200
[   67.120000] imxdma0: imx_dma_enable
[   67.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.130000] imxdma0: imx_dma_disable
[   67.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.140000] imxdma0: next sg chunk dst 0xa6c29400, src 0x10014038, size 0x00000200
[   67.150000] imxdma0: imx_dma_enable
[   67.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.160000] imxdma0: imx_dma_disable
[   67.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.170000] imxdma0: next sg chunk dst 0xa6c29600, src 0x10014038, size 0x00000200
[   67.180000] imxdma0: imx_dma_enable
[   67.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.190000] imxdma0: imx_dma_disable
[   67.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.210000] imxdma0: next sg chunk dst 0xa6c29800, src 0x10014038, size 0x00000200
[   67.210000] imxdma0: imx_dma_enable
[   67.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.220000] imxdma0: imx_dma_disable
[   67.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.240000] imxdma0: next sg chunk dst 0xa6c29a00, src 0x10014038, size 0x00000200
[   67.240000] imxdma0: imx_dma_enable
[   67.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.250000] imxdma0: imx_dma_disable
[   67.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.270000] imxdma0: next sg chunk dst 0xa6c29c00, src 0x10014038, size 0x00000200
[   67.280000] imxdma0: imx_dma_enable
[   67.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.290000] imxdma0: imx_dma_disable
[   67.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.300000] imxdma0: next sg chunk dst 0xa6c29e00, src 0x10014038, size 0x00000200
[   67.310000] imxdma0: imx_dma_enable
[   67.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.320000] imxdma0: imx_dma_disable
[   67.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.330000] imxdma0: next sg chunk dst 0xa6c2b000, src 0x10014038, size 0x00000200
[   67.340000] imxdma0: imx_dma_enable
[   67.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.350000] imxdma0: imx_dma_disable
[   67.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.360000] imxdma0: next sg chunk dst 0xa6c2b200, src 0x10014038, size 0x00000200
[   67.370000] imxdma0: imx_dma_enable
[   67.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.380000] imxdma0: imx_dma_disable
[   67.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.390000] imxdma0: next sg chunk dst 0xa6c2b400, src 0x10014038, size 0x00000200
[   67.400000] imxdma0: imx_dma_enable
[   67.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.410000] imxdma0: imx_dma_disable
[   67.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.420000] imxdma0: next sg chunk dst 0xa6c2b600, src 0x10014038, size 0x00000200
[   67.430000] imxdma0: imx_dma_enable
[   67.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.440000] imxdma0: imx_dma_disable
[   67.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.450000] imxdma0: next sg chunk dst 0xa6c2b800, src 0x10014038, size 0x00000200
[   67.460000] imxdma0: imx_dma_enable
[   67.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.470000] imxdma0: imx_dma_disable
[   67.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.490000] imxdma0: next sg chunk dst 0xa6c2ba00, src 0x10014038, size 0x00000200
[   67.490000] imxdma0: imx_dma_enable
[   67.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.500000] imxdma0: imx_dma_disable
[   67.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.520000] imxdma0: next sg chunk dst 0xa6c2bc00, src 0x10014038, size 0x00000200
[   67.520000] imxdma0: imx_dma_enable
[   67.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.530000] imxdma0: imx_dma_disable
[   67.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.550000] imxdma0: next sg chunk dst 0xa6c2be00, src 0x10014038, size 0x00000200
[   67.550000] imxdma0: imx_dma_enable
[   67.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.560000] imxdma0: imx_dma_disable
[   67.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.580000] imxdma0: next sg chunk dst 0xa6c2d000, src 0x10014038, size 0x00000200
[   67.590000] imxdma0: imx_dma_enable
[   67.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.600000] imxdma0: imx_dma_disable
[   67.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.610000] imxdma0: next sg chunk dst 0xa6c2d200, src 0x10014038, size 0x00000200
[   67.620000] imxdma0: imx_dma_enable
[   67.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.630000] imxdma0: imx_dma_disable
[   67.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.640000] imxdma0: next sg chunk dst 0xa6c2d400, src 0x10014038, size 0x00000200
[   67.650000] imxdma0: imx_dma_enable
[   67.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.660000] imxdma0: imx_dma_disable
[   67.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.670000] imxdma0: next sg chunk dst 0xa6c2d600, src 0x10014038, size 0x00000200
[   67.680000] imxdma0: imx_dma_enable
[   67.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.690000] imxdma0: imx_dma_disable
[   67.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.700000] imxdma0: next sg chunk dst 0xa6c2d800, src 0x10014038, size 0x00000200
[   67.710000] imxdma0: imx_dma_enable
[   67.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.720000] imxdma0: imx_dma_disable
[   67.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.730000] imxdma0: next sg chunk dst 0xa6c2da00, src 0x10014038, size 0x00000200
[   67.740000] imxdma0: imx_dma_enable
[   67.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.750000] imxdma0: imx_dma_disable
[   67.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.760000] imxdma0: next sg chunk dst 0xa6c2dc00, src 0x10014038, size 0x00000200
[   67.770000] imxdma0: imx_dma_enable
[   67.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.780000] imxdma0: imx_dma_disable
[   67.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.800000] imxdma0: next sg chunk dst 0xa6c2de00, src 0x10014038, size 0x00000200
[   67.800000] imxdma0: imx_dma_enable
[   67.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.810000] imxdma0: imx_dma_disable
[   67.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.830000] imxdma0: next sg chunk dst 0xa6c2f000, src 0x10014038, size 0x00000200
[   67.830000] imxdma0: imx_dma_enable
[   67.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.840000] imxdma0: imx_dma_disable
[   67.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.860000] imxdma0: next sg chunk dst 0xa6c2f200, src 0x10014038, size 0x00000200
[   67.860000] imxdma0: imx_dma_enable
[   67.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.870000] imxdma0: imx_dma_disable
[   67.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.890000] imxdma0: next sg chunk dst 0xa6c2f400, src 0x10014038, size 0x00000200
[   67.900000] imxdma0: imx_dma_enable
[   67.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.910000] imxdma0: imx_dma_disable
[   67.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.920000] imxdma0: next sg chunk dst 0xa6c2f600, src 0x10014038, size 0x00000200
[   67.930000] imxdma0: imx_dma_enable
[   67.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.940000] imxdma0: imx_dma_disable
[   67.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.950000] imxdma0: next sg chunk dst 0xa6c2f800, src 0x10014038, size 0x00000200
[   67.960000] imxdma0: imx_dma_enable
[   67.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   67.970000] imxdma0: imx_dma_disable
[   67.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   67.980000] imxdma0: next sg chunk dst 0xa6c2fa00, src 0x10014038, size 0x00000200
[   67.990000] imxdma0: imx_dma_enable
[   67.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.000000] imxdma0: imx_dma_disable
[   68.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.010000] imxdma0: next sg chunk dst 0xa6c2fc00, src 0x10014038, size 0x00000200
[   68.020000] imxdma0: imx_dma_enable
[   68.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.030000] imxdma0: imx_dma_disable
[   68.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.040000] imxdma0: next sg chunk dst 0xa6c2fe00, src 0x10014038, size 0x00000200
[   68.050000] imxdma0: imx_dma_enable
[   68.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.060000] imxdma0: imx_dma_disable
[   68.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.070000] imxdma0: next sg chunk dst 0xa6c31000, src 0x10014038, size 0x00000200
[   68.080000] imxdma0: imx_dma_enable
[   68.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.090000] imxdma0: imx_dma_disable
[   68.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.110000] imxdma0: next sg chunk dst 0xa6c31200, src 0x10014038, size 0x00000200
[   68.110000] imxdma0: imx_dma_enable
[   68.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.120000] imxdma0: imx_dma_disable
[   68.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.140000] imxdma0: next sg chunk dst 0xa6c31400, src 0x10014038, size 0x00000200
[   68.140000] imxdma0: imx_dma_enable
[   68.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.150000] imxdma0: imx_dma_disable
[   68.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.170000] imxdma0: next sg chunk dst 0xa6c31600, src 0x10014038, size 0x00000200
[   68.170000] imxdma0: imx_dma_enable
[   68.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.180000] imxdma0: imx_dma_disable
[   68.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.200000] imxdma0: next sg chunk dst 0xa6c31800, src 0x10014038, size 0x00000200
[   68.210000] imxdma0: imx_dma_enable
[   68.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.220000] imxdma0: imx_dma_disable
[   68.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.230000] imxdma0: next sg chunk dst 0xa6c31a00, src 0x10014038, size 0x00000200
[   68.240000] imxdma0: imx_dma_enable
[   68.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.250000] imxdma0: imx_dma_disable
[   68.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.260000] imxdma0: next sg chunk dst 0xa6c31c00, src 0x10014038, size 0x00000200
[   68.270000] imxdma0: imx_dma_enable
[   68.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.280000] imxdma0: imx_dma_disable
[   68.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.290000] imxdma0: next sg chunk dst 0xa6c31e00, src 0x10014038, size 0x00000200
[   68.300000] imxdma0: imx_dma_enable
[   68.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.310000] imxdma0: imx_dma_disable
[   68.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.320000] imxdma0: next sg chunk dst 0xa6c33000, src 0x10014038, size 0x00000200
[   68.330000] imxdma0: imx_dma_enable
[   68.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.340000] imxdma0: imx_dma_disable
[   68.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.350000] imxdma0: next sg chunk dst 0xa6c33200, src 0x10014038, size 0x00000200
[   68.360000] imxdma0: imx_dma_enable
[   68.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.370000] imxdma0: imx_dma_disable
[   68.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.380000] imxdma0: next sg chunk dst 0xa6c33400, src 0x10014038, size 0x00000200
[   68.390000] imxdma0: imx_dma_enable
[   68.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.400000] imxdma0: imx_dma_disable
[   68.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.420000] imxdma0: next sg chunk dst 0xa6c33600, src 0x10014038, size 0x00000200
[   68.420000] imxdma0: imx_dma_enable
[   68.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.430000] imxdma0: imx_dma_disable
[   68.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.450000] imxdma0: next sg chunk dst 0xa6c33800, src 0x10014038, size 0x00000200
[   68.450000] imxdma0: imx_dma_enable
[   68.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.460000] imxdma0: imx_dma_disable
[   68.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.480000] imxdma0: next sg chunk dst 0xa6c33a00, src 0x10014038, size 0x00000200
[   68.490000] imxdma0: imx_dma_enable
[   68.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.490000] imxdma0: imx_dma_disable
[   68.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.510000] imxdma0: next sg chunk dst 0xa6c33c00, src 0x10014038, size 0x00000200
[   68.520000] imxdma0: imx_dma_enable
[   68.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.530000] imxdma0: imx_dma_disable
[   68.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.540000] imxdma0: next sg chunk dst 0xa6c33e00, src 0x10014038, size 0x00000200
[   68.550000] imxdma0: imx_dma_enable
[   68.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.560000] imxdma0: imx_dma_disable
[   68.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.570000] imxdma0: next sg chunk dst 0xa6c35000, src 0x10014038, size 0x00000200
[   68.580000] imxdma0: imx_dma_enable
[   68.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.590000] imxdma0: imx_dma_disable
[   68.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.600000] imxdma0: next sg chunk dst 0xa6c35200, src 0x10014038, size 0x00000200
[   68.610000] imxdma0: imx_dma_enable
[   68.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.620000] imxdma0: imx_dma_disable
[   68.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.630000] imxdma0: next sg chunk dst 0xa6c35400, src 0x10014038, size 0x00000200
[   68.640000] imxdma0: imx_dma_enable
[   68.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.650000] imxdma0: imx_dma_disable
[   68.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.660000] imxdma0: next sg chunk dst 0xa6c35600, src 0x10014038, size 0x00000200
[   68.670000] imxdma0: imx_dma_enable
[   68.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.680000] imxdma0: imx_dma_disable
[   68.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.690000] imxdma0: next sg chunk dst 0xa6c35800, src 0x10014038, size 0x00000200
[   68.700000] imxdma0: imx_dma_enable
[   68.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.710000] imxdma0: imx_dma_disable
[   68.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.730000] imxdma0: next sg chunk dst 0xa6c35a00, src 0x10014038, size 0x00000200
[   68.730000] imxdma0: imx_dma_enable
[   68.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.740000] imxdma0: imx_dma_disable
[   68.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.760000] imxdma0: next sg chunk dst 0xa6c35c00, src 0x10014038, size 0x00000200
[   68.760000] imxdma0: imx_dma_enable
[   68.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.770000] imxdma0: imx_dma_disable
[   68.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.790000] imxdma0: next sg chunk dst 0xa6c35e00, src 0x10014038, size 0x00000200
[   68.800000] imxdma0: imx_dma_enable
[   68.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.800000] imxdma0: imx_dma_disable
[   68.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.820000] imxdma0: next sg chunk dst 0xa6c37000, src 0x10014038, size 0x00000200
[   68.830000] imxdma0: imx_dma_enable
[   68.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.840000] imxdma0: imx_dma_disable
[   68.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.850000] imxdma0: next sg chunk dst 0xa6c37200, src 0x10014038, size 0x00000200
[   68.860000] imxdma0: imx_dma_enable
[   68.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.870000] imxdma0: imx_dma_disable
[   68.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.880000] imxdma0: next sg chunk dst 0xa6c37400, src 0x10014038, size 0x00000200
[   68.890000] imxdma0: imx_dma_enable
[   68.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.900000] imxdma0: imx_dma_disable
[   68.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.910000] imxdma0: next sg chunk dst 0xa6c37600, src 0x10014038, size 0x00000200
[   68.920000] imxdma0: imx_dma_enable
[   68.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.930000] imxdma0: imx_dma_disable
[   68.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.940000] imxdma0: next sg chunk dst 0xa6c37800, src 0x10014038, size 0x00000200
[   68.950000] imxdma0: imx_dma_enable
[   68.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.960000] imxdma0: imx_dma_disable
[   68.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   68.970000] imxdma0: next sg chunk dst 0xa6c37a00, src 0x10014038, size 0x00000200
[   68.980000] imxdma0: imx_dma_enable
[   68.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   68.990000] imxdma0: imx_dma_disable
[   68.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.000000] imxdma0: next sg chunk dst 0xa6c39600, src 0x10014038, size 0x00000200
[   69.010000] imxdma0: imx_dma_enable
[   69.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.020000] imxdma0: imx_dma_disable
[   69.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.040000] imxdma0: next sg chunk dst 0xa6c39800, src 0x10014038, size 0x00000200
[   69.040000] imxdma0: imx_dma_enable
[   69.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.050000] imxdma0: imx_dma_disable
[   69.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.070000] imxdma0: next sg chunk dst 0xa6c39a00, src 0x10014038, size 0x00000200
[   69.070000] imxdma0: imx_dma_enable
[   69.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.080000] imxdma0: imx_dma_disable
[   69.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.100000] imxdma0: next sg chunk dst 0xa6c39c00, src 0x10014038, size 0x00000200
[   69.110000] imxdma0: imx_dma_enable
[   69.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.110000] imxdma0: imx_dma_disable
[   69.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.130000] imxdma0: next sg chunk dst 0xa6c39e00, src 0x10014038, size 0x00000200
[   69.140000] imxdma0: imx_dma_enable
[   69.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.150000] imxdma0: imx_dma_disable
[   69.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.160000] imxdma0: next sg chunk dst 0xa6c3b000, src 0x10014038, size 0x00000200
[   69.170000] imxdma0: imx_dma_enable
[   69.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.180000] imxdma0: imx_dma_disable
[   69.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.190000] imxdma0: next sg chunk dst 0xa6c3b200, src 0x10014038, size 0x00000200
[   69.200000] imxdma0: imx_dma_enable
[   69.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.210000] imxdma0: imx_dma_disable
[   69.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.220000] imxdma0: next sg chunk dst 0xa6c3b400, src 0x10014038, size 0x00000200
[   69.230000] imxdma0: imx_dma_enable
[   69.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.240000] imxdma0: imx_dma_disable
[   69.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.250000] imxdma0: next sg chunk dst 0xa6c3b600, src 0x10014038, size 0x00000200
[   69.260000] imxdma0: imx_dma_enable
[   69.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.270000] imxdma0: imx_dma_disable
[   69.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.280000] imxdma0: next sg chunk dst 0xa6c3b800, src 0x10014038, size 0x00000200
[   69.290000] imxdma0: imx_dma_enable
[   69.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.300000] imxdma0: imx_dma_disable
[   69.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.310000] imxdma0: next sg chunk dst 0xa6c3ba00, src 0x10014038, size 0x00000200
[   69.320000] imxdma0: imx_dma_enable
[   69.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.330000] imxdma0: imx_dma_disable
[   69.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.350000] imxdma0: next sg chunk dst 0xa6c3bc00, src 0x10014038, size 0x00000200
[   69.350000] imxdma0: imx_dma_enable
[   69.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.360000] imxdma0: imx_dma_disable
[   69.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.380000] imxdma0: next sg chunk dst 0xa6c3be00, src 0x10014038, size 0x00000200
[   69.380000] imxdma0: imx_dma_enable
[   69.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.390000] imxdma0: imx_dma_disable
[   69.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.410000] imxdma0: next sg chunk dst 0xa6c3d000, src 0x10014038, size 0x00000200
[   69.420000] imxdma0: imx_dma_enable
[   69.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.430000] imxdma0: imx_dma_disable
[   69.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.440000] imxdma0: next sg chunk dst 0xa6c3d200, src 0x10014038, size 0x00000200
[   69.450000] imxdma0: imx_dma_enable
[   69.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.460000] imxdma0: imx_dma_disable
[   69.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.470000] imxdma0: next sg chunk dst 0xa6c3d400, src 0x10014038, size 0x00000200
[   69.480000] imxdma0: imx_dma_enable
[   69.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.490000] imxdma0: imx_dma_disable
[   69.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.500000] imxdma0: next sg chunk dst 0xa6c3d600, src 0x10014038, size 0x00000200
[   69.510000] imxdma0: imx_dma_enable
[   69.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.520000] imxdma0: imx_dma_disable
[   69.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.530000] imxdma0: next sg chunk dst 0xa6c3d800, src 0x10014038, size 0x00000200
[   69.540000] imxdma0: imx_dma_enable
[   69.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.550000] imxdma0: imx_dma_disable
[   69.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.560000] imxdma0: next sg chunk dst 0xa6c3da00, src 0x10014038, size 0x00000200
[   69.570000] imxdma0: imx_dma_enable
[   69.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.580000] imxdma0: imx_dma_disable
[   69.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.590000] imxdma0: next sg chunk dst 0xa6c3dc00, src 0x10014038, size 0x00000200
[   69.600000] imxdma0: imx_dma_enable
[   69.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.610000] imxdma0: imx_dma_disable
[   69.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.620000] imxdma0: next sg chunk dst 0xa6c3de00, src 0x10014038, size 0x00000200
[   69.630000] imxdma0: imx_dma_enable
[   69.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.640000] imxdma0: imx_dma_disable
[   69.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.660000] imxdma0: next sg chunk dst 0xa6c3f000, src 0x10014038, size 0x00000200
[   69.660000] imxdma0: imx_dma_enable
[   69.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.670000] imxdma0: imx_dma_disable
[   69.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.690000] imxdma0: next sg chunk dst 0xa6c3f200, src 0x10014038, size 0x00000200
[   69.690000] imxdma0: imx_dma_enable
[   69.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.700000] imxdma0: imx_dma_disable
[   69.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.720000] imxdma0: next sg chunk dst 0xa6c3f400, src 0x10014038, size 0x00000200
[   69.730000] imxdma0: imx_dma_enable
[   69.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.740000] imxdma0: imx_dma_disable
[   69.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.750000] imxdma0: next sg chunk dst 0xa6c3f600, src 0x10014038, size 0x00000200
[   69.760000] imxdma0: imx_dma_enable
[   69.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.770000] imxdma0: imx_dma_disable
[   69.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.780000] imxdma0: next sg chunk dst 0xa6c3f800, src 0x10014038, size 0x00000200
[   69.790000] imxdma0: imx_dma_enable
[   69.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.800000] imxdma0: imx_dma_disable
[   69.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.810000] imxdma0: next sg chunk dst 0xa6c3fa00, src 0x10014038, size 0x00000200
[   69.820000] imxdma0: imx_dma_enable
[   69.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.830000] imxdma0: imx_dma_disable
[   69.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.840000] imxdma0: next sg chunk dst 0xa6c3fc00, src 0x10014038, size 0x00000200
[   69.850000] imxdma0: imx_dma_enable
[   69.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.860000] imxdma0: imx_dma_disable
[   69.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.870000] imxdma0: next sg chunk dst 0xa6c3fe00, src 0x10014038, size 0x00000200
[   69.880000] imxdma0: imx_dma_enable
[   69.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.890000] imxdma0: imx_dma_disable
[   69.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.900000] imxdma0: next sg chunk dst 0xa6c41000, src 0x10014038, size 0x00000200
[   69.910000] imxdma0: imx_dma_enable
[   69.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.920000] imxdma0: imx_dma_disable
[   69.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.940000] imxdma0: next sg chunk dst 0xa6c41200, src 0x10014038, size 0x00000200
[   69.940000] imxdma0: imx_dma_enable
[   69.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.950000] imxdma0: imx_dma_disable
[   69.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   69.970000] imxdma0: next sg chunk dst 0xa6c41400, src 0x10014038, size 0x00000200
[   69.970000] imxdma0: imx_dma_enable
[   69.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   69.980000] imxdma0: imx_dma_disable
[   69.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.000000] imxdma0: next sg chunk dst 0xa6c41600, src 0x10014038, size 0x00000200
[   70.000000] imxdma0: imx_dma_enable
[   70.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.010000] imxdma0: imx_dma_disable
[   70.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.030000] imxdma0: next sg chunk dst 0xa6c41800, src 0x10014038, size 0x00000200
[   70.040000] imxdma0: imx_dma_enable
[   70.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.050000] imxdma0: imx_dma_disable
[   70.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.060000] imxdma0: next sg chunk dst 0xa6c41a00, src 0x10014038, size 0x00000200
[   70.070000] imxdma0: imx_dma_enable
[   70.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.080000] imxdma0: imx_dma_disable
[   70.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.090000] imxdma0: next sg chunk dst 0xa6c41c00, src 0x10014038, size 0x00000200
[   70.100000] imxdma0: imx_dma_enable
[   70.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.110000] imxdma0: imx_dma_disable
[   70.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.120000] imxdma0: next sg chunk dst 0xa6c41e00, src 0x10014038, size 0x00000200
[   70.130000] imxdma0: imx_dma_enable
[   70.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.140000] imxdma0: imx_dma_disable
[   70.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.150000] imxdma0: next sg chunk dst 0xa6c43000, src 0x10014038, size 0x00000200
[   70.160000] imxdma0: imx_dma_enable
[   70.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.170000] imxdma0: imx_dma_disable
[   70.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.180000] imxdma0: next sg chunk dst 0xa6c43200, src 0x10014038, size 0x00000200
[   70.190000] imxdma0: imx_dma_enable
[   70.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.200000] imxdma0: imx_dma_disable
[   70.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.210000] imxdma0: next sg chunk dst 0xa6c43400, src 0x10014038, size 0x00000200
[   70.220000] imxdma0: imx_dma_enable
[   70.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.230000] imxdma0: imx_dma_disable
[   70.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.250000] imxdma0: next sg chunk dst 0xa6c43600, src 0x10014038, size 0x00000200
[   70.250000] imxdma0: imx_dma_enable
[   70.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.260000] imxdma0: imx_dma_disable
[   70.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.280000] imxdma0: next sg chunk dst 0xa6c43800, src 0x10014038, size 0x00000200
[   70.280000] imxdma0: imx_dma_enable
[   70.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.290000] imxdma0: imx_dma_disable
[   70.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.310000] imxdma0: next sg chunk dst 0xa6c43a00, src 0x10014038, size 0x00000200
[   70.320000] imxdma0: imx_dma_enable
[   70.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.320000] imxdma0: imx_dma_disable
[   70.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.340000] imxdma0: next sg chunk dst 0xa6c43c00, src 0x10014038, size 0x00000200
[   70.350000] imxdma0: imx_dma_enable
[   70.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.360000] imxdma0: imx_dma_disable
[   70.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.370000] imxdma0: next sg chunk dst 0xa6c43e00, src 0x10014038, size 0x00000200
[   70.380000] imxdma0: imx_dma_enable
[   70.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.390000] imxdma0: imx_dma_disable
[   70.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.400000] imxdma0: next sg chunk dst 0xa6c45000, src 0x10014038, size 0x00000200
[   70.410000] imxdma0: imx_dma_enable
[   70.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.420000] imxdma0: imx_dma_disable
[   70.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.430000] imxdma0: next sg chunk dst 0xa6c45200, src 0x10014038, size 0x00000200
[   70.440000] imxdma0: imx_dma_enable
[   70.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.450000] imxdma0: imx_dma_disable
[   70.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.460000] imxdma0: next sg chunk dst 0xa6c45400, src 0x10014038, size 0x00000200
[   70.470000] imxdma0: imx_dma_enable
[   70.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.480000] imxdma0: imx_dma_disable
[   70.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.490000] imxdma0: next sg chunk dst 0xa6c45600, src 0x10014038, size 0x00000200
[   70.500000] imxdma0: imx_dma_enable
[   70.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.510000] imxdma0: imx_dma_disable
[   70.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.520000] imxdma0: next sg chunk dst 0xa6c45800, src 0x10014038, size 0x00000200
[   70.530000] imxdma0: imx_dma_enable
[   70.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.540000] imxdma0: imx_dma_disable
[   70.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.560000] imxdma0: next sg chunk dst 0xa6c45a00, src 0x10014038, size 0x00000200
[   70.560000] imxdma0: imx_dma_enable
[   70.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.570000] imxdma0: imx_dma_disable
[   70.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.590000] imxdma0: next sg chunk dst 0xa6c45c00, src 0x10014038, size 0x00000200
[   70.590000] imxdma0: imx_dma_enable
[   70.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.600000] imxdma0: imx_dma_disable
[   70.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.620000] imxdma0: next sg chunk dst 0xa6c45e00, src 0x10014038, size 0x00000200
[   70.630000] imxdma0: imx_dma_enable
[   70.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.630000] imxdma0: imx_dma_disable
[   70.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.650000] imxdma0: next sg chunk dst 0xa6c47000, src 0x10014038, size 0x00000200
[   70.660000] imxdma0: imx_dma_enable
[   70.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.670000] imxdma0: imx_dma_disable
[   70.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.680000] imxdma0: next sg chunk dst 0xa6c47200, src 0x10014038, size 0x00000200
[   70.690000] imxdma0: imx_dma_enable
[   70.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.700000] imxdma0: imx_dma_disable
[   70.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.710000] imxdma0: next sg chunk dst 0xa6c47400, src 0x10014038, size 0x00000200
[   70.720000] imxdma0: imx_dma_enable
[   70.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.730000] imxdma0: imx_dma_disable
[   70.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.740000] imxdma0: next sg chunk dst 0xa6c47600, src 0x10014038, size 0x00000200
[   70.750000] imxdma0: imx_dma_enable
[   70.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.760000] imxdma0: imx_dma_disable
[   70.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.770000] imxdma0: next sg chunk dst 0xa6c47800, src 0x10014038, size 0x00000200
[   70.780000] imxdma0: imx_dma_enable
[   70.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.790000] imxdma0: imx_dma_disable
[   70.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.800000] imxdma0: next sg chunk dst 0xa6c47a00, src 0x10014038, size 0x00000200
[   70.810000] imxdma0: imx_dma_enable
[   70.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.820000] imxdma0: imx_dma_disable
[   70.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.830000] imxdma0: next sg chunk dst 0xa6c47c00, src 0x10014038, size 0x00000200
[   70.840000] imxdma0: imx_dma_enable
[   70.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.850000] imxdma0: imx_dma_disable
[   70.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.870000] imxdma0: next sg chunk dst 0xa6c47e00, src 0x10014038, size 0x00000200
[   70.870000] imxdma0: imx_dma_enable
[   70.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.880000] imxdma0: imx_dma_disable
[   70.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.900000] imxdma0: next sg chunk dst 0xa6c49000, src 0x10014038, size 0x00000200
[   70.900000] imxdma0: imx_dma_enable
[   70.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.910000] imxdma0: imx_dma_disable
[   70.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.930000] imxdma0: next sg chunk dst 0xa6c49200, src 0x10014038, size 0x00000200
[   70.940000] imxdma0: imx_dma_enable
[   70.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.940000] imxdma0: imx_dma_disable
[   70.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.960000] imxdma0: next sg chunk dst 0xa6c49400, src 0x10014038, size 0x00000200
[   70.970000] imxdma0: imx_dma_enable
[   70.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   70.980000] imxdma0: imx_dma_disable
[   70.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   70.990000] imxdma0: next sg chunk dst 0xa6c49600, src 0x10014038, size 0x00000200
[   71.000000] imxdma0: imx_dma_enable
[   71.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.010000] imxdma0: imx_dma_disable
[   71.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.020000] imxdma0: next sg chunk dst 0xa6c49800, src 0x10014038, size 0x00000200
[   71.030000] imxdma0: imx_dma_enable
[   71.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.040000] imxdma0: imx_dma_disable
[   71.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.050000] imxdma0: next sg chunk dst 0xa6c49a00, src 0x10014038, size 0x00000200
[   71.060000] imxdma0: imx_dma_enable
[   71.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.070000] imxdma0: imx_dma_disable
[   71.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.080000] imxdma0: next sg chunk dst 0xa6c49c00, src 0x10014038, size 0x00000200
[   71.090000] imxdma0: imx_dma_enable
[   71.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.100000] imxdma0: imx_dma_disable
[   71.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.110000] imxdma0: next sg chunk dst 0xa6c49e00, src 0x10014038, size 0x00000200
[   71.120000] imxdma0: imx_dma_enable
[   71.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.130000] imxdma0: imx_dma_disable
[   71.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.140000] imxdma0: next sg chunk dst 0xa6c4b000, src 0x10014038, size 0x00000200
[   71.150000] imxdma0: imx_dma_enable
[   71.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.160000] imxdma0: imx_dma_disable
[   71.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.180000] imxdma0: next sg chunk dst 0xa6c4b200, src 0x10014038, size 0x00000200
[   71.180000] imxdma0: imx_dma_enable
[   71.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.190000] imxdma0: imx_dma_disable
[   71.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.210000] imxdma0: next sg chunk dst 0xa6c4b400, src 0x10014038, size 0x00000200
[   71.210000] imxdma0: imx_dma_enable
[   71.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.220000] imxdma0: imx_dma_disable
[   71.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.240000] imxdma0: next sg chunk dst 0xa6c4b600, src 0x10014038, size 0x00000200
[   71.240000] imxdma0: imx_dma_enable
[   71.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.250000] imxdma0: imx_dma_disable
[   71.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.270000] imxdma0: next sg chunk dst 0xa6c4b800, src 0x10014038, size 0x00000200
[   71.280000] imxdma0: imx_dma_enable
[   71.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.290000] imxdma0: imx_dma_disable
[   71.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.300000] imxdma0: next sg chunk dst 0xa6c4ba00, src 0x10014038, size 0x00000200
[   71.310000] imxdma0: imx_dma_enable
[   71.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.320000] imxdma0: imx_dma_disable
[   71.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.330000] imxdma0: next sg chunk dst 0xa6c4bc00, src 0x10014038, size 0x00000200
[   71.340000] imxdma0: imx_dma_enable
[   71.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.350000] imxdma0: imx_dma_disable
[   71.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.360000] imxdma0: next sg chunk dst 0xa6c4be00, src 0x10014038, size 0x00000200
[   71.370000] imxdma0: imx_dma_enable
[   71.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.380000] imxdma0: imx_dma_disable
[   71.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.390000] imxdma0: next sg chunk dst 0xa6c4d000, src 0x10014038, size 0x00000200
[   71.400000] imxdma0: imx_dma_enable
[   71.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.410000] imxdma0: imx_dma_disable
[   71.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.420000] imxdma0: next sg chunk dst 0xa6c4d200, src 0x10014038, size 0x00000200
[   71.430000] imxdma0: imx_dma_enable
[   71.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.440000] imxdma0: imx_dma_disable
[   71.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.450000] imxdma0: next sg chunk dst 0xa6c4d400, src 0x10014038, size 0x00000200
[   71.460000] imxdma0: imx_dma_enable
[   71.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.470000] imxdma0: imx_dma_disable
[   71.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.490000] imxdma0: next sg chunk dst 0xa6c4d600, src 0x10014038, size 0x00000200
[   71.490000] imxdma0: imx_dma_enable
[   71.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.500000] imxdma0: imx_dma_disable
[   71.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.520000] imxdma0: next sg chunk dst 0xa6c4d800, src 0x10014038, size 0x00000200
[   71.520000] imxdma0: imx_dma_enable
[   71.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.530000] imxdma0: imx_dma_disable
[   71.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.550000] imxdma0: next sg chunk dst 0xa6c4da00, src 0x10014038, size 0x00000200
[   71.560000] imxdma0: imx_dma_enable
[   71.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.560000] imxdma0: imx_dma_disable
[   71.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.580000] imxdma0: next sg chunk dst 0xa6c4dc00, src 0x10014038, size 0x00000200
[   71.590000] imxdma0: imx_dma_enable
[   71.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.600000] imxdma0: imx_dma_disable
[   71.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.610000] imxdma0: next sg chunk dst 0xa6c4de00, src 0x10014038, size 0x00000200
[   71.620000] imxdma0: imx_dma_enable
[   71.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.630000] imxdma0: imx_dma_disable
[   71.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.640000] imxdma0: next sg chunk dst 0xa6c4f000, src 0x10014038, size 0x00000200
[   71.650000] imxdma0: imx_dma_enable
[   71.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.660000] imxdma0: imx_dma_disable
[   71.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.670000] imxdma0: next sg chunk dst 0xa6c4f200, src 0x10014038, size 0x00000200
[   71.680000] imxdma0: imx_dma_enable
[   71.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.690000] imxdma0: imx_dma_disable
[   71.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.700000] imxdma0: next sg chunk dst 0xa6c4f400, src 0x10014038, size 0x00000200
[   71.710000] imxdma0: imx_dma_enable
[   71.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.720000] imxdma0: imx_dma_disable
[   71.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.730000] imxdma0: next sg chunk dst 0xa6c4f600, src 0x10014038, size 0x00000200
[   71.740000] imxdma0: imx_dma_enable
[   71.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.750000] imxdma0: imx_dma_disable
[   71.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.760000] imxdma0: next sg chunk dst 0xa6c4f800, src 0x10014038, size 0x00000200
[   71.770000] imxdma0: imx_dma_enable
[   71.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.780000] imxdma0: imx_dma_disable
[   71.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.800000] imxdma0: next sg chunk dst 0xa6c4fa00, src 0x10014038, size 0x00000200
[   71.800000] imxdma0: imx_dma_enable
[   71.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.810000] imxdma0: imx_dma_disable
[   71.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.830000] imxdma0: next sg chunk dst 0xa6c4fc00, src 0x10014038, size 0x00000200
[   71.830000] imxdma0: imx_dma_enable
[   71.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.840000] imxdma0: imx_dma_disable
[   71.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.860000] imxdma0: next sg chunk dst 0xa6c4fe00, src 0x10014038, size 0x00000200
[   71.870000] imxdma0: imx_dma_enable
[   71.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.870000] imxdma0: imx_dma_disable
[   71.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.890000] imxdma0: next sg chunk dst 0xa6c51000, src 0x10014038, size 0x00000200
[   71.900000] imxdma0: imx_dma_enable
[   71.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.910000] imxdma0: imx_dma_disable
[   71.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.920000] imxdma0: next sg chunk dst 0xa6c51200, src 0x10014038, size 0x00000200
[   71.930000] imxdma0: imx_dma_enable
[   71.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.940000] imxdma0: imx_dma_disable
[   71.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.950000] imxdma0: next sg chunk dst 0xa6c51400, src 0x10014038, size 0x00000200
[   71.960000] imxdma0: imx_dma_enable
[   71.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   71.970000] imxdma0: imx_dma_disable
[   71.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   71.980000] imxdma0: next sg chunk dst 0xa6c51600, src 0x10014038, size 0x00000200
[   71.990000] imxdma0: imx_dma_enable
[   71.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.000000] imxdma0: imx_dma_disable
[   72.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.010000] imxdma0: next sg chunk dst 0xa6c51800, src 0x10014038, size 0x00000200
[   72.020000] imxdma0: imx_dma_enable
[   72.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.030000] imxdma0: imx_dma_disable
[   72.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.040000] imxdma0: next sg chunk dst 0xa6c51a00, src 0x10014038, size 0x00000200
[   72.050000] imxdma0: imx_dma_enable
[   72.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.060000] imxdma0: imx_dma_disable
[   72.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.070000] imxdma0: next sg chunk dst 0xa6c51c00, src 0x10014038, size 0x00000200
[   72.080000] imxdma0: imx_dma_enable
[   72.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.090000] imxdma0: imx_dma_disable
[   72.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.110000] imxdma0: next sg chunk dst 0xa6c51e00, src 0x10014038, size 0x00000200
[   72.110000] imxdma0: imx_dma_enable
[   72.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.120000] imxdma0: imx_dma_disable
[   72.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.140000] imxdma0: next sg chunk dst 0xa6c53000, src 0x10014038, size 0x00000200
[   72.140000] imxdma0: imx_dma_enable
[   72.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.150000] imxdma0: imx_dma_disable
[   72.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.170000] imxdma0: next sg chunk dst 0xa6c53200, src 0x10014038, size 0x00000200
[   72.180000] imxdma0: imx_dma_enable
[   72.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.190000] imxdma0: imx_dma_disable
[   72.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.200000] imxdma0: next sg chunk dst 0xa6c53400, src 0x10014038, size 0x00000200
[   72.210000] imxdma0: imx_dma_enable
[   72.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.220000] imxdma0: imx_dma_disable
[   72.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.230000] imxdma0: next sg chunk dst 0xa6c53600, src 0x10014038, size 0x00000200
[   72.240000] imxdma0: imx_dma_enable
[   72.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.250000] imxdma0: imx_dma_disable
[   72.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.260000] imxdma0: next sg chunk dst 0xa6c53800, src 0x10014038, size 0x00000200
[   72.270000] imxdma0: imx_dma_enable
[   72.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.280000] imxdma0: imx_dma_disable
[   72.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.290000] imxdma0: next sg chunk dst 0xa6c53a00, src 0x10014038, size 0x00000200
[   72.300000] imxdma0: imx_dma_enable
[   72.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.310000] imxdma0: imx_dma_disable
[   72.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.320000] imxdma0: next sg chunk dst 0xa6c53c00, src 0x10014038, size 0x00000200
[   72.330000] imxdma0: imx_dma_enable
[   72.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.340000] imxdma0: imx_dma_disable
[   72.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.350000] imxdma0: next sg chunk dst 0xa6c53e00, src 0x10014038, size 0x00000200
[   72.360000] imxdma0: imx_dma_enable
[   72.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.370000] imxdma0: imx_dma_disable
[   72.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.390000] imxdma0: next sg chunk dst 0xa6c55000, src 0x10014038, size 0x00000200
[   72.390000] imxdma0: imx_dma_enable
[   72.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.400000] imxdma0: imx_dma_disable
[   72.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.420000] imxdma0: next sg chunk dst 0xa6c55200, src 0x10014038, size 0x00000200
[   72.420000] imxdma0: imx_dma_enable
[   72.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.430000] imxdma0: imx_dma_disable
[   72.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.450000] imxdma0: next sg chunk dst 0xa6c55400, src 0x10014038, size 0x00000200
[   72.450000] imxdma0: imx_dma_enable
[   72.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.460000] imxdma0: imx_dma_disable
[   72.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.480000] imxdma0: next sg chunk dst 0xa6c55600, src 0x10014038, size 0x00000200
[   72.490000] imxdma0: imx_dma_enable
[   72.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.500000] imxdma0: imx_dma_disable
[   72.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.510000] imxdma0: next sg chunk dst 0xa6c55800, src 0x10014038, size 0x00000200
[   72.520000] imxdma0: imx_dma_enable
[   72.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.530000] imxdma0: imx_dma_disable
[   72.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.540000] imxdma0: next sg chunk dst 0xa6c55a00, src 0x10014038, size 0x00000200
[   72.550000] imxdma0: imx_dma_enable
[   72.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.560000] imxdma0: imx_dma_disable
[   72.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.570000] imxdma0: next sg chunk dst 0xa6c55c00, src 0x10014038, size 0x00000200
[   72.580000] imxdma0: imx_dma_enable
[   72.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.590000] imxdma0: imx_dma_disable
[   72.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.600000] imxdma0: next sg chunk dst 0xa6c55e00, src 0x10014038, size 0x00000200
[   72.610000] imxdma0: imx_dma_enable
[   72.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.620000] imxdma0: imx_dma_disable
[   72.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.630000] imxdma0: next sg chunk dst 0xa6c57000, src 0x10014038, size 0x00000200
[   72.640000] imxdma0: imx_dma_enable
[   72.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.650000] imxdma0: imx_dma_disable
[   72.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.660000] imxdma0: next sg chunk dst 0xa6c57200, src 0x10014038, size 0x00000200
[   72.670000] imxdma0: imx_dma_enable
[   72.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.680000] imxdma0: imx_dma_disable
[   72.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.700000] imxdma0: next sg chunk dst 0xa6c57400, src 0x10014038, size 0x00000200
[   72.700000] imxdma0: imx_dma_enable
[   72.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.710000] imxdma0: imx_dma_disable
[   72.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.730000] imxdma0: next sg chunk dst 0xa6c57600, src 0x10014038, size 0x00000200
[   72.730000] imxdma0: imx_dma_enable
[   72.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.740000] imxdma0: imx_dma_disable
[   72.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.760000] imxdma0: next sg chunk dst 0xa6c57800, src 0x10014038, size 0x00000200
[   72.760000] imxdma0: imx_dma_enable
[   72.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.770000] imxdma0: imx_dma_disable
[   72.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.790000] imxdma0: next sg chunk dst 0xa6c57a00, src 0x10014038, size 0x00000200
[   72.800000] imxdma0: imx_dma_enable
[   72.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.810000] imxdma0: imx_dma_disable
[   72.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.820000] imxdma0: next sg chunk dst 0xa6c57c00, src 0x10014038, size 0x00000200
[   72.830000] imxdma0: imx_dma_enable
[   72.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.840000] imxdma0: imx_dma_disable
[   72.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.850000] imxdma0: next sg chunk dst 0xa6c57e00, src 0x10014038, size 0x00000200
[   72.860000] imxdma0: imx_dma_enable
[   72.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.870000] imxdma0: imx_dma_disable
[   72.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.880000] imxdma0: next sg chunk dst 0xa6c59000, src 0x10014038, size 0x00000200
[   72.890000] imxdma0: imx_dma_enable
[   72.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.900000] imxdma0: imx_dma_disable
[   72.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.910000] imxdma0: next sg chunk dst 0xa6c59200, src 0x10014038, size 0x00000200
[   72.920000] imxdma0: imx_dma_enable
[   72.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.930000] imxdma0: imx_dma_disable
[   72.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.940000] imxdma0: next sg chunk dst 0xa6c59400, src 0x10014038, size 0x00000200
[   72.950000] imxdma0: imx_dma_enable
[   72.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.960000] imxdma0: imx_dma_disable
[   72.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   72.970000] imxdma0: next sg chunk dst 0xa6c59600, src 0x10014038, size 0x00000200
[   72.980000] imxdma0: imx_dma_enable
[   72.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   72.990000] imxdma0: imx_dma_disable
[   73.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.010000] imxdma0: next sg chunk dst 0xa6c59800, src 0x10014038, size 0x00000200
[   73.010000] imxdma0: imx_dma_enable
[   73.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.020000] imxdma0: imx_dma_disable
[   73.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.040000] imxdma0: next sg chunk dst 0xa6c59a00, src 0x10014038, size 0x00000200
[   73.040000] imxdma0: imx_dma_enable
[   73.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.050000] imxdma0: imx_dma_disable
[   73.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.070000] imxdma0: next sg chunk dst 0xa6c59c00, src 0x10014038, size 0x00000200
[   73.070000] imxdma0: imx_dma_enable
[   73.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.080000] imxdma0: imx_dma_disable
[   73.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.100000] imxdma0: next sg chunk dst 0xa6c59e00, src 0x10014038, size 0x00000200
[   73.110000] imxdma0: imx_dma_enable
[   73.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.120000] imxdma0: imx_dma_disable
[   73.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.130000] imxdma0: next sg chunk dst 0xa6c5b000, src 0x10014038, size 0x00000200
[   73.140000] imxdma0: imx_dma_enable
[   73.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.150000] imxdma0: imx_dma_disable
[   73.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.160000] imxdma0: next sg chunk dst 0xa6c5b200, src 0x10014038, size 0x00000200
[   73.170000] imxdma0: imx_dma_enable
[   73.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.180000] imxdma0: imx_dma_disable
[   73.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.190000] imxdma0: next sg chunk dst 0xa6c5b400, src 0x10014038, size 0x00000200
[   73.200000] imxdma0: imx_dma_enable
[   73.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.210000] imxdma0: imx_dma_disable
[   73.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.220000] imxdma0: next sg chunk dst 0xa6c5b600, src 0x10014038, size 0x00000200
[   73.230000] imxdma0: imx_dma_enable
[   73.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.240000] imxdma0: imx_dma_disable
[   73.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.250000] imxdma0: next sg chunk dst 0xa6c5b800, src 0x10014038, size 0x00000200
[   73.260000] imxdma0: imx_dma_enable
[   73.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.270000] imxdma0: imx_dma_disable
[   73.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.280000] imxdma0: next sg chunk dst 0xa6c5ba00, src 0x10014038, size 0x00000200
[   73.290000] imxdma0: imx_dma_enable
[   73.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.300000] imxdma0: imx_dma_disable
[   73.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.320000] imxdma0: next sg chunk dst 0xa6c5bc00, src 0x10014038, size 0x00000200
[   73.320000] imxdma0: imx_dma_enable
[   73.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.330000] imxdma0: imx_dma_disable
[   73.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.350000] imxdma0: next sg chunk dst 0xa6c5be00, src 0x10014038, size 0x00000200
[   73.350000] imxdma0: imx_dma_enable
[   73.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.360000] imxdma0: imx_dma_disable
[   73.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.380000] imxdma0: next sg chunk dst 0xa6c5d000, src 0x10014038, size 0x00000200
[   73.390000] imxdma0: imx_dma_enable
[   73.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.390000] imxdma0: imx_dma_disable
[   73.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.410000] imxdma0: next sg chunk dst 0xa6c5d200, src 0x10014038, size 0x00000200
[   73.420000] imxdma0: imx_dma_enable
[   73.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.430000] imxdma0: imx_dma_disable
[   73.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.440000] imxdma0: next sg chunk dst 0xa6c5d400, src 0x10014038, size 0x00000200
[   73.450000] imxdma0: imx_dma_enable
[   73.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.460000] imxdma0: imx_dma_disable
[   73.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.470000] imxdma0: next sg chunk dst 0xa6c5d600, src 0x10014038, size 0x00000200
[   73.480000] imxdma0: imx_dma_enable
[   73.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.490000] imxdma0: imx_dma_disable
[   73.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.500000] imxdma0: next sg chunk dst 0xa6c5d800, src 0x10014038, size 0x00000200
[   73.510000] imxdma0: imx_dma_enable
[   73.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.520000] imxdma0: imx_dma_disable
[   73.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.530000] imxdma0: next sg chunk dst 0xa6c5da00, src 0x10014038, size 0x00000200
[   73.540000] imxdma0: imx_dma_enable
[   73.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.550000] imxdma0: imx_dma_disable
[   73.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.560000] imxdma0: next sg chunk dst 0xa6c5dc00, src 0x10014038, size 0x00000200
[   73.570000] imxdma0: imx_dma_enable
[   73.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.580000] imxdma0: imx_dma_disable
[   73.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.590000] imxdma0: next sg chunk dst 0xa6c5de00, src 0x10014038, size 0x00000200
[   73.600000] imxdma0: imx_dma_enable
[   73.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.610000] imxdma0: imx_dma_disable
[   73.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.630000] imxdma0: next sg chunk dst 0xa6c5f000, src 0x10014038, size 0x00000200
[   73.630000] imxdma0: imx_dma_enable
[   73.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.640000] imxdma0: imx_dma_disable
[   73.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.660000] imxdma0: next sg chunk dst 0xa6c5f200, src 0x10014038, size 0x00000200
[   73.660000] imxdma0: imx_dma_enable
[   73.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.670000] imxdma0: imx_dma_disable
[   73.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.690000] imxdma0: next sg chunk dst 0xa6c5f400, src 0x10014038, size 0x00000200
[   73.700000] imxdma0: imx_dma_enable
[   73.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.700000] imxdma0: imx_dma_disable
[   73.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.720000] imxdma0: next sg chunk dst 0xa6c5f600, src 0x10014038, size 0x00000200
[   73.730000] imxdma0: imx_dma_enable
[   73.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.740000] imxdma0: imx_dma_disable
[   73.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.750000] imxdma0: next sg chunk dst 0xa6c5f800, src 0x10014038, size 0x00000200
[   73.760000] imxdma0: imx_dma_enable
[   73.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.770000] imxdma0: imx_dma_disable
[   73.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.780000] imxdma0: next sg chunk dst 0xa6c5fa00, src 0x10014038, size 0x00000200
[   73.790000] imxdma0: imx_dma_enable
[   73.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.800000] imxdma0: imx_dma_disable
[   73.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.810000] imxdma0: next sg chunk dst 0xa6c5fc00, src 0x10014038, size 0x00000200
[   73.820000] imxdma0: imx_dma_enable
[   73.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.830000] imxdma0: imx_dma_disable
[   73.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.840000] imxdma0: next sg chunk dst 0xa6c5fe00, src 0x10014038, size 0x00000200
[   73.850000] imxdma0: imx_dma_enable
[   73.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.860000] imxdma0: imx_dma_disable
[   73.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.870000] imxdma0: next sg chunk dst 0xa6c61000, src 0x10014038, size 0x00000200
[   73.880000] imxdma0: imx_dma_enable
[   73.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.890000] imxdma0: imx_dma_disable
[   73.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.900000] imxdma0: next sg chunk dst 0xa6c61200, src 0x10014038, size 0x00000200
[   73.910000] imxdma0: imx_dma_enable
[   73.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.920000] imxdma0: imx_dma_disable
[   73.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.940000] imxdma0: next sg chunk dst 0xa6c61400, src 0x10014038, size 0x00000200
[   73.940000] imxdma0: imx_dma_enable
[   73.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.950000] imxdma0: imx_dma_disable
[   73.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   73.970000] imxdma0: next sg chunk dst 0xa6c61600, src 0x10014038, size 0x00000200
[   73.970000] imxdma0: imx_dma_enable
[   73.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   73.980000] imxdma0: imx_dma_disable
[   73.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.000000] imxdma0: next sg chunk dst 0xa6c61800, src 0x10014038, size 0x00000200
[   74.000000] imxdma0: imx_dma_enable
[   74.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.010000] imxdma0: imx_dma_disable
[   74.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.030000] imxdma0: next sg chunk dst 0xa6c61a00, src 0x10014038, size 0x00000200
[   74.040000] imxdma0: imx_dma_enable
[   74.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.050000] imxdma0: imx_dma_disable
[   74.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.060000] imxdma0: next sg chunk dst 0xa6c61c00, src 0x10014038, size 0x00000200
[   74.070000] imxdma0: imx_dma_enable
[   74.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.080000] imxdma0: imx_dma_disable
[   74.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.090000] imxdma0: next sg chunk dst 0xa6c61e00, src 0x10014038, size 0x00000200
[   74.100000] imxdma0: imx_dma_enable
[   74.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.110000] imxdma0: imx_dma_disable
[   74.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.120000] imxdma0: next sg chunk dst 0xa6c63000, src 0x10014038, size 0x00000200
[   74.130000] imxdma0: imx_dma_enable
[   74.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.140000] imxdma0: imx_dma_disable
[   74.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.150000] imxdma0: next sg chunk dst 0xa6c63200, src 0x10014038, size 0x00000200
[   74.160000] imxdma0: imx_dma_enable
[   74.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.170000] imxdma0: imx_dma_disable
[   74.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.180000] imxdma0: next sg chunk dst 0xa6c63400, src 0x10014038, size 0x00000200
[   74.190000] imxdma0: imx_dma_enable
[   74.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.200000] imxdma0: imx_dma_disable
[   74.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.210000] imxdma0: next sg chunk dst 0xa6c63600, src 0x10014038, size 0x00000200
[   74.220000] imxdma0: imx_dma_enable
[   74.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.230000] imxdma0: imx_dma_disable
[   74.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.250000] imxdma0: next sg chunk dst 0xa6c63800, src 0x10014038, size 0x00000200
[   74.250000] imxdma0: imx_dma_enable
[   74.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.260000] imxdma0: imx_dma_disable
[   74.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.280000] imxdma0: next sg chunk dst 0xa6c63a00, src 0x10014038, size 0x00000200
[   74.280000] imxdma0: imx_dma_enable
[   74.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.290000] imxdma0: imx_dma_disable
[   74.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.310000] imxdma0: next sg chunk dst 0xa6c63c00, src 0x10014038, size 0x00000200
[   74.320000] imxdma0: imx_dma_enable
[   74.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.320000] imxdma0: imx_dma_disable
[   74.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.340000] imxdma0: next sg chunk dst 0xa6c63e00, src 0x10014038, size 0x00000200
[   74.350000] imxdma0: imx_dma_enable
[   74.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.360000] imxdma0: imx_dma_disable
[   74.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.370000] imxdma0: next sg chunk dst 0xa6c65000, src 0x10014038, size 0x00000200
[   74.380000] imxdma0: imx_dma_enable
[   74.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.390000] imxdma0: imx_dma_disable
[   74.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.400000] imxdma0: next sg chunk dst 0xa6c65200, src 0x10014038, size 0x00000200
[   74.410000] imxdma0: imx_dma_enable
[   74.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.420000] imxdma0: imx_dma_disable
[   74.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.430000] imxdma0: next sg chunk dst 0xa6c65400, src 0x10014038, size 0x00000200
[   74.440000] imxdma0: imx_dma_enable
[   74.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.450000] imxdma0: imx_dma_disable
[   74.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.460000] imxdma0: next sg chunk dst 0xa6c65600, src 0x10014038, size 0x00000200
[   74.470000] imxdma0: imx_dma_enable
[   74.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.480000] imxdma0: imx_dma_disable
[   74.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.490000] imxdma0: next sg chunk dst 0xa6c65800, src 0x10014038, size 0x00000200
[   74.500000] imxdma0: imx_dma_enable
[   74.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.510000] imxdma0: imx_dma_disable
[   74.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.520000] imxdma0: next sg chunk dst 0xa6c65a00, src 0x10014038, size 0x00000200
[   74.530000] imxdma0: imx_dma_enable
[   74.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.540000] imxdma0: imx_dma_disable
[   74.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.560000] imxdma0: next sg chunk dst 0xa6c65c00, src 0x10014038, size 0x00000200
[   74.560000] imxdma0: imx_dma_enable
[   74.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.570000] imxdma0: imx_dma_disable
[   74.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.590000] imxdma0: next sg chunk dst 0xa6c65e00, src 0x10014038, size 0x00000200
[   74.590000] imxdma0: imx_dma_enable
[   74.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.600000] imxdma0: imx_dma_disable
[   74.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.620000] imxdma0: next sg chunk dst 0xa6c67000, src 0x10014038, size 0x00000200
[   74.630000] imxdma0: imx_dma_enable
[   74.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.630000] imxdma0: imx_dma_disable
[   74.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.650000] imxdma0: next sg chunk dst 0xa6c67200, src 0x10014038, size 0x00000200
[   74.660000] imxdma0: imx_dma_enable
[   74.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.670000] imxdma0: imx_dma_disable
[   74.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.680000] imxdma0: next sg chunk dst 0xa6c67400, src 0x10014038, size 0x00000200
[   74.690000] imxdma0: imx_dma_enable
[   74.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.700000] imxdma0: imx_dma_disable
[   74.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.710000] imxdma0: next sg chunk dst 0xa6c67600, src 0x10014038, size 0x00000200
[   74.720000] imxdma0: imx_dma_enable
[   74.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.730000] imxdma0: imx_dma_disable
[   74.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.740000] imxdma0: next sg chunk dst 0xa6c67800, src 0x10014038, size 0x00000200
[   74.750000] imxdma0: imx_dma_enable
[   74.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.760000] imxdma0: imx_dma_disable
[   74.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.770000] imxdma0: next sg chunk dst 0xa6c67a00, src 0x10014038, size 0x00000200
[   74.780000] imxdma0: imx_dma_enable
[   74.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.790000] imxdma0: imx_dma_disable
[   74.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.800000] imxdma0: next sg chunk dst 0xa6c67c00, src 0x10014038, size 0x00000200
[   74.810000] imxdma0: imx_dma_enable
[   74.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.820000] imxdma0: imx_dma_disable
[   74.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.830000] imxdma0: next sg chunk dst 0xa6c67e00, src 0x10014038, size 0x00000200
[   74.840000] imxdma0: imx_dma_enable
[   74.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.850000] imxdma0: imx_dma_disable
[   74.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.870000] imxdma0: next sg chunk dst 0xa6c69000, src 0x10014038, size 0x00000200
[   74.870000] imxdma0: imx_dma_enable
[   74.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.880000] imxdma0: imx_dma_disable
[   74.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.900000] imxdma0: next sg chunk dst 0xa6c69200, src 0x10014038, size 0x00000200
[   74.900000] imxdma0: imx_dma_enable
[   74.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.910000] imxdma0: imx_dma_disable
[   74.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.930000] imxdma0: next sg chunk dst 0xa6c69400, src 0x10014038, size 0x00000200
[   74.940000] imxdma0: imx_dma_enable
[   74.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.940000] imxdma0: imx_dma_disable
[   74.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.960000] imxdma0: next sg chunk dst 0xa6c69600, src 0x10014038, size 0x00000200
[   74.970000] imxdma0: imx_dma_enable
[   74.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   74.980000] imxdma0: imx_dma_disable
[   74.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   74.990000] imxdma0: next sg chunk dst 0xa6c69800, src 0x10014038, size 0x00000200
[   75.000000] imxdma0: imx_dma_enable
[   75.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.010000] imxdma0: imx_dma_disable
[   75.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.020000] imxdma0: next sg chunk dst 0xa6c69a00, src 0x10014038, size 0x00000200
[   75.030000] imxdma0: imx_dma_enable
[   75.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.040000] imxdma0: imx_dma_disable
[   75.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.050000] imxdma0: next sg chunk dst 0xa6c69c00, src 0x10014038, size 0x00000200
[   75.060000] imxdma0: imx_dma_enable
[   75.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.070000] imxdma0: imx_dma_disable
[   75.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.080000] imxdma0: next sg chunk dst 0xa6c69e00, src 0x10014038, size 0x00000200
[   75.090000] imxdma0: imx_dma_enable
[   75.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.100000] imxdma0: imx_dma_disable
[   75.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.110000] imxdma0: next sg chunk dst 0xa6c6b000, src 0x10014038, size 0x00000200
[   75.120000] imxdma0: imx_dma_enable
[   75.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.130000] imxdma0: imx_dma_disable
[   75.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.140000] imxdma0: next sg chunk dst 0xa6c6b200, src 0x10014038, size 0x00000200
[   75.150000] imxdma0: imx_dma_enable
[   75.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.160000] imxdma0: imx_dma_disable
[   75.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.180000] imxdma0: next sg chunk dst 0xa6c6b400, src 0x10014038, size 0x00000200
[   75.180000] imxdma0: imx_dma_enable
[   75.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.190000] imxdma0: imx_dma_disable
[   75.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.210000] imxdma0: next sg chunk dst 0xa6c6b600, src 0x10014038, size 0x00000200
[   75.210000] imxdma0: imx_dma_enable
[   75.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.220000] imxdma0: imx_dma_disable
[   75.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.240000] imxdma0: next sg chunk dst 0xa6c6b800, src 0x10014038, size 0x00000200
[   75.250000] imxdma0: imx_dma_enable
[   75.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.260000] imxdma0: imx_dma_disable
[   75.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.270000] imxdma0: next sg chunk dst 0xa6c6ba00, src 0x10014038, size 0x00000200
[   75.280000] imxdma0: imx_dma_enable
[   75.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.290000] imxdma0: imx_dma_disable
[   75.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.300000] imxdma0: next sg chunk dst 0xa6c6bc00, src 0x10014038, size 0x00000200
[   75.310000] imxdma0: imx_dma_enable
[   75.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.320000] imxdma0: imx_dma_disable
[   75.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.330000] imxdma0: next sg chunk dst 0xa6c6be00, src 0x10014038, size 0x00000200
[   75.340000] imxdma0: imx_dma_enable
[   75.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.350000] imxdma0: imx_dma_disable
[   75.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.360000] imxdma0: next sg chunk dst 0xa6c6d000, src 0x10014038, size 0x00000200
[   75.370000] imxdma0: imx_dma_enable
[   75.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.380000] imxdma0: imx_dma_disable
[   75.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.390000] imxdma0: next sg chunk dst 0xa6c6d200, src 0x10014038, size 0x00000200
[   75.400000] imxdma0: imx_dma_enable
[   75.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.410000] imxdma0: imx_dma_disable
[   75.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.420000] imxdma0: next sg chunk dst 0xa6c6d400, src 0x10014038, size 0x00000200
[   75.430000] imxdma0: imx_dma_enable
[   75.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.440000] imxdma0: imx_dma_disable
[   75.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.460000] imxdma0: next sg chunk dst 0xa6c6d600, src 0x10014038, size 0x00000200
[   75.460000] imxdma0: imx_dma_enable
[   75.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.470000] imxdma0: imx_dma_disable
[   75.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.490000] imxdma0: next sg chunk dst 0xa6c6d800, src 0x10014038, size 0x00000200
[   75.490000] imxdma0: imx_dma_enable
[   75.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.500000] imxdma0: imx_dma_disable
[   75.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.520000] imxdma0: next sg chunk dst 0xa6c6da00, src 0x10014038, size 0x00000200
[   75.520000] imxdma0: imx_dma_enable
[   75.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.530000] imxdma0: imx_dma_disable
[   75.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.550000] imxdma0: next sg chunk dst 0xa6c6dc00, src 0x10014038, size 0x00000200
[   75.560000] imxdma0: imx_dma_enable
[   75.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.570000] imxdma0: imx_dma_disable
[   75.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.580000] imxdma0: next sg chunk dst 0xa6c6de00, src 0x10014038, size 0x00000200
[   75.590000] imxdma0: imx_dma_enable
[   75.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.600000] imxdma0: imx_dma_disable
[   75.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.610000] imxdma0: next sg chunk dst 0xa6c6f000, src 0x10014038, size 0x00000200
[   75.620000] imxdma0: imx_dma_enable
[   75.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.630000] imxdma0: imx_dma_disable
[   75.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.640000] imxdma0: next sg chunk dst 0xa6c6f200, src 0x10014038, size 0x00000200
[   75.650000] imxdma0: imx_dma_enable
[   75.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.660000] imxdma0: imx_dma_disable
[   75.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.670000] imxdma0: next sg chunk dst 0xa6c6f400, src 0x10014038, size 0x00000200
[   75.680000] imxdma0: imx_dma_enable
[   75.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.690000] imxdma0: imx_dma_disable
[   75.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.700000] imxdma0: next sg chunk dst 0xa6c6f600, src 0x10014038, size 0x00000200
[   75.710000] imxdma0: imx_dma_enable
[   75.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.720000] imxdma0: imx_dma_disable
[   75.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.730000] imxdma0: next sg chunk dst 0xa6c6f800, src 0x10014038, size 0x00000200
[   75.740000] imxdma0: imx_dma_enable
[   75.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.750000] imxdma0: imx_dma_disable
[   75.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.770000] imxdma0: next sg chunk dst 0xa6c6fa00, src 0x10014038, size 0x00000200
[   75.770000] imxdma0: imx_dma_enable
[   75.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.780000] imxdma0: imx_dma_disable
[   75.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.800000] imxdma0: next sg chunk dst 0xa6c6fc00, src 0x10014038, size 0x00000200
[   75.800000] imxdma0: imx_dma_enable
[   75.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.810000] imxdma0: imx_dma_disable
[   75.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.830000] imxdma0: next sg chunk dst 0xa6c6fe00, src 0x10014038, size 0x00000200
[   75.840000] imxdma0: imx_dma_enable
[   75.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.840000] imxdma0: imx_dma_disable
[   75.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.860000] imxdma0: next sg chunk dst 0xa6c71000, src 0x10014038, size 0x00000200
[   75.870000] imxdma0: imx_dma_enable
[   75.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.880000] imxdma0: imx_dma_disable
[   75.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.890000] imxdma0: next sg chunk dst 0xa6c71200, src 0x10014038, size 0x00000200
[   75.900000] imxdma0: imx_dma_enable
[   75.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.910000] imxdma0: imx_dma_disable
[   75.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.920000] imxdma0: next sg chunk dst 0xa6c71400, src 0x10014038, size 0x00000200
[   75.930000] imxdma0: imx_dma_enable
[   75.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.940000] imxdma0: imx_dma_disable
[   75.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.950000] imxdma0: next sg chunk dst 0xa6c71600, src 0x10014038, size 0x00000200
[   75.960000] imxdma0: imx_dma_enable
[   75.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   75.970000] imxdma0: imx_dma_disable
[   75.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   75.980000] imxdma0: next sg chunk dst 0xa6c71800, src 0x10014038, size 0x00000200
[   75.990000] imxdma0: imx_dma_enable
[   75.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.000000] imxdma0: imx_dma_disable
[   76.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.010000] imxdma0: next sg chunk dst 0xa6c71a00, src 0x10014038, size 0x00000200
[   76.020000] imxdma0: imx_dma_enable
[   76.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.030000] imxdma0: imx_dma_disable
[   76.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.040000] imxdma0: next sg chunk dst 0xa6c71c00, src 0x10014038, size 0x00000200
[   76.050000] imxdma0: imx_dma_enable
[   76.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.060000] imxdma0: imx_dma_disable
[   76.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.080000] imxdma0: next sg chunk dst 0xa6c71e00, src 0x10014038, size 0x00000200
[   76.080000] imxdma0: imx_dma_enable
[   76.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.090000] imxdma0: imx_dma_disable
[   76.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.110000] imxdma0: next sg chunk dst 0xa6c73000, src 0x10014038, size 0x00000200
[   76.110000] imxdma0: imx_dma_enable
[   76.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.120000] imxdma0: imx_dma_disable
[   76.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.140000] imxdma0: next sg chunk dst 0xa6c73200, src 0x10014038, size 0x00000200
[   76.150000] imxdma0: imx_dma_enable
[   76.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.150000] imxdma0: imx_dma_disable
[   76.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.170000] imxdma0: next sg chunk dst 0xa6c73400, src 0x10014038, size 0x00000200
[   76.180000] imxdma0: imx_dma_enable
[   76.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.190000] imxdma0: imx_dma_disable
[   76.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.200000] imxdma0: next sg chunk dst 0xa6c73600, src 0x10014038, size 0x00000200
[   76.210000] imxdma0: imx_dma_enable
[   76.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.220000] imxdma0: imx_dma_disable
[   76.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.230000] imxdma0: next sg chunk dst 0xa6c73800, src 0x10014038, size 0x00000200
[   76.240000] imxdma0: imx_dma_enable
[   76.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.250000] imxdma0: imx_dma_disable
[   76.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.260000] imxdma0: next sg chunk dst 0xa6c73a00, src 0x10014038, size 0x00000200
[   76.270000] imxdma0: imx_dma_enable
[   76.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.280000] imxdma0: imx_dma_disable
[   76.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.290000] imxdma0: next sg chunk dst 0xa6c73c00, src 0x10014038, size 0x00000200
[   76.300000] imxdma0: imx_dma_enable
[   76.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.310000] imxdma0: imx_dma_disable
[   76.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.320000] imxdma0: next sg chunk dst 0xa6c73e00, src 0x10014038, size 0x00000200
[   76.330000] imxdma0: imx_dma_enable
[   76.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.340000] imxdma0: imx_dma_disable
[   76.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.350000] imxdma0: next sg chunk dst 0xa6c75000, src 0x10014038, size 0x00000200
[   76.360000] imxdma0: imx_dma_enable
[   76.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.370000] imxdma0: imx_dma_disable
[   76.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.390000] imxdma0: next sg chunk dst 0xa6c75200, src 0x10014038, size 0x00000200
[   76.390000] imxdma0: imx_dma_enable
[   76.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.400000] imxdma0: imx_dma_disable
[   76.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.420000] imxdma0: next sg chunk dst 0xa6c75400, src 0x10014038, size 0x00000200
[   76.420000] imxdma0: imx_dma_enable
[   76.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.430000] imxdma0: imx_dma_disable
[   76.440000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.450000] imxdma0: next sg chunk dst 0xa6c75600, src 0x10014038, size 0x00000200
[   76.460000] imxdma0: imx_dma_enable
[   76.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.460000] imxdma0: imx_dma_disable
[   76.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.480000] imxdma0: next sg chunk dst 0xa6c75800, src 0x10014038, size 0x00000200
[   76.490000] imxdma0: imx_dma_enable
[   76.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.500000] imxdma0: imx_dma_disable
[   76.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.510000] imxdma0: next sg chunk dst 0xa6c75a00, src 0x10014038, size 0x00000200
[   76.520000] imxdma0: imx_dma_enable
[   76.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.530000] imxdma0: imx_dma_disable
[   76.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.540000] imxdma0: next sg chunk dst 0xa6c75c00, src 0x10014038, size 0x00000200
[   76.550000] imxdma0: imx_dma_enable
[   76.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.560000] imxdma0: imx_dma_disable
[   76.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.570000] imxdma0: next sg chunk dst 0xa6c75e00, src 0x10014038, size 0x00000200
[   76.580000] imxdma0: imx_dma_enable
[   76.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.590000] imxdma0: imx_dma_disable
[   76.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.600000] imxdma0: next sg chunk dst 0xa6c77000, src 0x10014038, size 0x00000200
[   76.610000] imxdma0: imx_dma_enable
[   76.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.620000] imxdma0: imx_dma_disable
[   76.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.630000] imxdma0: next sg chunk dst 0xa6c77200, src 0x10014038, size 0x00000200
[   76.640000] imxdma0: imx_dma_enable
[   76.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.650000] imxdma0: imx_dma_disable
[   76.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.660000] imxdma0: next sg chunk dst 0xa6c77400, src 0x10014038, size 0x00000200
[   76.670000] imxdma0: imx_dma_enable
[   76.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.680000] imxdma0: imx_dma_disable
[   76.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.700000] imxdma0: next sg chunk dst 0xa6c77600, src 0x10014038, size 0x00000200
[   76.700000] imxdma0: imx_dma_enable
[   76.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.710000] imxdma0: imx_dma_disable
[   76.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.730000] imxdma0: next sg chunk dst 0xa6c77800, src 0x10014038, size 0x00000200
[   76.730000] imxdma0: imx_dma_enable
[   76.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.740000] imxdma0: imx_dma_disable
[   76.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.760000] imxdma0: next sg chunk dst 0xa6c77a00, src 0x10014038, size 0x00000200
[   76.770000] imxdma0: imx_dma_enable
[   76.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.770000] imxdma0: imx_dma_disable
[   76.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.790000] imxdma0: next sg chunk dst 0xa6c77c00, src 0x10014038, size 0x00000200
[   76.800000] imxdma0: imx_dma_enable
[   76.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.810000] imxdma0: imx_dma_disable
[   76.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.820000] imxdma0: next sg chunk dst 0xa6c77e00, src 0x10014038, size 0x00000200
[   76.830000] imxdma0: imx_dma_enable
[   76.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.840000] imxdma0: imx_dma_disable
[   76.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.850000] imxdma0: next sg chunk dst 0xa6c79000, src 0x10014038, size 0x00000200
[   76.860000] imxdma0: imx_dma_enable
[   76.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.870000] imxdma0: imx_dma_disable
[   76.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.880000] imxdma0: next sg chunk dst 0xa6c79200, src 0x10014038, size 0x00000200
[   76.890000] imxdma0: imx_dma_enable
[   76.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.900000] imxdma0: imx_dma_disable
[   76.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.910000] imxdma0: next sg chunk dst 0xa6c79400, src 0x10014038, size 0x00000200
[   76.920000] imxdma0: imx_dma_enable
[   76.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.930000] imxdma0: imx_dma_disable
[   76.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.940000] imxdma0: next sg chunk dst 0xa6c79600, src 0x10014038, size 0x00000200
[   76.950000] imxdma0: imx_dma_enable
[   76.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.960000] imxdma0: imx_dma_disable
[   76.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   76.970000] imxdma0: next sg chunk dst 0xa6c79800, src 0x10014038, size 0x00000200
[   76.980000] imxdma0: imx_dma_enable
[   76.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   76.990000] imxdma0: imx_dma_disable
[   77.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.010000] imxdma0: next sg chunk dst 0xa6c79a00, src 0x10014038, size 0x00000200
[   77.010000] imxdma0: imx_dma_enable
[   77.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.020000] imxdma0: imx_dma_disable
[   77.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.040000] imxdma0: next sg chunk dst 0xa6c79c00, src 0x10014038, size 0x00000200
[   77.040000] imxdma0: imx_dma_enable
[   77.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.050000] imxdma0: imx_dma_disable
[   77.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.070000] imxdma0: next sg chunk dst 0xa6c79e00, src 0x10014038, size 0x00000200
[   77.080000] imxdma0: imx_dma_enable
[   77.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.080000] imxdma0: imx_dma_disable
[   77.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.100000] imxdma0: next sg chunk dst 0xa6c7b000, src 0x10014038, size 0x00000200
[   77.110000] imxdma0: imx_dma_enable
[   77.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.120000] imxdma0: imx_dma_disable
[   77.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.130000] imxdma0: next sg chunk dst 0xa6c7b200, src 0x10014038, size 0x00000200
[   77.140000] imxdma0: imx_dma_enable
[   77.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.150000] imxdma0: imx_dma_disable
[   77.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.160000] imxdma0: next sg chunk dst 0xa6c7b400, src 0x10014038, size 0x00000200
[   77.170000] imxdma0: imx_dma_enable
[   77.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.180000] imxdma0: imx_dma_disable
[   77.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.190000] imxdma0: next sg chunk dst 0xa6c7b600, src 0x10014038, size 0x00000200
[   77.200000] imxdma0: imx_dma_enable
[   77.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.210000] imxdma0: imx_dma_disable
[   77.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.220000] imxdma0: next sg chunk dst 0xa6c7b800, src 0x10014038, size 0x00000200
[   77.230000] imxdma0: imx_dma_enable
[   77.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.240000] imxdma0: imx_dma_disable
[   77.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.250000] imxdma0: next sg chunk dst 0xa6c7ba00, src 0x10014038, size 0x00000200
[   77.260000] imxdma0: imx_dma_enable
[   77.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.270000] imxdma0: imx_dma_disable
[   77.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.280000] imxdma0: next sg chunk dst 0xa6c7bc00, src 0x10014038, size 0x00000200
[   77.290000] imxdma0: imx_dma_enable
[   77.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.300000] imxdma0: imx_dma_disable
[   77.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.320000] imxdma0: next sg chunk dst 0xa6c7be00, src 0x10014038, size 0x00000200
[   77.320000] imxdma0: imx_dma_enable
[   77.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.330000] imxdma0: imx_dma_disable
[   77.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.350000] imxdma0: next sg chunk dst 0xa6c7d000, src 0x10014038, size 0x00000200
[   77.350000] imxdma0: imx_dma_enable
[   77.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.360000] imxdma0: imx_dma_disable
[   77.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.380000] imxdma0: next sg chunk dst 0xa6c7d200, src 0x10014038, size 0x00000200
[   77.390000] imxdma0: imx_dma_enable
[   77.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.400000] imxdma0: imx_dma_disable
[   77.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.410000] imxdma0: next sg chunk dst 0xa6c7d400, src 0x10014038, size 0x00000200
[   77.420000] imxdma0: imx_dma_enable
[   77.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.430000] imxdma0: imx_dma_disable
[   77.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.440000] imxdma0: next sg chunk dst 0xa6c7d600, src 0x10014038, size 0x00000200
[   77.450000] imxdma0: imx_dma_enable
[   77.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.460000] imxdma0: imx_dma_disable
[   77.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.470000] imxdma0: next sg chunk dst 0xa6c7d800, src 0x10014038, size 0x00000200
[   77.480000] imxdma0: imx_dma_enable
[   77.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.490000] imxdma0: imx_dma_disable
[   77.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.500000] imxdma0: next sg chunk dst 0xa6c7da00, src 0x10014038, size 0x00000200
[   77.510000] imxdma0: imx_dma_enable
[   77.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.520000] imxdma0: imx_dma_disable
[   77.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.530000] imxdma0: next sg chunk dst 0xa6c7dc00, src 0x10014038, size 0x00000200
[   77.540000] imxdma0: imx_dma_enable
[   77.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.550000] imxdma0: imx_dma_disable
[   77.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.560000] imxdma0: next sg chunk dst 0xa6c7de00, src 0x10014038, size 0x00000200
[   77.570000] imxdma0: imx_dma_enable
[   77.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.580000] imxdma0: imx_dma_disable
[   77.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.590000] imxdma0: next sg chunk dst 0xa6c7f000, src 0x10014038, size 0x00000200
[   77.600000] imxdma0: imx_dma_enable
[   77.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.610000] imxdma0: imx_dma_disable
[   77.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.630000] imxdma0: next sg chunk dst 0xa6c7f200, src 0x10014038, size 0x00000200
[   77.630000] imxdma0: imx_dma_enable
[   77.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.640000] imxdma0: imx_dma_disable
[   77.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.660000] imxdma0: next sg chunk dst 0xa6c7f400, src 0x10014038, size 0x00000200
[   77.660000] imxdma0: imx_dma_enable
[   77.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.670000] imxdma0: imx_dma_disable
[   77.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.690000] imxdma0: next sg chunk dst 0xa6c7f600, src 0x10014038, size 0x00000200
[   77.700000] imxdma0: imx_dma_enable
[   77.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.700000] imxdma0: imx_dma_disable
[   77.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.720000] imxdma0: next sg chunk dst 0xa6c7f800, src 0x10014038, size 0x00000200
[   77.730000] imxdma0: imx_dma_enable
[   77.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.740000] imxdma0: imx_dma_disable
[   77.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.750000] imxdma0: next sg chunk dst 0xa6c7fa00, src 0x10014038, size 0x00000200
[   77.760000] imxdma0: imx_dma_enable
[   77.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.770000] imxdma0: imx_dma_disable
[   77.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.780000] imxdma0: next sg chunk dst 0xa6c7fc00, src 0x10014038, size 0x00000200
[   77.790000] imxdma0: imx_dma_enable
[   77.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.800000] imxdma0: imx_dma_disable
[   77.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.810000] imxdma0: next sg chunk dst 0xa6c7fe00, src 0x10014038, size 0x00000200
[   77.820000] imxdma0: imx_dma_enable
[   77.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.830000] imxdma0: imx_dma_disable
[   77.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.840000] imxdma0: next sg chunk dst 0xa6c81000, src 0x10014038, size 0x00000200
[   77.850000] imxdma0: imx_dma_enable
[   77.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.860000] imxdma0: imx_dma_disable
[   77.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.870000] imxdma0: next sg chunk dst 0xa6c81200, src 0x10014038, size 0x00000200
[   77.880000] imxdma0: imx_dma_enable
[   77.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.890000] imxdma0: imx_dma_disable
[   77.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.900000] imxdma0: next sg chunk dst 0xa6c81400, src 0x10014038, size 0x00000200
[   77.910000] imxdma0: imx_dma_enable
[   77.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.920000] imxdma0: imx_dma_disable
[   77.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.940000] imxdma0: next sg chunk dst 0xa6c81600, src 0x10014038, size 0x00000200
[   77.940000] imxdma0: imx_dma_enable
[   77.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.950000] imxdma0: imx_dma_disable
[   77.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   77.970000] imxdma0: next sg chunk dst 0xa6c81800, src 0x10014038, size 0x00000200
[   77.970000] imxdma0: imx_dma_enable
[   77.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   77.980000] imxdma0: imx_dma_disable
[   77.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.000000] imxdma0: next sg chunk dst 0xa6c81a00, src 0x10014038, size 0x00000200
[   78.010000] imxdma0: imx_dma_enable
[   78.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.010000] imxdma0: imx_dma_disable
[   78.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.030000] imxdma0: next sg chunk dst 0xa6c81c00, src 0x10014038, size 0x00000200
[   78.040000] imxdma0: imx_dma_enable
[   78.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.050000] imxdma0: imx_dma_disable
[   78.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.060000] imxdma0: next sg chunk dst 0xa6c81e00, src 0x10014038, size 0x00000200
[   78.070000] imxdma0: imx_dma_enable
[   78.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.080000] imxdma0: imx_dma_disable
[   78.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.090000] imxdma0: next sg chunk dst 0xa6c83000, src 0x10014038, size 0x00000200
[   78.100000] imxdma0: imx_dma_enable
[   78.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.110000] imxdma0: imx_dma_disable
[   78.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.120000] imxdma0: next sg chunk dst 0xa6c83200, src 0x10014038, size 0x00000200
[   78.130000] imxdma0: imx_dma_enable
[   78.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.140000] imxdma0: imx_dma_disable
[   78.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.150000] imxdma0: next sg chunk dst 0xa6c83400, src 0x10014038, size 0x00000200
[   78.160000] imxdma0: imx_dma_enable
[   78.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.170000] imxdma0: imx_dma_disable
[   78.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.180000] imxdma0: next sg chunk dst 0xa6c83600, src 0x10014038, size 0x00000200
[   78.190000] imxdma0: imx_dma_enable
[   78.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.200000] imxdma0: imx_dma_disable
[   78.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.220000] imxdma0: next sg chunk dst 0xa6c83800, src 0x10014038, size 0x00000200
[   78.220000] imxdma0: imx_dma_enable
[   78.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.230000] imxdma0: imx_dma_disable
[   78.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.250000] imxdma0: next sg chunk dst 0xa6c83a00, src 0x10014038, size 0x00000200
[   78.250000] imxdma0: imx_dma_enable
[   78.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.260000] imxdma0: imx_dma_disable
[   78.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.280000] imxdma0: next sg chunk dst 0xa6c83c00, src 0x10014038, size 0x00000200
[   78.280000] imxdma0: imx_dma_enable
[   78.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.290000] imxdma0: imx_dma_disable
[   78.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.310000] imxdma0: next sg chunk dst 0xa6c83e00, src 0x10014038, size 0x00000200
[   78.320000] imxdma0: imx_dma_enable
[   78.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.330000] imxdma0: imx_dma_disable
[   78.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.340000] imxdma0: next sg chunk dst 0xa6c85000, src 0x10014038, size 0x00000200
[   78.350000] imxdma0: imx_dma_enable
[   78.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.360000] imxdma0: imx_dma_disable
[   78.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.370000] imxdma0: next sg chunk dst 0xa6c85200, src 0x10014038, size 0x00000200
[   78.380000] imxdma0: imx_dma_enable
[   78.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.390000] imxdma0: imx_dma_disable
[   78.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.400000] imxdma0: next sg chunk dst 0xa6c85400, src 0x10014038, size 0x00000200
[   78.410000] imxdma0: imx_dma_enable
[   78.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.420000] imxdma0: imx_dma_disable
[   78.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.430000] imxdma0: next sg chunk dst 0xa6c85600, src 0x10014038, size 0x00000200
[   78.440000] imxdma0: imx_dma_enable
[   78.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.450000] imxdma0: imx_dma_disable
[   78.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.460000] imxdma0: next sg chunk dst 0xa6c85800, src 0x10014038, size 0x00000200
[   78.470000] imxdma0: imx_dma_enable
[   78.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.480000] imxdma0: imx_dma_disable
[   78.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.490000] imxdma0: next sg chunk dst 0xa6c85a00, src 0x10014038, size 0x00000200
[   78.500000] imxdma0: imx_dma_enable
[   78.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.510000] imxdma0: imx_dma_disable
[   78.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.530000] imxdma0: next sg chunk dst 0xa6c85c00, src 0x10014038, size 0x00000200
[   78.530000] imxdma0: imx_dma_enable
[   78.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.540000] imxdma0: imx_dma_disable
[   78.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.560000] imxdma0: next sg chunk dst 0xa6c85e00, src 0x10014038, size 0x00000200
[   78.560000] imxdma0: imx_dma_enable
[   78.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.570000] imxdma0: imx_dma_disable
[   78.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.590000] imxdma0: next sg chunk dst 0xa6c87000, src 0x10014038, size 0x00000200
[   78.600000] imxdma0: imx_dma_enable
[   78.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.600000] imxdma0: imx_dma_disable
[   78.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.620000] imxdma0: next sg chunk dst 0xa6c87200, src 0x10014038, size 0x00000200
[   78.630000] imxdma0: imx_dma_enable
[   78.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.640000] imxdma0: imx_dma_disable
[   78.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.650000] imxdma0: next sg chunk dst 0xa6c87400, src 0x10014038, size 0x00000200
[   78.660000] imxdma0: imx_dma_enable
[   78.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.670000] imxdma0: imx_dma_disable
[   78.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.680000] imxdma0: next sg chunk dst 0xa6c87600, src 0x10014038, size 0x00000200
[   78.690000] imxdma0: imx_dma_enable
[   78.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.700000] imxdma0: imx_dma_disable
[   78.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.710000] imxdma0: next sg chunk dst 0xa6c87800, src 0x10014038, size 0x00000200
[   78.720000] imxdma0: imx_dma_enable
[   78.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.730000] imxdma0: imx_dma_disable
[   78.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.740000] imxdma0: next sg chunk dst 0xa6c87a00, src 0x10014038, size 0x00000200
[   78.750000] imxdma0: imx_dma_enable
[   78.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.760000] imxdma0: imx_dma_disable
[   78.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.770000] imxdma0: next sg chunk dst 0xa6c87c00, src 0x10014038, size 0x00000200
[   78.780000] imxdma0: imx_dma_enable
[   78.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.790000] imxdma0: imx_dma_disable
[   78.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.800000] imxdma0: next sg chunk dst 0xa6c87e00, src 0x10014038, size 0x00000200
[   78.810000] imxdma0: imx_dma_enable
[   78.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.820000] imxdma0: imx_dma_disable
[   78.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.840000] imxdma0: next sg chunk dst 0xa6c89000, src 0x10014038, size 0x00000200
[   78.840000] imxdma0: imx_dma_enable
[   78.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.850000] imxdma0: imx_dma_disable
[   78.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.870000] imxdma0: next sg chunk dst 0xa6c89200, src 0x10014038, size 0x00000200
[   78.870000] imxdma0: imx_dma_enable
[   78.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.880000] imxdma0: imx_dma_disable
[   78.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.900000] imxdma0: next sg chunk dst 0xa6c89400, src 0x10014038, size 0x00000200
[   78.910000] imxdma0: imx_dma_enable
[   78.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.920000] imxdma0: imx_dma_disable
[   78.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.930000] imxdma0: next sg chunk dst 0xa6c89600, src 0x10014038, size 0x00000200
[   78.940000] imxdma0: imx_dma_enable
[   78.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.950000] imxdma0: imx_dma_disable
[   78.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.960000] imxdma0: next sg chunk dst 0xa6c89800, src 0x10014038, size 0x00000200
[   78.970000] imxdma0: imx_dma_enable
[   78.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   78.980000] imxdma0: imx_dma_disable
[   78.980000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   78.990000] imxdma0: next sg chunk dst 0xa6c89a00, src 0x10014038, size 0x00000200
[   79.000000] imxdma0: imx_dma_enable
[   79.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.010000] imxdma0: imx_dma_disable
[   79.010000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.020000] imxdma0: next sg chunk dst 0xa6c89c00, src 0x10014038, size 0x00000200
[   79.030000] imxdma0: imx_dma_enable
[   79.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.040000] imxdma0: imx_dma_disable
[   79.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.050000] imxdma0: next sg chunk dst 0xa6c89e00, src 0x10014038, size 0x00000200
[   79.060000] imxdma0: imx_dma_enable
[   79.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.070000] imxdma0: imx_dma_disable
[   79.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.080000] imxdma0: next sg chunk dst 0xa6c8b000, src 0x10014038, size 0x00000200
[   79.090000] imxdma0: imx_dma_enable
[   79.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.100000] imxdma0: imx_dma_disable
[   79.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.110000] imxdma0: next sg chunk dst 0xa6c8b200, src 0x10014038, size 0x00000200
[   79.120000] imxdma0: imx_dma_enable
[   79.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.130000] imxdma0: imx_dma_disable
[   79.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.150000] imxdma0: next sg chunk dst 0xa6c8b400, src 0x10014038, size 0x00000200
[   79.150000] imxdma0: imx_dma_enable
[   79.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.160000] imxdma0: imx_dma_disable
[   79.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.180000] imxdma0: next sg chunk dst 0xa6c8b600, src 0x10014038, size 0x00000200
[   79.180000] imxdma0: imx_dma_enable
[   79.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.190000] imxdma0: imx_dma_disable
[   79.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.210000] imxdma0: next sg chunk dst 0xa6c8b800, src 0x10014038, size 0x00000200
[   79.220000] imxdma0: imx_dma_enable
[   79.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.220000] imxdma0: imx_dma_disable
[   79.230000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.240000] imxdma0: next sg chunk dst 0xa6c8ba00, src 0x10014038, size 0x00000200
[   79.250000] imxdma0: imx_dma_enable
[   79.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.260000] imxdma0: imx_dma_disable
[   79.260000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.270000] imxdma0: next sg chunk dst 0xa6c8bc00, src 0x10014038, size 0x00000200
[   79.280000] imxdma0: imx_dma_enable
[   79.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.290000] imxdma0: imx_dma_disable
[   79.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.300000] imxdma0: next sg chunk dst 0xa6c8be00, src 0x10014038, size 0x00000200
[   79.310000] imxdma0: imx_dma_enable
[   79.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.320000] imxdma0: imx_dma_disable
[   79.320000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.330000] imxdma0: next sg chunk dst 0xa6c8d000, src 0x10014038, size 0x00000200
[   79.340000] imxdma0: imx_dma_enable
[   79.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.350000] imxdma0: imx_dma_disable
[   79.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.360000] imxdma0: next sg chunk dst 0xa6c8d200, src 0x10014038, size 0x00000200
[   79.370000] imxdma0: imx_dma_enable
[   79.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.380000] imxdma0: imx_dma_disable
[   79.380000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.390000] imxdma0: next sg chunk dst 0xa6c8d400, src 0x10014038, size 0x00000200
[   79.400000] imxdma0: imx_dma_enable
[   79.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.410000] imxdma0: imx_dma_disable
[   79.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.420000] imxdma0: next sg chunk dst 0xa6c8d600, src 0x10014038, size 0x00000200
[   79.430000] imxdma0: imx_dma_enable
[   79.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.440000] imxdma0: imx_dma_disable
[   79.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.460000] imxdma0: next sg chunk dst 0xa6c8d800, src 0x10014038, size 0x00000200
[   79.460000] imxdma0: imx_dma_enable
[   79.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.470000] imxdma0: imx_dma_disable
[   79.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.490000] imxdma0: next sg chunk dst 0xa6c8da00, src 0x10014038, size 0x00000200
[   79.490000] imxdma0: imx_dma_enable
[   79.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.500000] imxdma0: imx_dma_disable
[   79.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.520000] imxdma0: next sg chunk dst 0xa6c8dc00, src 0x10014038, size 0x00000200
[   79.530000] imxdma0: imx_dma_enable
[   79.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.530000] imxdma0: imx_dma_disable
[   79.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.550000] imxdma0: next sg chunk dst 0xa6c8de00, src 0x10014038, size 0x00000200
[   79.560000] imxdma0: imx_dma_enable
[   79.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.570000] imxdma0: imx_dma_disable
[   79.570000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.580000] imxdma0: next sg chunk dst 0xa0761200, src 0x10014038, size 0x00000200
[   79.590000] imxdma0: imx_dma_enable
[   79.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.600000] imxdma0: imx_dma_disable
[   79.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.610000] imxdma0: next sg chunk dst 0xa0761400, src 0x10014038, size 0x00000200
[   79.620000] imxdma0: imx_dma_enable
[   79.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.630000] imxdma0: imx_dma_disable
[   79.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.640000] imxdma0: next sg chunk dst 0xa0761600, src 0x10014038, size 0x00000200
[   79.650000] imxdma0: imx_dma_enable
[   79.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.660000] imxdma0: imx_dma_disable
[   79.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.670000] imxdma0: next sg chunk dst 0xa0761800, src 0x10014038, size 0x00000200
[   79.680000] imxdma0: imx_dma_enable
[   79.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.690000] imxdma0: imx_dma_disable
[   79.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.700000] imxdma0: next sg chunk dst 0xa0761a00, src 0x10014038, size 0x00000200
[   79.710000] imxdma0: imx_dma_enable
[   79.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.720000] imxdma0: imx_dma_disable
[   79.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.730000] imxdma0: next sg chunk dst 0xa0761c00, src 0x10014038, size 0x00000200
[   79.740000] imxdma0: imx_dma_enable
[   79.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.750000] imxdma0: imx_dma_disable
[   79.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.770000] imxdma0: next sg chunk dst 0xa0761e00, src 0x10014038, size 0x00000200
[   79.770000] imxdma0: imx_dma_enable
[   79.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.780000] imxdma0: imx_dma_disable
[   79.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.800000] imxdma0: next sg chunk dst 0xa6c90000, src 0x10014038, size 0x00000200
[   79.800000] imxdma0: imx_dma_enable
[   79.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.810000] imxdma0: imx_dma_disable
[   79.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.830000] imxdma0: next sg chunk dst 0xa6c90200, src 0x10014038, size 0x00000200
[   79.840000] imxdma0: imx_dma_enable
[   79.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.850000] imxdma0: imx_dma_disable
[   79.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.860000] imxdma0: next sg chunk dst 0xa6c90400, src 0x10014038, size 0x00000200
[   79.870000] imxdma0: imx_dma_enable
[   79.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.880000] imxdma0: imx_dma_disable
[   79.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.890000] imxdma0: next sg chunk dst 0xa6c90600, src 0x10014038, size 0x00000200
[   79.900000] imxdma0: imx_dma_enable
[   79.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.910000] imxdma0: imx_dma_disable
[   79.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.920000] imxdma0: next sg chunk dst 0xa6c90800, src 0x10014038, size 0x00000200
[   79.930000] imxdma0: imx_dma_enable
[   79.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.940000] imxdma0: imx_dma_disable
[   79.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.950000] imxdma0: next sg chunk dst 0xa6c90a00, src 0x10014038, size 0x00000200
[   79.960000] imxdma0: imx_dma_enable
[   79.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   79.970000] imxdma0: imx_dma_disable
[   79.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   79.980000] imxdma0: next sg chunk dst 0xa6c90c00, src 0x10014038, size 0x00000200
[   79.990000] imxdma0: imx_dma_enable
[   79.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.000000] imxdma0: imx_dma_disable
[   80.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.010000] imxdma0: next sg chunk dst 0xa6c90e00, src 0x10014038, size 0x00000200
[   80.020000] imxdma0: imx_dma_enable
[   80.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.030000] imxdma0: imx_dma_disable
[   80.040000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.050000] imxdma0: next sg chunk dst 0xa6c92000, src 0x10014038, size 0x00000200
[   80.050000] imxdma0: imx_dma_enable
[   80.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.060000] imxdma0: imx_dma_disable
[   80.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.080000] imxdma0: next sg chunk dst 0xa6c92200, src 0x10014038, size 0x00000200
[   80.080000] imxdma0: imx_dma_enable
[   80.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.090000] imxdma0: imx_dma_disable
[   80.100000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.110000] imxdma0: next sg chunk dst 0xa6c92400, src 0x10014038, size 0x00000200
[   80.110000] imxdma0: imx_dma_enable
[   80.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.120000] imxdma0: imx_dma_disable
[   80.130000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.140000] imxdma0: next sg chunk dst 0xa6c92600, src 0x10014038, size 0x00000200
[   80.150000] imxdma0: imx_dma_enable
[   80.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.160000] imxdma0: imx_dma_disable
[   80.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.170000] imxdma0: next sg chunk dst 0xa6c92800, src 0x10014038, size 0x00000200
[   80.180000] imxdma0: imx_dma_enable
[   80.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.190000] imxdma0: imx_dma_disable
[   80.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   80.200000] imxdma0: next sg chunk dst 0xa6c92a00, src 0x10014038, size 0x00000200
[   80.210000] imxdma0: imx_dma_enable
[   80.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.220000] imxdma0: imx_dma_disable
[   80.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   80.250000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d2000, size 0x00001000
[   80.250000] imxdma0: imx_dma_enable
[   80.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.260000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d4000, size 0x00001000
[   80.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.270000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d6000, size 0x00001000
[   80.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.290000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d8000, size 0x00001000
[   80.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.300000] imxdma0: next sg chunk dst 0x10014038, src 0xa73da000, size 0x00001000
[   80.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.310000] imxdma0: next sg chunk dst 0x10014038, src 0xa73dc000, size 0x00001000
[   80.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.330000] imxdma0: next sg chunk dst 0x10014038, src 0xa73de000, size 0x00001000
[   80.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.340000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e0000, size 0x00001000
[   80.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.360000] imxdma0: imx_dma_disable
[   80.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   80.370000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e2000, size 0x00001000
[   80.380000] imxdma0: imx_dma_enable
[   80.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.390000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e4000, size 0x00001000
[   80.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.400000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e6000, size 0x00001000
[   80.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.410000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e8000, size 0x00001000
[   80.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.430000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ea000, size 0x00001000
[   80.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.440000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ec000, size 0x00001000
[   80.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.450000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ee000, size 0x00001000
[   80.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.470000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f0000, size 0x00001000
[   80.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.490000] imxdma0: imx_dma_disable
[   80.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   80.500000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f2000, size 0x00001000
[   80.510000] imxdma0: imx_dma_enable
[   80.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.510000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f4000, size 0x00001000
[   80.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.530000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f6000, size 0x00001000
[   80.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.540000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f8000, size 0x00001000
[   80.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.550000] imxdma0: next sg chunk dst 0x10014038, src 0xa73fa000, size 0x00001000
[   80.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.570000] imxdma0: next sg chunk dst 0x10014038, src 0xa73fc000, size 0x00001000
[   80.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.580000] imxdma0: next sg chunk dst 0x10014038, src 0xa73fe000, size 0x00001000
[   80.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.600000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c00000, size 0x00001000
[   80.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.610000] imxdma0: imx_dma_disable
[   80.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   80.630000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c02000, size 0x00001000
[   80.640000] imxdma0: imx_dma_enable
[   80.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.640000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c04000, size 0x00001000
[   80.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.650000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c06000, size 0x00001000
[   80.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.670000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c08000, size 0x00001000
[   80.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.680000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0a000, size 0x00001000
[   80.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.700000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0c000, size 0x00001000
[   80.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.710000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0e000, size 0x00001000
[   80.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.720000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c10000, size 0x00001000
[   80.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.740000] imxdma0: imx_dma_disable
[   80.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   80.760000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c12000, size 0x00001000
[   80.760000] imxdma0: imx_dma_enable
[   80.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.770000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c14000, size 0x00001000
[   80.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.780000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c16000, size 0x00001000
[   80.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.800000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c18000, size 0x00001000
[   80.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.810000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1a000, size 0x00001000
[   80.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.820000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1c000, size 0x00001000
[   80.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.840000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1e000, size 0x00001000
[   80.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.850000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c20000, size 0x00001000
[   80.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.870000] imxdma0: imx_dma_disable
[   80.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   80.880000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c22000, size 0x00001000
[   80.890000] imxdma0: imx_dma_enable
[   80.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.900000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c24000, size 0x00001000
[   80.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.910000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c26000, size 0x00001000
[   80.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.920000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c28000, size 0x00001000
[   80.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.940000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2a000, size 0x00001000
[   80.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.950000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2c000, size 0x00001000
[   80.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.960000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2e000, size 0x00001000
[   80.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   80.980000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c30000, size 0x00001000
[   80.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.000000] imxdma0: imx_dma_disable
[   81.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=4 total length=15360 dev_addr=0x10014038 for write
[   81.010000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c32000, size 0x00001000
[   81.020000] imxdma0: imx_dma_enable
[   81.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.020000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c34000, size 0x00001000
[   81.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.040000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c36000, size 0x00001000
[   81.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.050000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c38000, size 0x00000c00
[   81.060000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.070000] imxdma0: imx_dma_disable
[   81.070000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   81.080000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c3a600, size 0x00000a00
[   81.090000] imxdma0: imx_dma_enable
[   81.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.100000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c3c000, size 0x00001000
[   81.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.110000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c3e000, size 0x00001000
[   81.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.120000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c40000, size 0x00001000
[   81.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.140000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c42000, size 0x00001000
[   81.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.150000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c44000, size 0x00001000
[   81.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.160000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c46000, size 0x00001000
[   81.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.180000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c48000, size 0x00001000
[   81.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.190000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4a000, size 0x00000600
[   81.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.210000] imxdma0: imx_dma_disable
[   81.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   81.230000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4a600, size 0x00000a00
[   81.230000] imxdma0: imx_dma_enable
[   81.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.240000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4c000, size 0x00001000
[   81.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.250000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4e000, size 0x00001000
[   81.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.260000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c50000, size 0x00001000
[   81.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.280000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c52000, size 0x00001000
[   81.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.290000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c54000, size 0x00001000
[   81.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.310000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c56000, size 0x00001000
[   81.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.320000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c58000, size 0x00001000
[   81.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.330000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5a000, size 0x00000600
[   81.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.350000] imxdma0: imx_dma_disable
[   81.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   81.370000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5a600, size 0x00000a00
[   81.370000] imxdma0: imx_dma_enable
[   81.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.380000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5c000, size 0x00001000
[   81.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.390000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5e000, size 0x00001000
[   81.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.410000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c60000, size 0x00001000
[   81.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.420000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c62000, size 0x00001000
[   81.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.430000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c64000, size 0x00001000
[   81.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.450000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c66000, size 0x00001000
[   81.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.460000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c68000, size 0x00001000
[   81.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.470000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6a000, size 0x00000600
[   81.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.490000] imxdma0: imx_dma_disable
[   81.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   81.510000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6a600, size 0x00000a00
[   81.520000] imxdma0: imx_dma_enable
[   81.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.520000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6c000, size 0x00001000
[   81.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.530000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6e000, size 0x00001000
[   81.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.550000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c70000, size 0x00001000
[   81.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.560000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c72000, size 0x00001000
[   81.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.570000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c74000, size 0x00001000
[   81.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.590000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c76000, size 0x00001000
[   81.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.600000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c78000, size 0x00001000
[   81.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.610000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7a000, size 0x00000600
[   81.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.630000] imxdma0: imx_dma_disable
[   81.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   81.650000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7a600, size 0x00000a00
[   81.660000] imxdma0: imx_dma_enable
[   81.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.660000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7c000, size 0x00001000
[   81.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.670000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7e000, size 0x00001000
[   81.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.690000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c80000, size 0x00001000
[   81.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.700000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c82000, size 0x00001000
[   81.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.710000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c84000, size 0x00001000
[   81.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.730000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c86000, size 0x00001000
[   81.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.740000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c88000, size 0x00001000
[   81.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.760000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8a000, size 0x00000600
[   81.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.770000] imxdma0: imx_dma_disable
[   81.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=3 total length=10752 dev_addr=0x10014038 for write
[   81.790000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8a600, size 0x00000a00
[   81.800000] imxdma0: imx_dma_enable
[   81.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.800000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8c000, size 0x00001000
[   81.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.810000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8e000, size 0x00001000
[   81.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.830000] imxdma0: imx_dma_disable
[   81.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for write
[   81.850000] imxdma0: next sg chunk dst 0x10014038, src 0xa7377200, size 0x00000200
[   81.860000] imxdma0: imx_dma_enable
[   81.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.870000] imxdma0: imx_dma_disable
[   81.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for write
[   81.880000] imxdma0: next sg chunk dst 0x10014038, src 0xa7358200, size 0x00000200
[   81.890000] imxdma0: imx_dma_enable
[   81.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.900000] imxdma0: imx_dma_disable
[   81.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=3 total length=10752 dev_addr=0x10014038 for write
[   81.920000] imxdma0: next sg chunk dst 0x10014038, src 0xa0761000, size 0x00001000
[   81.920000] imxdma0: imx_dma_enable
[   81.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.930000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c90000, size 0x00001000
[   81.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.940000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c92000, size 0x00000a00
[   81.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.960000] imxdma0: imx_dma_disable
[   81.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   81.980000] imxdma0: next sg chunk dst 0x10014038, src 0xa73cfa00, size 0x00000600
[   81.980000] imxdma0: imx_dma_enable
[   81.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   81.990000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d1000, size 0x00001000
[   82.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.000000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d3000, size 0x00001000
[   82.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.010000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d5000, size 0x00001000
[   82.030000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.030000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d7000, size 0x00001000
[   82.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.040000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d9000, size 0x00001000
[   82.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.050000] imxdma0: next sg chunk dst 0x10014038, src 0xa73db000, size 0x00001000
[   82.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.070000] imxdma0: next sg chunk dst 0x10014038, src 0xa73dd000, size 0x00001000
[   82.090000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.090000] imxdma0: next sg chunk dst 0x10014038, src 0xa73df000, size 0x00000a00
[   82.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.100000] imxdma0: imx_dma_disable
[   82.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   82.120000] imxdma0: next sg chunk dst 0x10014038, src 0xa73dfa00, size 0x00000600
[   82.130000] imxdma0: imx_dma_enable
[   82.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.130000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e1000, size 0x00001000
[   82.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.140000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e3000, size 0x00001000
[   82.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.160000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e5000, size 0x00001000
[   82.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.170000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e7000, size 0x00001000
[   82.190000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.190000] imxdma0: next sg chunk dst 0x10014038, src 0xa73e9000, size 0x00001000
[   82.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.200000] imxdma0: next sg chunk dst 0x10014038, src 0xa73eb000, size 0x00001000
[   82.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.210000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ed000, size 0x00001000
[   82.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.230000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ef000, size 0x00000a00
[   82.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.250000] imxdma0: imx_dma_disable
[   82.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   82.260000] imxdma0: next sg chunk dst 0x10014038, src 0xa73efa00, size 0x00000600
[   82.270000] imxdma0: imx_dma_enable
[   82.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.270000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f1000, size 0x00001000
[   82.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.290000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f3000, size 0x00001000
[   82.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.300000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f5000, size 0x00001000
[   82.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.310000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f7000, size 0x00001000
[   82.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.330000] imxdma0: next sg chunk dst 0x10014038, src 0xa73f9000, size 0x00001000
[   82.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.340000] imxdma0: next sg chunk dst 0x10014038, src 0xa73fb000, size 0x00001000
[   82.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.350000] imxdma0: next sg chunk dst 0x10014038, src 0xa73fd000, size 0x00001000
[   82.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.370000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ff000, size 0x00000a00
[   82.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.390000] imxdma0: imx_dma_disable
[   82.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   82.400000] imxdma0: next sg chunk dst 0x10014038, src 0xa73ffa00, size 0x00000600
[   82.410000] imxdma0: imx_dma_enable
[   82.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.410000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c01000, size 0x00001000
[   82.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.430000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c03000, size 0x00001000
[   82.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.440000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c05000, size 0x00001000
[   82.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.450000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c07000, size 0x00001000
[   82.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.470000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c09000, size 0x00001000
[   82.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.480000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0b000, size 0x00001000
[   82.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.490000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0d000, size 0x00001000
[   82.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.510000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0f000, size 0x00000a00
[   82.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.530000] imxdma0: imx_dma_disable
[   82.540000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   82.550000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c0fa00, size 0x00000600
[   82.560000] imxdma0: imx_dma_enable
[   82.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.560000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c11000, size 0x00001000
[   82.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.570000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c13000, size 0x00001000
[   82.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.590000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c15000, size 0x00001000
[   82.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.600000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c17000, size 0x00001000
[   82.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.610000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c19000, size 0x00001000
[   82.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.630000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1b000, size 0x00001000
[   82.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.640000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1d000, size 0x00001000
[   82.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.660000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1f000, size 0x00000a00
[   82.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.670000] imxdma0: imx_dma_disable
[   82.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   82.690000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c1fa00, size 0x00000600
[   82.700000] imxdma0: imx_dma_enable
[   82.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.700000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c21000, size 0x00001000
[   82.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.710000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c23000, size 0x00001000
[   82.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.730000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c25000, size 0x00001000
[   82.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.740000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c27000, size 0x00001000
[   82.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.750000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c29000, size 0x00001000
[   82.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.770000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2b000, size 0x00001000
[   82.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.780000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2d000, size 0x00001000
[   82.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.800000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2f000, size 0x00000a00
[   82.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.810000] imxdma0: imx_dma_disable
[   82.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=5 total length=16896 dev_addr=0x10014038 for write
[   82.830000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c2fa00, size 0x00000600
[   82.840000] imxdma0: imx_dma_enable
[   82.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.840000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c31000, size 0x00001000
[   82.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.850000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c33000, size 0x00001000
[   82.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.870000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c35000, size 0x00001000
[   82.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.880000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c37000, size 0x00000c00
[   82.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.900000] imxdma0: imx_dma_disable
[   82.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   82.920000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c39600, size 0x00000a00
[   82.920000] imxdma0: imx_dma_enable
[   82.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.930000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c3b000, size 0x00001000
[   82.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.940000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c3d000, size 0x00001000
[   82.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.960000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c3f000, size 0x00001000
[   82.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.970000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c41000, size 0x00001000
[   82.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   82.980000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c43000, size 0x00001000
[   83.000000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.000000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c45000, size 0x00001000
[   83.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.010000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c47000, size 0x00001000
[   83.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.020000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c49000, size 0x00000600
[   83.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.040000] imxdma0: imx_dma_disable
[   83.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   83.060000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c49600, size 0x00000a00
[   83.070000] imxdma0: imx_dma_enable
[   83.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.070000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4b000, size 0x00001000
[   83.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.080000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4d000, size 0x00001000
[   83.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.100000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c4f000, size 0x00001000
[   83.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.110000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c51000, size 0x00001000
[   83.120000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.120000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c53000, size 0x00001000
[   83.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.140000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c55000, size 0x00001000
[   83.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.150000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c57000, size 0x00001000
[   83.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.160000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c59000, size 0x00000600
[   83.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.180000] imxdma0: imx_dma_disable
[   83.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   83.200000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c59600, size 0x00000a00
[   83.210000] imxdma0: imx_dma_enable
[   83.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.210000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5b000, size 0x00001000
[   83.220000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.220000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5d000, size 0x00001000
[   83.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.240000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c5f000, size 0x00001000
[   83.250000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.250000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c61000, size 0x00001000
[   83.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.260000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c63000, size 0x00001000
[   83.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.280000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c65000, size 0x00001000
[   83.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.290000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c67000, size 0x00001000
[   83.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.310000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c69000, size 0x00000600
[   83.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.320000] imxdma0: imx_dma_disable
[   83.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   83.340000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c69600, size 0x00000a00
[   83.350000] imxdma0: imx_dma_enable
[   83.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.350000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6b000, size 0x00001000
[   83.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.360000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6d000, size 0x00001000
[   83.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.380000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c6f000, size 0x00001000
[   83.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.390000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c71000, size 0x00001000
[   83.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.400000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c73000, size 0x00001000
[   83.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.420000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c75000, size 0x00001000
[   83.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.430000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c77000, size 0x00001000
[   83.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.450000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c79000, size 0x00000600
[   83.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.460000] imxdma0: imx_dma_disable
[   83.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   83.480000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c79600, size 0x00000a00
[   83.490000] imxdma0: imx_dma_enable
[   83.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.490000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7b000, size 0x00001000
[   83.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.500000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7d000, size 0x00001000
[   83.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.520000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c7f000, size 0x00001000
[   83.530000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.530000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c81000, size 0x00001000
[   83.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.550000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c83000, size 0x00001000
[   83.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.560000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c85000, size 0x00001000
[   83.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.570000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c87000, size 0x00001000
[   83.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.590000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c89000, size 0x00000600
[   83.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.610000] imxdma0: imx_dma_disable
[   83.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=6 total length=20480 dev_addr=0x10014038 for write
[   83.620000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c89600, size 0x00000a00
[   83.630000] imxdma0: imx_dma_enable
[   83.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.630000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8b000, size 0x00001000
[   83.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.650000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8d000, size 0x00001000
[   83.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.660000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c8f000, size 0x00001000
[   83.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.670000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c91000, size 0x00001000
[   83.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.690000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c93000, size 0x00000600
[   83.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.700000] imxdma0: imx_dma_disable
[   83.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=2048 dev_addr=0x10014038 for write
[   83.720000] imxdma0: next sg chunk dst 0x10014038, src 0xa73d0800, size 0x00000800
[   83.730000] imxdma0: imx_dma_enable
[   83.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.750000] imxdma0: imx_dma_disable
[   83.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.760000] imxdma0: next sg chunk dst 0xa6c92c00, src 0x10014038, size 0x00000200
[   83.770000] imxdma0: imx_dma_enable
[   83.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.780000] imxdma0: imx_dma_disable
[   83.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.790000] imxdma0: next sg chunk dst 0xa6c92e00, src 0x10014038, size 0x00000200
[   83.800000] imxdma0: imx_dma_enable
[   83.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.810000] imxdma0: imx_dma_disable
[   83.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.820000] imxdma0: next sg chunk dst 0xa6c94000, src 0x10014038, size 0x00000200
[   83.830000] imxdma0: imx_dma_enable
[   83.840000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.840000] imxdma0: imx_dma_disable
[   83.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.850000] imxdma0: next sg chunk dst 0xa6c94200, src 0x10014038, size 0x00000200
[   83.860000] imxdma0: imx_dma_enable
[   83.870000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.870000] imxdma0: imx_dma_disable
[   83.880000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.890000] imxdma0: next sg chunk dst 0xa6c94400, src 0x10014038, size 0x00000200
[   83.890000] imxdma0: imx_dma_enable
[   83.900000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.900000] imxdma0: imx_dma_disable
[   83.910000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.920000] imxdma0: next sg chunk dst 0xa6c94600, src 0x10014038, size 0x00000200
[   83.920000] imxdma0: imx_dma_enable
[   83.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.930000] imxdma0: imx_dma_disable
[   83.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.950000] imxdma0: next sg chunk dst 0xa6c94800, src 0x10014038, size 0x00000200
[   83.960000] imxdma0: imx_dma_enable
[   83.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   83.970000] imxdma0: imx_dma_disable
[   83.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   83.980000] imxdma0: next sg chunk dst 0xa6c94a00, src 0x10014038, size 0x00000200
[   83.990000] imxdma0: imx_dma_enable
[   83.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.000000] imxdma0: imx_dma_disable
[   84.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.010000] imxdma0: next sg chunk dst 0xa6c94c00, src 0x10014038, size 0x00000200
[   84.020000] imxdma0: imx_dma_enable
[   84.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.030000] imxdma0: imx_dma_disable
[   84.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.040000] imxdma0: next sg chunk dst 0xa6c94e00, src 0x10014038, size 0x00000200
[   84.050000] imxdma0: imx_dma_enable
[   84.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.060000] imxdma0: imx_dma_disable
[   84.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.070000] imxdma0: next sg chunk dst 0xa6c96000, src 0x10014038, size 0x00000200
[   84.080000] imxdma0: imx_dma_enable
[   84.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.090000] imxdma0: imx_dma_disable
[   84.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.100000] imxdma0: next sg chunk dst 0xa6c96200, src 0x10014038, size 0x00000200
[   84.110000] imxdma0: imx_dma_enable
[   84.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.120000] imxdma0: imx_dma_disable
[   84.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.130000] imxdma0: next sg chunk dst 0xa6c96400, src 0x10014038, size 0x00000200
[   84.140000] imxdma0: imx_dma_enable
[   84.150000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.150000] imxdma0: imx_dma_disable
[   84.160000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.170000] imxdma0: next sg chunk dst 0xa6c96600, src 0x10014038, size 0x00000200
[   84.170000] imxdma0: imx_dma_enable
[   84.180000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.180000] imxdma0: imx_dma_disable
[   84.190000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.200000] imxdma0: next sg chunk dst 0xa6c96800, src 0x10014038, size 0x00000200
[   84.200000] imxdma0: imx_dma_enable
[   84.210000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.210000] imxdma0: imx_dma_disable
[   84.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.230000] imxdma0: next sg chunk dst 0xa6c96a00, src 0x10014038, size 0x00000200
[   84.230000] imxdma0: imx_dma_enable
[   84.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.240000] imxdma0: imx_dma_disable
[   84.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.260000] imxdma0: next sg chunk dst 0xa6c96c00, src 0x10014038, size 0x00000200
[   84.270000] imxdma0: imx_dma_enable
[   84.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.280000] imxdma0: imx_dma_disable
[   84.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.290000] imxdma0: next sg chunk dst 0xa6c96e00, src 0x10014038, size 0x00000200
[   84.300000] imxdma0: imx_dma_enable
[   84.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.310000] imxdma0: imx_dma_disable
[   84.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.320000] imxdma0: next sg chunk dst 0xa6c98000, src 0x10014038, size 0x00000200
[   84.330000] imxdma0: imx_dma_enable
[   84.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.340000] imxdma0: imx_dma_disable
[   84.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.350000] imxdma0: next sg chunk dst 0xa6c98200, src 0x10014038, size 0x00000200
[   84.360000] imxdma0: imx_dma_enable
[   84.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.370000] imxdma0: imx_dma_disable
[   84.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.380000] imxdma0: next sg chunk dst 0xa6c98400, src 0x10014038, size 0x00000200
[   84.390000] imxdma0: imx_dma_enable
[   84.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.400000] imxdma0: imx_dma_disable
[   84.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.410000] imxdma0: next sg chunk dst 0xa6c98600, src 0x10014038, size 0x00000200
[   84.420000] imxdma0: imx_dma_enable
[   84.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.430000] imxdma0: imx_dma_disable
[   84.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.440000] imxdma0: next sg chunk dst 0xa6c98800, src 0x10014038, size 0x00000200
[   84.450000] imxdma0: imx_dma_enable
[   84.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.460000] imxdma0: imx_dma_disable
[   84.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.480000] imxdma0: next sg chunk dst 0xa6c98a00, src 0x10014038, size 0x00000200
[   84.480000] imxdma0: imx_dma_enable
[   84.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.490000] imxdma0: imx_dma_disable
[   84.500000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.510000] imxdma0: next sg chunk dst 0xa6c98c00, src 0x10014038, size 0x00000200
[   84.510000] imxdma0: imx_dma_enable
[   84.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.520000] imxdma0: imx_dma_disable
[   84.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.540000] imxdma0: next sg chunk dst 0xa6c98e00, src 0x10014038, size 0x00000200
[   84.550000] imxdma0: imx_dma_enable
[   84.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.550000] imxdma0: imx_dma_disable
[   84.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.570000] imxdma0: next sg chunk dst 0xa7366000, src 0x10014038, size 0x00000200
[   84.580000] imxdma0: imx_dma_enable
[   84.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.590000] imxdma0: imx_dma_disable
[   84.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.600000] imxdma0: next sg chunk dst 0xa7366200, src 0x10014038, size 0x00000200
[   84.610000] imxdma0: imx_dma_enable
[   84.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.620000] imxdma0: imx_dma_disable
[   84.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.630000] imxdma0: next sg chunk dst 0xa7366400, src 0x10014038, size 0x00000200
[   84.640000] imxdma0: imx_dma_enable
[   84.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.650000] imxdma0: imx_dma_disable
[   84.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.660000] imxdma0: next sg chunk dst 0xa7366800, src 0x10014038, size 0x00000200
[   84.670000] imxdma0: imx_dma_enable
[   84.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.680000] imxdma0: imx_dma_disable
[   84.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.690000] imxdma0: next sg chunk dst 0xa7366a00, src 0x10014038, size 0x00000200
[   84.700000] imxdma0: imx_dma_enable
[   84.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.710000] imxdma0: imx_dma_disable
[   84.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.720000] imxdma0: next sg chunk dst 0xa7366c00, src 0x10014038, size 0x00000200
[   84.730000] imxdma0: imx_dma_enable
[   84.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.740000] imxdma0: imx_dma_disable
[   84.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.750000] imxdma0: next sg chunk dst 0xa7366e00, src 0x10014038, size 0x00000200
[   84.760000] imxdma0: imx_dma_enable
[   84.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.770000] imxdma0: imx_dma_disable
[   84.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.790000] imxdma0: next sg chunk dst 0xa6c9b000, src 0x10014038, size 0x00000200
[   84.790000] imxdma0: imx_dma_enable
[   84.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.800000] imxdma0: imx_dma_disable
[   84.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.820000] imxdma0: next sg chunk dst 0xa6c9b200, src 0x10014038, size 0x00000200
[   84.820000] imxdma0: imx_dma_enable
[   84.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.830000] imxdma0: imx_dma_disable
[   84.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.850000] imxdma0: next sg chunk dst 0xa6c9b400, src 0x10014038, size 0x00000200
[   84.860000] imxdma0: imx_dma_enable
[   84.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.860000] imxdma0: imx_dma_disable
[   84.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.880000] imxdma0: next sg chunk dst 0xa6c9b600, src 0x10014038, size 0x00000200
[   84.890000] imxdma0: imx_dma_enable
[   84.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.900000] imxdma0: imx_dma_disable
[   84.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.910000] imxdma0: next sg chunk dst 0xa6c9b800, src 0x10014038, size 0x00000200
[   84.920000] imxdma0: imx_dma_enable
[   84.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.930000] imxdma0: imx_dma_disable
[   84.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.940000] imxdma0: next sg chunk dst 0xa6c9ba00, src 0x10014038, size 0x00000200
[   84.950000] imxdma0: imx_dma_enable
[   84.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.960000] imxdma0: imx_dma_disable
[   84.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   84.970000] imxdma0: next sg chunk dst 0xa6c9bc00, src 0x10014038, size 0x00000200
[   84.980000] imxdma0: imx_dma_enable
[   84.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   84.990000] imxdma0: imx_dma_disable
[   84.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.000000] imxdma0: next sg chunk dst 0xa6c9be00, src 0x10014038, size 0x00000200
[   85.010000] imxdma0: imx_dma_enable
[   85.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.020000] imxdma0: imx_dma_disable
[   85.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.030000] imxdma0: next sg chunk dst 0xa6c9d000, src 0x10014038, size 0x00000200
[   85.040000] imxdma0: imx_dma_enable
[   85.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.050000] imxdma0: imx_dma_disable
[   85.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.060000] imxdma0: next sg chunk dst 0xa6c9d200, src 0x10014038, size 0x00000200
[   85.070000] imxdma0: imx_dma_enable
[   85.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.080000] imxdma0: imx_dma_disable
[   85.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.100000] imxdma0: next sg chunk dst 0xa6c9d400, src 0x10014038, size 0x00000200
[   85.100000] imxdma0: imx_dma_enable
[   85.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.110000] imxdma0: imx_dma_disable
[   85.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.130000] imxdma0: next sg chunk dst 0xa6c9d600, src 0x10014038, size 0x00000200
[   85.130000] imxdma0: imx_dma_enable
[   85.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.140000] imxdma0: imx_dma_disable
[   85.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.160000] imxdma0: next sg chunk dst 0xa6c9d800, src 0x10014038, size 0x00000200
[   85.170000] imxdma0: imx_dma_enable
[   85.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.170000] imxdma0: imx_dma_disable
[   85.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.190000] imxdma0: next sg chunk dst 0xa6c9da00, src 0x10014038, size 0x00000200
[   85.200000] imxdma0: imx_dma_enable
[   85.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.210000] imxdma0: imx_dma_disable
[   85.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.220000] imxdma0: next sg chunk dst 0xa6c9dc00, src 0x10014038, size 0x00000200
[   85.230000] imxdma0: imx_dma_enable
[   85.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.240000] imxdma0: imx_dma_disable
[   85.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for write
[   85.250000] imxdma0: next sg chunk dst 0x10014038, src 0xa7358200, size 0x00000200
[   85.260000] imxdma0: imx_dma_enable
[   85.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.290000] imxdma0: imx_dma_disable
[   85.290000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=7 total length=25088 dev_addr=0x10014038 for write
[   85.300000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c92a00, size 0x00000600
[   85.310000] imxdma0: imx_dma_enable
[   85.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.310000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c94000, size 0x00001000
[   85.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.330000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c96000, size 0x00001000
[   85.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.340000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c98000, size 0x00001000
[   85.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.350000] imxdma0: next sg chunk dst 0x10014038, src 0xa7366000, size 0x00001000
[   85.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.370000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9b000, size 0x00001000
[   85.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.380000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9d000, size 0x00000c00
[   85.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.400000] imxdma0: imx_dma_disable
[   85.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=7 total length=25600 dev_addr=0x10014038 for write
[   85.420000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c93400, size 0x00000c00
[   85.430000] imxdma0: imx_dma_enable
[   85.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.440000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c95000, size 0x00001000
[   85.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.450000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c97000, size 0x00001000
[   85.460000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.460000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c99000, size 0x00001000
[   85.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.480000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9a000, size 0x00001000
[   85.490000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.490000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9c000, size 0x00001000
[   85.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.510000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9e000, size 0x00000800
[   85.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.530000] imxdma0: imx_dma_disable
[   85.530000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.540000] imxdma0: next sg chunk dst 0xa6c9de00, src 0x10014038, size 0x00000200
[   85.550000] imxdma0: imx_dma_enable
[   85.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.560000] imxdma0: imx_dma_disable
[   85.560000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.570000] imxdma0: next sg chunk dst 0xa6c9f000, src 0x10014038, size 0x00000200
[   85.580000] imxdma0: imx_dma_enable
[   85.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.590000] imxdma0: imx_dma_disable
[   85.600000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.600000] imxdma0: next sg chunk dst 0xa6c9f200, src 0x10014038, size 0x00000200
[   85.610000] imxdma0: imx_dma_enable
[   85.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.620000] imxdma0: imx_dma_disable
[   85.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.640000] imxdma0: next sg chunk dst 0xa6c9f400, src 0x10014038, size 0x00000200
[   85.640000] imxdma0: imx_dma_enable
[   85.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.650000] imxdma0: imx_dma_disable
[   85.660000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.670000] imxdma0: next sg chunk dst 0xa6c9f600, src 0x10014038, size 0x00000200
[   85.670000] imxdma0: imx_dma_enable
[   85.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.680000] imxdma0: imx_dma_disable
[   85.690000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.700000] imxdma0: next sg chunk dst 0xa6c9f800, src 0x10014038, size 0x00000200
[   85.710000] imxdma0: imx_dma_enable
[   85.710000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.720000] imxdma0: imx_dma_disable
[   85.720000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.730000] imxdma0: next sg chunk dst 0xa6c9fa00, src 0x10014038, size 0x00000200
[   85.740000] imxdma0: imx_dma_enable
[   85.740000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.750000] imxdma0: imx_dma_disable
[   85.750000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.760000] imxdma0: next sg chunk dst 0xa6c9fc00, src 0x10014038, size 0x00000200
[   85.770000] imxdma0: imx_dma_enable
[   85.770000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.780000] imxdma0: imx_dma_disable
[   85.780000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.790000] imxdma0: next sg chunk dst 0xa6c9fe00, src 0x10014038, size 0x00000200
[   85.800000] imxdma0: imx_dma_enable
[   85.800000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.810000] imxdma0: imx_dma_disable
[   85.810000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.820000] imxdma0: next sg chunk dst 0xa6ca1000, src 0x10014038, size 0x00000200
[   85.830000] imxdma0: imx_dma_enable
[   85.830000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.840000] imxdma0: imx_dma_disable
[   85.840000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.850000] imxdma0: next sg chunk dst 0xa6ca1200, src 0x10014038, size 0x00000200
[   85.860000] imxdma0: imx_dma_enable
[   85.860000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.870000] imxdma0: imx_dma_disable
[   85.870000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.880000] imxdma0: next sg chunk dst 0xa6ca1400, src 0x10014038, size 0x00000200
[   85.890000] imxdma0: imx_dma_enable
[   85.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.900000] imxdma0: imx_dma_disable
[   85.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.910000] imxdma0: next sg chunk dst 0xa6ca1600, src 0x10014038, size 0x00000200
[   85.920000] imxdma0: imx_dma_enable
[   85.930000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.930000] imxdma0: imx_dma_disable
[   85.940000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.950000] imxdma0: next sg chunk dst 0xa6ca1800, src 0x10014038, size 0x00000200
[   85.950000] imxdma0: imx_dma_enable
[   85.960000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.960000] imxdma0: imx_dma_disable
[   85.970000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   85.980000] imxdma0: next sg chunk dst 0xa6ca1a00, src 0x10014038, size 0x00000200
[   85.980000] imxdma0: imx_dma_enable
[   85.990000] imxdma: dma_irq_handler called, disr=0x00000001
[   85.990000] imxdma0: imx_dma_disable
[   86.000000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.010000] imxdma0: next sg chunk dst 0xa6ca1c00, src 0x10014038, size 0x00000200
[   86.010000] imxdma0: imx_dma_enable
[   86.020000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.020000] imxdma0: imx_dma_disable
[   86.030000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.040000] imxdma0: next sg chunk dst 0xa6ca1e00, src 0x10014038, size 0x00000200
[   86.050000] imxdma0: imx_dma_enable
[   86.050000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.060000] imxdma0: imx_dma_disable
[   86.060000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.070000] imxdma0: next sg chunk dst 0xa6ca3000, src 0x10014038, size 0x00000200
[   86.080000] imxdma0: imx_dma_enable
[   86.080000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.090000] imxdma0: imx_dma_disable
[   86.090000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.100000] imxdma0: next sg chunk dst 0xa6ca3200, src 0x10014038, size 0x00000200
[   86.110000] imxdma0: imx_dma_enable
[   86.110000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.120000] imxdma0: imx_dma_disable
[   86.120000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.130000] imxdma0: next sg chunk dst 0xa6ca3400, src 0x10014038, size 0x00000200
[   86.140000] imxdma0: imx_dma_enable
[   86.140000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.150000] imxdma0: imx_dma_disable
[   86.150000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.160000] imxdma0: next sg chunk dst 0xa6ca3600, src 0x10014038, size 0x00000200
[   86.170000] imxdma0: imx_dma_enable
[   86.170000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.180000] imxdma0: imx_dma_disable
[   86.180000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.190000] imxdma0: next sg chunk dst 0xa6ca3800, src 0x10014038, size 0x00000200
[   86.200000] imxdma0: imx_dma_enable
[   86.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.210000] imxdma0: imx_dma_disable
[   86.210000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.220000] imxdma0: next sg chunk dst 0xa6ca3a00, src 0x10014038, size 0x00000200
[   86.230000] imxdma0: imx_dma_enable
[   86.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.240000] imxdma0: imx_dma_disable
[   86.250000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.250000] imxdma0: next sg chunk dst 0xa6ca3c00, src 0x10014038, size 0x00000200
[   86.260000] imxdma0: imx_dma_enable
[   86.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.270000] imxdma0: imx_dma_disable
[   86.280000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.290000] imxdma0: next sg chunk dst 0xa6ca3e00, src 0x10014038, size 0x00000200
[   86.290000] imxdma0: imx_dma_enable
[   86.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.300000] imxdma0: imx_dma_disable
[   86.310000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.320000] imxdma0: next sg chunk dst 0xa6ca5000, src 0x10014038, size 0x00000200
[   86.320000] imxdma0: imx_dma_enable
[   86.330000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.330000] imxdma0: imx_dma_disable
[   86.340000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.350000] imxdma0: next sg chunk dst 0xa6ca5200, src 0x10014038, size 0x00000200
[   86.360000] imxdma0: imx_dma_enable
[   86.360000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.370000] imxdma0: imx_dma_disable
[   86.370000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.380000] imxdma0: next sg chunk dst 0xa6ca5400, src 0x10014038, size 0x00000200
[   86.390000] imxdma0: imx_dma_enable
[   86.390000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.400000] imxdma0: imx_dma_disable
[   86.400000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.410000] imxdma0: next sg chunk dst 0xa6ca5600, src 0x10014038, size 0x00000200
[   86.420000] imxdma0: imx_dma_enable
[   86.420000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.430000] imxdma0: imx_dma_disable
[   86.430000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.440000] imxdma0: next sg chunk dst 0xa6ca5800, src 0x10014038, size 0x00000200
[   86.450000] imxdma0: imx_dma_enable
[   86.450000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.460000] imxdma0: imx_dma_disable
[   86.460000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.470000] imxdma0: next sg chunk dst 0xa6ca5a00, src 0x10014038, size 0x00000200
[   86.480000] imxdma0: imx_dma_enable
[   86.480000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.490000] imxdma0: imx_dma_disable
[   86.490000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.500000] imxdma0: next sg chunk dst 0xa6ca5c00, src 0x10014038, size 0x00000200
[   86.510000] imxdma0: imx_dma_enable
[   86.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.520000] imxdma0: imx_dma_disable
[   86.520000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.530000] imxdma0: next sg chunk dst 0xa6ca5e00, src 0x10014038, size 0x00000200
[   86.540000] imxdma0: imx_dma_enable
[   86.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.550000] imxdma0: imx_dma_disable
[   86.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.560000] imxdma0: next sg chunk dst 0xa6ca7000, src 0x10014038, size 0x00000200
[   86.570000] imxdma0: imx_dma_enable
[   86.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.580000] imxdma0: imx_dma_disable
[   86.590000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.600000] imxdma0: next sg chunk dst 0xa6ca7200, src 0x10014038, size 0x00000200
[   86.600000] imxdma0: imx_dma_enable
[   86.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.610000] imxdma0: imx_dma_disable
[   86.620000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.630000] imxdma0: next sg chunk dst 0xa6ca7400, src 0x10014038, size 0x00000200
[   86.630000] imxdma0: imx_dma_enable
[   86.640000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.640000] imxdma0: imx_dma_disable
[   86.650000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.660000] imxdma0: next sg chunk dst 0xa6ca7600, src 0x10014038, size 0x00000200
[   86.670000] imxdma0: imx_dma_enable
[   86.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.670000] imxdma0: imx_dma_disable
[   86.680000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.690000] imxdma0: next sg chunk dst 0xa6ca7800, src 0x10014038, size 0x00000200
[   86.700000] imxdma0: imx_dma_enable
[   86.700000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.710000] imxdma0: imx_dma_disable
[   86.710000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.720000] imxdma0: next sg chunk dst 0xa6ca7a00, src 0x10014038, size 0x00000200
[   86.730000] imxdma0: imx_dma_enable
[   86.730000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.740000] imxdma0: imx_dma_disable
[   86.740000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.750000] imxdma0: next sg chunk dst 0xa6ca7c00, src 0x10014038, size 0x00000200
[   86.760000] imxdma0: imx_dma_enable
[   86.760000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.770000] imxdma0: imx_dma_disable
[   86.770000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.780000] imxdma0: next sg chunk dst 0xa6ca7e00, src 0x10014038, size 0x00000200
[   86.790000] imxdma0: imx_dma_enable
[   86.790000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.800000] imxdma0: imx_dma_disable
[   86.800000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.810000] imxdma0: next sg chunk dst 0xa6ca9000, src 0x10014038, size 0x00000200
[   86.820000] imxdma0: imx_dma_enable
[   86.820000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.830000] imxdma0: imx_dma_disable
[   86.830000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.840000] imxdma0: next sg chunk dst 0xa6ca9200, src 0x10014038, size 0x00000200
[   86.850000] imxdma0: imx_dma_enable
[   86.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.860000] imxdma0: imx_dma_disable
[   86.860000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.870000] imxdma0: next sg chunk dst 0xa6ca9400, src 0x10014038, size 0x00000200
[   86.880000] imxdma0: imx_dma_enable
[   86.890000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.890000] imxdma0: imx_dma_disable
[   86.900000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.900000] imxdma0: next sg chunk dst 0xa6ca9600, src 0x10014038, size 0x00000200
[   86.910000] imxdma0: imx_dma_enable
[   86.920000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.920000] imxdma0: imx_dma_disable
[   86.930000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.940000] imxdma0: next sg chunk dst 0xa6ca9800, src 0x10014038, size 0x00000200
[   86.940000] imxdma0: imx_dma_enable
[   86.950000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.950000] imxdma0: imx_dma_disable
[   86.960000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   86.970000] imxdma0: next sg chunk dst 0xa6ca9a00, src 0x10014038, size 0x00000200
[   86.970000] imxdma0: imx_dma_enable
[   86.980000] imxdma: dma_irq_handler called, disr=0x00000001
[   86.980000] imxdma0: imx_dma_disable
[   86.990000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.000000] imxdma0: next sg chunk dst 0xa6ca9c00, src 0x10014038, size 0x00000200
[   87.010000] imxdma0: imx_dma_enable
[   87.010000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.020000] imxdma0: imx_dma_disable
[   87.020000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.030000] imxdma0: next sg chunk dst 0xa6ca9e00, src 0x10014038, size 0x00000200
[   87.040000] imxdma0: imx_dma_enable
[   87.040000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.050000] imxdma0: imx_dma_disable
[   87.050000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.060000] imxdma0: next sg chunk dst 0xa6cab000, src 0x10014038, size 0x00000200
[   87.070000] imxdma0: imx_dma_enable
[   87.070000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.080000] imxdma0: imx_dma_disable
[   87.080000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.090000] imxdma0: next sg chunk dst 0xa6cab200, src 0x10014038, size 0x00000200
[   87.100000] imxdma0: imx_dma_enable
[   87.100000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.110000] imxdma0: imx_dma_disable
[   87.110000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.120000] imxdma0: next sg chunk dst 0xa6cab400, src 0x10014038, size 0x00000200
[   87.130000] imxdma0: imx_dma_enable
[   87.130000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.140000] imxdma0: imx_dma_disable
[   87.140000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.150000] imxdma0: next sg chunk dst 0xa6cab600, src 0x10014038, size 0x00000200
[   87.160000] imxdma0: imx_dma_enable
[   87.160000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.170000] imxdma0: imx_dma_disable
[   87.170000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.180000] imxdma0: next sg chunk dst 0xa6cab800, src 0x10014038, size 0x00000200
[   87.190000] imxdma0: imx_dma_enable
[   87.200000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.200000] imxdma0: imx_dma_disable
[   87.200000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.210000] imxdma0: next sg chunk dst 0xa6caba00, src 0x10014038, size 0x00000200
[   87.220000] imxdma0: imx_dma_enable
[   87.230000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.230000] imxdma0: imx_dma_disable
[   87.240000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.250000] imxdma0: next sg chunk dst 0xa6cabc00, src 0x10014038, size 0x00000200
[   87.250000] imxdma0: imx_dma_enable
[   87.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.260000] imxdma0: imx_dma_disable
[   87.270000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.280000] imxdma0: next sg chunk dst 0xa6cabe00, src 0x10014038, size 0x00000200
[   87.280000] imxdma0: imx_dma_enable
[   87.290000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.290000] imxdma0: imx_dma_disable
[   87.300000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.310000] imxdma0: next sg chunk dst 0xa6cad000, src 0x10014038, size 0x00000200
[   87.310000] imxdma0: imx_dma_enable
[   87.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.320000] imxdma0: imx_dma_disable
[   87.330000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.340000] imxdma0: next sg chunk dst 0xa6cad200, src 0x10014038, size 0x00000200
[   87.350000] imxdma0: imx_dma_enable
[   87.350000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.360000] imxdma0: imx_dma_disable
[   87.360000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.370000] imxdma0: next sg chunk dst 0xa6cad400, src 0x10014038, size 0x00000200
[   87.380000] imxdma0: imx_dma_enable
[   87.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.390000] imxdma0: imx_dma_disable
[   87.390000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.400000] imxdma0: next sg chunk dst 0xa6cad600, src 0x10014038, size 0x00000200
[   87.410000] imxdma0: imx_dma_enable
[   87.410000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.420000] imxdma0: imx_dma_disable
[   87.420000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.430000] imxdma0: next sg chunk dst 0xa6cad800, src 0x10014038, size 0x00000200
[   87.440000] imxdma0: imx_dma_enable
[   87.440000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.450000] imxdma0: imx_dma_disable
[   87.450000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.460000] imxdma0: next sg chunk dst 0xa6cada00, src 0x10014038, size 0x00000200
[   87.470000] imxdma0: imx_dma_enable
[   87.470000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.480000] imxdma0: imx_dma_disable
[   87.480000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.490000] imxdma0: next sg chunk dst 0xa6cadc00, src 0x10014038, size 0x00000200
[   87.500000] imxdma0: imx_dma_enable
[   87.500000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.510000] imxdma0: imx_dma_disable
[   87.510000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.520000] imxdma0: next sg chunk dst 0xa6cade00, src 0x10014038, size 0x00000200
[   87.530000] imxdma0: imx_dma_enable
[   87.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.540000] imxdma0: imx_dma_disable
[   87.550000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.550000] imxdma0: next sg chunk dst 0xa6caf000, src 0x10014038, size 0x00000200
[   87.560000] imxdma0: imx_dma_enable
[   87.570000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.570000] imxdma0: imx_dma_disable
[   87.580000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.590000] imxdma0: next sg chunk dst 0xa6caf200, src 0x10014038, size 0x00000200
[   87.590000] imxdma0: imx_dma_enable
[   87.600000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.600000] imxdma0: imx_dma_disable
[   87.610000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.620000] imxdma0: next sg chunk dst 0xa6caf400, src 0x10014038, size 0x00000200
[   87.620000] imxdma0: imx_dma_enable
[   87.630000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.630000] imxdma0: imx_dma_disable
[   87.640000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.650000] imxdma0: next sg chunk dst 0xa6caf600, src 0x10014038, size 0x00000200
[   87.660000] imxdma0: imx_dma_enable
[   87.660000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.670000] imxdma0: imx_dma_disable
[   87.670000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.680000] imxdma0: next sg chunk dst 0xa6caf800, src 0x10014038, size 0x00000200
[   87.690000] imxdma0: imx_dma_enable
[   87.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.700000] imxdma0: imx_dma_disable
[   87.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.710000] imxdma0: next sg chunk dst 0xa6cafa00, src 0x10014038, size 0x00000200
[   87.720000] imxdma0: imx_dma_enable
[   87.720000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.730000] imxdma0: imx_dma_disable
[   87.730000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.740000] imxdma0: next sg chunk dst 0xa6cafc00, src 0x10014038, size 0x00000200
[   87.750000] imxdma0: imx_dma_enable
[   87.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.760000] imxdma0: imx_dma_disable
[   87.760000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.770000] imxdma0: next sg chunk dst 0xa6cafe00, src 0x10014038, size 0x00000200
[   87.780000] imxdma0: imx_dma_enable
[   87.780000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.790000] imxdma0: imx_dma_disable
[   87.790000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.800000] imxdma0: next sg chunk dst 0xa73a1000, src 0x10014038, size 0x00000200
[   87.810000] imxdma0: imx_dma_enable
[   87.810000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.820000] imxdma0: imx_dma_disable
[   87.820000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.830000] imxdma0: next sg chunk dst 0xa73a1200, src 0x10014038, size 0x00000200
[   87.840000] imxdma0: imx_dma_enable
[   87.850000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.850000] imxdma0: imx_dma_disable
[   87.850000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.860000] imxdma0: next sg chunk dst 0xa73a1400, src 0x10014038, size 0x00000200
[   87.870000] imxdma0: imx_dma_enable
[   87.880000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.880000] imxdma0: imx_dma_disable
[   87.890000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.900000] imxdma0: next sg chunk dst 0xa73a1600, src 0x10014038, size 0x00000200
[   87.900000] imxdma0: imx_dma_enable
[   87.910000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.910000] imxdma0: imx_dma_disable
[   87.920000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.930000] imxdma0: next sg chunk dst 0xa73a1800, src 0x10014038, size 0x00000200
[   87.930000] imxdma0: imx_dma_enable
[   87.940000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.940000] imxdma0: imx_dma_disable
[   87.950000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for read
[   87.960000] imxdma0: next sg chunk dst 0xa73a1a00, src 0x10014038, size 0x00000200
[   87.960000] imxdma0: imx_dma_enable
[   87.970000] imxdma: dma_irq_handler called, disr=0x00000001
[   87.970000] imxdma0: imx_dma_disable
500+0 records in
500+0 records out
real    0m 38.51s
user    0m 0.00s
sys     0m 0.21s
root@phyCARD:~ [   90.220000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=8 total length=32768 dev_addr=0x10014038 for write
[   90.230000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca0000, size 0x00001000
[   90.240000] imxdma0: imx_dma_enable
[   90.240000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.240000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca2000, size 0x00001000
[   90.260000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.260000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca4000, size 0x00001000
[   90.270000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.270000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca6000, size 0x00001000
[   90.280000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.280000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca8000, size 0x00001000
[   90.300000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.300000] imxdma0: next sg chunk dst 0x10014038, src 0xa6caa000, size 0x00001000
[   90.310000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.310000] imxdma0: next sg chunk dst 0x10014038, src 0xa6cac000, size 0x00001000
[   90.320000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.320000] imxdma0: next sg chunk dst 0x10014038, src 0xa6cae000, size 0x00001000
[   90.340000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.340000] imxdma0: imx_dma_disable
[   90.350000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=3 total length=11264 dev_addr=0x10014038 for write
[   90.360000] imxdma0: next sg chunk dst 0x10014038, src 0xa6cb0000, size 0x00001000
[   90.370000] imxdma0: imx_dma_enable
[   90.370000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.370000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a3000, size 0x00001000
[   90.380000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.380000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a4000, size 0x00000c00
[   90.400000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.400000] imxdma0: imx_dma_disable
[   90.410000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=512 dev_addr=0x10014038 for write
[   90.420000] imxdma0: next sg chunk dst 0x10014038, src 0xa7358200, size 0x00000200
[   90.420000] imxdma0: imx_dma_enable
[   90.430000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.470000] imxdma0: imx_dma_disable
[   90.470000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=9 total length=32768 dev_addr=0x10014038 for write
[   90.480000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9dc00, size 0x00000400
[   90.490000] imxdma0: imx_dma_enable
[   90.510000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.510000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9f000, size 0x00001000
[   90.520000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.520000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca1000, size 0x00001000
[   90.540000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.540000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca3000, size 0x00001000
[   90.550000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.550000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca5000, size 0x00001000
[   90.560000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.560000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca7000, size 0x00001000
[   90.580000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.580000] imxdma0: next sg chunk dst 0x10014038, src 0xa6ca9000, size 0x00001000
[   90.590000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.590000] imxdma0: next sg chunk dst 0x10014038, src 0xa6cab000, size 0x00001000
[   90.610000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.610000] imxdma0: next sg chunk dst 0x10014038, src 0xa6cad000, size 0x00000c00
[   90.620000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.630000] imxdma0: imx_dma_disable
[   90.630000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=4 total length=12288 dev_addr=0x10014038 for write
[   90.640000] imxdma0: next sg chunk dst 0x10014038, src 0xa6cadc00, size 0x00000400
[   90.650000] imxdma0: imx_dma_enable
[   90.650000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.650000] imxdma0: next sg chunk dst 0x10014038, src 0xa6caf000, size 0x00001000
[   90.670000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.670000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a1000, size 0x00001000
[   90.680000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.680000] imxdma0: next sg chunk dst 0x10014038, src 0xa73a2000, size 0x00000c00
[   90.690000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.700000] imxdma0: imx_dma_disable
[   90.700000] imxdma0: imx_dma_setup_sg sg=c7ae3800 sgcount=1 total length=2560 dev_addr=0x10014038 for write
[   90.710000] imxdma0: next sg chunk dst 0x10014038, src 0xa6c9e600, size 0x00000a00
[   90.720000] imxdma0: imx_dma_enable
[   90.750000] imxdma: dma_irq_handler called, disr=0x00000001
[   90.760000] imxdma0: imx_dma_disable

root@phyCARD:~



