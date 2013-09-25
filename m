Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3IYI22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:28:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41442 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3IYI20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:28:26 -0400
From: =?iso-8859-15?q?J=FCrgen_Beisert?= <jbe@pengutronix.de>
Organization: Pengutronix e.K.
To: linux-arm-kernel@lists.infradead.org
Subject: ARM/Samsung/S3C24xx: Linux-3.11 crashes when using PWM
Date: Wed, 25 Sep 2013 10:29:44 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201309251029.44265.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5e26:aff:fe2b:7cc4
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

yesterday I tried to make the buzzer on the Mini2440 platform work again. But
when I add one of the timer device descriptions to list of devices, the
Linux-3.11 kernel crashes. This does not happen to Linux-3.10.

What I have done:

$ make mini2440_defconfig

Change one single line:

diff --git a/arch/arm/mach-s3c24xx/mach-mini2440.c b/arch/arm/mach-s3c24xx/mach-mini2440.c
index a83db46..d8273da 100644
--- a/arch/arm/mach-s3c24xx/mach-mini2440.c
+++ b/arch/arm/mach-s3c24xx/mach-mini2440.c
@@ -519,6 +519,7 @@ static struct platform_device *mini2440_devices[] __initdata = {
        &s3c_device_iis,
        &uda1340_codec,
        &mini2440_audio,
+       &s3c_device_timer[0],
 };

 static void __init mini2440_map_io(void)

$ make menuconfig

+ CONFIG_DEBUG_LL
+ CONFIG_EARLY_PRINTK

(otherwise no output on the serial line)

$ make uImage

Then booting this image on my Mini2440:

[...]
booting kernel of type uimage from /dev/ram0.kernel
   Verifying Checksum ... OK
   Image Name:   Linux-3.11.0+
   Created:      2013-09-24  19:15:10 UTC
   Image Type:   <NULL> <NULL> <NULL> (<NULL>)
   Data Size:    2551080 Bytes =  2.4 MB
   Load Address: 30008000
   Entry Point:  30008000
