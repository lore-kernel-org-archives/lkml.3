Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaCaO6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:58:39 -0400
Received: from mail001.aei.ca ([206.123.6.130]:37213 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaCaO6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:58:37 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [BUG] 3.14-rc6 at mousedev_open_device+0x77/0x100
Date: Mon, 31 Mar 2014 10:58:28 -0400
Message-ID: <8839108.mXWBK1Dc7p@grover>
Organization: me
User-Agent: KMail/4.12.3 (Linux/3.14.0-1-mainline; KDE/4.12.3; x86_64; ; )
In-Reply-To: <1513450.PT1cqDJBLI@grover>
References: <1513450.PT1cqDJBLI@grover>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 12:07:56 Ed Tomlinson wrote:

This seems fixed by "[PATCH] Input: mousedev - fix race when creating mixed device" which is in 3.14

Thanks
Ed

> This happens every couple of boots with 3.14-rc kernels have not noticed it with 3.13.  Not really sure where else this should be sent...
> 
> Mar 10 10:45:05 localhost kernel: [    4.740750] BUG: unable to handle kernel NULL pointer dereference at           (null)
> Mar 10 10:45:05 localhost kernel: [    4.740845] IP: [<ffffffffa02ee317>] mousedev_open_device+0x77/0x100 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.740930] PGD 412cfa067 PUD 41881e067 PMD 0 
> Mar 10 10:45:05 localhost kernel: [    4.740989] Oops: 0000 [#1] PREEMPT SMP 
> Mar 10 10:45:05 localhost kernel: [    4.741043] Modules linked in: mousedev(+) pl2303 usbserial btusb joydev hid_generic snd_usb_audio usbhid snd_usbmidi_lib snd_
> rawmidi hid snd_seq_device zram nct6775 hwmon_vid radeon ttm btrfs snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi raid6_pq xor iTCO_wdt iTCO_vendor
> _support x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf1
> 28mul glue_helper ablk_helper cryptd psmouse pcspkr i2c_i801 serio_raw tpm_tis tpm i915 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm drm_kms_helper mei_me snd_tim
> er e1000e drm nuvoton_cir mei snd rc_core shpchp intel_gtt ptp i2c_algo_bit pps_core soundcore lpc_ich evdev microcode ath3k bluetooth 6lowpan_iphc rfkill gspca_pa
> c7311 gspca_ov519 gspca_main videodev media i2c_core video acpi_power_meter thermal processor pci chipreg mtd fan button battery acpi_pad acpi_ipmi ipmi_msghandler
>  ext4 crc16 mbcache jbd2 usb_storage sd_mod crc_t10dif crct10dif_common atkbd libps2 ahci libahci libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_common i80
> 42 serio
> Mar 10 10:45:05 localhost kernel: [    4.742722] CPU: 4 PID: 338 Comm: acpid Not tainted 3.14.0-1-mainline #1
> Mar 10 10:45:05 localhost kernel: [    4.742822] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z87E-ITX, BIOS P2.30 12/06/2013
> Mar 10 10:45:05 localhost kernel: [    4.742916] task: ffff8804170889e0 ti: ffff8800c2800000 task.ti: ffff8800c2800000
> Mar 10 10:45:05 localhost kernel: [    4.743013] RIP: 0010:[<ffffffffa02ee317>]  [<ffffffffa02ee317>] mousedev_open_device+0x77/0x100 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.743015] RSP: 0018:ffff8800c2801c10  EFLAGS: 00010202
> Mar 10 10:45:05 localhost kernel: [    4.743021] RAX: 0000000000000000 RBX: ffff880404650800 RCX: ffff880404650868
> Mar 10 10:45:05 localhost kernel: [    4.743023] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000246
> Mar 10 10:45:05 localhost kernel: [    4.743024] RBP: ffff8800c2801c28 R08: 0000000000000000 R09: ffff88041e803600
> Mar 10 10:45:05 localhost kernel: [    4.743025] R10: 0000000000000000 R11: 0000000000000004 R12: 0000000000000000
> Mar 10 10:45:05 localhost kernel: [    4.743027] R13: ffff880404650880 R14: ffff88040a78f778 R15: ffff880417744c00
> Mar 10 10:45:05 localhost kernel: [    4.743029] FS:  00007f93d2f6c700(0000) GS:ffff88042f300000(0000) knlGS:0000000000000000
> Mar 10 10:45:05 localhost kernel: [    4.743031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Mar 10 10:45:05 localhost kernel: [    4.743032] CR2: 0000000000000000 CR3: 0000000417542000 CR4: 00000000001407e0
> Mar 10 10:45:05 localhost kernel: [    4.743033] Stack:
> Mar 10 10:45:05 localhost kernel: [    4.743038]  ffff880412de1c00 ffff880404650800 ffff880404650878 ffff8800c2801c60
> Mar 10 10:45:05 localhost kernel: [    4.743041]  ffffffffa02ef0cc ffff880404650b48 ffff88040a78f778 ffff880417744c00
> Mar 10 10:45:05 localhost kernel: [    4.743045]  ffffffffa02efe80 ffff880417744c10 ffff8800c2801c98 ffffffff811b5e2f
> Mar 10 10:45:05 localhost kernel: [    4.743046] Call Trace:
> Mar 10 10:45:05 localhost kernel: [    4.743054]  [<ffffffffa02ef0cc>] mousedev_open+0xcc/0x150 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.743061]  [<ffffffff811b5e2f>] chrdev_open+0x9f/0x1d0
> Mar 10 10:45:05 localhost kernel: [    4.743068]  [<ffffffff811af527>] do_dentry_open+0x1b7/0x2c0
> Mar 10 10:45:05 localhost kernel: [    4.743073]  [<ffffffff811bc7e1>] ? __inode_permission+0x41/0xb0
> Mar 10 10:45:05 localhost kernel: [    4.743077]  [<ffffffff811b5d90>] ? cdev_put+0x30/0x30
> Mar 10 10:45:05 localhost kernel: [    4.743081]  [<ffffffff811af941>] finish_open+0x31/0x40
> Mar 10 10:45:05 localhost kernel: [    4.743086]  [<ffffffff811bf612>] do_last+0x572/0xe90
> Mar 10 10:45:05 localhost kernel: [    4.743091]  [<ffffffff811bcad6>] ? link_path_walk+0x236/0x8d0
> Mar 10 10:45:05 localhost kernel: [    4.743097]  [<ffffffff811bffeb>] path_openat+0xbb/0x6b0
> Mar 10 10:45:05 localhost kernel: [    4.743102]  [<ffffffff811c16fa>] do_filp_open+0x3a/0x90
> Mar 10 10:45:05 localhost kernel: [    4.743106]  [<ffffffff811cddf7>] ? __alloc_fd+0xa7/0x130
> Mar 10 10:45:05 localhost kernel: [    4.743111]  [<ffffffff811b0b14>] do_sys_open+0x124/0x220
> Mar 10 10:45:05 localhost kernel: [    4.743116]  [<ffffffff811b0c2e>] SyS_open+0x1e/0x20
> Mar 10 10:45:05 localhost kernel: [    4.743120]  [<ffffffff8153702d>] system_call_fastpath+0x1a/0x1f
> Mar 10 10:45:05 localhost kernel: [    4.743151] Code: c0 f2 23 e1 5b 44 89 e0 41 5c 41 5d 5d c3 66 0f 1f 44 00 00 4c 89 ef 41 bc ed ff ff ff e8 a2 f2 23 e1 eb e0 
> 48 8b 15 c9 21 00 00 <8b> 02 8d 48 01 85 c0 89 0a 75 c6 48 8b 05 37 1f 00 00 48 3d 60 
> Mar 10 10:45:05 localhost kernel: [    4.743156] RIP  [<ffffffffa02ee317>] mousedev_open_device+0x77/0x100 [mousedev]
> Mar 10 10:45:05 localhost kernel: [    4.743157]  RSP <ffff8800c2801c10>
> Mar 10 10:45:05 localhost kernel: [    4.743158] CR2: 0000000000000000
> Mar 10 10:45:05 localhost kernel: [    4.743200] ---[ end trace 9ee5bcb02f264a08 ]---
> 
> The bug does not seem to hurt things much but...
> 
> TIA
> Ed Tomlinson
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

