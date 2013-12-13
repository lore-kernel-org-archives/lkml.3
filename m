Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3LMNlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:41:12 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58583 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3LMNlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:41:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131213113903.GE4360@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
	<20131213095655.GB4360@n2100.arm.linux.org.uk>
	<CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com>
	<20131213113903.GE4360@n2100.arm.linux.org.uk>
Date: Fri, 13 Dec 2013 14:33:15 +0100
Message-ID: <CACmBeS3WLGsNKj4+2MHKCQqKMX1YzHzEQ4Bi6hyR7-2PK0BMCQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boots without panic when bx is removed.

Diff and boot log:

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index b3fb8c9..ad736b3 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -737,8 +737,8 @@ ENDPROC(__switch_to)

        .macro  usr_ret, reg
 #ifdef CONFIG_ARM_THUMB
-       bx      \reg
-#else
+#      bx      \reg
+##else
        mov     pc, \reg
 #endif
        .endm


Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.13.0-rc3-next-20131213+ (i@Ildjarn)
(gcc version 4.6.3 (crosstool-NG 1.16.0) ) #1346 PREEMPT Fri Dec 13
13:16:00 CET 2013
[    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine model: MOXA UC-7112-LX
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: Data cache writeback
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 8120
[    0.000000] Kernel command line: console=ttyS0,115200n8 earlyprintk
root=/dev/mmcblk0p1 rw rootwait
[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Memory: 23116K/32768K available (2521K kernel code,
108K rwdata, 572K rodata, 150K init, 5884K bss, 9652K reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
[    0.000000]       .text : 0xc0008000 - 0xc030d914   (3095 kB)
[    0.000000]       .init : 0xc030e000 - 0xc0333b30   ( 151 kB)
[    0.000000]       .data : 0xc0334000 - 0xc034f160   ( 109 kB)
[    0.000000]        .bss : 0xc034f16c - 0xc090e378   (5885 kB)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
wraps every 21474836480000000ns
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] kmemleak: Early log buffer exceeded (673), please
increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.120000] Calibrating delay loop... 144.79 BogoMIPS (lpj=723968)
[    0.200000] pid_max: default: 4096 minimum: 301
[    0.210000] Mount-cache hash table entries: 512
[    0.290000] CPU: Testing write buffer coherency: ok
[    0.310000] Setting up static identity map for 0x266a60 - 0x266ae8
[    0.370000] devtmpfs: initialized
[    0.420000] kworker/u2:0 (13) used greatest stack depth: 6296 bytes left
[    0.430000] NET: Registered protocol family 16
[    0.460000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    1.050000] bio: create slab <bio-0> at 0
[    1.390000] DMA-API: preallocated 4096 debug entries
[    1.390000] DMA-API: debugging enabled by kernel config
[    1.400000] Switched to clocksource moxart_timer
[    1.510000] NET: Registered protocol family 2
[    1.530000] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    1.550000] TCP bind hash table entries: 1024 (order: 3, 36864 bytes)
[    1.560000] TCP: Hash tables configured (established 1024 bind 1024)
[    1.570000] TCP: reno registered
[    1.570000] UDP hash table entries: 128 (order: 1, 10240 bytes)
[    1.580000] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[    1.600000] NET: Registered protocol family 1
[    1.720000] kworker/u2:0 (136) used greatest stack depth: 6196 bytes left
[    2.330000] jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    2.370000] msgmni has been set to 45
[    2.380000] io scheduler noop registered
[    2.380000] io scheduler cfq registered (default)
[    2.430000] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
[    2.520000] 98200000.uart: ttyS0 at MMIO 0x98200000 (irq = 21,
base_baud = 921600) is a 16550A
[    2.530000] console [ttyS0] enabled
[    2.530000] console [ttyS0] enabled
[    2.540000] bootconsole [earlycon0] disabled
[    2.540000] bootconsole [earlycon0] disabled
[    2.650000] 80000000.flash: Found 1 x16 devices at 0x0 in 16-bit
bank. Manufacturer ID 0x000089 Chip ID 0x000018
[    2.660000] Intel/Sharp Extended Query Table at 0x0031
[    2.660000] Intel/Sharp Extended Query Table at 0x0031
[    2.670000] Using buffer write method
[    2.670000] cfi_cmdset_0001: Erase suspend on write enabled
[    2.680000] 4 ofpart partitions found on MTD device 80000000.flash
[    2.690000] Creating 4 MTD partitions on "80000000.flash":
[    2.690000] 0x000000000000-0x000000040000 : "bootloader"
[    2.780000] 0x000000040000-0x000000200000 : "linux kernel"
[    2.840000] 0x000000200000-0x000000a00000 : "root filesystem"
[    2.910000] 0x000000a00000-0x000001000000 : "user filesystem"
[    3.650000] libphy: MOXA ART Ethernet MII: probed
[    4.340000] libphy: MOXA ART Ethernet MII: probed
[    4.420000] moxart-ethernet 90900000.mac eth0: generated random MAC
address ee:8e:8b:cb:a1:e2
[    4.460000] moxart-ethernet 92000000.mac eth1: generated random MAC
address 1a:78:21:30:99:8c
[    4.490000] input: gpio_keys_polled.2 as
/devices/gpio_keys_polled.2/input/input0
[    4.550000] moxart-rtc rtc.0: rtc core: registered rtc.0 as rtc0
[    4.740000] TCP: cubic registered
[    4.780000] mmc0: new SD card at address 636c
[    4.830000] console [netcon0] enabled
[    4.850000] netconsole: network logging started
[    4.850000] moxart-rtc rtc.0: setting system clock to 2010-02-08
03:35:33 UTC (1265600133)
[    4.860000] mmcblk0: mmc0:636c SD02G 1.83 GiB
[    4.920000]  mmcblk0: p1
[    5.400000] EXT3-fs (mmcblk0p1): warning: ext3_clear_journal_err:
Filesystem error recorded from previous mount: IO failure
[    5.410000] kjournald starting.  Commit interval 5 seconds
[    5.420000] EXT3-fs (mmcblk0p1): warning: ext3_clear_journal_err:
Marking fs in need of filesystem check.
[    5.450000] EXT3-fs (mmcblk0p1): warning: mounting fs with errors,
running e2fsck is recommended
[    5.480000] EXT3-fs (mmcblk0p1): using internal journal
[    5.730000] EXT3-fs (mmcblk0p1): recovery complete
[    5.730000] EXT3-fs (mmcblk0p1): mounted filesystem with ordered data mode
[    5.740000] VFS: Mounted root (ext3 filesystem) on device 179:1.
[    5.770000] devtmpfs: mounted
[    5.780000] Freeing unused kernel memory: 148K (c030e000 - c0333000)
init started: BusyBox v1.22.0.git (2013-12-13 13:22:47 CET)
starting pid 264, tty '': '/etc/init.d/start'
[    7.220000] mount (265) used greatest stack depth: 5924 bytes left
[    7.700000] route (272) used greatest stack depth: 5872 bytes left
PING 10.0.1.200 (10.0.1.200): 56 data bytes
64 bytes from 10.0.1.200: seq=0 ttl=64 time=20.008 ms
[    9.450000] libphy: 90900090.mdio--1:01 - Link is Up - 100/Full
[    9.500000] libphy: 92000090.mdio--1:01 - Link is Up - 100/Full
64 bytes from 10.0.1.200: seq=1 ttl=64 time=3.308 ms
[   10.180000] SysRq : Terminate All Tasks
starting pid 275, tty '': '/bin/cttyhack /bin/sh'
[   10.210000] ping (274) used greatest stack depth: 5628 bytes left
# zcat /proc/config.gz | grep THUMB
CONFIG_ARM_THUMB=y
