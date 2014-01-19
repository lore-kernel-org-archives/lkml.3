Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaASGxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 01:53:21 -0500
Received: from www.humilis.net ([80.100.93.5]:46085 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaASGxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 01:53:18 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jan 2014 01:53:18 EST
Date: Sun, 19 Jan 2014 07:44:01 +0100
From: Sander <sander@humilis.net>
To: linux-kernel@vger.kernel.org
Cc: Roy Franz <roy.franz@linaro.org>
Subject: EFI stub: Booting Linux using EFI stub, Kernel panic,
 unflatten_device_tree, Arndale
Message-ID: <20140119064401.GA31639@panda>
Reply-To: sander@humilis.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Uptime: 07:09:32 up 40 days, 10:23, 10 users,  load average: 1.68, 2.52,
 2.50
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I try to boot with EFI stub on an Arndale, both with a provided dtb and
with an appended dtb.

With an appended dtb, I get "EFI stub: ERROR: Device tree header not valid."

With a provided dtb, I get the below kernel panic.

The reason I try to boot with the Shell is that if I just let the board
boot (Boot Manager), I don't see any devices plugged in on usb or sata.
It does say:

[    0.000000] efi: Getting parameters from FDT:
[    0.000000] efi: Can't find System Table in device tree!

Which turns up empty in google.

Kernel is patched with the patch series
"[PATCH V6 0/8] Add ARM EFI stub" from Roy Franz.

dtb is copied from arch/arm/boot/dts/exynos5250-arndale.dtb

Do you have any tip as to what I can try to get the Arndale to boot?

	Sander


# egrep 'EFI|DTB' .config
CONFIG_EFI_PARTITION=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_ARM_APPENDED_DTB=y
CONFIG_ARM_ATAG_DTB_COMPAT=y
CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER=y
# CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is not set
# EFI (Extensible Firmware Interface) Support
CONFIG_EFI_VARS=y
CONFIG_UEFI_PARAMS_FROM_FDT=y
CONFIG_EFIVAR_FS=y


FS0:\> ver
UEFI Interactive Shell v2.0
Copyright 2009-2013 Intel(r) Corporation. All rights reserved.
UEFI v2.40 (ARM Platform EFI Jan 18 2014 21:50:23, 0x00000000)


FS0:\> zImage earlyprintk
EFI stub: Booting Linux using EFI stub.
EFI stub: ERROR: Device tree header not valid.


FS0:\> zImage dtb=board.dtb earlyprintk
EFI stub: Booting Linux using EFI stub.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.13.0-rc7-00368-g4530249-dirty (root@x301) (gcc version 4.5.2 (Sourcery G++ Lite 2011.03-41) ) #1 SMP PREEMPT Sun Jan 19 06:59:18 CET 2014
[    0.000000] CPU: ARMv7 Processor [410fc0f4] revision 4 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: Insignal Arndale evaluation board based on EXYNOS5250
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] efi: Getting parameters from FDT:
[    0.000000] UEFI v2.40 by ARM Platform EFI Jan 18 2014 21:50:23
[    0.000000] efi: 
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] CPU EXYNOS5250 (id 0x43520010)
[    0.000000] Unable to handle kernel paging request at virtual address 07ff6000
[    0.000000] pgd = c0004000
[    0.000000] [07ff6000] *pgd=00000000
[    0.000000] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-rc7-00368-g4530249-dirty #1
[    0.000000] task: c0d86d68 ti: c0d7c000 task.ti: c0d7c000
[    0.000000] PC is at __unflatten_device_tree+0x1c/0x15c
[    0.000000] LR is at unflatten_device_tree+0x28/0x34
[    0.000000] pc : [<c0365880>]    lr : [<c0597d9c>]    psr: 200001d3
[    0.000000] sp : c0d7df50  ip : 00000000  fp : 00000000
[    0.000000] r10: c1e11140  r9 : 410fc0f4  r8 : c0d87bec
[    0.000000] r7 : c057e7c8  r6 : c0d8c7b8  r5 : c0de4b74  r4 : 07ff6000
[    0.000000] r3 : 0000feed  r2 : c057e7c8  r1 : c0df6f48  r0 : 07ff6000
[    0.000000] Flags: nzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[    0.000000] Control: 10c5387d  Table: 4000406a  DAC: 00000015
[    0.000000] Process swapper (pid: 0, stack limit = 0xc0d7c240)
[    0.000000] Stack: (0xc0d7df50 to 0xc0d7e000)
[    0.000000] df40:                                     8fc00000 c0d88b00 c0df6f48 c041660c
[    0.000000] df60: c057e7c8 c0de4b74 c0d8c7b8 c0d87bec c0d87bec c0597d9c c059c9e0 c057dde8
[    0.000000] df80: 00000000 10c5387d 410fc0f4 00000000 00000000 c0411f14 c04da398 c0d7dfb4
[    0.000000] dfa0: c0d7dfc0 00000001 c0d843c0 ffffffff c0db9a80 7fffffff 00000000 c057a860
[    0.000000] dfc0: 00000000 00000000 00000000 00000000 bd94352e c05a0238 00000000 10c5387d
[    0.000000] dfe0: c0d843ec c05a0234 c0d87d04 4000406a 00000000 40008074 00000000 00000000
[    0.000000] [<c0365880>] (__unflatten_device_tree+0x1c/0x15c) from [<c0597d9c>] (unflatten_device_tree+0x28/0x34)
[    0.000000] [<c0597d9c>] (unflatten_device_tree+0x28/0x34) from [<c057dde8>] (setup_arch+0x6a0/0x890)
[    0.000000] [<c057dde8>] (setup_arch+0x6a0/0x890) from [<c057a860>] (start_kernel+0xc8/0x3fc)
[    0.000000] [<c057a860>] (start_kernel+0xc8/0x3fc) from [<40008074>] (0x40008074)
[    0.000000] Code: e1a07002 e58d1008 0a00003a e30f3eed (e5941000) 
[    0.000000] ---[ end trace 15c15b4afa9eff8e ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
