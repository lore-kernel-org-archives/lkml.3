Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaESNw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:52:57 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:40684 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaESNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:52:55 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 19 May 2014 09:56:54 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: perfevents: irq loop stuck!
In-Reply-To: <alpine.DEB.2.10.1405190906190.14771@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405190954460.14771@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu> <20140515182136.GI11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405160017120.1351@vincent-weaver-1.umelst.maine.edu>
 <20140516074445.GJ11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405190906190.14771@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Vince Weaver wrote:

> The fuzzing also turned up a few other issues, and in the end after 2 days 
> it locked up the machine so hard that it also took out the ethernet switch 
> due to some sort of packet trasmit storm, which is a failure mode I 
> have to admit I haven't encountered before.

Not only did it take out the ethernet switch, but it corrupted the 
filesystem too :(

Though I guess I should be surprised this doesn't happen more considering 
how often I have to hard-reboot the machines. 

[ 3835.636255] EXT4-fs error (device sda4): ext4_mb_generate_buddy:756: group 1681, 14687 clusters in bitmap, 14680 in gd; block bitmap corrupt.
[ 3835.649921] Aborting journal on device sda4-8.
[ 3835.654895] EXT4-fs (sda4): Remounting filesystem read-only
[ 3835.661053] ------------[ cut here ]------------
[ 3835.666163] WARNING: CPU: 0 PID: 2265 at fs/ext4/ext4_jbd2.c:259 __ext4_handle_dirty_metadata+0x1b2/0x200()
[ 3835.676785] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi kvm iTCO_wdt snd_hda_codec_realtek snd_hda_codec_generic iTCO_vendor_support i915 crc32_pclmul snd_hda_intel ghash_clmulni_intel snd_hda_controller wmi evdev drm_kms_helper ppdev aesni_intel mei_me mei drm snd_hda_codec aes_x86_64 lrw gf128mul glue_helper snd_hwdep ablk_helper psmouse snd_pcm snd_timer tpm_tis i2c_algo_bit snd tpm pcspkr serio_raw processor battery i2c_i801 i2c_core lpc_ich parport_pc parport cryptd soundcore button video mfd_core sd_mod sr_mod crc_t10dif crct10dif_generic cdrom ehci_pci ahci libahci xhci_hcd e1000e ehci_hcd crct10dif_pclmul libata crct10dif_common ptp crc32c_intel usbcore scsi_mod pps_core usb_common thermal fan thermal_sys
[ 3835.751220] CPU: 0 PID: 2265 Comm: git Not tainted 3.15.0-rc5+ #108
[ 3835.757911] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[ 3835.765842]  0000000000000009 ffff8801179fb908 ffffffff8164a8f0 0000000000000000
[ 3835.773882]  ffff8801179fb940 ffffffff810646ad ffff880036aa7888 0000000000000000
[ 3835.781927]  ffff880036bf1cc8 ffffffff81830e20 00000000000012f3 ffff8801179fb950
[ 3835.789913] Call Trace:
[ 3835.792537]  [<ffffffff8164a8f0>] dump_stack+0x45/0x56
[ 3835.798028]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
[ 3835.804381]  [<ffffffff8106478a>] warn_slowpath_null+0x1a/0x20
[ 3835.810577]  [<ffffffff81269662>] __ext4_handle_dirty_metadata+0x1b2/0x200
[ 3835.817882]  [<ffffffff81652017>] ? _raw_spin_unlock+0x27/0x30
[ 3835.824080]  [<ffffffff81271ef6>] ext4_free_blocks+0x646/0xbf0
[ 3835.830334]  [<ffffffff81264be9>] ext4_ext_remove_space+0x7d9/0x1050
[ 3835.837054]  [<ffffffff81267580>] ext4_ext_truncate+0xb0/0xe0
[ 3835.843223]  [<ffffffff81240589>] ext4_truncate+0x379/0x3c0
[ 3835.849076]  [<ffffffff81152be9>] ? truncate_pagecache+0x59/0x60
[ 3835.855547]  [<ffffffff81241d1f>] ext4_setattr+0x2ef/0x730
[ 3835.861437]  [<ffffffff811d2961>] notify_change+0x241/0x390
[ 3835.867342]  [<ffffffff811b315f>] do_truncate+0x6f/0xa0
[ 3835.873046]  [<ffffffff811b2bab>] ? do_dentry_open+0x22b/0x2c0
[ 3835.879284]  [<ffffffff811c4edf>] do_last+0xa7f/0x12f0
[ 3835.884863]  [<ffffffff811c1241>] ? link_path_walk+0x71/0x880
[ 3835.891080]  [<ffffffff811c57c8>] ? path_openat+0x78/0x670
[ 3835.897030]  [<ffffffff811c580b>] path_openat+0xbb/0x670
[ 3835.902656]  [<ffffffff810b0d4d>] ? __lock_acquire.isra.29+0x3bd/0xb90
[ 3835.909714]  [<ffffffff811c65da>] do_filp_open+0x3a/0x90
[ 3835.915433]  [<ffffffff81652017>] ? _raw_spin_unlock+0x27/0x30
[ 3835.921711]  [<ffffffff811d3c97>] ? __alloc_fd+0xa7/0x130
[ 3835.927522]  [<ffffffff811b4698>] do_sys_open+0x128/0x220
[ 3835.933351]  [<ffffffff811b47ae>] SyS_open+0x1e/0x20
[ 3835.938695]  [<ffffffff8165b5ed>] system_call_fastpath+0x1a/0x1f
[ 3835.945196] ---[ end trace abc274a1f233508e ]---
[ 3835.950155] EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at line 3740, credits 16/16, errcode -30
[ 3835.961325] EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at line 3740, credits 16/16, errcode -30<2>[ 3835.972625] EXT4-fs error (device sda4) in ext4_free_blocks:4867: Journal has aborted
[ 3835.981224] EXT4-fs error (device sda4) in ext4_reserve_inode_write:4877: Journal has aborted
[ 3836.011139] EXT4-fs error (device sda4) in ext4_reserve_inode_write:4877: Journal has aborted
[ 3836.020512] EXT4-fs error (device sda4) in ext4_ext_remove_space:3018: Journal has aborted
[ 3836.036079] EXT4-fs error (device sda4) in ext4_ext_truncate:4666: Journal has aborted
[ 3836.044701] EXT4-fs error (device sda4) in ext4_reserve_inode_write:4877: Journal has aborted
[ 3836.053985] EXT4-fs error (device sda4) in ext4_orphan_del:2684: Journal has aborted
[ 3836.069403] EXT4-fs error (device sda4) in ext4_reserve_inode_write:4877: Journal has aborted

