Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaIEGtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:49:13 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:41631 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaIEGtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:49:07 -0400
Message-ID: <54095D73.7010907@gmail.com>
Date: Fri, 05 Sep 2014 08:51:31 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt@console-pimps.org>
Subject: oops on kernel 3.14.17 seems related to EFI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Another day, another oops...

[  +0.055412] BUG: unable to handle kernel NULL pointer dereference at
         (null)
[  +0.000062] IP: [<          (null)>]           (null)
[  +0.000034] PGD 2b3c067 PUD 2b3d067 PMD 2b3e067 PTE 8000000000000163
[  +0.000047] Oops: 0011 [#1] SMP
[  +0.000027] Modules linked in: btrfs raid6_pq xor ses enclosure
usb_storage tun loop joydev fuse coretemp hwmon arc4 iwldvm led_class
intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm
nls_iso8859_1 mac80211 nls_cp437 crct10d
[  +0.000574]  ac processor mac_hid nfs lockd sunrpc fscache ext4 crc16
mbcache jbd2 hid_generic usbhid hid bcache sd_mod sr_mod crc_t10dif
cdrom crct10dif_common rtsx_pci_sdmmc mmc_core atkbd libps2 ahci libahci
ehci_pci libata xhci_hcd e
[  +0.000274] CPU: 3 PID: 12321 Comm: systemd-udevd Not tainted
3.14.17-1-lts #1
[  +0.000044] Hardware name: CLEVO CO.                        W55xEU
                      /W55xEU                          , BIOS 4.6.5
03/05/2013
[  +0.000077] task: ffff8803a9ef60e0 ti: ffff8800b4000000 task.ti:
ffff8800b4000000
[  +0.000045] RIP: 0010:[<0000000000000000>]  [<          (null)>]
     (null)
[  +0.000046] RSP: 0018:ffff8800b4001da8  EFLAGS: 00010002
[  +0.000032] RAX: 0000000080050033 RBX: ffff880406288000 RCX:
ffff880406288000
[  +0.000041] RDX: ffff880406288400 RSI: ffff880406288000 RDI:
0000000000000000
[  +0.000042] RBP: ffff8800b4001e80 R08: 0000000000000000 R09:
ffff8800b4001ec0
[  +0.000042] R10: 0000000000000000 R11: 0000000000000246 R12:
ffff880406288400
[  +0.000042] R13: 0000000000000000 R14: ffff8800b4001ec0 R15:
000000000009b000
[  +0.000042] FS:  00007f7720a567c0(0000) GS:ffff88041e2c0000(0000)
knlGS:0000000000000000
[  +0.000048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000034] CR2: 0000000000000000 CR3: 000000000009b000 CR4:
00000000001427e0
[  +0.000042] Stack:
[  +0.000014]  ffffffff81063281 ffffffff811bd95c 0000000000000246
ffff8800da9e6628
[  +0.000052]  8000000300000000 0000000000000000 0000000000000000
ffff8800b4001e50
[  +0.000051]  0000000080050033 00007f7722abbc50 00007f7722abbb50
00ffffffffffffff
[  +0.000052] Call Trace:
[  +0.000022]  [<ffffffff81063281>] ? efi_call5+0x71/0xf0
[  +0.000035]  [<ffffffff811bd95c>] ? getname_flags+0x2c/0x130
[  +0.000037]  [<ffffffff81062649>] ? virt_efi_get_variable+0x49/0x60
[  +0.000051]  [<ffffffff813d0181>] efivar_entry_size+0x41/0x80
[  +0.000030]  [<ffffffff8123aec9>] efivarfs_file_read+0x49/0x100
[  +0.000046]  [<ffffffff811b2077>] vfs_read+0x97/0x160
[  +0.000041]  [<ffffffff811b2bc9>] SyS_read+0x59/0xd0
[  +0.000041]  [<ffffffff81509e29>] system_call_fastpath+0x16/0x1b
[  +0.000035] Code:  Bad RIP value.
[  +0.000026] RIP  [<          (null)>]           (null)
[  +0.000033]  RSP <ffff8800b4001da8>
[  +0.000022] CR2: 0000000000000000
[  +0.015070] ---[ end trace 9b69115f973204df ]---

Thanks for any helps.