OK
commandline: console=ttySAC0,115200 mini2440=0tbc earlyprintk ip=192.168.0.241:192.168.0.10:192.168.0.1:255.255.255.0::: root=/dev/nfs 
nfsroot=/root,v3,tcp,port=2049,mountport=2049,v3,tcp noinitrd mtdparts=nand:512k(barebox),384k(bareboxenv),2048k(kernel),-(root)
arch_number: 1999

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 3.11.0+ (jb@isonoe) (gcc version 4.6.2 (OSELAS.Toolchain-2011.11.1 linaro-4.6-2011.11) ) #1 Tue Sep 24 
21:14:53 CEST 2013
CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=c0007177
CPU: VIVT data cache, VIVT instruction cache
Machine: MINI2440
bootconsole [earlycon0] enabled
Memory policy: ECC disabled, Data cache writeback
CPU S3C2440A (id 0x32440001)
S3C24XX Clocks, Copyright 2004 Simtec Electronics
S3C244X: core 405.000 MHz, memory 101.250 MHz, peripheral 50.625 MHz
CLOCK: Slow mode (1.500 MHz), fast, MPLL on, UPLL on
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line: console=ttySAC0,115200 mini2440=0tbc earlyprintk 
ip=192.168.0.241:192.168.0.10:192.168.0.1:255.255.255.0::: root=/dev/nfs 
nfsroot=/root,v3,tcp,port=2049,mountport=2049,v3,tcp noinitrd 
mtdparts=nand:512k(barebox),384k(bareboxenv),2048k(kernel),-(root)
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 59784K/65536K available (3570K kernel code, 187K rwdata, 960K rodata, 143K init, 240K bss, 5752K reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc4800000 - 0xff000000   ( 936 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc0474a44   (4531 kB)
      .init : 0xc0475000 - 0xc0498d6c   ( 144 kB)
      .data : 0xc049a000 - 0xc04c8c80   ( 188 kB)
       .bss : 0xc04c8c80 - 0xc0505050   ( 241 kB)
SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:103
S3C2440: IRQ Support
irq: clearing pending status 00000080
irq: clearing pending status 00000002
sched_clock: 16 bits at 1012kHz, resolution 987ns, wraps every 64ms
Console: colour dummy device 80x30
Calibrating delay loop... 201.52 BogoMIPS (lpj=503808)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
Setting up static identity map for 0xc0363ac8 - 0xc0363b20
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
MINI2440: Option string mini2440=0tbc
MINI2440: 't' ignored, touchscreen not compiled in
MINI2440: LCD [0:240x320] 1:800x480 2:1024x768 3:320x240
S3C2440: Initialising architecture
S3C244X: Clock Support, DVS off
Unable to handle kernel NULL pointer dereference at virtual address 00000084
pgd = c0004000
[00000084] *pgd=00000000
Internal error: Oops: 5 [#1] ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0+ #1
task: c3830000 ti: c3832000 task.ti: c3832000
PC is at get_device_parent+0x48/0x16c
LR is at get_device_parent+0x40/0x16c
pc : [<c01db338>]    lr : [<c01db330>]    psr: 60000053
sp : c3833d88  ip : c3857354  fp : 00000000
r10: c047546c  r9 : c0498770  r8 : c3855f8c
r7 : c04a7c98  r6 : c04a7c90  r5 : c3857300  r4 : c3857300
r3 : c04b595c  r2 : 00000000  r1 : 00000000  r0 : c04b9a34
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: 30004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc38321b8)
Stack: (0xc3833d88 to 0xc3834000)
3d80:                   c385c220 c3857300 00000000 c04a7c90 00000000 c01db728
3da0: c0498770 c047546c c3833dc4 c0033be8 00000000 c3857308 c38046c0 c04b595c
3dc0: 00000000 c3857300 00000000 c3855f8c c0498770 c047546c 00000000 c01dbcf4
3de0: c3855f8c 00000000 00000024 00000000 c04b5a70 c01dbd7c 00000000 c0410594
3e00: c3833e2c c0011f0c 00000009 c01dbda4 c0410594 c3833e2c c3855f8c c3833e2c
3e20: 00000000 c01a4e84 c0410594 00000000 c3855f8c c01a4594 00000000 c04a6d08
3e40: c04a7c90 c3855f70 c04a7c90 00000000 00590004 c01a52a4 c04a7c98 00000000
3e60: 00000000 c04fd658 c04b5a70 c04a7c90 00000000 c01df17c c01df168 c01ddf54
3e80: c04a7c90 c04b5a70 c04a7cc4 00000000 c0488774 c01de168 c04b5a70 c01de0dc
3ea0: 00000000 c01dc9a4 c384628c c3855bd0 c04b5a70 c04b9b48 c3855f00 c01dd714
3ec0: c03f8884 c04c8f88 c04b5a70 00000000 c0492ce8 c04c8c80 c0488774 c01de604
3ee0: 00000000 c04fa6e4 00000000 c0492ce8 c04c8c80 c0488774 c047546c c04887cc
3f00: c3832000 c0008748 c04ae180 c0366288 c384db40 c04eef40 00000000 00000000
3f20: 00000000 c00d4da0 00000000 60000053 c04545d0 c05863f8 0000007e c002b710
3f40: c03f4e94 c0453df0 00000003 00000003 00000000 c0492d04 c0492d08 00000003
3f60: c0492ce8 c04c8c80 0000007e c047546c 00000000 c0475adc 00000003 00000003
3f80: c047546c 33cc33cc 00000000 c035deac 00000000 00000000 00000000 00000000
3fa0: 00000000 c035deb4 00000000 c0009450 00000000 00000000 00000000 00000000
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000 33cc33cc 33cc33cc
[<c01db338>] (get_device_parent+0x48/0x16c) from [<c01db728>] (device_add+0x9c/0x5bc)
[<c01db728>] (device_add+0x9c/0x5bc) from [<c01dbcf4>] (device_create_groups_vargs+0x94/0xc8)
[<c01dbcf4>] (device_create_groups_vargs+0x94/0xc8) from [<c01dbd7c>] (device_create_vargs+0x24/0x2c)
[<c01dbd7c>] (device_create_vargs+0x24/0x2c) from [<c01dbda4>] (device_create+0x20/0x28)
[<c01dbda4>] (device_create+0x20/0x28) from [<c01a4e84>] (pwmchip_sysfs_export+0x30/0x60)
[<c01a4e84>] (pwmchip_sysfs_export+0x30/0x60) from [<c01a4594>] (pwmchip_add+0x17c/0x1d0)
[<c01a4594>] (pwmchip_add+0x17c/0x1d0) from [<c01a52a4>] (s3c_pwm_probe+0xd8/0x1e8)
[<c01a52a4>] (s3c_pwm_probe+0xd8/0x1e8) from [<c01df17c>] (platform_drv_probe+0x14/0x18)
[<c01df17c>] (platform_drv_probe+0x14/0x18) from [<c01ddf54>] (driver_probe_device+0x7c/0x204)
[<c01ddf54>] (driver_probe_device+0x7c/0x204) from [<c01de168>] (__driver_attach+0x8c/0x90)
[<c01de168>] (__driver_attach+0x8c/0x90) from [<c01dc9a4>] (bus_for_each_dev+0x5c/0x8c)
[<c01dc9a4>] (bus_for_each_dev+0x5c/0x8c) from [<c01dd714>] (bus_add_driver+0xd8/0x22c)
[<c01dd714>] (bus_add_driver+0xd8/0x22c) from [<c01de604>] (driver_register+0x78/0x144)
[<c01de604>] (driver_register+0x78/0x144) from [<c04887cc>] (pwm_init+0x58/0x84)
[<c04887cc>] (pwm_init+0x58/0x84) from [<c0008748>] (do_one_initcall+0x34/0x160)
[<c0008748>] (do_one_initcall+0x34/0x160) from [<c0475adc>] (kernel_init_freeable+0xec/0x1a8)
[<c0475adc>] (kernel_init_freeable+0xec/0x1a8) from [<c035deb4>] (kernel_init+0x8/0xe4)
[<c035deb4>] (kernel_init+0x8/0xe4) from [<c0009450>] (ret_from_fork+0x14/0x24)
Code: e59f0118 eb061af6 e59530c0 e5932040 (e5b23084)
---[ end trace 2965f3757c9915e1 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Any chance to get it work again? I guess the other S3C24xx based platforms in
arch/arm/mach-s3c24xx will also crash, because they use PWM units for their
backlights.

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
