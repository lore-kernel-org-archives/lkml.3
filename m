Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaKKR5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:57:07 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33595 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKKR5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:57:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAJBHPoiYce87At_DKiGbj6WnkcuuS0zEdGvdaYTDUUcq2gn6AA@mail.gmail.com>
References: <CAJBHPoiYce87At_DKiGbj6WnkcuuS0zEdGvdaYTDUUcq2gn6AA@mail.gmail.com>
Date: Tue, 11 Nov 2014 18:57:02 +0100
Message-ID: <CAJBHPohDaFTGCh-00W2RNUVfzoeWk5Mrig5y4yXcjH5ZUMG2xg@mail.gmail.com>
Subject: Fwd: Crash of radeon_ttm_tt_unpopulate in ttm_dma_unpopulate with
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This crash occured after about a day  with 3.18.0-rc3
that is unmodified with exception of a single unrelated i915 driver
patch from http://www.spinics.net/lists/intel-gfx/msg54997.html

Its a samsung np730u3e-s05 with hybrid graphics chipset and the Radeon
HD 8550M isn't used. I can provide further info if this is of
interest.

(resent in plaintex)

[23168.559229] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000018
[23168.560206] IP: [<ffffffffa0458700>] ttm_dma_unpopulate+0x260/0x390 [ttm]
[23168.561209] PGD 0
[23168.562145] Oops: 0000 [#1] PREEMPT SMP
[23168.563096] Modules linked in: ctr ccm fuse arc4 snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic iTCO_wdt uvcvideo iwldvm
coretemp videobuf2_vmalloc intel_rapl joydev videobuf2_memops mac80211
videobuf2_core snd_hda_intel snd_hda_controller iTCO_vendor_support
mousedev x86_pkg_temp_thermal intel_powerclamp radeon v4l2_common
iwlwifi samsung_laptop kvm_intel videodev snd_hda_codec i915 ttm evdev
ecb mac_hid snd_hwdep drm_kms_helper r8169 kvm btusb psmouse pcspkr
serio_raw i2c_i801 media cfg80211 drm lpc_ich rtsx_usb_ms intel_gtt
snd_pcm hwmon bluetooth mii i2c_algo_bit tpm_infineon memstick mei_me
fan rfkill snd_timer wmi tpm_tis i2c_core battery snd thermal tpm
soundcore mei video shpchp button ac processor ext4 crc16 mbcache jbd2
algif_skcipher af_alg dm_crypt dm_mod rtsx_usb_sdmmc
[23168.566629]  led_class mmc_core rtsx_usb sd_mod crct10dif_pclmul
crc32_pclmul crc32c_intel atkbd ghash_clmulni_intel libps2 aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ahci libahci
xhci_pci ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common
i8042 serio
[23168.569111] CPU: 3 PID: 406 Comm: Xorg.bin Tainted: G        W
3.18.0-rc3-marcus1 #1
[23168.570348] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
730U3E/740U3E/NP730U3E-S05DE, BIOS P03ABW.051.130226.dg 02/26/2013
[23168.571614] task: ffff8801a5cf6eb0 ti: ffff8800bf908000 task.ti:
ffff8800bf908000
[23168.572879] RIP: 0010:[<ffffffffa0458700>]  [<ffffffffa0458700>]
ttm_dma_unpopulate+0x260/0x390 [ttm]
[23168.574163] RSP: 0000:ffff8800bf90b978  EFLAGS: 00010207
[23168.575443] RAX: 0000000000000000 RBX: ffff8801a55d6300 RCX: 0000000000000005
[23168.576719] RDX: ffff8800bffd3600 RSI: dead000000200200 RDI: ffff8801a55d6900
[23168.578039] RBP: ffff8800bf90b9b8 R08: 0000000000000004 R09: ffff8800c372b5a0
[23168.579310] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801a55d6360
[23168.580579] R13: ffff8801a4bd4710 R14: ffff8801a4f3cb40 R15: 0000000000000006
[23168.581855] FS:  00007fd27407f700(0000) GS:ffff8801af380000(0000)
knlGS:0000000000000000
[23168.583145] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[23168.584434] CR2: 0000000000000018 CR3: 0000000001811000 CR4: 00000000001407e0
[23168.585742] Stack:
[23168.587045]  ffff8800c3728800 ffff8801a55d6900 ffff8801a4bd4000
ffff8801a55d6300
[23168.588420]  0000000000000002 ffff8801a4bd4710 ffff8801a55d6300
000000000000002a
[23168.589785]  ffff8800bf90b9e8 ffffffffa094a8b7 ffff8801a55d6300
0000000000000002
[23168.591134] Call Trace:
[23168.592483]  [<ffffffffa094a8b7>]
radeon_ttm_tt_unpopulate+0x147/0x150 [radeon]
[23168.593878]  [<ffffffffa044f2a4>] ttm_tt_unpopulate+0x54/0x60 [ttm]
[23168.595220]  [<ffffffffa044f315>] ttm_tt_destroy+0x65/0x70 [ttm]
[23168.596557]  [<ffffffffa044fa93>] ttm_bo_cleanup_memtype_use+0x43/0x90 [ttm]
[23168.597901]  [<ffffffffa0450730>] ttm_bo_release+0x120/0x2e0 [ttm]
[23168.599188]  [<ffffffffa0450919>] ttm_bo_unref+0x29/0x30 [ttm]
[23168.600431]  [<ffffffffa094c2f9>] radeon_bo_unref+0x39/0x70 [radeon]
[23168.601661]  [<ffffffffa096137b>] radeon_gem_object_free+0x4b/0x70 [radeon]
[23168.602899]  [<ffffffffa049dbf7>] drm_gem_object_free+0x27/0x40 [drm]
[23168.604143]  [<ffffffffa049dd30>]
drm_gem_object_handle_unreference_unlocked+0x120/0x130 [drm]
[23168.605406]  [<ffffffffa049df77>]
drm_gem_object_release_handle+0x57/0x80 [drm]
[23168.606668]  [<ffffffff812ad2e5>] idr_for_each+0xb5/0x120
[23168.607934]  [<ffffffffa049df20>] ? drm_gem_dumb_destroy+0x20/0x20 [drm]
[23168.609213]  [<ffffffffa049e5f4>] drm_gem_release+0x24/0x40 [drm]
[23168.610463]  [<ffffffffa049d35b>] drm_release+0x43b/0x520 [drm]
[23168.611773]  [<ffffffff811c9b8c>] __fput+0x9c/0x200
[23168.613039]  [<ffffffff811c9d3e>] ____fput+0xe/0x10
[23168.614333]  [<ffffffff8108834c>] task_work_run+0xbc/0xe0
[23168.615577]  [<ffffffff8106e505>] do_exit+0x3a5/0xb30
[23168.616825]  [<ffffffff8109123e>] ? ttwu_stat+0x9e/0x110
[23168.618083]  [<ffffffff810e5e60>] ? get_futex_key+0x250/0x2c0
[23168.619400]  [<ffffffff8106ed27>] do_group_exit+0x47/0xc0
[23168.620666]  [<ffffffff8107a673>] get_signal+0x273/0x710
[23168.621931]  [<ffffffff810145f7>] do_signal+0x37/0x800
[23168.623221]  [<ffffffff81014e28>] do_notify_resume+0x68/0xa0
[23168.624488]  [<ffffffff8154d1e0>] int_signal+0x12/0x17
[23168.625762] Code: ff 66 2e 0f 1f 84 00 00 00 00 00 49 89 ce 48 8b
43 60 4c 8d 63 60 45 31 ff 4c 39 e0 74 28 45 31 ff 66 2e 0f 1f 84 00
00 00 00 00 <48> 8b 70 18 48 8b 53 18 44 89 f9 41 83 c7 01 48 89 34 ca
48 8b
[23168.627274] RIP  [<ffffffffa0458700>] ttm_dma_unpopulate+0x260/0x390 [ttm]
[23168.628790]  RSP <ffff8800bf90b978>
[23168.630300] CR2: 0000000000000018
[23168.631810] ---[ end trace acd63743d38c53a7 ]---
[23168.633307] Fixing recursive fault but reboot is needed!

regards
Marcus
