Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3BQG02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:26:28 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:35405
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356Ab3BQG0Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:26:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 17 Feb 2013 14:26:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Michael Ellerman <michael@ellerman.id.au>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476  (tty is NULL)
Message-ID: <20130217062609.GA16632@S2101-09.ap.freescale.net>
References: <20130102153744.GC25940@redhat.com>
 <20130118205358.GA6854@redhat.com>
 <20130118210728.GA16742@kroah.com>
 <50FB0957.2000400@suse.cz>
 <1359570837.3325.30.camel@thor.lan>
 <20130211024412.GA7623@concordia>
 <1360593750.25941.13.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1360593750.25941.13.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Feb 11, 2013 at 09:42:30AM -0500, Peter Hurley wrote:
> Can you reproduce after using the following patch series?
> [PATCH v3 00/23] ldisc fixes
> 
I'm constantly seeing this warning on my board (imx6q - ARM Cortex-A9
Quad) with -next kernel, while I believe v3.8-rc kernel works just
fine for me.

The warning can be seen during both boot and suspend/resume (in a
couple of iterations).  The bad thing is "[PATCH v3 00/23] ldisc
fixes" does not help my case at all.

Shawn

Booting Linux on physical CPU 0x0
Linux version 3.8.0-rc7-next-20130215+ (r65073@S2101-09) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #330 SMP Sun Feb 17 13:59:44 CST
2013
CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: Freescale i.MX6 Quad (Device Tree), model: Freescale i.MX6Q
SABRE Smart Device Board
Memory policy: ECC disabled, Data cache writealloc
On node 0 totalpages: 262144
free_area_init_node: node 0, pgdat 80746180, node_mem_map 8079f000
  Normal zone: 2048 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 262144 pages, LIFO batch:31
