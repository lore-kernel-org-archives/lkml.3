Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbaEKRlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 13:41:00 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:45878 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaEKRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 13:40:58 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
References: <1399796911.2442.7.camel@localhost.localdomain>
	<CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
Date: Sun, 11 May 2014 19:40:57 +0200
Message-ID: <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
Subject: Re: 3.15-rc5: Regression in i915 driver?
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
> On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
>> Hi,
>>
>> 3.14.3 works as expected.
>> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
>> seems to be disfunctional.
>>
>> I see this WARNING in the kernel log before suspend to ram in the early
>> boot process:

Doesn't ring a bell really.
- Is there anything in dmesg after resume?
- How exactly does X misbehave? Is fbcon still working? Does X
behaviour get restored if you restart X?
- Can you please try to bisect this issue? Note that the backlight
issue might be unrelated to the issues with X misbehaving after
resume. You might need to do a bisect for both if the symptoms don't
agree.

Thanks, Daniel

>>
>> - Fresh boot 3.15-rc5:
>> Mai 10 15:24:43 localhost.localdomain kernel: [drm] Initialized drm 1.1.0 20060810
>> Mai 10 15:24:43 localhost.localdomain kernel: [drm] Memory usable by graphics device = 2048M
>> Mai 10 15:24:43 localhost.localdomain kernel: ACPI: Battery Slot [BAT1] (battery absent)
>> Mai 10 15:24:43 localhost.localdomain kernel: i915 0000:00:02.0: irq 42 for MSI/MSI-X
>> Mai 10 15:24:43 localhost.localdomain kernel: [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
>> Mai 10 15:24:43 localhost.localdomain kernel: [drm] Driver supports precise vblank timestamp query.
>> Mai 10 15:24:43 localhost.localdomain kernel: vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
>> Mai 10 15:24:43 localhost.localdomain kernel: fbcon: inteldrmfb (fb0) is primary device
>> Mai 10 15:24:43 localhost.localdomain kernel: ------------[ cut here ]------------
>> Mai 10 15:24:43 localhost.localdomain kernel: WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_panel.c:714 i965_enable_backlight+0x12a/0x150()
>> Mai 10 15:24:43 localhost.localdomain kernel: backlight already enabled
>> Mai 10 15:24:43 localhost.localdomain kernel: Modules linked in:
>> Mai 10 15:24:43 localhost.localdomain kernel: CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5 #132
>> Mai 10 15:24:43 localhost.localdomain kernel: Hardware name: Acer Aspire 1810T/JM11-MS, BIOS v1.3310 03/25/2010
>> Mai 10 15:24:43 localhost.localdomain kernel:  ffff8802368bd470 00000000a776f508 ffff8802368bd428 ffffffff81585472
>> Mai 10 15:24:43 localhost.localdomain kernel:  ffff8802368bd460 ffffffff8103d1fc ffff8800b4898000 0000000000000000
>> Mai 10 15:24:43 localhost.localdomain kernel:  ffff880234979c00 00000000c0000000 ffff880235154200 ffff8802368bd4c8
>> Mai 10 15:24:43 localhost.localdomain kernel: Call Trace:
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81585472>] dump_stack+0x19/0x1b
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8103d1fc>] warn_slowpath_common+0x6c/0x90
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8103d277>] warn_slowpath_fmt+0x57/0x80
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813af59a>] i965_enable_backlight+0x12a/0x150
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81375200>] ? gen4_write64+0x60/0x60
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813b0543>] intel_panel_enable_backlight+0x73/0xd0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813ae2b3>] intel_enable_lvds+0x163/0x180
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81375200>] ? gen4_write64+0x60/0x60
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81387fb1>] i9xx_crtc_enable+0x2e1/0x410
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8138ab8f>] __intel_set_mode+0x80f/0x1630
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8138dff1>] intel_set_mode+0x11/0x30
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8138ee8d>] intel_crtc_set_config+0x8dd/0xdb0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8132fbf1>] drm_mode_set_config_internal+0x61/0xf0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8131eb4b>] drm_fb_helper_restore_fbdev_mode+0xab/0xd0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813206fc>] drm_fb_helper_set_par+0x2c/0x80
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81295094>] fbcon_init+0x504/0x580
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff812fe0f3>] visual_init+0xb3/0x110
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81300583>] do_bind_con_driver+0x153/0x320
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81300d24>] do_take_over_console+0x114/0x1c0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8129082b>] do_fbcon_takeover+0x5b/0xc0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81295b2d>] fbcon_event_notify+0x68d/0x7e0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8105d96c>] notifier_call_chain+0x4c/0x70
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8105dcb8>] __blocking_notifier_call_chain+0x48/0x70
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8105dcf1>] blocking_notifier_call_chain+0x11/0x20
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8129bda6>] fb_notifier_call_chain+0x16/0x20
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8129ddb6>] register_framebuffer+0x1f6/0x340
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81320a7e>] drm_fb_helper_initial_config+0x32e/0x500
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81320cb4>] ? drm_fb_helper_single_add_all_connectors+0x64/0xd0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81399b4a>] intel_fbdev_initial_config+0x1a/0x20
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813ba0fc>] i915_driver_load+0xe7c/0xf00
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c1ed9>] ? dev_uevent+0x59/0x220
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff814fca58>] ? netlink_has_listeners+0x58/0x70
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81248542>] ? kobject_uevent_env+0x102/0x540
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813bff52>] ? get_device+0x12/0x30
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c50b0>] ? klist_class_dev_get+0x10/0x20
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8157dd08>] ? klist_node_init+0x38/0x50
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8157dd98>] ? klist_add_tail+0x18/0x60
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c166d>] ? device_add+0x1ad/0x5d0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8132da8d>] ? drm_sysfs_device_add+0xcd/0x110
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8132a0a5>] drm_dev_register+0xa5/0x100
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8132caf4>] drm_get_pci_dev+0x84/0x210
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8133f886>] i915_pci_probe+0x36/0x50
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8127389c>] pci_device_probe+0x7c/0xe0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c4536>] driver_probe_device+0x76/0x250
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c47db>] __driver_attach+0x8b/0x90
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c4750>] ? __device_attach+0x40/0x40
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c2713>] bus_for_each_dev+0x73/0xc0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c4079>] driver_attach+0x19/0x20
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c3cc0>] bus_add_driver+0x170/0x210
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81836d89>] ? drm_core_init+0x109/0x109
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff813c4e0f>] driver_register+0x5f/0xf0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81836d89>] ? drm_core_init+0x109/0x109
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81271f9a>] __pci_register_driver+0x3a/0x40
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8132cd85>] drm_pci_init+0x105/0x130
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81836d89>] ? drm_core_init+0x109/0x109
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81836df3>] i915_init+0x6a/0x6c
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8100032a>] do_one_initcall+0x10a/0x160
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff81057f08>] ? parse_args+0x1e8/0x320
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8180bff0>] kernel_init_freeable+0x154/0x1f8
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8180b83b>] ? do_early_param+0x88/0x88
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8157e5f0>] ? rest_init+0x80/0x80
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8157e5f9>] kernel_init+0x9/0xe0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8158b9fa>] ret_from_fork+0x7a/0xb0
>> Mai 10 15:24:43 localhost.localdomain kernel:  [<ffffffff8157e5f0>] ? rest_init+0x80/0x80
>> Mai 10 15:24:43 localhost.localdomain kernel: ---[ end trace e0096217047999a3 ]---
>> Mai 10 15:24:43 localhost.localdomain kernel: Console: switching to colour frame buffer device 170x48
>> Mai 10 15:24:43 localhost.localdomain kernel: i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>> Mai 10 15:24:43 localhost.localdomain kernel: i915 0000:00:02.0: registered panic notifier
>> Mai 10 15:24:43 localhost.localdomain kernel: ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
>> Mai 10 15:24:43 localhost.localdomain kernel: acpi device:02: registered as cooling_device1
>> Mai 10 15:24:43 localhost.localdomain kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
>> Mai 10 15:24:43 localhost.localdomain kernel: [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>>
>> Suspend+resume, same boot:
>> Mai 10 17:49:34 localhost.localdomain kernel: PM: Syncing filesystems ...
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211: World regulatory domain updated:
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:  DFS Master region: unset
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211: Calling CRDA for country: DE
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211: Regulatory domain changed to country: DE
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:  DFS Master region: unset
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (5150000 KHz - 5350000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (5470000 KHz - 5725000 KHz @ 80000 KHz), (N/A, 2698 mBm), (0 s)
>> Mai 10 17:49:34 localhost.localdomain kernel: cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
>> Mai 10 17:49:34 localhost.localdomain kernel: done.
>> Mai 10 17:51:08 localhost.localdomain kernel: Freezing user space processes ... (elapsed 0.364 seconds) done.
>> Mai 10 17:51:08 localhost.localdomain kernel: Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>> Mai 10 17:51:08 localhost.localdomain kernel: Suspending console(s) (use no_console_suspend to debug)
>> Mai 10 17:51:11 localhost.localdomain kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
>> Mai 10 17:51:11 localhost.localdomain kernel: sd 0:0:0:0: [sda] Stopping disk
>> Mai 10 17:51:14 localhost.localdomain kernel: PM: suspend of devices complete after 501.989 msecs
>> Mai 10 17:51:14 localhost.localdomain kernel: PM: late suspend of devices complete after 13.328 msecs
>> Mai 10 17:51:14 localhost.localdomain kernel: ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: ehci-pci 0000:00:1a.7: System wakeup enabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1a.0: System wakeup enabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: noirq suspend of devices complete after 13.421 msecs
>> Mai 10 17:51:15 localhost.localdomain kernel: ACPI: Preparing to enter system sleep state S3
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: Saving platform NVS memory
>> Mai 10 17:51:15 localhost.localdomain kernel: ACPI: Low-level resume complete
>> Mai 10 17:51:15 localhost.localdomain kernel: ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S0_] (20140214/hwxface-580)
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: Restoring platform NVS memory
>> Mai 10 17:51:15 localhost.localdomain kernel: ACPI: Waking up from system sleep state S3
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1a.0: System wakeup disabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: ehci-pci 0000:00:1a.7: System wakeup disabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: noirq resume of devices complete after 12.627 msecs
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: early resume of devices complete after 0.229 msecs
>> Mai 10 17:51:15 localhost.localdomain kernel: usb usb3: root hub lost power or was reset
>> Mai 10 17:51:15 localhost.localdomain kernel: snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
>> Mai 10 17:51:15 localhost.localdomain kernel: usb usb4: root hub lost power or was reset
>> Mai 10 17:51:15 localhost.localdomain kernel: usb usb5: root hub lost power or was reset
>> Mai 10 17:51:15 localhost.localdomain kernel: usb usb6: root hub lost power or was reset
>> Mai 10 17:51:15 localhost.localdomain kernel: sd 0:0:0:0: [sda] Starting disk
>> Mai 10 17:51:15 localhost.localdomain kernel: [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head d0003368 tail 00000000 start 0012f000
>> Mai 10 17:51:15 localhost.localdomain kernel: ata5: SATA link down (SStatus 0 SControl 300)
>> Mai 10 17:51:15 localhost.localdomain kernel: ata2: SATA link down (SStatus 0 SControl 300)
>> Mai 10 17:51:15 localhost.localdomain kernel: usb 2-5: reset high-speed USB device number 3 using ehci-pci
>> Mai 10 17:51:15 localhost.localdomain kernel: ata6: SATA link down (SStatus 0 SControl 300)
>> Mai 10 17:51:15 localhost.localdomain kernel: usb 6-2: reset full-speed USB device number 2 using uhci_hcd
>> Mai 10 17:51:15 localhost.localdomain kernel: dpm_run_callback(): pci_pm_resume+0x0/0xb0 returns -5
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: Device 0000:00:02.0 failed to resume async: error -5
>> Mai 10 17:51:15 localhost.localdomain kernel: PM: resume of devices complete after 756.269 msecs
>> Mai 10 17:51:15 localhost.localdomain kernel: [drm] vendor descriptor length:22 data:22 5f 01 00 20 05 00 01 03 04 02
>> Mai 10 17:51:15 localhost.localdomain kernel: Raw EDID:
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel:          00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Mai 10 17:51:15 localhost.localdomain kernel: udl 2-2.1:1.0: DVI-I-2: EDID invalid.
>> Mai 10 17:51:15 localhost.localdomain kernel: udl 2-2.1:1.0: fb2: udldrmfb frame buffer device
>> Mai 10 17:51:15 localhost.localdomain kernel: [drm] Initialized udl 0.0.1 20120220 on minor 1
>> Mai 10 17:51:15 localhost.localdomain kernel: atl1c 0000:01:00.0: no hotplug settings from platform
>> Mai 10 17:51:15 localhost.localdomain kernel: iwlwifi 0000:02:00.0: no hotplug settings from platform
>> Mai 10 17:51:15 localhost.localdomain kernel: Restarting tasks ... done.
>> Mai 10 17:51:15 localhost.localdomain kernel: video LNXVIDEO:00: Restoring backlight state
>> Mai 10 17:51:15 localhost.localdomain kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> Mai 10 17:51:15 localhost.localdomain kernel: ata1.00: configured for UDMA/100
>> Mai 10 17:51:15 localhost.localdomain systemd[1]: Service bluetooth.target is not needed anymore. Stopping.
>> Mai 10 17:51:15 localhost.localdomain kernel: atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
>> Mai 10 17:51:15 localhost.localdomain kernel: IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
>> Mai 10 17:51:15 localhost.localdomain kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s29f7u2u3: link is not ready
>> Mai 10 17:51:15 localhost.localdomain kernel: iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
>> Mai 10 17:51:15 localhost.localdomain kernel: iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
>> Mai 10 17:51:15 localhost.localdomain kernel: IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> Mai 10 17:51:37 localhost.localdomain kernel: [drm:intel_enable_lvds] *ERROR* timed out waiting for panel to power on
>> Mai 10 17:51:41 localhost.localdomain kernel: [drm:intel_enable_lvds] *ERROR* timed out waiting for panel to power on
>> Mai 10 17:51:49 localhost.localdomain kernel: [drm:intel_enable_lvds] *ERROR* timed out waiting for panel to power on
>> Mai 10 17:52:58 localhost.localdomain kernel: [drm:intel_enable_lvds] *ERROR* timed out waiting for panel to power on
>>
>> any ideas?
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
