Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbaEQPYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:24:10 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:37509 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbaEQPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:24:08 -0400
Message-ID: <53777F7B.8060407@gmail.com>
Date: Sat, 17 May 2014 17:25:47 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: kernel 3.14.2 oops: seems related to EFI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  +0.018677] general protection fault: 0000 [#1] PREEMPT SMP
[  +0.000068] Modules linked in: usb_storage tun raid1 md_mod loop fuse
joydev coretemp hwmon arc4 intel_rapl x86_pkg_temp_thermal
intel_powerclamp kvm_intel nls_iso8859_1 nls_cp437 iTCO_wdt kvm vfat fat
iTCO_vendor_support iwldvm uvcvideo led_class crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel mac80211 videobuf2_vmalloc
videobuf2_memops videobuf2_core aesni_intel videodev aes_x86_64
snd_hda_codec_hdmi lrw gf128mul mousedev glue_helper btusb
snd_hda_codec_via ablk_helper media cryptd iwlwifi snd_hda_codec_generic
bluetooth psmouse microcode i2c_i801 serio_raw cfg80211 6lowpan_iphc
rtsx_pci_ms r8169 memstick rfkill lpc_ich mii snd_hda_intel
snd_hda_codec thermal snd_hwdep wmi snd_pcm tpm_infineon snd_timer
tpm_tis mei_me snd tpm mei shpchp evdev soundcore processor battery
mac_hid ac
[  +0.000803]  ext4 crc16 mbcache jbd2 hid_generic usbhid hid bcache
sd_mod sr_mod crc_t10dif cdrom crct10dif_common rtsx_pci_sdmmc mmc_core
atkbd libps2 ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod
rtsx_pci usbcore usb_common i8042 serio i915 video button intel_gtt
i2c_algo_bit drm_kms_helper drm i2c_core
[  +0.000328] CPU: 0 PID: 30835 Comm: systemd-udevd Not tainted
3.14.2-1-ARCH #1
[  +0.000064] Hardware name: CLEVO CO.                        W55xEU
                      /W55xEU                          , BIOS 4.6.5
03/05/2013
[  +0.000102] task: ffff880405ee6bf0 ti: ffff880400f4a000 task.ti:
ffff880400f4a000
[  +0.000060] RIP: 0010:[<ffffffff810655af>]  [<ffffffff810655af>]
efi_call5+0x6f/0xf0
[  +0.000071] RSP: 0018:ffff880400f4bdb0  EFLAGS: 00010002
[  +0.000045] RAX: 0000000080050033 RBX: ffff8804040e3000 RCX:
ffff8804040e3000
[  +0.000055] RDX: ffff8804040e3400 RSI: ffff8804040e3000 RDI:
bff7fffff7afffff
[  +0.000056] RBP: ffff880400f4be80 R08: 0000000000000000 R09:
ffff880400f4bec0
[  +0.000055] R10: 0000000000000000 R11: 0000000000000246 R12:
ffff8804040e3400
[  +0.000056] R13: 0000000000000000 R14: ffff880400f4bec0 R15:
000000000009b000
[  +0.002960] FS:  00007fb6167c97c0(0000) GS:ffff88041e200000(0000)
knlGS:0000000000000000
[  +0.002958] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.003177] CR2: 00007fb61581f4c0 CR3: 000000000009b000 CR4:
00000000001427e0
[  +0.003258] Stack:
[  +0.003257]  0000000000000201 8000000000000065 ffff880400000000
ffff880100000000
[  +0.003328]  0000000000000000 0000000000000000 ffff880400f4be50
0000000080050033
[  +0.003354]  0000000000ff0000 0000000000000000 00ffffffffffffff
0000000000000000
[  +0.003368] Call Trace:
[  +0.003389]  [<ffffffff81064901>] ? virt_efi_get_variable+0x51/0x80
[  +0.003353]  [<ffffffff813dbb71>] efivar_entry_size+0x41/0x80
[  +0.003315]  [<ffffffff81245659>] efivarfs_file_read+0x49/0x100
[  +0.003326]  [<ffffffff811ba797>] vfs_read+0x97/0x160
[  +0.003305]  [<ffffffff811bb2e9>] SyS_read+0x59/0xd0
[  +0.003263]  [<ffffffff81517629>] system_call_fastpath+0x16/0x1b
[  +0.003239] Code: 89 c8 48 89 f1 80 3d e8 16 7d 00 00 74 1d 4c 89 3d
c7 16 7d 00 41 0f 20 df 4c 89 3d c4 16 7d 00 4c 8b 3d c5 16 7d 00 41 0f
22 df <ff> d7 80 3d c0 16 7d 00 00 74 41 4c 8b 3d a7 16 7d 00 41 0f 22
[  +0.003648] RIP  [<ffffffff810655af>] efi_call5+0x6f/0xf0
[  +0.003511]  RSP <ffff880400f4bdb0>
[  +0.024630] ---[ end trace 3670998c9a49abb7 ]---
[  +0.000005] note: systemd-udevd[30835] exited with preempt_count 2
