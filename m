Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbbAKMqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:46:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbbAKMqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:46:51 -0500
Message-ID: <54B270B4.60900@redhat.com>
Date: Sun, 11 Jan 2015 13:46:44 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: WARNING at drivers/gpu/drm/i915/intel_audio.c:291 ilk_audio_codec_disable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I constantly get this warning triggered on bootup. Any ideas? ;)

Thanks a lot,
Daniel

[...]
[    4.634728] [drm] Memory usable by graphics device = 2048M
[    4.636017] checking generic (90000000 420000) vs hw (90000000 10000000)
[    4.636020] fb: switching to inteldrmfb from EFI VGA
[    4.637030] Console: switching to colour dummy device 80x25
[    4.637393] usb 4-1.8.1.1: new full-speed USB device number 6 using ehci-pci
[    4.638716] [drm] Replacing VGA console driver
[    4.687008] apple 0003:05AC:0249.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-1.8.2/input1
[    4.691830] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.691836] [drm] Driver supports precise vblank timestamp query.
[    4.692334] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.714479] usb 4-1.8.1.1: New USB device found, idVendor=05ac, idProduct=820a
[    4.714490] usb 4-1.8.1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.716769] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.1/4-1.8.1.1/4-1.8.1.1:1.0/0003:05AC:820A.0003/input/input5
[    4.742378] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[    4.743551] acpi device:06: registered as cooling_device4
[    4.744023] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    4.768459] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1d.0-1.8.1.1/input0
[    4.768810] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    4.801685] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    4.811196] fbcon: inteldrmfb (fb0) is primary device
[    4.811359] ------------[ cut here ]------------
[    4.811387] WARNING: CPU: 0 PID: 96 at drivers/gpu/drm/i915/intel_audio.c:291 ilk_audio_codec_disable+0x166/0x1a0 [i915]()
[    4.811388] WARN_ON(!port)
[    4.811392] Modules linked in: i915 i2c_algo_bit drm_kms_helper drm i2c_core video
[    4.811394] CPU: 0 PID: 96 Comm: kworker/u16:6 Not tainted 3.19.0-rc2+ #81
[    4.811395] Hardware name: Apple Inc. MacBookAir5,1/Mac-66F35F19FE2A0D05, BIOS MBA51.88Z.00EF.B02.1211271028 11/27/2012
[    4.811400] Workqueue: events_unbound async_run_entry_fn
[    4.811402]  ffffffffa0164018 ffff880261baf608 ffffffff8174e91c ffff880265785a00
[    4.811404]  ffff880261baf658 ffff880261baf648 ffffffff810913ca 0000000000000282
[    4.811407]  ffff88025f500000 0000000000000111 00000000000e50c0 0000000000000000
[    4.811407] Call Trace:
[    4.811412]  [<ffffffff8174e91c>] dump_stack+0x4c/0x65
[    4.811415]  [<ffffffff810913ca>] warn_slowpath_common+0x8a/0xc0
[    4.811417]  [<ffffffff81091446>] warn_slowpath_fmt+0x46/0x50
[    4.811435]  [<ffffffffa00f7606>] ilk_audio_codec_disable+0x166/0x1a0 [i915]
[    4.811451]  [<ffffffffa00f7ece>] intel_audio_codec_disable+0x1e/0x30 [i915]
[    4.811472]  [<ffffffffa012f1b5>] intel_disable_dp+0x65/0x70 [i915]
[    4.811489]  [<ffffffffa010a7ea>] ironlake_crtc_disable+0x16a/0x7c0 [i915]
[    4.811504]  [<ffffffffa010be19>] __intel_set_mode+0xa69/0xc80 [i915]
[    4.811520]  [<ffffffffa0112752>] intel_crtc_set_config+0x9f2/0xf80 [i915]
[    4.811530]  [<ffffffffa00327a2>] drm_mode_set_config_internal+0x72/0x120 [drm]
[    4.811535]  [<ffffffffa0092478>] restore_fbdev_mode+0xc8/0xf0 [drm_kms_helper]
[    4.811539]  [<ffffffffa0094359>] drm_fb_helper_restore_fbdev_mode_unlocked+0x29/0x80 [drm_kms_helper]
[    4.811542]  [<ffffffffa00943d2>] drm_fb_helper_set_par+0x22/0x50 [drm_kms_helper]
[    4.811560]  [<ffffffffa011fe7a>] intel_fbdev_set_par+0x1a/0x60 [i915]
[    4.811563]  [<ffffffff813e5d14>] fbcon_init+0x4f4/0x580
[    4.811565]  [<ffffffff81460fcc>] visual_init+0xbc/0x120
[    4.811567]  [<ffffffff81463693>] do_bind_con_driver+0x163/0x330
[    4.811569]  [<ffffffff81463e14>] do_take_over_console+0x114/0x1c0
[    4.811571]  [<ffffffff813e13f3>] do_fbcon_takeover+0x63/0xd0
[    4.811573]  [<ffffffff813e67bd>] fbcon_event_notify+0x68d/0x7e0
[    4.811575]  [<ffffffff810b137c>] notifier_call_chain+0x4c/0x70
[    4.811578]  [<ffffffff810b1653>] __blocking_notifier_call_chain+0x53/0x70
[    4.811580]  [<ffffffff810b1686>] blocking_notifier_call_chain+0x16/0x20
[    4.811582]  [<ffffffff813ecc5b>] fb_notifier_call_chain+0x1b/0x20
[    4.811584]  [<ffffffff813eef3c>] register_framebuffer+0x1ec/0x330
[    4.811588]  [<ffffffffa009465c>] drm_fb_helper_initial_config+0x25c/0x3b0 [drm_kms_helper]
[    4.811604]  [<ffffffffa01211ab>] intel_fbdev_initial_config+0x1b/0x20 [i915]
[    4.811616]  [<ffffffff810b305a>] async_run_entry_fn+0x4a/0x140
[    4.811618]  [<ffffffff810aaa72>] process_one_work+0x1c2/0x4f0
[    4.811620]  [<ffffffff810aa9fb>] ? process_one_work+0x14b/0x4f0
[    4.811622]  [<ffffffff810aaebb>] worker_thread+0x11b/0x4a0
[    4.811624]  [<ffffffff810aada0>] ? process_one_work+0x4f0/0x4f0
[    4.811626]  [<ffffffff810b01ef>] kthread+0xef/0x110
[    4.811628]  [<ffffffff810b0100>] ? kthread_create_on_node+0x210/0x210
[    4.811632]  [<ffffffff81757dbc>] ret_from_fork+0x7c/0xb0
[    4.811634]  [<ffffffff810b0100>] ? kthread_create_on_node+0x210/0x210
[    4.811635] ---[ end trace 14b371fe6863e3e5 ]---
[    4.831049] usb 4-1.8.1.2: new full-speed USB device number 7 using ehci-pci
[    4.911944] usb 4-1.8.1.2: New USB device found, idVendor=05ac, idProduct=820b
[    4.911948] usb 4-1.8.1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[...]