PERCPU: Embedded 7 pages/cpu @80fad000 s6656 r8192 d13824 u32768
pcpu-alloc: s6656 r8192 d13824 u32768 alloc=8*4096
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
260096
Kernel command line: console=ttymxc0,115200 debug earlyprintk
no_console_suspend root=/dev/nfs ip=dhcp
nfsroot=192.168.1.100:/home/r65073/nfs/rfs-imx6q,v3,tcp
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
__ex_table already sorted, skipping sort
Memory: 1024MB = 1024MB total
Memory: 1031576k/1031576k available, 17000k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc0800000 - 0xff000000   (1000 MB)
    lowmem  : 0x80000000 - 0xc0000000   (1024 MB)
    modules : 0x7f000000 - 0x80000000   (  16 MB)
      .text : 0x80008000 - 0x806aff04   (6816 kB)
      .init : 0x806b0000 - 0x806faa00   ( 299 kB)
      .data : 0x806fc000 - 0x80746ae0   ( 299 kB)
       .bss : 0x80746ae0 - 0x8079ef54   ( 354 kB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
L310 cache controller enabled
l2x0: 16 ways, CACHE_ID 0x000000c0, AUX_CTRL 0x02070000, Cache size:
1048576 B
sched_clock: 32 bits at 66MHz, resolution 15ns, wraps every 65075ms
smp_twd: clock not found -2
CPU identified as i.MX6Q, silicon rev 1.2
Console: colour dummy device 80x30
Calibrating delay loop... 1581.05 BogoMIPS (lpj=7905280)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Calibrating local timer... 396.17MHz.
Setting up static identity map for 0x8051f678 - 0x8051f6e8
CPU1: Booted secondary processor
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
CPU2: Booted secondary processor
CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
CPU3: Booted secondary processor
CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
Brought up 4 CPUs
SMP: Total of 4 processors activated (6324.22 BogoMIPS).
CPU: All CPU(s) started in SVC mode.
devtmpfs: initialized
pinctrl core: initialized pinctrl subsystem
regulator-dummy: no parameters
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
syscon 20c8000.anatop: syscon regmap start 0x20c8000 end 0x20c8fff
registered
vdd1p1: 800 <--> 1375 mV at 1100 mV
vdd3p0: 2800 <--> 3150 mV at 3000 mV
vdd2p5: 2000 <--> 2750 mV at 2400 mV
cpu: 725 <--> 1450 mV at 1100 mV
vddpu: 725 <--> 1450 mV at 1100 mV
vddsoc: 725 <--> 1450 mV at 1200 mV
syscon 20e0000.iomuxc-gpr: syscon regmap start 0x20e0000 end 0x20e0037
registered
imx6q-pinctrl 20e0000.iomuxc: initialized IMX pinctrl driver
bio: create slab <bio-0> at 0
mxs-dma 110000.dma-apbh: initialized
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti
<giometti@linux.it>
PTP clock support registered
Advanced Linux Sound Architecture Driver Initialized.
Switching to clocksource mxc_timer1
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
fuse init (API version 7.21)
msgmni has been set to 2014
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
imx-sdma 20ec000.sdma: initialized
Serial: IMX driver
2020000.serial: ttymxc0 at MMIO 0x2020000 (irq = 58) is a IMX
console [ttymxc0] enabled
[drm] Initialized drm 1.1.0 20060810
brd: module loaded
loop: module loaded
registered PHC device on eth%d
libphy: fec_enet_mii_bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-mxc: Freescale On-Chip EHCI Host driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
mousedev: PS/2 mouse device common for all mice
snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp
as rtc0
i2c /dev entries driver
imx2-wdt 20bc000.wdog: IMX2+ Watchdog Timer enabled. timeout=60s
(nowayout=0)
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pltfm: SDHCI platform and OF driver helper
mmc0: no vqmmc regulator found
mmc0: no vmmc regulator found
mmc0: SDHCI controller on 2194000.usdhc [2194000.usdhc] using ADMA
mmc1: no vqmmc regulator found
mmc1: no vmmc regulator found
mmc1: SDHCI controller on 2198000.usdhc [2198000.usdhc] using ADMA
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized imx-drm 1.0.0 20120507 on minor 0
imx-ipuv3 2400000.ipu: IPUv3H probed
imx-ipuv3 2800000.ipu: IPUv3H probed
TCP: cubic registered
NET: Registered protocol family 10
sit: IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Key type dns_resolver registered
VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
input: gpio-keys.8 as /devices/gpio-keys.8/input/input0
------------[ cut here ]------------
WARNING: at
/home/r65073/repos/next/linux-next/drivers/tty/tty_buffer.c:428
flush_to_ldisc+0x18c/0x1a0()
snvs_rtc 20cc034.snvs-rtc-lp: setting system clock to 1970-01-01
04:16:21 UTC (15381)
tty is NULL
Modules linked in:
Backtrace:
[<8001199c>] (dump_backtrace+0x0/0x10c) from [<805195c8>]
(dump_stack+0x18/0x1c)
 r6:000001ac r5:8029a8e8 r4:bfa89e98 r3:00000000
[<805195b0>] (dump_stack+0x0/0x1c) from [<80021004>]
(warn_slowpath_common+0x54/0x70)
[<80020fb0>] (warn_slowpath_common+0x0/0x70) from [<800210c4>]
(warn_slowpath_fmt+0x38/0x40)
 r8:00000000 r7:bf804000 r6:80fb1000 r5:00000000 r4:bf804000
r3:00000009
[<8002108c>] (warn_slowpath_fmt+0x0/0x40) from [<8029a8e8>]
(flush_to_ldisc+0x18c/0x1a0)
 r3:00000000 r2:80642ac0
[<8029a75c>] (flush_to_ldisc+0x0/0x1a0) from [<80038f48>]
(process_one_work+0x114/0x378)
[<80038e34>] (process_one_work+0x0/0x378) from [<80039540>]
(worker_thread+0x12c/0x3f0)
[<80039414>] (worker_thread+0x0/0x3f0) from [<8003e8f0>]
(kthread+0xac/0xb8)
[<8003e844>] (kthread+0x0/0xb8) from [<8000e618>]
(ret_from_fork+0x14/0x3c)
 r7:00000000 r6:00000000 r5:8003e844 r4:bf879e64
---[ end trace df46cda12ac3bc25 ]---
eth0: Freescale FEC PHY driver [Generic PHY]
(mii_bus:phy_addr=2188000.ethernet:01, irq=-1)
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
libphy: 2188000.ethernet:01 - Link is Up - 100/Full
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Sending DHCP requests ., OK
IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.103
IP-Config: Complete:
     device=eth0, hwaddr=00:04:9f:01:1b:63, ipaddr=192.168.1.103,
mask=255.255.255.0, gw=192.168.1.1
     host=192.168.1.103, domain=domain, nis-domain=(none)
     bootserver=0.0.0.0, rootserver=192.168.1.100, rootpath=, mtu=576
     nameserver0=61.177.7.1, nameserver1=221.228.255.1
ALSA device list:
  No soundcards found.
VFS: Mounted root (nfs filesystem) readonly on device 0:11.
devtmpfs: mounted
Freeing init memory: 296K
starting pid 52, tty '': '/etc/rc.d/rcS'
Mounting /proc and /sys
Starting the hotplug events dispatcher udevd
udevd (62): /proc/62/oom_adj is deprecated, please use
/proc/62/oom_score_adj instead.
Synthesizing initial hotplug events
imx-sdma 20ec000.sdma: firmware not found
Setting the hostname to freescale
Mounting filesystems
mount: mounting usbfs on /proc/bus/usb failed: No such file or directory
Starting the dropbear ssh server:
D-Bus per-session daemon address is:
unix:abstract=/tmp/dbus-gBTWuUASn1,guid=4a5fbed482fe86f57671852a00003c1f
gtk: creating gdk-pixbuf.loaders
pango: creating module list
starting pid 682, tty '': '/etc/rc.d/rc_gpu.S'
starting pid 688, tty '': '/etc/rc.d/rc_mxc.S'
Error opening framebuffer /dev/fb0: No such file or directory

Fatal server error:
no screens found

arm-none-linux-gnueabi-gcc (Freescale MAD -- Linaro 2011.07 -- Built at
2011/08/10 09:20) 4.6.2 20110630 (prerelease)
root filesystem built on Wed, 26 Dec 2012 15:44:10 -0600
Freescale Semiconductor, Inc.

freescale login: matchbox-panel: failed to open displaymatchbox-desktop:
unable to open display !
matchbox: can't open display! check your DISPLAY variable.
root
login[690]: root login on 'ttymxc0'


BusyBox v1.20.2 () built-in shell (ash)
Enter 'help' for a list of built-in commands.

root@freescale ~$ ./rtcwakeup.sh
rtcwakeup.out: wakeup from "mem" using rtc0 at Fri Jan  2 04:18:12 1970
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
PM: suspend of devices complete after 0.699 msecs
PM: suspend devices took 0.010 seconds
PM: late suspend of devices complete after 0.220 msecs
PM: noirq suspend of devices complete after 0.691 msecs
Disabling non-boot CPUs ...
CPU1: shutdown
CPU2: shutdown
CPU3: shutdown
Enabling non-boot CPUs ...
CPU1: Booted secondary processor
CPU1 is up
CPU2: Booted secondary processor
CPU2 is up
CPU3: Booted secondary processor
CPU3 is up
PM: noirq resume of devices complete after 0.180 msecs
PM: early resume of devices complete after 0.258 msecs
PM: resume of devices complete after 2.687 msecs
PM: resume devices took 0.010 seconds
PM: Finishing wakeup.
Restarting tasks ... done.
Pass 2 times!!!!!!!!!!
rtcwakeup.out: wakeup from "mem" using rtc0 at Fri Jan  2 04:18:16 1970
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
PM: suspend of devices complete after 0.689 msecs
PM: suspend devices took 0.010 seconds
PM: late suspend of devices complete after 0.223 msecs
PM: noirq suspend of devices complete after 0.725 msecs
Disabling non-boot CPUs ...
CPU1: shutdown
CPU2: shutdown
CPU3: shutdown
Enabling non-boot CPUs ...
CPU1: Booted secondary processor
CPU1 is up
CPU2: Booted secondary processor
CPU2 is up
CPU3: Booted secondary processor
CPU3 is up
PM: noirq resume of devices complete after 0.182 msecs
PM: early resume of devices complete after 0.273 msecs
------------[ cut here ]------------
WARNING: at
/home/r65073/repos/next/linux-next/drivers/tty/tty_buffer.c:428
flush_to_ldisc+0x18c/0x1a0()
tty is NULL
Modules linked in:
Backtrace: PM: resume of devices complete after 17.922 msecs
PM: resume devices took 0.020 seconds
PM: Finishing wakeup.
Restarting tasks ... done.


[<8001199c>] (dump_backtrace+0x0/0x10c) from [<805195c8>]
(dump_stack+0x18/0x1c)
 r6:000001ac r5:8029a8e8 r4:bfa89e98 r3:00000000
[<805195b0>] (dump_stack+0x0/0x1c) from [<80021004>]
(warn_slowpath_common+0x54/0x70)
[<80020fb0>] (warn_slowpath_common+0x0/0x70) from [<800210c4>]
(warn_slowpath_fmt+0x38/0x40)
 r8:00000000 r7:bf0d2600 r6:80fb1000 r5:00000000 r4:bf0d2600
r3:00000009
[<8002108c>] (warn_slowpath_fmt+0x0/0x40) from [<8029a8e8>]
(flush_to_ldisc+0x18c/0x1a0)
 r3:00000000 r2:80642ac0
[<8029a75c>] (flush_to_ldisc+0x0/0x1a0) from [<80038f48>]
(process_one_work+0x114/0x378)
[<80038e34>] (process_one_work+0x0/0x378) from [<80039540>]
(worker_thread+0x12c/0x3f0)
[<80039414>] (worker_thread+0x0/0x3f0) from [<8003e8f0>]
(kthread+0xac/0xb8)
[<8003e844>] (kthread+0x0/0xb8) from [<8000e618>]
(ret_from_fork+0x14/0x3c)
 r7:00000000 r6:00000000 r5:8003e844 r4:bf879e64
---[ end trace df46cda12ac3bc26 ]---
Pass 3 times!!!!!!!!!!
rtcwakeup.out: wakeup from "mem" using rtc0 at Fri Jan  2 04:18:20 1970
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
PM: suspend of devices complete after 0.687 msecs
PM: suspend devices took 0.010 seconds
PM: late suspend of devices complete after 0.210 msecs
PM: noirq suspend of devices complete after 0.721 msecs
Disabling non-boot CPUs ...
CPU1: shutdown
CPU2: shutdown
CPU3: shutdown
Enabling non-boot CPUs ...
CPU1: Booted secondary processor
CPU1 is up
CPU2: Booted secondary processor
CPU2 is up
CPU3: Booted secondary processor
CPU3 is up
PM: noirq resume of devices complete after 0.179 msecs
PM: early resume of devices complete after 0.261 msecs
------------[ cut here ]------------
WARNING: at
/home/r65073/repos/next/linux-next/drivers/tty/tty_buffer.c:428
flush_to_ldisc+0x18c/0x1a0()
tty is NULL
Modules linked in:
Backtrace: PM: resume of devices complete after 17.891 msecs
PM: resume devices took 0.010 seconds
PM: Finishing wakeup.
Restarting tasks ... done.


[<8001199c>] (dump_backtrace+0x0/0x10c) from [<805195c8>]
(dump_stack+0x18/0x1c)
 r6:000001ac r5:8029a8e8 r4:bf2bbe98 r3:00000000
[<805195b0>] (dump_stack+0x0/0x1c) from [<80021004>]
(warn_slowpath_common+0x54/0x70)
[<80020fb0>] (warn_slowpath_common+0x0/0x70) from [<800210c4>]
(warn_slowpath_fmt+0x38/0x40)
 r8:00000000 r7:bf0d2600 r6:80fb1000 r5:00000000 r4:bf0d2600
r3:00000009
[<8002108c>] (warn_slowpath_fmt+0x0/0x40) from [<8029a8e8>]
(flush_to_ldisc+0x18c/0x1a0)
 r3:00000000 r2:80642ac0
[<8029a75c>] (flush_to_ldisc+0x0/0x1a0) from [<80038f48>]
(process_one_work+0x114/0x378)
[<80038e34>] (process_one_work+0x0/0x378) from [<80039540>]
(worker_thread+0x12c/0x3f0)
[<80039414>] (worker_thread+0x0/0x3f0) from [<8003e8f0>]
(kthread+0xac/0xb8)
[<8003e844>] (kthread+0x0/0xb8) from [<8000e618>]
(ret_from_fork+0x14/0x3c)
 r7:00000000 r6:00000000 r5:8003e844 r4:bf879e64
---[ end trace df46cda12ac3bc27 ]---

root@freescale ~$

