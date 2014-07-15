Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbaGOWVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:21:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41391 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506AbaGOWUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:20:44 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
X-Google-Original-From: Peter Senna Tschudin <peter@hp-peter.rsr.lip6.fr>
Date: Wed, 16 Jul 2014 00:20:25 +0200
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: OOPS: NULL pointer dereference: blk_throtl_drain+0x28/0x110
Message-ID: <20140715222025.GA2412@hp-peter.rsr.lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

OOPS on 3.16.0-rc5-next-20140715

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oops

[   74.423074] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[   74.425506] IP: [<ffffffff8141f168>] blk_throtl_drain+0x28/0x110
[   74.426276] PGD 0 
[   74.426931] Oops: 0000 [#1] SMP 
[   74.427596] Modules linked in: usb_storage rfcomm fuse xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 iwlmvm mac80211 rtsx_pci_sdmmc mmc_core iTCO_wdt iTCO_vendor_support rtsx_pci_ms hp_wmi memstick ppdev sparse_keymap vfat fat iwlwifi x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_codec_idt snd_hda_codec_hdmi cfg80211 snd_hda_codec_generic snd_hda_intel snd_hda_controller crct10dif_pclmul crc32_pclmul snd_hda_codec tpm_infineon crc32c_intel uvcvideo ghash_clmulni_intel microcode videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hwdep joydev lpc_ich serio_raw btusb bluetooth snd_seq i2c_i801 media
[   74.429907]  snd_seq_device snd_pcm rtsx_pci mfd_core snd_timer snd mei_me mei shpchp rfkill parport_pc soundcore parport wmi tpm_tis tpm hp_accel lis3lv02d input_polldev hp_wireless i915 i2c_algo_bit drm_kms_helper drm e1000e ptp pps_core video
[   74.431602] CPU: 0 PID: 37 Comm: khubd Not tainted 3.16.0-rc5-next-20140715 #12
[   74.432458] Hardware name: Hewlett-Packard HP EliteBook 840 G1/198F, BIOS L71 Ver. 01.10 03/25/2014
[   74.433349] task: ffff8804381ec130 ti: ffff880437dfc000 task.ti: ffff880437dfc000
[   74.434155] RIP: 0010:[<ffffffff8141f168>]  [<ffffffff8141f168>] blk_throtl_drain+0x28/0x110
[   74.434997] RSP: 0018:ffff880437dff950  EFLAGS: 00010046
[   74.435841] RAX: 0000000000000000 RBX: ffff880432f007c8 RCX: 0000000000000000
[   74.436694] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[   74.437545] RBP: ffff880437dff968 R08: ffff88043180ee48 R09: ffff880437ae2da0
[   74.438401] R10: ffff880437dff960 R11: ffffea0010c75100 R12: ffff880432f007c8
[   74.439269] R13: ffff88040ffda400 R14: ffff880432f00e20 R15: ffff8800a8440920
[   74.440121] FS:  0000000000000000(0000) GS:ffff88044ea00000(0000) knlGS:0000000000000000
[   74.441107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.441982] CR2: 0000000000000028 CR3: 0000000001e11000 CR4: 00000000001407f0
[   74.442857] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   74.443764] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   74.444672] Stack:
[   74.445578]  ffff880432f007c8 0000000000000000 ffff880432f00e30 ffff880437dff978
[   74.446461]  ffffffff8141c07e ffff880437dff9a8 ffffffff813fec6e ffff880432f007c8
[   74.447379]  ffffffff81e9db00 ffff880432f007c8 ffff8800a8440800 ffff880437dff9c0
[   74.448326] Call Trace:
[   74.449268]  [<ffffffff8141c07e>] blkcg_drain_queue+0xe/0x10
[   74.450156]  [<ffffffff813fec6e>] __blk_drain_queue+0x6e/0x150
[   74.451160]  [<ffffffff813fedad>] blk_queue_bypass_start+0x5d/0x80
[   74.452069]  [<ffffffff8141b338>] blkcg_deactivate_policy+0x38/0x120
[   74.452979]  [<ffffffff8141f384>] blk_throtl_exit+0x34/0x50
[   74.453963]  [<ffffffff8141c0ba>] blkcg_exit_queue+0x3a/0x40
[   74.454881]  [<ffffffff81402296>] blk_release_queue+0x26/0xe0
[   74.455792]  [<ffffffff8142d597>] kobject_cleanup+0x77/0x1b0
[   74.456721]  [<ffffffff8142d448>] kobject_put+0x28/0x60
[   74.457702]  [<ffffffff813fb875>] blk_put_queue+0x15/0x20
[   74.458683]  [<ffffffff8156b50b>] scsi_device_dev_release_usercontext+0xbb/0x120
[   74.459681]  [<ffffffff810a8af7>] execute_in_process_context+0x67/0x70
[   74.460673]  [<ffffffff8156b44c>] scsi_device_dev_release+0x1c/0x20
[   74.461657]  [<ffffffff8153ab42>] device_release+0x32/0xa0
[   74.462617]  [<ffffffff8142d597>] kobject_cleanup+0x77/0x1b0
[   74.463514]  [<ffffffff8142d448>] kobject_put+0x28/0x60
[   74.464407]  [<ffffffff8153ae67>] put_device+0x17/0x20
[   74.465276]  [<ffffffff8156c26e>] __scsi_remove_device+0x9e/0xe0
[   74.466173]  [<ffffffff8156a764>] scsi_forget_host+0x64/0x70
[   74.467069]  [<ffffffff8155e447>] scsi_remove_host+0x77/0x120
[   74.467964]  [<ffffffffa07753f9>] usb_stor_disconnect+0x59/0xd0 [usb_storage]
[   74.468864]  [<ffffffff815c6ac4>] usb_unbind_interface+0x74/0x2b0
[   74.469763]  [<ffffffff8153f51f>] __device_release_driver+0x7f/0xf0
[   74.470661]  [<ffffffff8153f5b3>] device_release_driver+0x23/0x30
[   74.471561]  [<ffffffff8153ee88>] bus_remove_device+0x108/0x180
[   74.472462]  [<ffffffff8153b3f9>] device_del+0x129/0x1c0
[   74.473364]  [<ffffffff815c4400>] usb_disable_device+0xb0/0x290
[   74.474248]  [<ffffffff815b9bf5>] usb_disconnect+0x95/0x280
[   74.475159]  [<ffffffff815bbf09>] hub_thread+0x7b9/0x16f0
[   74.476068]  [<ffffffff818035bd>] ? __schedule+0x2bd/0x730
[   74.476976]  [<ffffffff810d0400>] ? abort_exclusive_wait+0xb0/0xb0
[   74.477887]  [<ffffffff815bb750>] ? hub_port_debounce+0x170/0x170
[   74.478805]  [<ffffffff810afbb8>] kthread+0xd8/0xf0
[   74.479721]  [<ffffffff810afae0>] ? insert_kthread_work+0x40/0x40
[   74.480643]  [<ffffffff81807abc>] ret_from_fork+0x7c/0xb0
[   74.481567]  [<ffffffff810afae0>] ? insert_kthread_work+0x40/0x40
[   74.482498] Code: 1f 40 00 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 49 89 fc 53 4c 8b af 40 07 00 00 49 8b 85 a0 00 00 00 31 ff 48 8b 80 c8 05 00 00 <48> 8b 70 28 e8 9f ac cf ff 48 85 c0 48 89 c3 74 61 0f 1f 80 00 
[   74.483502] RIP  [<ffffffff8141f168>] blk_throtl_drain+0x28/0x110
[   74.484426]  RSP <ffff880437dff950>
[   74.485335] CR2: 0000000000000028
[   74.492437] ---[ end trace 348883f55fad779f ]---

--/9DWx/yDrRhgMJTb--
