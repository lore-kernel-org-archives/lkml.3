Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3LENNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:13:01 -0500
Received: from smtp.dezem.de ([46.4.88.120]:42820 "EHLO smtp.dezem.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3LENM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:12:56 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 08:12:55 EST
Message-ID: <52A07A74.6050303@dezem.de>
Date: Thu, 05 Dec 2013 14:07:00 +0100
From: Holger Adams <holger.adams@dezem.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.12.3, panic: crashes using kexec in combination with usb on the
 ARM ST SPEAr320 platform
Content-Type: multipart/mixed;
 boundary="------------070007010004020200050903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070007010004020200050903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hey All,

I hit some interesting crash with our ARM ST SPEAr320 evaluation board 
using the latest (3.12.3) vanilla kernel.

A small initramfs containing kexec is being included and booted from RAM 
using the latest u-boot. The kernel configuration based on a standard 
spear3xx_defconfig including some stuff for kexec and mass usb storages.

1) How to reproduce

  1. Boot linux
  2. Mount USB mass storage
  3. 'kexec -l' from mounted USB partition
  4. kexec -e
  --> Crash, see file stspear_312_crash

  1. Boot linux
  2. Mount USB-Stick
  2.1 Copy kernel and all other files to /tmp
  2.2 unmount USB mass storage
  2.3. Leaving the USB plugged
  3. 'kexec -l' from /tmp
  4. 'kexec -e'
  --> Crash

  1. Boot linux
  2. Mount USB-Stick
  2.1 Copy kernel and all other files to /tmp
  2.2 Unmount USB mass storage
  2.3. Unplug the usb device
  3. 'kexec -l' from /tmp
  4. kexec -e
  --> Booting. Some mem corrupt. warnings. See file stspear_312_working

2)  cat /proc/version

Linux version 3.12.3 (openembedded@openembedded) (gcc version 4.7.2 
(GCC) ) #1 Thu Dec 5 09:52:37 CET 2013

3) cat /proc/cpuinfo

root@spear320-eval:~# cat /proc/cpuinfo
processor       : 0
model name      : ARM926EJ-S rev 5 (v5l)
Features        : swp half thumb fastmult edsp java
CPU implementer : 0x41
CPU architecture: 5TEJ
CPU variant     : 0x0
CPU part        : 0x926
CPU revision    : 5

Hardware        : ST SPEAr320 SoC with Flattened Device Tree
Revision        : 0000
Serial          : 0000000000000000


4) cat /proc/iomem

root@spear320-eval:~# cat /proc/iomem
00000000-07ffffff : System RAM
   00008000-005537b3 : Kernel code
   00ae6000-00be41af : Kernel data
a3000000-a3000fff : /ahb/apb/serial@a3000000
   a3000000-a3000fff : uart-pl011
b3000000-b3000fff : /ahb/pinmux@b3000000
d0000000-d0000fff : /ahb/apb/serial@d0000000
   d0000000-d0000fff : uart-pl011
d0100000-d0100fff : /ahb/spi@d0100000
   d0100000-d0100fff : ssp-pl022
d0180000-d0180fff : /ahb/apb/i2c@d0180000
e0800000-e0807fff : /ahb/eth@e0800000
e1800000-e1800fff : ehci_hcd
e1900000-e1900fff : ohci_hcd
e2100000-e2100fff : ohci_hcd
fc000000-fc000fff : /ahb/flash@fc000000
fc400000-fc400fff : /ahb/dma@fc400000
   fc400000-fc400fff : pl08xdmac
fc880000-fc880fff : /ahb/apb/wdt@fc880000
   fc880000-fc880fff : sp805_wdt
fc900000-fc900fff : /ahb/apb/rtc@fc900000
fc980000-fc980fff : /ahb/apb/gpio@fc980000
   fc980000-fc980fff : pl061

5) cat /proc/scsi/scsi

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: INTENSO  Model: USB              Rev: 1100
   Type:   Direct-Access                    ANSI  SCSI revision: 00


Best Regards,
Holger

-- 
Holger Adams, DeZem GmbH
phone: +49 30 3180 0730, fax: +49 30 3180 0731

--------------070007010004020200050903
Content-Type: text/plain; charset=UTF-8;
 name="stspear_312_crash"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="stspear_312_crash"

root@spear320-eval:/var/volatile/tmp/kaese# kexec -l uImage--3.12.3-r0-spear320-
eval-20131205085108.bin --dtb=spear320-evb-kernel3.12.3.dtb  --command-line="$( 
cat /proc/cmdline)" 

root@spear320-eval:/var/volatile/tmp/kaese# kexec -e

