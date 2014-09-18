Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaIRQBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:01:33 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50487 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbaIRQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:01:32 -0400
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 18 Sep 2014 12:01:00 -0400
Message-ID: <CAJhHMCBhN7iVOBVJmoFBiLVurs2uncnJ57p5RBeC5z=_kSgUfg@mail.gmail.com>
Subject: BUG in ext4_setattr
To: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following splat occurs in the latest rc5+ kernel. I am not sure
this is enough information. Please let me know what options to enable
to get more meaningful info.

Thanks!

[ 6382.247836] ------------[ cut here ]------------
[ 6382.248011] Kernel BUG at c00b1a70 [verbose debug info unavailable]
[ 6382.248209] Oops: Exception in kernel mode, sig: 5 [#1]
[ 6382.248370] PowerMac
[ 6382.248442] Modules linked in: uinput joydev hid_generic usbhid
radeon hid drm_kms_helper evdev ttm drm snd_powermac snd_pcm snd_timer
snd soundcore loop fuse autofs4 ext4 crc16 mbcache jbd2 ohci_pci
ehci_pci ohci_hcd ehci_hcd sg firewire_ohci sungem sungem_phy
firewire_core crc_itu_t sd_mod sr_mod crc_t10dif cdrom
crct10dif_generic crct10dif_common usbcore usb_common
[ 6382.249822] CPU: 0 PID: 1239 Comm: dpkg Not tainted 3.17.0-rc5+ #14
[ 6382.250013] task: ec78c000 ti: ec610000 task.ti: ec610000
[ 6382.250179] NIP: c00b1a70 LR: c00b1a60 CTR: c00b1a48
[ 6382.250331] REGS: ec611d70 TRAP: 0700   Not tainted  (3.17.0-rc5+)
[ 6382.250518] MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 40022488  XER: 20000000
[ 6382.250799]
[ 6382.250799] GPR00: f307d88c ec611e20 ec78c000 c05966e0 ec611ea8
00000000 00000000 00000000
[ 6382.250799] GPR08: 00010000 00000001 00000000 ec611e60 c00b1a48
1005831c 00000000 10040000
[ 6382.250799] GPR16: 1002f3d0 100d0000 100309e0 10030a68 00000000
1026ad50 102698f0 1003094c
[ 6382.250799] GPR24: 10d8b1c0 ec611ee0 00001846 ef0edb88 ef11e088
00000000 c05966e0 ef11e088
[ 6382.252001] NIP [c00b1a70] clear_page_dirty_for_io+0x28/0x11c
[ 6382.252178] LR [c00b1a60] clear_page_dirty_for_io+0x18/0x11c
[ 6382.252349] Call Trace:
[ 6382.252436] [ec611e20] [ec611ee0] 0xec611ee0 (unreliable)
[ 6382.252667] [ec611e30] [f307d88c] ext4_setattr+0x2c/0x66c [ext4]
[ 6382.252863] [ec611e70] [c0100f14] notify_change+0x1b0/0x300
[ 6382.253046] [ec611ea0] [c00e7c60] chown_common.isra.10+0xe4/0x13c
[ 6382.253240] [ec611f10] [c00e8be0] SyS_fchownat+0x84/0xbc
[ 6382.253411] [ec611f40] [c0011fb8] ret_from_syscall+0x0/0x40
[ 6382.253591] --- interrupt: c01 at 0xff0006c
[ 6382.253591]     LR = 0x10003f3c
[ 6382.253810] Instruction dump:
[ 6382.253910] 7fc3f378 4bf66f84 9421fff0 7c0802a6 bfc10008 7c7f1b78
90010014 4800d32d
[ 6382.254215] 813f0000 7c7e1b78 552907fe 69290001 <0f090000> 2f830000
419e00cc 81230040
[ 6382.294471] ---[ end trace 5bfcfc2ec91b3062 ]---
[ 6382.294619]
[ 6549.036833] Unable to handle kernel paging request for data at
address 0x00000428
[ 6549.037094] Faulting instruction address: 0xc00b1a7c
[ 6549.037258] Oops: Kernel access of bad area, sig: 11 [#2]
[ 6549.037431] PowerMac
[ 6549.037510] Modules linked in: uinput joydev hid_generic usbhid
radeon hid drm_kms_helper evdev ttm drm snd_powermac snd_pcm snd_timer
snd soundcore loop fuse autofs4 ext4 crc16 mbcache jbd2 ohci_pci
ehci_pci ohci_hcd ehci_hcd sg firewire_ohci sungem sungem_phy
firewire_core crc_itu_t sd_mod sr_mod crc_t10dif cdrom
crct10dif_generic crct10dif_common usbcore usb_common
[ 6549.039149] CPU: 0 PID: 1261 Comm: vim Tainted: G      D
3.17.0-rc5+ #14
[ 6549.039377] task: ec762770 ti: ec77a000 task.ti: ec77a000
[ 6549.039548] NIP: c00b1a7c LR: c00b1a60 CTR: c00b1a48
[ 6549.039707] REGS: ec77bd70 TRAP: 0300   Tainted: G      D
(3.17.0-rc5+)
[ 6549.039933] MSR: 00009032 <EE,ME,IR,DR,RI>  CR: 28000824  XER: 00000000
[ 6549.040272] DAR: 00000428 DSISR: 40000000
[ 6549.040272] GPR00: f307d88c ec77be20 ec762770 000003e8 ec77bea8
00000001 35523e00 00000000
[ 6549.040272] GPR08: 00000000 00000000 000003e8 35523ec9 c00b1a48
1028b4a8 00000002 10280000
[ 6549.040272] GPR16: 102adba0 00000000 000001a4 00000000 10280000
10280000 10280000 10280000
[ 6549.040272] GPR24: 102af1e8 ec77bee0 00000041 ec5df6c0 ef15a2c8
000001a4 000003e8 ef15a2c8
[ 6549.041799] NIP [c00b1a7c] clear_page_dirty_for_io+0x34/0x11c
[ 6549.041982] LR [c00b1a60] clear_page_dirty_for_io+0x18/0x11c
[ 6549.042160] Call Trace:
[ 6549.042253] [ec77be20] [c00f4394] path_lookupat+0x60/0x6d8 (unreliable)
[ 6549.042540] [ec77be30] [f307d88c] ext4_setattr+0x2c/0x66c [ext4]
[ 6549.042748] [ec77be70] [c0100f14] notify_change+0x1b0/0x300
[ 6549.042943] [ec77bea0] [c00e78c4] chmod_common+0x74/0xd4
[ 6549.043126] [ec77bf10] [c00e8b18] SyS_fchmodat+0x48/0x78
[ 6549.043309] [ec77bf40] [c0011fb8] ret_from_syscall+0x0/0x40
[ 6549.043504] --- interrupt: c01 at 0xe847584
[ 6549.043504]     LR = 0x10149ea0
[ 6549.043730] Instruction dump:
[ 6549.043842] 7c0802a6 bfc10008 7c7f1b78 90010014 4800d32d 813f0000
7c7e1b78 552907fe
[ 6549.044203] 69290001 0f090000 2f830000 419e00cc <81230040> 81290010
712a0001 40a200bc
[ 6549.044573] ---[ end trace 5bfcfc2ec91b3063 ]---

-- 
Pranith
