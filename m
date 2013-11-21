Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3KUX3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:29:38 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42174 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3KUX3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:29:35 -0500
X-AuditID: cbfec37a-b7fb76d000006e93-6c-528e975dc3e6
Message-id: <528E975B.5010200@samsung.com>
Date: Thu, 21 Nov 2013 16:29:31 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: 3.12.1 Virt dev invalid for slot_id 0x1
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9hP9246X1BBp2HGC0u75rDZvH1p4PF
	go2PGB2YPXbOusvu8XmTXABTFJdNSmpOZllqkb5dAlfGw31JBdPlKy78OMfYwPhCsouRk0NC
	wETiXmczE4QtJnHh3no2EFtIYBmjxOtV7l2MXEB2L5NE8+2N7BDORkaJvw83M4JU8QpoSeyZ
	0ccKYrMIqEo0NX1jB7HZBNQlPr/ewQ4xSU6iaclqZhBbVCBC4ujqZ6wQvYISPybfYwEZKiJw
	glFi67EWsISwgIHE1HUTwBqYBawlVk7axghhy0tsXvOWGWKossSfy6eAzuYAOltRYvtqqwmM
	grOQjJ2FpHsWku4FjMyrGMVKi5MLipPSUysM9YoTc4tL89L1kvNzNzFCwrZqB+OdrzaHGAU4
	GJV4eHdY9gUJsSaWFVfmHmKU4GBWEuGdWggU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBjUn2EQ
	vDx50v0ZbV1/JR4nnjFNsE3fY7OR/2RsQeNp+SDhxm81p4r1F5rPecAYnvFF53NGwvtlxT3/
	XofFsG5cz5Y67cfu3zquzqdeviirnOP28dyCNRMSl3z5u8PIs6vWRewF7wS/PZHNz+32FogV
	WmzZci5WxnrrmZijy/9Gtv3+KfZG/6gSS3FGoqEWc1FxIgADd90TOQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started seeing the following on my Samsung Series on 3.12.1

Is this bad? Looks like the following WARN_ON is firing:

drivers/usb/host/xhci.c:

         if (WARN_ON(!virt_dev)) {
                 /*
                  * In plug/unplug torture test with an NEC controller,
                  * a zero-dereference was observed once due to virt_dev 
= 0.
                  * Print useful debug rather than crash if it is 
observed again!
                  */
                 xhci_warn(xhci, "Virt dev invalid for slot_id 0x%x!\n",
                         udev->slot_id);
                 return -EINVAL;
         }


[  565.276187] ------------[ cut here ]------------
[  565.276198] WARNING: CPU: 2 PID: 2228 at drivers/usb/host/xhci.c:3748 
xhci_address_device+0x57b/0x630()
[  565.276262] Modules linked in: parport_pc ppdev arc4 iwldvm rfcomm 
bnep mac80211 i915 ext2 joydev x86_pkg_temp_thermal coretemp kvm_intel 
kvm iwlwifi uvcvideo videobuf2_vmalloc cfg80211 videobuf2_memops 
snd_hda_codec_hdmi videobuf2_core videodev drm_kms_helper 
snd_hda_codec_realtek ghash_clmulni_intel aesni_intel drm snd_hda_intel 
aes_x86_64 btusb media ablk_helper snd_hda_codec cryptd bluetooth lrw 
gf128mul glue_helper hid_generic samsung_laptop usbhid tpm_infineon hid 
snd_hwdep snd_pcm psmouse snd_page_alloc snd_timer microcode 
i2c_algo_bit lpc_ich serio_raw lp parport video wmi tpm_tis mac_hid 
r8169 mii
[  565.276267] CPU: 2 PID: 2228 Comm: kworker/u16:39 Not tainted 3.12.1+ #11
[  565.276269] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
[  565.276278] Workqueue: events_unbound async_run_entry_fn
[  565.276285]  0000000000000009 ffff88002fb0fb00 ffffffff816bf0c1 
0000000000000000
[  565.276289]  ffff88002fb0fb38 ffffffff8104d5fd ffff88040cc7e000 
0000000000000000
[  565.276293]  ffff8803f0195800 0000000000000002 0000000000000000 
ffff88002fb0fb48
[  565.276294] Call Trace:
[  565.276307]  [<ffffffff816bf0c1>] dump_stack+0x45/0x56
[  565.276314]  [<ffffffff8104d5fd>] warn_slowpath_common+0x7d/0xa0
[  565.276318]  [<ffffffff8104d6da>] warn_slowpath_null+0x1a/0x20
[  565.276324]  [<ffffffff8150a43b>] xhci_address_device+0x57b/0x630
[  565.276330]  [<ffffffff814d49d4>] hub_port_init+0x1f4/0xa40
[  565.276335]  [<ffffffff814d5336>] usb_reset_and_verify_device+0x116/0x730
[  565.276340]  [<ffffffff814d2ced>] ? hub_port_status+0xdd/0x120
[  565.276345]  [<ffffffff814d7bd0>] usb_port_resume+0x2f0/0x5c0
[  565.276352]  [<ffffffff814eb535>] generic_resume+0x15/0x30
[  565.276358]  [<ffffffff814e26e7>] usb_resume_both+0x107/0x150
[  565.276366]  [<ffffffff814d1e30>] ? usb_for_each_dev+0x30/0x30
[  565.276372]  [<ffffffff814e325f>] usb_resume+0x1f/0xd0
[  565.276377]  [<ffffffff814d1e30>] ? usb_for_each_dev+0x30/0x30
[  565.276383]  [<ffffffff814d1e43>] usb_dev_restore+0x13/0x20
[  565.276392]  [<ffffffff8143c179>] dpm_run_callback+0x49/0xa0
[  565.276398]  [<ffffffff8143c2d6>] device_resume+0xc6/0x1f0
[  565.276404]  [<ffffffff8143c41d>] async_resume+0x1d/0x50
[  565.276409]  [<ffffffff810766c7>] async_run_entry_fn+0x37/0x130
[  565.276418]  [<ffffffff81068357>] process_one_work+0x177/0x410
[  565.276424]  [<ffffffff81068f91>] worker_thread+0x121/0x3a0
[  565.276431]  [<ffffffff81068e70>] ? manage_workers.isra.25+0x2b0/0x2b0
[  565.276436]  [<ffffffff8106f730>] kthread+0xc0/0xd0
[  565.276442]  [<ffffffff8106f670>] ? kthread_create_on_node+0x120/0x120
[  565.276448]  [<ffffffff816ced2c>] ret_from_fork+0x7c/0xb0
[  565.276453]  [<ffffffff8106f670>] ? kthread_create_on_node+0x120/0x120
[  565.276456] ---[ end trace 115d14352276d432 ]---
[  565.276460] xhci_hcd 0000:03:00.0: Virt dev invalid for slot_id 0x1!
[  565.478224] ------------[ cut here ]------------



-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