Starting new kernel
Bye!
Booting Linux on physical CPU 0x0
Linux version 3.12.3 (openembedded@openembedded) (gcc version 4.7.2 (GCC) ) #1 Thu Dec 5 09:52:37 CET 2013
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: ST SPEAr320 SoC with Flattened Device Tree, model: ST SPEAr320 Evaluation Board
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32480
Kernel command line: console=ttyAMA0,115200 mem=128M root=/dev/mtdblock5 rootfstype=jffs2
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 117576K/131072K available (4136K kernel code, 326K rwdata, 1284K rodata, 5701K init, 690K bss, 13496K reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc8800000 - 0xff000000   ( 872 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc05537b4   (5422 kB)
      .init : 0xc0554000 - 0xc0ae54f4   (5702 kB)
      .data : 0xc0ae6000 - 0xc0b378f8   ( 327 kB)
       .bss : 0xc0b378f8 - 0xc0be41b0   ( 691 kB)
SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:16 nr_irqs:16 16
VIC @c8800000: id 0x00041190, vendor 0x41
sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 4294967286ms
Console: colour dummy device 80x30
Calibrating delay loop... 165.27 BogoMIPS (lpj=826368)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
ftrace: allocating 14111 entries in 42 pages
Setting up static identity map for 0xc03bd650 - 0xc03bd6a8
devtmpfs: initialized
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
pagealloc: memory corruption
c78c1080: 4c 7a 00 00                                      Lz..
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.3 #1
[<c000ef10>] (unwind_backtrace+0x0/0x138) from [<c000c260>] (show_stack+0x20/0x24)
[<c000c260>] (show_stack+0x20/0x24) from [<c03b9854>] (dump_stack+0x20/0x28)
[<c03b9854>] (dump_stack+0x20/0x28) from [<c00bce8c>] (kernel_map_pages+0x170/0x268)
[<c00bce8c>] (kernel_map_pages+0x170/0x268) from [<c008d668>] (get_page_from_freelist+0x674/0x6d8)
[<c008d668>] (get_page_from_freelist+0x674/0x6d8) from [<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0)
[<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0) from [<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4)
[<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4) from [<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8)
[<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8) from [<c0558988>] (atomic_pool_init+0x78/0x134)
[<c0558988>] (atomic_pool_init+0x78/0x134) from [<c0008960>] (do_one_initcall+0xe4/0x1a0)
[<c0008960>] (do_one_initcall+0xe4/0x1a0) from [<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8)
[<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8) from [<c03b5d40>] (kernel_init+0x18/0xf4)
[<c03b5d40>] (kernel_init+0x18/0xf4) from [<c0009750>] (ret_from_fork+0x14/0x20)
pagealloc: memory corruption
c78c2080: df 79 00 00                                      .y..
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.3 #1
[<c000ef10>] (unwind_backtrace+0x0/0x138) from [<c000c260>] (show_stack+0x20/0x24)
[<c000c260>] (show_stack+0x20/0x24) from [<c03b9854>] (dump_stack+0x20/0x28)
[<c03b9854>] (dump_stack+0x20/0x28) from [<c00bce8c>] (kernel_map_pages+0x170/0x268)
[<c00bce8c>] (kernel_map_pages+0x170/0x268) from [<c008d668>] (get_page_from_freelist+0x674/0x6d8)
[<c008d668>] (get_page_from_freelist+0x674/0x6d8) from [<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0)
[<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0) from [<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4)
[<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4) from [<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8)
[<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8) from [<c0558988>] (atomic_pool_init+0x78/0x134)
[<c0558988>] (atomic_pool_init+0x78/0x134) from [<c0008960>] (do_one_initcall+0xe4/0x1a0)
[<c0008960>] (do_one_initcall+0xe4/0x1a0) from [<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8)
[<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8) from [<c03b5d40>] (kernel_init+0x18/0xf4)
[<c03b5d40>] (kernel_init+0x18/0xf4) from [<c0009750>] (ret_from_fork+0x14/0x20)
DMA: preallocated 256 KiB pool for atomic coherent allocations
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/irq/irqdomain.c:276 irq_domain_associate+0x58/0x1bc()
error: hwirq 0x15 is too large for (null)
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.3 #1
[<c000ef10>] (unwind_backtrace+0x0/0x138) from [<c000c260>] (show_stack+0x20/0x24)
[<c000c260>] (show_stack+0x20/0x24) from [<c03b9854>] (dump_stack+0x20/0x28)
[<c03b9854>] (dump_stack+0x20/0x28) from [<c0016b9c>] (warn_slowpath_common+0x78/0x98)
[<c0016b9c>] (warn_slowpath_common+0x78/0x98) from [<c0016c78>] (warn_slowpath_fmt+0x40/0x48)
[<c0016c78>] (warn_slowpath_fmt+0x40/0x48) from [<c004e458>] (irq_domain_associate+0x58/0x1bc)
[<c004e458>] (irq_domain_associate+0x58/0x1bc) from [<c004e708>] (irq_create_mapping+0x14c/0x1ec)
[<c004e708>] (irq_create_mapping+0x14c/0x1ec) from [<c004e870>] (irq_create_of_mapping+0xc8/0x11c)
[<c004e870>] (irq_create_of_mapping+0xc8/0x11c) from [<c030eb2c>] (irq_of_parse_and_map+0x3c/0x44)
[<c030eb2c>] (irq_of_parse_and_map+0x3c/0x44) from [<c030eb5c>] (of_irq_to_resource+0x28/0x94)
[<c030eb5c>] (of_irq_to_resource+0x28/0x94) from [<c030ec54>] (of_irq_count+0x34/0x44)
[<c030ec54>] (of_irq_count+0x34/0x44) from [<c030c254>] (of_device_alloc+0x7c/0x184)
[<c030c254>] (of_device_alloc+0x7c/0x184) from [<c030c39c>] (of_platform_device_create_pdata+0x40/0x84)
[<c030c39c>] (of_platform_device_create_pdata+0x40/0x84) from [<c030c674>] (of_platform_bus_create+0x294/0x378)
[<c030c674>] (of_platform_bus_create+0x294/0x378) from [<c030c6e0>] (of_platform_bus_create+0x300/0x378)
---[ end trace 1b75b31a2719ed1c ]---
of_amba_device_create(): amba_device_add() failed (-19) for /ahb/apb/serial@a4000000
of_amba_device_create(): amba_device_add() failed (-19) for /ahb/spi@a5000000
of_amba_device_create(): amba_device_add() failed (-19) for /ahb/spi@a6000000
No ATAGs?
spear320-pinmux b3000000.pinmux: Configured Mode: extended mode with id: 18

Serial: AMBA PL011 UART driver
d0000000.serial: ttyAMA0 at MMIO 0xd0000000 (irq = 35, base_baud = 0) is a PL011 rev2
console [ttyAMA0] enabled
a3000000.serial: ttyAMA1 at MMIO 0xa3000000 (irq = 61, base_baud = 0) is a PL011 rev2
bio: create slab <bio-0> at 0
spear-plgpio b3000000.gpio: can't request region for resource [mem 0xb3000000-0xb3000fff]
spear-plgpio: probe of b3000000.gpio failed with error -16
pl08xdmac fc400000.dma: initialized 8 virtual memcpy channels
pl08xdmac fc400000.dma: initialized 26 virtual slave channels
pl08xdmac fc400000.dma: DMA: PL080s rev1 at 0xfc400000 irq 24
SCSI subsystem initialized
ssp-pl022 d0100000.spi: ARM PL022 driver, device ID: 0x00041022
pl022: mapped registers from 0xd0100000 to fd100000
of_dma_request_slave_channel: dma-names property of node '/ahb/spi@d0100000' missing or empty
ssp-pl022 d0100000.spi: setup for DMA on RX dma1chan2, TX dma1chan3
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c_designware a7000000.i2c: no irq resource?
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
Switched to clocksource tmr1
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 2, 20480 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP: reno registered
UDP hash table entries: 256 (order: 1, 12288 bytes)
UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
NET: Registered protocol family 1
jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
msgmni has been set to 229
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
of_dma_request_slave_channel: dma-names property of node '/ahb/apb/serial@d0000000' missing or empty
uart-pl011 d0000000.serial: no DMA platform data
of_dma_request_slave_channel: dma-names property of node '/ahb/apb/serial@a3000000' missing or empty
uart-pl011 a3000000.serial: DMA channel TX dma1chan15
of_dma_request_slave_channel: dma-names property of node '/ahb/apb/serial@a3000000' missing or empty
uart-pl011 a3000000.serial: DMA channel RX dma1chan14
brd: module loaded
smi fc000000.flash: mtd .name=st m25p64 .size=800000(8M)
smi fc000000.flash: .erasesize = 0x10000(64K)
6 ofpart partitions found on MTD device st m25p64
Creating 6 MTD partitions on "st m25p64":
0x000000000000-0x000000010000 : "xloader"
0x000000010000-0x000000060000 : "u-boot"
0x000000060000-0x000000070000 : "environment"
0x000000070000-0x000000080000 : "dtb"
0x000000080000-0x000000390000 : "linux"
0x000000390000-0x000000800000 : "rootfs"
fsmc-nand 4c000000.flash: FSMC device partno 090, manufacturer 80, revision 00, config 00
No NAND device found
fsmc-nand 4c000000.flash: No NAND Device found!
stmmac - user ID: 0x4, Synopsys ID: 0x0
 Ring mode enabled
 DMA HW capability register supported
 Normal descriptors
 RX Checksum Offload Engine supported (type 2)
 TX Checksum insertion supported
libphy: stmmac: probed
eth0: PHY ID 04000400 at 0 IRQ 0 (stmmac-0:00) active
eth0: PHY ID 04000400 at 1 IRQ 0 (stmmac-0:01)
eth0: PHY ID 04000400 at 2 IRQ 0 (stmmac-0:02)
eth0: PHY ID 04000400 at 3 IRQ 0 (stmmac-0:03)
eth0: PHY ID 04000400 at 4 IRQ 0 (stmmac-0:04)
eth0: PHY ID 04000400 at 5 IRQ 0 (stmmac-0:05)
eth0: PHY ID 04000400 at 6 IRQ 0 (stmmac-0:06)
eth0: PHY ID 04000400 at 7 IRQ 0 (stmmac-0:07)
eth0: PHY ID 04000400 at 8 IRQ 0 (stmmac-0:08)
eth0: PHY ID 04000400 at 9 IRQ 0 (stmmac-0:09)
eth0: PHY ID 04000400 at 10 IRQ 0 (stmmac-0:0a)
eth0: PHY ID 04000400 at 11 IRQ 0 (stmmac-0:0b)
eth0: PHY ID 04000400 at 12 IRQ 0 (stmmac-0:0c)
eth0: PHY ID 04000400 at 13 IRQ 0 (stmmac-0:0d)
eth0: PHY ID 04000400 at 14 IRQ 0 (stmmac-0:0e)
eth0: PHY ID 04000400 at 15 IRQ 0 (stmmac-0:0f)
eth0: PHY ID 04000400 at 16 IRQ 0 (stmmac-0:10)
eth0: PHY ID 04000400 at 17 IRQ 0 (stmmac-0:11)
eth0: PHY ID 04000400 at 18 IRQ 0 (stmmac-0:12)
eth0: PHY ID 04000400 at 19 IRQ 0 (stmmac-0:13)
eth0: PHY ID 04000400 at 20 IRQ 0 (stmmac-0:14)
eth0: PHY ID 04000400 at 21 IRQ 0 (stmmac-0:15)
eth0: PHY ID 04000400 at 22 IRQ 0 (stmmac-0:16)
eth0: PHY ID 04000400 at 23 IRQ 0 (stmmac-0:17)
eth0: PHY ID 04000400 at 24 IRQ 0 (stmmac-0:18)
eth0: PHY ID 04000400 at 25 IRQ 0 (stmmac-0:19)
eth0: PHY ID 04000400 at 26 IRQ 0 (stmmac-0:1a)
eth0: PHY ID 04000400 at 27 IRQ 0 (stmmac-0:1b)
eth0: PHY ID 04000400 at 28 IRQ 0 (stmmac-0:1c)
eth0: PHY ID 04000400 at 29 IRQ 0 (stmmac-0:1d)
eth0: PHY ID 04000400 at 30 IRQ 0 (stmmac-0:1e)
eth0: PHY ID 04000400 at 31 IRQ 0 (stmmac-0:1f)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
SPEAr-ehci: EHCI SPEAr driver
spear-ehci e1800000.ehci: EHCI Host Controller
spear-ehci e1800000.ehci: new USB bus registered, assigned bus number 1
spear-ehci e1800000.ehci: irq 42, io mem 0xe1800000
spear-ehci e1800000.ehci: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.12.3 ehci_hcd
usb usb1: SerialNumber: e1800000.ehci
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
spear-ohci e1900000.ohci: SPEAr OHCI
spear-ohci e1900000.ohci: new USB bus registered, assigned bus number 2
Unable to handle kernel NULL pointer dereference at virtual address 0000000c
pgd = c0004000
[0000000c] *pgd=00000000
Internal error: Oops: 17 [#1] ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.12.3 #1
task: c786a000 ti: c786c000 task.ti: c786c000
PC is at ohci_irq+0x1c/0x220
LR is at usb_hcd_irq+0x40/0x58
pc : [<c02ba640>]    lr : [<c029aa10>]    psr: 60000093
sp : c786db70  ip : c786db98  fp : c786db94
r10: c0b30160  r9 : c7808034  r8 : 00000000
r7 : 00000000  r6 : 00000029  r5 : c6e34000  r4 : 00000000
r3 : c02ba624  r2 : c786a000  r1 : c6e34000  r0 : c6e34000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: 06e14000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc786c1c0)
Stack: (0xc786db70 to 0xc786e000)
db60:                                     c02ba624 60000093 c7808054 00000029
db80: 00000000 00000000 c786dbac c786db98 c029aa10 c02ba634 c029a9d0 c6e2e300
dba0: c786dbec c786dbb0 c0049bcc c029a9e0 00000000 00000000 00000000 c7808000
dbc0: ffffffff c7808000 c7808054 c6e2e300 c0bda604 00000000 c7808034 00000029
dbe0: c786dc0c c786dbf0 c0049e08 c0049b70 00020000 c7808000 c7808054 00000000
dc00: c786dc24 c786dc10 c004c33c c0049dcc 00000029 00000029 c786dc3c c786dc28
dc20: c00494d0 c004c26c 00000043 c0b0e268 c786dc5c c786dc40 c000a068 c00494b0
dc40: 00000020 c0bda604 c786dc88 00000000 c786dc84 c786dc60 c000874c c000a008
dc60: c03bd180 c03bd184 60000013 ffffffff c786dcbc 60000013 c786dce4 c786dc88
dc80: c000ce40 c00086f4 c7808054 60000013 c786a000 00000000 60000013 c6e2e300
dca0: c029a9d0 c7808054 60000013 c7808034 00000029 c786dce4 c786dcd0 c786dcd0
dcc0: c03bd180 c03bd184 60000013 ffffffff 00000000 c7808000 c786dd1c c786dce8
dce0: c004b030 c03bd174 c6e34000 c6e34054 c786dd0c c6e2e300 c7808000 c029a9d0
dd00: 00000000 00000029 00000000 c6e34000 c786dd4c c786dd20 c004b290 c004acec
dd20: 00000000 c6e34000 c6e34054 00000029 00000000 c0b2074c c05841e4 00000002
dd40: c786dd84 c786dd50 c029bfc8 c004b1c8 c6e34054 c6e34000 c780bd80 c6e34400
dd60: c78a9400 c78a9410 c6e34000 c780bd80 c6e34130 00000073 c786ddb4 c786dd88
dd80: c02b6da0 c029bcd4 c03ee9bc c786dd98 c0126ab8 c78a9410 c0bdc4b4 c0b32ee8
dda0: 00000000 c0b21108 c786ddc4 c786ddb8 c024acbc c02b6c10 c786ddf4 c786ddc8
ddc0: c024962c c024aca8 c786ddf4 c786ddd8 c024aea0 c78a9410 c0b21108 c78a9444
dde0: 00000000 c057bdec c786de14 c786ddf8 c02498b0 c02494e4 00000002 00000000
de00: c0b21108 c0249838 c786de3c c786de18 c02476a8 c0249848 c780386c c78aa040
de20: c03bd160 c0b21108 c6e2a3c0 c0b15770 c786de4c c786de40 c0249110 c0247658
de40: c786de7c c786de50 c0248aa4 c02490f8 c04bf254 00000000 c786de7c c0b21108
de60: c0bdcddc c786c000 00000000 c057bdec c786de94 c786de80 c024a004 c02489b0
de80: c059bffc c0bdcddc c786dea4 c786de98 c024b010 c0249f64 c786dec4 c786dea8
dea0: c057be88 c024afc8 00000040 c024afc8 c059bffc 00000006 c786df4c c786dec8
dec0: c0008960 c057bdfc c03bd180 c01fb3ec c786defc c786dee0 c0554428 c01f0324
dee0: c0554400 c0d08b14 c03dfa50 00000073 c786df4c c786df00 c003174c c055441c
df00: 00000000 00000000 00000000 00000006 00000006 c04fe9cc c04c2274 00000000
df20: c786df4c c059bffc 00000006 c0b37900 c055440c c05841f0 c05841e4 00000073
df40: c786df94 c786df50 c0554bd4 c000888c 00000006 00000006 c055440c c01fb3ec
df60: c786df94 c786df70 c003c860 00000000 c03b5d28 00000000 00000000 00000000
df80: 00000000 00000000 c786dfac c786df98 c03b5d40 c0554af4 00000000 00000000
dfa0: 00000000 c786dfb0 c0009750 c03b5d38 00000000 00000000 00000000 00000000
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 aaaaaaaa aaaaaaaa
[<c02ba640>] (ohci_irq+0x1c/0x220) from [<c029aa10>] (usb_hcd_irq+0x40/0x58)
[<c029aa10>] (usb_hcd_irq+0x40/0x58) from [<c0049bcc>] (handle_irq_event_percpu+0x6c/0x25c)
[<c0049bcc>] (handle_irq_event_percpu+0x6c/0x25c) from [<c0049e08>] (handle_irq_event+0x4c/0x6c)
[<c0049e08>] (handle_irq_event+0x4c/0x6c) from [<c004c33c>] (handle_level_irq+0xe0/0xf8)
[<c004c33c>] (handle_level_irq+0xe0/0xf8) from [<c00494d0>] (generic_handle_irq+0x30/0x40)
[<c00494d0>] (generic_handle_irq+0x30/0x40) from [<c000a068>] (handle_IRQ+0x70/0x90)
[<c000a068>] (handle_IRQ+0x70/0x90) from [<c000874c>] (vic_handle_irq+0x68/0xac)
[<c000874c>] (vic_handle_irq+0x68/0xac) from [<c000ce40>] (__irq_svc+0x40/0x4c)
Exception stack(0xc786dc88 to 0xc786dcd0)
dc80:                   c7808054 60000013 c786a000 00000000 60000013 c6e2e300
dca0: c029a9d0 c7808054 60000013 c7808034 00000029 c786dce4 c786dcd0 c786dcd0
dcc0: c03bd180 c03bd184 60000013 ffffffff
[<c000ce40>] (__irq_svc+0x40/0x4c) from [<c03bd184>] (_raw_spin_unlock_irqrestore+0x20/0x24)
[<c03bd184>] (_raw_spin_unlock_irqrestore+0x20/0x24) from [<c004b030>] (__setup_irq+0x354/0x4dc)
[<c004b030>] (__setup_irq+0x354/0x4dc) from [<c004b290>] (request_threaded_irq+0xd8/0x138)
[<c004b290>] (request_threaded_irq+0xd8/0x138) from [<c029bfc8>] (usb_add_hcd+0x304/0x760)
[<c029bfc8>] (usb_add_hcd+0x304/0x760) from [<c02b6da0>] (spear_ohci_hcd_drv_probe+0x1a0/0x214)
[<c02b6da0>] (spear_ohci_hcd_drv_probe+0x1a0/0x214) from [<c024acbc>] (platform_drv_probe+0x24/0x28)
[<c024acbc>] (platform_drv_probe+0x24/0x28) from [<c024962c>] (driver_probe_device+0x158/0x364)
[<c024962c>] (driver_probe_device+0x158/0x364) from [<c02498b0>] (__driver_attach+0x78/0x9c)
[<c02498b0>] (__driver_attach+0x78/0x9c) from [<c02476a8>] (bus_for_each_dev+0x60/0x9c)
[<c02476a8>] (bus_for_each_dev+0x60/0x9c) from [<c0249110>] (driver_attach+0x28/0x30)
[<c0249110>] (driver_attach+0x28/0x30) from [<c0248aa4>] (bus_add_driver+0x104/0x2a0)
[<c0248aa4>] (bus_add_driver+0x104/0x2a0) from [<c024a004>] (driver_register+0xb0/0xf4)
[<c024a004>] (driver_register+0xb0/0xf4) from [<c024b010>] (__platform_driver_register+0x58/0x6c)
[<c024b010>] (__platform_driver_register+0x58/0x6c) from [<c057be88>] (ohci_hcd_mod_init+0x9c/0x110)
[<c057be88>] (ohci_hcd_mod_init+0x9c/0x110) from [<c0008960>] (do_one_initcall+0xe4/0x1a0)
[<c0008960>] (do_one_initcall+0xe4/0x1a0) from [<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8)
[<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8) from [<c03b5d40>] (kernel_init+0x18/0xf4)
[<c03b5d40>] (kernel_init+0x18/0xf4) from [<c0009750>] (ret_from_fork+0x14/0x20)
Code: e52de004 e8bd4000 e1a05000 e5904140 (e594300c) 
---[ end trace 1b75b31a2719ed1d ]---
Kernel panic - not syncing: Fatal exception in interrupt


--------------070007010004020200050903
Content-Type: text/plain; charset=UTF-8;
 name="stspear_312_working"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="stspear_312_working"

root@spear320-eval:/var/volatile/tmp# kexec -e
Starting new kernel
Bye!
Booting Linux on physical CPU 0x0
Linux version 3.12.3 (openembedded@openembedded) (gcc version 4.7.2 (GCC) ) #1 Thu Dec 5 09:52:37 CET 2013
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: ST SPEAr320 SoC with Flattened Device Tree, model: ST SPEAr320 Evaluation Board
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32480
Kernel command line: console=ttyAMA0,115200 mem=128M root=/dev/mtdblock5 rootfstype=jffs2
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 117576K/131072K available (4136K kernel code, 326K rwdata, 1284K rodata, 5701K init, 690K bss, 13496K reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc8800000 - 0xff000000   ( 872 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc05537b4   (5422 kB)
      .init : 0xc0554000 - 0xc0ae54f4   (5702 kB)
      .data : 0xc0ae6000 - 0xc0b378f8   ( 327 kB)
       .bss : 0xc0b378f8 - 0xc0be41b0   ( 691 kB)
SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:16 nr_irqs:16 16
VIC @c8800000: id 0x00041190, vendor 0x41
sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 4294967286ms
Console: colour dummy device 80x30
Calibrating delay loop... 165.27 BogoMIPS (lpj=826368)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
ftrace: allocating 14111 entries in 42 pages
Setting up static identity map for 0xc03bd650 - 0xc03bd6a8
devtmpfs: initialized
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
pagealloc: memory corruption
c78c1080: 1e cc 00 00                                      ....
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.3 #1
[<c000ef10>] (unwind_backtrace+0x0/0x138) from [<c000c260>] (show_stack+0x20/0x24)
[<c000c260>] (show_stack+0x20/0x24) from [<c03b9854>] (dump_stack+0x20/0x28)
[<c03b9854>] (dump_stack+0x20/0x28) from [<c00bce8c>] (kernel_map_pages+0x170/0x268)
[<c00bce8c>] (kernel_map_pages+0x170/0x268) from [<c008d668>] (get_page_from_freelist+0x674/0x6d8)
[<c008d668>] (get_page_from_freelist+0x674/0x6d8) from [<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0)
[<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0) from [<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4)
[<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4) from [<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8)
[<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8) from [<c0558988>] (atomic_pool_init+0x78/0x134)
[<c0558988>] (atomic_pool_init+0x78/0x134) from [<c0008960>] (do_one_initcall+0xe4/0x1a0)
[<c0008960>] (do_one_initcall+0xe4/0x1a0) from [<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8)
[<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8) from [<c03b5d40>] (kernel_init+0x18/0xf4)
[<c03b5d40>] (kernel_init+0x18/0xf4) from [<c0009750>] (ret_from_fork+0x14/0x20)
pagealloc: memory corruption
c78c2080: b1 cb 00 00                                      ....
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.3 #1
[<c000ef10>] (unwind_backtrace+0x0/0x138) from [<c000c260>] (show_stack+0x20/0x24)
[<c000c260>] (show_stack+0x20/0x24) from [<c03b9854>] (dump_stack+0x20/0x28)
[<c03b9854>] (dump_stack+0x20/0x28) from [<c00bce8c>] (kernel_map_pages+0x170/0x268)
[<c00bce8c>] (kernel_map_pages+0x170/0x268) from [<c008d668>] (get_page_from_freelist+0x674/0x6d8)
[<c008d668>] (get_page_from_freelist+0x674/0x6d8) from [<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0)
[<c008e194>] (__alloc_pages_nodemask+0xf0/0x8c0) from [<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4)
[<c000fc30>] (__dma_alloc_buffer.isra.15+0x3c/0xf4) from [<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8)
[<c000fd0c>] (__alloc_remap_buffer.isra.18+0x24/0xd8) from [<c0558988>] (atomic_pool_init+0x78/0x134)
[<c0558988>] (atomic_pool_init+0x78/0x134) from [<c0008960>] (do_one_initcall+0xe4/0x1a0)
[<c0008960>] (do_one_initcall+0xe4/0x1a0) from [<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8)
[<c0554bd4>] (kernel_init_freeable+0xf0/0x1b8) from [<c03b5d40>] (kernel_init+0x18/0xf4)
[<c03b5d40>] (kernel_init+0x18/0xf4) from [<c0009750>] (ret_from_fork+0x14/0x20)
DMA: preallocated 256 KiB pool for atomic coherent allocations
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/irq/irqdomain.c:276 irq_domain_associate+0x58/0x1bc()
error: hwirq 0x15 is too large for (null)
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.3 #1
[<c000ef10>] (unwind_backtrace+0x0/0x138) from [<c000c260>] (show_stack+0x20/0x24)
[<c000c260>] (show_stack+0x20/0x24) from [<c03b9854>] (dump_stack+0x20/0x28)
[<c03b9854>] (dump_stack+0x20/0x28) from [<c0016b9c>] (warn_slowpath_common+0x78/0x98)
[<c0016b9c>] (warn_slowpath_common+0x78/0x98) from [<c0016c78>] (warn_slowpath_fmt+0x40/0x48)
[<c0016c78>] (warn_slowpath_fmt+0x40/0x48) from [<c004e458>] (irq_domain_associate+0x58/0x1bc)
[<c004e458>] (irq_domain_associate+0x58/0x1bc) from [<c004e708>] (irq_create_mapping+0x14c/0x1ec)
[<c004e708>] (irq_create_mapping+0x14c/0x1ec) from [<c004e870>] (irq_create_of_mapping+0xc8/0x11c)
[<c004e870>] (irq_create_of_mapping+0xc8/0x11c) from [<c030eb2c>] (irq_of_parse_and_map+0x3c/0x44)
[<c030eb2c>] (irq_of_parse_and_map+0x3c/0x44) from [<c030eb5c>] (of_irq_to_resource+0x28/0x94)
[<c030eb5c>] (of_irq_to_resource+0x28/0x94) from [<c030ec54>] (of_irq_count+0x34/0x44)
[<c030ec54>] (of_irq_count+0x34/0x44) from [<c030c254>] (of_device_alloc+0x7c/0x184)
[<c030c254>] (of_device_alloc+0x7c/0x184) from [<c030c39c>] (of_platform_device_create_pdata+0x40/0x84)
[<c030c39c>] (of_platform_device_create_pdata+0x40/0x84) from [<c030c674>] (of_platform_bus_create+0x294/0x378)
[<c030c674>] (of_platform_bus_create+0x294/0x378) from [<c030c6e0>] (of_platform_bus_create+0x300/0x378)
---[ end trace 1b75b31a2719ed1c ]---
of_amba_device_create(): amba_device_add() failed (-19) for /ahb/apb/serial@a4000000
of_amba_device_create(): amba_device_add() failed (-19) for /ahb/spi@a5000000
of_amba_device_create(): amba_device_add() failed (-19) for /ahb/spi@a6000000
No ATAGs?
spear320-pinmux b3000000.pinmux: Configured Mode: extended mode with id: 18

Serial: AMBA PL011 UART driver
d0000000.serial: ttyAMA0 at MMIO 0xd0000000 (irq = 35, base_baud = 0) is a PL011 rev2
console [ttyAMA0] enabled
a3000000.serial: ttyAMA1 at MMIO 0xa3000000 (irq = 61, base_baud = 0) is a PL011 rev2
bio: create slab <bio-0> at 0
spear-plgpio b3000000.gpio: can't request region for resource [mem 0xb3000000-0xb3000fff]
spear-plgpio: probe of b3000000.gpio failed with error -16
pl08xdmac fc400000.dma: initialized 8 virtual memcpy channels
pl08xdmac fc400000.dma: initialized 26 virtual slave channels
pl08xdmac fc400000.dma: DMA: PL080s rev1 at 0xfc400000 irq 24
SCSI subsystem initialized
ssp-pl022 d0100000.spi: ARM PL022 driver, device ID: 0x00041022
pl022: mapped registers from 0xd0100000 to fd100000
of_dma_request_slave_channel: dma-names property of node '/ahb/spi@d0100000' missing or empty
ssp-pl022 d0100000.spi: setup for DMA on RX dma1chan2, TX dma1chan3
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c_designware a7000000.i2c: no irq resource?
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
Switched to clocksource tmr1
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 2, 20480 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP: reno registered
UDP hash table entries: 256 (order: 1, 12288 bytes)
UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
NET: Registered protocol family 1
jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
msgmni has been set to 229
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
of_dma_request_slave_channel: dma-names property of node '/ahb/apb/serial@d0000000' missing or empty
uart-pl011 d0000000.serial: no DMA platform data
of_dma_request_slave_channel: dma-names property of node '/ahb/apb/serial@a3000000' missing or empty
uart-pl011 a3000000.serial: DMA channel TX dma1chan15
of_dma_request_slave_channel: dma-names property of node '/ahb/apb/serial@a3000000' missing or empty
uart-pl011 a3000000.serial: DMA channel RX dma1chan14
brd: module loaded
smi fc000000.flash: mtd .name=st m25p64 .size=800000(8M)
smi fc000000.flash: .erasesize = 0x10000(64K)
6 ofpart partitions found on MTD device st m25p64
Creating 6 MTD partitions on "st m25p64":
0x000000000000-0x000000010000 : "xloader"
0x000000010000-0x000000060000 : "u-boot"
0x000000060000-0x000000070000 : "environment"
0x000000070000-0x000000080000 : "dtb"
0x000000080000-0x000000390000 : "linux"
0x000000390000-0x000000800000 : "rootfs"
fsmc-nand 4c000000.flash: FSMC device partno 090, manufacturer 80, revision 00, config 00
No NAND device found
fsmc-nand 4c000000.flash: No NAND Device found!
stmmac - user ID: 0x4, Synopsys ID: 0x0
 Ring mode enabled
 DMA HW capability register supported
 Normal descriptors
 RX Checksum Offload Engine supported (type 2)
 TX Checksum insertion supported
libphy: stmmac: probed
eth0: PHY ID 04000400 at 0 IRQ 0 (stmmac-0:00) active
eth0: PHY ID 04000400 at 1 IRQ 0 (stmmac-0:01)
eth0: PHY ID 04000400 at 2 IRQ 0 (stmmac-0:02)
eth0: PHY ID 04000400 at 3 IRQ 0 (stmmac-0:03)
eth0: PHY ID 04000400 at 4 IRQ 0 (stmmac-0:04)
eth0: PHY ID 04000400 at 5 IRQ 0 (stmmac-0:05)
eth0: PHY ID 04000400 at 6 IRQ 0 (stmmac-0:06)
eth0: PHY ID 04000400 at 7 IRQ 0 (stmmac-0:07)
eth0: PHY ID 04000400 at 8 IRQ 0 (stmmac-0:08)
eth0: PHY ID 04000400 at 9 IRQ 0 (stmmac-0:09)
eth0: PHY ID 04000400 at 10 IRQ 0 (stmmac-0:0a)
eth0: PHY ID 04000400 at 11 IRQ 0 (stmmac-0:0b)
eth0: PHY ID 04000400 at 12 IRQ 0 (stmmac-0:0c)
eth0: PHY ID 04000400 at 13 IRQ 0 (stmmac-0:0d)
eth0: PHY ID 04000400 at 14 IRQ 0 (stmmac-0:0e)
eth0: PHY ID 04000400 at 15 IRQ 0 (stmmac-0:0f)
eth0: PHY ID 04000400 at 16 IRQ 0 (stmmac-0:10)
eth0: PHY ID 04000400 at 17 IRQ 0 (stmmac-0:11)
eth0: PHY ID 04000400 at 18 IRQ 0 (stmmac-0:12)
eth0: PHY ID 04000400 at 19 IRQ 0 (stmmac-0:13)
eth0: PHY ID 04000400 at 20 IRQ 0 (stmmac-0:14)
eth0: PHY ID 04000400 at 21 IRQ 0 (stmmac-0:15)
eth0: PHY ID 04000400 at 22 IRQ 0 (stmmac-0:16)
eth0: PHY ID 04000400 at 23 IRQ 0 (stmmac-0:17)
eth0: PHY ID 04000400 at 24 IRQ 0 (stmmac-0:18)
eth0: PHY ID 04000400 at 25 IRQ 0 (stmmac-0:19)
eth0: PHY ID 04000400 at 26 IRQ 0 (stmmac-0:1a)
eth0: PHY ID 04000400 at 27 IRQ 0 (stmmac-0:1b)
eth0: PHY ID 04000400 at 28 IRQ 0 (stmmac-0:1c)
eth0: PHY ID 04000400 at 29 IRQ 0 (stmmac-0:1d)
eth0: PHY ID 04000400 at 30 IRQ 0 (stmmac-0:1e)
eth0: PHY ID 04000400 at 31 IRQ 0 (stmmac-0:1f)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
SPEAr-ehci: EHCI SPEAr driver
spear-ehci e1800000.ehci: EHCI Host Controller
spear-ehci e1800000.ehci: new USB bus registered, assigned bus number 1
spear-ehci e1800000.ehci: irq 42, io mem 0xe1800000
spear-ehci e1800000.ehci: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.12.3 ehci_hcd
usb usb1: SerialNumber: e1800000.ehci
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
spear-ohci e1900000.ohci: SPEAr OHCI
spear-ohci e1900000.ohci: new USB bus registered, assigned bus number 2
spear-ohci e1900000.ohci: irq 41, io mem 0xe1900000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: SPEAr OHCI
usb usb2: Manufacturer: Linux 3.12.3 ohci_hcd
usb usb2: SerialNumber: e1900000.ohci
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 1 port detected
spear-ohci e2100000.ohci: SPEAr OHCI
spear-ohci e2100000.ohci: new USB bus registered, assigned bus number 3
spear-ohci e2100000.ohci: irq 43, io mem 0xe2100000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: SPEAr OHCI
usb usb3: Manufacturer: Linux 3.12.3 ohci_hcd
usb usb3: SerialNumber: e2100000.ohci
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 1 port detected
usbcore: registered new interface driver usb-storage
mousedev: PS/2 mouse device common for all mice
rtc-spear fc900000.rtc: rtc core: registered fc900000.rtc as rtc0
sp805-wdt fc880000.wdt: registration successful
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pltfm: SDHCI platform and OF driver helper
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP: cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
rtc-spear fc900000.rtc: hctosys: invalid date/time
Freeing unused kernel memory: 5700K (c0554000 - c0ae5000)
Failed to execute /init
INIT: version 2.88 booting

--------------070007010004020200050903
Content-Type: text/plain; charset=UTF-8;
 name="defconfig"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="defconfig"

#
# Automatically generated file; DO NOT EDIT.
# Linux/arm 3.12.1 Kernel Configuration
#
CONFIG_ARM=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_HAVE_PROC_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_VECTORS_BASE=0xffff0000
CONFIG_ARM_PATCH_PHYS_VIRT=y
CONFIG_GENERIC_BUG=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_GENERIC_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="/home/openembedded/openembedded-core/tmp/build/deploy/images/spear320-eval/core-image-minimal-spear320-eval.cpio"
CONFIG_INITRAMFS_ROOT_UID=0
CONFIG_INITRAMFS_ROOT_GID=0
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_INITRAMFS_COMPRESSION_NONE=y
# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
# CONFIG_INITRAMFS_COMPRESSION_XZ is not set
# CONFIG_INITRAMFS_COMPRESSION_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_GENERIC_IDLE_POLL_SETUP=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# System Type
#
CONFIG_MMU=y
CONFIG_ARCH_MULTIPLATFORM=y
# CONFIG_ARCH_INTEGRATOR is not set
# CONFIG_ARCH_REALVIEW is not set
# CONFIG_ARCH_VERSATILE is not set
# CONFIG_ARCH_AT91 is not set
# CONFIG_ARCH_CLPS711X is not set
# CONFIG_ARCH_GEMINI is not set
# CONFIG_ARCH_EBSA110 is not set
# CONFIG_ARCH_EP93XX is not set
# CONFIG_ARCH_FOOTBRIDGE is not set
# CONFIG_ARCH_NETX is not set
# CONFIG_ARCH_IOP13XX is not set
# CONFIG_ARCH_IOP32X is not set
# CONFIG_ARCH_IOP33X is not set
# CONFIG_ARCH_IXP4XX is not set
# CONFIG_ARCH_DOVE is not set
# CONFIG_ARCH_KIRKWOOD is not set
# CONFIG_ARCH_MV78XX0 is not set
# CONFIG_ARCH_ORION5X is not set
# CONFIG_ARCH_MMP is not set
# CONFIG_ARCH_KS8695 is not set
# CONFIG_ARCH_W90X900 is not set
# CONFIG_ARCH_LPC32XX is not set
# CONFIG_ARCH_PXA is not set
# CONFIG_ARCH_MSM is not set
# CONFIG_ARCH_SHMOBILE is not set
# CONFIG_ARCH_RPC is not set
# CONFIG_ARCH_SA1100 is not set
# CONFIG_ARCH_S3C24XX is not set
# CONFIG_ARCH_S3C64XX is not set
# CONFIG_ARCH_S5P64X0 is not set
# CONFIG_ARCH_S5PC100 is not set
# CONFIG_ARCH_S5PV210 is not set
# CONFIG_ARCH_EXYNOS is not set
# CONFIG_ARCH_SHARK is not set
# CONFIG_ARCH_DAVINCI is not set
# CONFIG_ARCH_OMAP1 is not set

#
# Multiple platform selection
#

#
# CPU Core family selection
#
# CONFIG_ARCH_MULTI_V4T is not set
CONFIG_ARCH_MULTI_V5=y
CONFIG_ARCH_MULTI_V4_V5=y
# CONFIG_ARCH_MULTI_V6 is not set
# CONFIG_ARCH_MULTI_V7 is not set
CONFIG_ARCH_MULTI_CPU_AUTO=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_ARCH_MXC is not set
# CONFIG_ARCH_MXS is not set
# CONFIG_ARCH_NOMADIK is not set
# CONFIG_ARCH_NSPIRE is not set
CONFIG_PLAT_SPEAR=y
CONFIG_ARCH_SPEAR3XX=y
CONFIG_MACH_SPEAR300=y
CONFIG_MACH_SPEAR310=y
CONFIG_MACH_SPEAR320=y
# CONFIG_ARCH_SPEAR6XX is not set
# CONFIG_ARCH_SPEAR_AUTO is not set
# CONFIG_ARCH_U300 is not set
# CONFIG_ARCH_WM8505 is not set

#
# Processor Type
#
CONFIG_CPU_ARM926T=y
CONFIG_CPU_32v5=y
CONFIG_CPU_ABRT_EV5TJ=y
CONFIG_CPU_PABRT_LEGACY=y
CONFIG_CPU_CACHE_VIVT=y
CONFIG_CPU_COPY_V4WB=y
CONFIG_CPU_TLB_V4WBI=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y
CONFIG_CPU_USE_DOMAINS=y

#
# Processor Features
#
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARM_THUMB=y
# CONFIG_CPU_ICACHE_DISABLE is not set
# CONFIG_CPU_DCACHE_DISABLE is not set
# CONFIG_CPU_DCACHE_WRITETHROUGH is not set
# CONFIG_CPU_CACHE_ROUND_ROBIN is not set
CONFIG_NEED_KUSER_HELPERS=y
CONFIG_KUSER_HELPERS=y
# CONFIG_CACHE_L2X0 is not set
CONFIG_ARM_L1_CACHE_SHIFT=5
CONFIG_ARM_NR_BANKS=8
CONFIG_MULTI_IRQ_HANDLER=y

#
# Bus support
#
CONFIG_ARM_AMBA=y
# CONFIG_PCI_SYSCALL is not set
# CONFIG_PCCARD is not set

#
# Kernel Features
#
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_ARCH_NR_GPIO=0
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_HZ_FIXED=0
CONFIG_HZ_100=y
# CONFIG_HZ_200 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_500 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_AEABI=y
# CONFIG_OABI_COMPAT is not set
# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
CONFIG_HAVE_ARCH_PFN_VALID=y
# CONFIG_HIGHMEM is not set
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_FORCE_MAX_ZONEORDER=11
CONFIG_ALIGNMENT_TRAP=y
# CONFIG_UACCESS_WITH_MEMCPY is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set

#
# Boot options
#
CONFIG_USE_OF=y
CONFIG_ATAGS=y
# CONFIG_DEPRECATED_PARAM_STRUCT is not set
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
# CONFIG_ARM_APPENDED_DTB is not set
CONFIG_CMDLINE=" debug"
CONFIG_CMDLINE_FROM_BOOTLOADER=y
# CONFIG_CMDLINE_EXTEND is not set
# CONFIG_CMDLINE_FORCE is not set
CONFIG_KEXEC=y
CONFIG_ATAGS_PROC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_AUTO_ZRELADDR=y

#
# CPU Power Management
#

#
# CPU Idle
#
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Floating point emulation
#

#
# At least one emulation must be selected
#
# CONFIG_VFP is not set

#
# Userspace binary formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y

#
# Power management options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_APM_EMULATION is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_CPU_PM=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARM_CPU_SUSPEND=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_NET_IP_TUNNEL is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_ARM_CCI is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AFS_PARTS is not set
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SPEAR_SMI=y
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_NAND_FSMC=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_MTD=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MG_DISK is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_ATMEL_PWM is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_SPI is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NLMON is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_DM9000 is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_FARADAY is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_ETHOC is not set
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
# CONFIG_STMMAC_DEBUG_FS is not set
# CONFIG_STMMAC_DA is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_ATKBD is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SPEAR=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_AMBAKMI is not set
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_SERIO_APBPS2 is not set
# CONFIG_SERIO_OLPC_APSP is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_AMBA_PL010 is not set
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
# CONFIG_SERIAL_KGDB_NMI is not set
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_HVC_DCC is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_R3964 is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
# CONFIG_TCG_TPM is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_NOMADIK is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_FSL_SPI is not set
# CONFIG_SPI_FSL_DSPI is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PL022=y
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
# CONFIG_PINCONF is not set
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_SINGLE is not set
CONFIG_PINCTRL_SPEAR=y
CONFIG_PINCTRL_SPEAR3XX=y
CONFIG_PINCTRL_SPEAR300=y
CONFIG_PINCTRL_SPEAR310=y
CONFIG_PINCTRL_SPEAR320=y
CONFIG_PINCTRL_SPEAR_PLGPIO=y
CONFIG_ARCH_HAVE_CUSTOM_GPIO_H=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_EM is not set
CONFIG_GPIO_PL061=y
# CONFIG_GPIO_RCAR is not set
# CONFIG_GPIO_SPEAR_SPICS is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_GRGPIO is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ARM_SP805_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_ASIC3 is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_EGPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_T7L66XB is not set
# CONFIG_MFD_TC6387XB is not set
# CONFIG_MFD_TC6393XB is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_VEXPRESS_CONFIG is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_DRM is not set
# CONFIG_TEGRA_HOST1X is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
CONFIG_FB_ARMCLCD=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_HCD_SPEAR=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_ULPI is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_U_RNDIS=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_SUBSET=y
CONFIG_USB_F_RNDIS=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_ARMMMCI is not set
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_PXAV3 is not set
# CONFIG_MMC_SDHCI_PXAV2 is not set
CONFIG_MMC_SDHCI_SPEAR=y
CONFIG_MMC_SPI=y
# CONFIG_MMC_DW is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_SPEAR=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PL030 is not set
# CONFIG_RTC_DRV_PL031 is not set
# CONFIG_RTC_DRV_SNVS is not set
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_AMBA_PL08X=y
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PL330_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_DEBUG is not set
# CONFIG_COMMON_CLK_SI5351 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_MMIO=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_ARM_VIC=y
CONFIG_ARM_VIC_NR=2
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#

#
# printk and dmesg options
#
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_POISONING=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
# CONFIG_KGDB_KDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_ARM_UNWIND=y
CONFIG_OLD_MCOUNT=y
# CONFIG_DEBUG_USER is not set
# CONFIG_DEBUG_LL is not set
CONFIG_DEBUG_LL_INCLUDE="debug/pl01x.S"
CONFIG_DEBUG_UART_PL01X=y
# CONFIG_DEBUG_UART_8250 is not set
CONFIG_DEBUG_UART_PHYS=0xd0000000
CONFIG_DEBUG_UART_VIRT=0xfd000000
CONFIG_UNCOMPRESS_INCLUDE="debug/uncompress.h"
# CONFIG_OC_ETM is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRCT10DIF is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_ARM is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_ARM is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_GENERIC_ATOMIC64=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
# CONFIG_VIRTUALIZATION is not set

--------------070007010004020200050903--
