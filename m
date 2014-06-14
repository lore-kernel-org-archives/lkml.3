Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaFNTb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:31:56 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:52433 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaFNTby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:31:54 -0400
MIME-Version: 1.0
Date: Sat, 14 Jun 2014 12:31:53 -0700
Message-ID: <CAKx2Y1mFC7fry+hCfGkEpyvvUU2u+a63YbReo6H-=yXYaRA8tw@mail.gmail.com>
Subject: drm modeset lock traces on boot
From: Kui Zhang <kuizhang@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robdclark@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am getting these on boot. The computer seems to function normally.

Some time I can trigger some of the traces with: udevadm trigger


[    0.248160] ------------[ cut here ]------------
[    0.248300] WARNING: CPU: 1 PID: 6 at kernel/time/tick-sched.c:191
can_stop_full_tick+0xb4/0xbf()
[    0.248526] NO_HZ FULL will not work with unstable sched clock
[    0.248582] Modules linked in:
[    0.248891] CPU: 1 PID: 6 Comm: kworker/u4:0 Not tainted 3.15.0+ #39
[    0.249029] Hardware name: Sony Corporation VGN-XXXXXX
[    0.249261]  ffff8800c156bfd8 ffffffff8146b43b ffff8800c6303f20
ffffffff81061b38
[    0.249658]  ffffffff810a4d50 0000000000000000 ffff8800c6303f70
ffffffff818472d0
[    0.250068]  0000000000000040 ffffffff81061b94 ffffffff8175149a
ffffffff00000018
[    0.250467] Call Trace:
[    0.250600]  <IRQ>  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    0.250844]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    0.250985]  [<ffffffff810a4d50>] ? can_stop_full_tick+0xb4/0xbf
[    0.251119]  [<ffffffff81061b94>] ? warn_slowpath_fmt+0x47/0x49
[    0.251257]  [<ffffffff810859c8>] ? sched_clock_cpu+0x8c/0x9b
[    0.251391]  [<ffffffff810a4d50>] ? can_stop_full_tick+0xb4/0xbf
[    0.251528]  [<ffffffff810a55ef>] ? tick_nohz_irq_exit+0x58/0x71
[    0.251663]  [<ffffffff810652af>] ? irq_exit+0xb3/0xb9
[    0.251797]  [<ffffffff814706ba>] ? reschedule_interrupt+0x6a/0x70
[    0.251932]  <EOI>  [<ffffffff810804a3>] ? finish_task_switch+0x5d/0x10c
[    0.252158]  [<ffffffff8146cab9>] ? __schedule+0x452/0x5e6
[    0.252293]  [<ffffffff81074f14>] ? worker_thread+0x2ce/0x33f
[    0.252430]  [<ffffffff81074c46>] ? cancel_delayed_work_sync+0xa/0xa
[    0.252565]  [<ffffffff8107908b>] ? kthread+0x9e/0xa6
[    0.252697]  [<ffffffff81080000>] ? register_sched_domain_sysctl+0x31f/0x4ae
[    0.252834]  [<ffffffff81080000>] ? register_sched_domain_sysctl+0x31f/0x4ae
[    0.252969]  [<ffffffff81078fed>] ? __kthread_parkme+0x55/0x55
[    0.253104]  [<ffffffff8146f1ac>] ? ret_from_fork+0x7c/0xb0
[    0.253238]  [<ffffffff81078fed>] ? __kthread_parkme+0x55/0x55
[    0.253374] ---[ end trace 4d814acb31cba204 ]---



[    7.250339] ------------[ cut here ]------------
[    7.250350] WARNING: CPU: 0 PID: 1141 at
drivers/gpu/drm/drm_modeset_lock.c:108 modeset_lock+0x2a/0xd0()
[    7.250353] Modules linked in: snd_seq snd_seq_device snd_timer
i915(+) cfg80211 snd drm_kms_helper tpm_infineon tpm soundcore fuse
firewire_ohci sr_mod cdrom firewire_core crc_itu_t uhci_hcd sky2
thermal
[    7.250375] CPU: 0 PID: 1141 Comm: systemd-udevd Tainted: G
W     3.15.0+ #39
[    7.250377] Hardware name: Sony Corporation VGN-XXXXXX
[    7.250380]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    7.250384]  ffffffff8130fd07 ffff8800c0d5f8e0 ffff8800c0da9a28
0000000000000000
[    7.250388]  0000000000000000 ffffffff8130fd07 0000000000000001
ffff8800c0d5f910
[    7.250393] Call Trace:
[    7.250400]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    7.250407]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    7.250411]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    7.250414]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    7.250475]  [<ffffffffa0182842>] ?
intel_get_load_detect_pipe+0x89/0x3ea [i915]
[    7.250481]  [<ffffffff8130b1c6>] ? drm_do_probe_ddc_edid+0xc3/0x11a
[    7.250530]  [<ffffffffa01a5151>] ? intel_tv_detect+0x100/0x439 [i915]
[    7.250534]  [<ffffffff8130b22f>] ? drm_probe_ddc+0x12/0x19
[    7.250538]  [<ffffffff8146c3e3>] ? schedule_timeout+0xc3/0xdc
[    7.250546]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    7.250552]  [<ffffffffa00a7798>] ?
drm_fb_helper_probe_connector_modes+0x3d/0x4c [drm_kms_helper]
[    7.250557]  [<ffffffffa00a906e>] ?
drm_fb_helper_initial_config+0x15c/0x407 [drm_kms_helper]
[    7.250598]  [<ffffffffa016e96a>] ? gen4_write32+0x3a/0x53 [i915]
[    7.250646]  [<ffffffffa01a7f57>] ? i915_driver_load+0xb42/0xd4d [i915]
[    7.250652]  [<ffffffff8108a4d0>] ? pick_next_task_fair+0x14e/0x332
[    7.250658]  [<ffffffff810303a0>] ? __switch_to+0x22d/0x466
[    7.250663]  [<ffffffff8107dd1a>] ? tick_nohz_full_enabled+0x5/0x15
[    7.250667]  [<ffffffff81080516>] ? finish_task_switch+0xd0/0x10c
[    7.250673]  [<ffffffff810a5265>] ? tick_nohz_full_cpu+0x8/0x2b
[    7.250678]  [<ffffffff8146cab9>] ? __schedule+0x452/0x5e6
[    7.250682]  [<ffffffff813140a4>] ? get_device+0xe/0x16
[    7.250688]  [<ffffffff81465547>] ? klist_add_tail+0x1b/0x3c
[    7.250692]  [<ffffffff8131544e>] ? device_add+0x4bf/0x4d0
[    7.250697]  [<ffffffff8111391c>] ? kmem_cache_alloc_trace+0x102/0x110
[    7.250703]  [<ffffffff812669a3>] ? idr_replace+0x2d/0x93
[    7.250709]  [<ffffffff81300dd9>] ? drm_dev_register+0x72/0xe3
[    7.250714]  [<ffffffff8130303c>] ? drm_get_pci_dev+0xf4/0x1b0
[    7.250720]  [<ffffffff8131d1a9>] ? __pm_runtime_resume+0x5d/0x69
[    7.250726]  [<ffffffff81288c9c>] ? pci_device_probe+0x6c/0xcb
[    7.250731]  [<ffffffff81317475>] ? driver_probe_device+0x9b/0x1cf
[    7.250735]  [<ffffffff8131762d>] ? __driver_attach+0x53/0x73
[    7.250739]  [<ffffffff813175da>] ? __device_attach+0x31/0x31
[    7.250744]  [<ffffffff81315d95>] ? bus_for_each_dev+0x6e/0x78
[    7.250748]  [<ffffffff81316d7c>] ? bus_add_driver+0x100/0x1c9
[    7.250752]  [<ffffffff81317997>] ? driver_register+0x83/0xbb
[    7.250756]  [<ffffffffa01e9000>] ? 0xffffffffa01e8fff
[    7.250761]  [<ffffffff810002da>] ? do_one_initcall+0xe3/0x162
[    7.250765]  [<ffffffff810acb61>] ? load_module+0x1a82/0x1c2b
[    7.250770]  [<ffffffff810a9ec2>] ? module_flags+0x6f/0x6f
[    7.250774]  [<ffffffff810acded>] ? SyS_finit_module+0x4a/0x5e
[    7.250779]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    7.250782] ---[ end trace 4d814acb31cba206 ]---




[    7.250785] ------------[ cut here ]------------
[    7.250789] WARNING: CPU: 0 PID: 1141 at
drivers/gpu/drm/drm_modeset_lock.c:108 modeset_lock+0x2a/0xd0()
[    7.250791] Modules linked in: snd_seq snd_seq_device snd_timer
i915(+) cfg80211 snd drm_kms_helper tpm_infineon tpm soundcore fuse
firewire_ohci sr_mod cdrom firewire_core crc_itu_t uhci_hcd sky2
thermal
[    7.250807] CPU: 0 PID: 1141 Comm: systemd-udevd Tainted: G
W     3.15.0+ #39
[    7.250810] Hardware name: Sony Corporation VGN-XXXXXX
[    7.250811]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    7.250816]  ffffffff8130fd07 ffff8800c0d5f8e0 ffff8800c16b7018
0000000000000000
[    7.250820]  0000000000000000 ffffffff8130fd07 ffff8800c16b7000
ffff8800c0d5f910
[    7.250824] Call Trace:
[    7.250828]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    7.250833]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    7.250836]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    7.250840]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    7.250883]  [<ffffffffa0182920>] ?
intel_get_load_detect_pipe+0x167/0x3ea [i915]
[    7.250887]  [<ffffffff8130b1c6>] ? drm_do_probe_ddc_edid+0xc3/0x11a
[    7.250934]  [<ffffffffa01a5151>] ? intel_tv_detect+0x100/0x439 [i915]
[    7.250938]  [<ffffffff8130b22f>] ? drm_probe_ddc+0x12/0x19
[    7.250943]  [<ffffffff8146c3e3>] ? schedule_timeout+0xc3/0xdc
[    7.250949]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    7.250955]  [<ffffffffa00a7798>] ?
drm_fb_helper_probe_connector_modes+0x3d/0x4c [drm_kms_helper]
[    7.250960]  [<ffffffffa00a906e>] ?
drm_fb_helper_initial_config+0x15c/0x407 [drm_kms_helper]
[    7.251001]  [<ffffffffa016e96a>] ? gen4_write32+0x3a/0x53 [i915]
[    7.251048]  [<ffffffffa01a7f57>] ? i915_driver_load+0xb42/0xd4d [i915]
[    7.251053]  [<ffffffff8108a4d0>] ? pick_next_task_fair+0x14e/0x332
[    7.251057]  [<ffffffff810303a0>] ? __switch_to+0x22d/0x466
[    7.251061]  [<ffffffff8107dd1a>] ? tick_nohz_full_enabled+0x5/0x15
[    7.251065]  [<ffffffff81080516>] ? finish_task_switch+0xd0/0x10c
[    7.251069]  [<ffffffff810a5265>] ? tick_nohz_full_cpu+0x8/0x2b
[    7.251073]  [<ffffffff8146cab9>] ? __schedule+0x452/0x5e6
[    7.251077]  [<ffffffff813140a4>] ? get_device+0xe/0x16
[    7.251081]  [<ffffffff81465547>] ? klist_add_tail+0x1b/0x3c
[    7.251085]  [<ffffffff8131544e>] ? device_add+0x4bf/0x4d0
[    7.251089]  [<ffffffff8111391c>] ? kmem_cache_alloc_trace+0x102/0x110
[    7.251093]  [<ffffffff812669a3>] ? idr_replace+0x2d/0x93
[    7.251097]  [<ffffffff81300dd9>] ? drm_dev_register+0x72/0xe3
[    7.251102]  [<ffffffff8130303c>] ? drm_get_pci_dev+0xf4/0x1b0
[    7.251106]  [<ffffffff8131d1a9>] ? __pm_runtime_resume+0x5d/0x69
[    7.251110]  [<ffffffff81288c9c>] ? pci_device_probe+0x6c/0xcb
[    7.251115]  [<ffffffff81317475>] ? driver_probe_device+0x9b/0x1cf
[    7.251119]  [<ffffffff8131762d>] ? __driver_attach+0x53/0x73
[    7.251123]  [<ffffffff813175da>] ? __device_attach+0x31/0x31
[    7.251127]  [<ffffffff81315d95>] ? bus_for_each_dev+0x6e/0x78
[    7.251131]  [<ffffffff81316d7c>] ? bus_add_driver+0x100/0x1c9
[    7.251135]  [<ffffffff81317997>] ? driver_register+0x83/0xbb
[    7.251138]  [<ffffffffa01e9000>] ? 0xffffffffa01e8fff
[    7.251142]  [<ffffffff810002da>] ? do_one_initcall+0xe3/0x162
[    7.251146]  [<ffffffff810acb61>] ? load_module+0x1a82/0x1c2b
[    7.251150]  [<ffffffff810a9ec2>] ? module_flags+0x6f/0x6f
[    7.251154]  [<ffffffff810acded>] ? SyS_finit_module+0x4a/0x5e
[    7.251159]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    7.251161] ---[ end trace 4d814acb31cba207 ]---
[    7.376245] ------------[ cut here ]------------




[    7.376259] WARNING: CPU: 1 PID: 1141 at
drivers/gpu/drm/drm_modeset_lock.c:90
drm_modeset_drop_locks+0x1d/0x38()
[    7.376262] Modules linked in: snd_hwdep hwmon tifm_7xx1 tifm_core
snd_pcm snd_seq snd_seq_device snd_timer i915(+) cfg80211 snd
drm_kms_helper tpm_infineon tpm soundcore fuse firewire_ohci sr_mod
cdrom firewire_core crc_itu_t uhci_hcd sky2 thermal
[    7.376292] CPU: 1 PID: 1141 Comm: systemd-udevd Tainted: G
W     3.15.0+ #39
[    7.376295] Hardware name: Sony Corporation VGN-XXXXXX
[    7.376298]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    7.376302]  ffffffff8130fc8d ffff8800c0d5f8e0 ffff8800c0d5f8d0
ffff8800c0dae000
[    7.376306]  ffff8800c16b7000 ffffffff8130fc8d ffff8800c03e6c00
ffff8800c0d5f8d0
[    7.376310] Call Trace:
[    7.376318]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    7.376324]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    7.376328]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    7.376332]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    7.376394]  [<ffffffffa0182c61>] ?
intel_release_load_detect_pipe+0xbe/0xce [i915]
[    7.376444]  [<ffffffffa01a53f3>] ? intel_tv_detect+0x3a2/0x439 [i915]
[    7.376449]  [<ffffffff8146c3e3>] ? schedule_timeout+0xc3/0xdc
[    7.376457]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    7.376463]  [<ffffffffa00a7798>] ?
drm_fb_helper_probe_connector_modes+0x3d/0x4c [drm_kms_helper]
[    7.376468]  [<ffffffffa00a906e>] ?
drm_fb_helper_initial_config+0x15c/0x407 [drm_kms_helper]
[    7.376509]  [<ffffffffa016e96a>] ? gen4_write32+0x3a/0x53 [i915]
[    7.376557]  [<ffffffffa01a7f57>] ? i915_driver_load+0xb42/0xd4d [i915]
[    7.376563]  [<ffffffff8108a4d0>] ? pick_next_task_fair+0x14e/0x332
[    7.376569]  [<ffffffff810303a0>] ? __switch_to+0x22d/0x466
[    7.376574]  [<ffffffff8107dd1a>] ? tick_nohz_full_enabled+0x5/0x15
[    7.376579]  [<ffffffff81080516>] ? finish_task_switch+0xd0/0x10c
[    7.376584]  [<ffffffff810a5265>] ? tick_nohz_full_cpu+0x8/0x2b
[    7.376588]  [<ffffffff8146cab9>] ? __schedule+0x452/0x5e6
[    7.376593]  [<ffffffff813140a4>] ? get_device+0xe/0x16
[    7.376598]  [<ffffffff81465547>] ? klist_add_tail+0x1b/0x3c
[    7.376602]  [<ffffffff8131544e>] ? device_add+0x4bf/0x4d0
[    7.376608]  [<ffffffff8111391c>] ? kmem_cache_alloc_trace+0x102/0x110
[    7.376613]  [<ffffffff812669a3>] ? idr_replace+0x2d/0x93
[    7.376619]  [<ffffffff81300dd9>] ? drm_dev_register+0x72/0xe3
[    7.376623]  [<ffffffff8130303c>] ? drm_get_pci_dev+0xf4/0x1b0
[    7.376629]  [<ffffffff8131d1a9>] ? __pm_runtime_resume+0x5d/0x69
[    7.376634]  [<ffffffff81288c9c>] ? pci_device_probe+0x6c/0xcb
[    7.376639]  [<ffffffff81317475>] ? driver_probe_device+0x9b/0x1cf
[    7.376643]  [<ffffffff8131762d>] ? __driver_attach+0x53/0x73
[    7.376647]  [<ffffffff813175da>] ? __device_attach+0x31/0x31
[    7.376651]  [<ffffffff81315d95>] ? bus_for_each_dev+0x6e/0x78
[    7.376655]  [<ffffffff81316d7c>] ? bus_add_driver+0x100/0x1c9
[    7.376660]  [<ffffffff81317997>] ? driver_register+0x83/0xbb
[    7.376664]  [<ffffffffa01e9000>] ? 0xffffffffa01e8fff
[    7.376668]  [<ffffffff810002da>] ? do_one_initcall+0xe3/0x162
[    7.376673]  [<ffffffff810acb61>] ? load_module+0x1a82/0x1c2b
[    7.376677]  [<ffffffff810a9ec2>] ? module_flags+0x6f/0x6f
[    7.376681]  [<ffffffff810acded>] ? SyS_finit_module+0x4a/0x5e
[    7.376686]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    7.376689] ---[ end trace 4d814acb31cba208 ]---




[    8.690379] ------------[ cut here ]------------
[    8.690390] WARNING: CPU: 0 PID: 881 at
drivers/gpu/drm/drm_modeset_lock.c:108 modeset_lock+0x2a/0xd0()
[    8.690392] Modules linked in: snd_hda_codec_idt
snd_hda_codec_generic usb_storage arc4 iwl3945 iwlegacy mac80211
dm_multipath dm_mod snd_hda_intel snd_hda_controller snd_hda_codec
coretemp snd_hwdep hwmon tifm_7xx1 tifm_core snd_pcm snd_seq
snd_seq_device snd_timer i915 cfg80211 snd drm_kms_helper tpm_infineon
tpm soundcore fuse firewire_ohci sr_mod cdrom firewire_core crc_itu_t
uhci_hcd sky2 thermal
[    8.690432] CPU: 0 PID: 881 Comm: plymouthd Tainted: G        W
3.15.0+ #39
[    8.690434] Hardware name: Sony Corporation VGN-XXXXXX
[    8.690437]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    8.690441]  ffffffff8130fd07 ffff8800c03b3be0 ffff8800c0da9a28
0000000000000000
[    8.690445]  0000000000000000 ffffffff8130fd07 0000000000000001
ffff8800c03b3c10
[    8.690449] Call Trace:
[    8.690457]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    8.690463]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    8.690467]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.690471]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.690502]  [<ffffffffa0182842>] ?
intel_get_load_detect_pipe+0x89/0x3ea [i915]
[    8.690507]  [<ffffffff8130b1c6>] ? drm_do_probe_ddc_edid+0xc3/0x11a
[    8.690529]  [<ffffffffa01a5151>] ? intel_tv_detect+0x100/0x439 [i915]
[    8.690533]  [<ffffffff8130b22f>] ? drm_probe_ddc+0x12/0x19
[    8.690541]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    8.690546]  [<ffffffff813077ab>] ? drm_mode_getconnector+0xd5/0x2e0
[    8.690551]  [<ffffffff810e9703>] ? get_page+0x9/0x25
[    8.690555]  [<ffffffff812fcb99>] ? drm_ioctl+0x33a/0x3b6
[    8.690559]  [<ffffffff813076d6>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.690565]  [<ffffffff811040ad>] ? do_mmap_pgoff+0x288/0x2d6
[    8.690570]  [<ffffffff810857e3>] ? sched_clock_local+0xc/0x6a
[    8.690575]  [<ffffffff8112f596>] ? do_vfs_ioctl+0x34f/0x419
[    8.690602]  [<ffffffff8108601c>] ? vtime_account_user+0x34/0x3e
[    8.690606]  [<ffffffff8112f6a6>] ? SyS_ioctl+0x46/0x71
[    8.690612]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    8.690615] ---[ end trace 4d814acb31cba209 ]---



[    8.690618] ------------[ cut here ]------------
[    8.690622] WARNING: CPU: 0 PID: 881 at
drivers/gpu/drm/drm_modeset_lock.c:108 modeset_lock+0x2a/0xd0()
[    8.690623] Modules linked in: snd_hda_codec_idt
snd_hda_codec_generic usb_storage arc4 iwl3945 iwlegacy mac80211
dm_multipath dm_mod snd_hda_intel snd_hda_controller snd_hda_codec
coretemp snd_hwdep hwmon tifm_7xx1 tifm_core snd_pcm snd_seq
snd_seq_device snd_timer i915 cfg80211 snd drm_kms_helper tpm_infineon
tpm soundcore fuse firewire_ohci sr_mod cdrom firewire_core crc_itu_t
uhci_hcd sky2 thermal
[    8.690653] CPU: 0 PID: 881 Comm: plymouthd Tainted: G        W
3.15.0+ #39
[    8.690655] Hardware name: Sony Corporation VGN-XXXXXX
[    8.690657]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    8.690661]  ffffffff8130fd07 ffff8800c03b3be0 ffff8800c16b7018
0000000000000000
[    8.690665]  0000000000000000 ffffffff8130fd07 ffff8800c16b7000
ffff8800c03b3c10
[    8.690669] Call Trace:
[    8.690674]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    8.690678]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    8.690682]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.690685]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.690706]  [<ffffffffa0182920>] ?
intel_get_load_detect_pipe+0x167/0x3ea [i915]
[    8.690710]  [<ffffffff8130b1c6>] ? drm_do_probe_ddc_edid+0xc3/0x11a
[    8.690731]  [<ffffffffa01a5151>] ? intel_tv_detect+0x100/0x439 [i915]
[    8.690735]  [<ffffffff8130b22f>] ? drm_probe_ddc+0x12/0x19
[    8.690742]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    8.690747]  [<ffffffff813077ab>] ? drm_mode_getconnector+0xd5/0x2e0
[    8.690750]  [<ffffffff810e9703>] ? get_page+0x9/0x25
[    8.690754]  [<ffffffff812fcb99>] ? drm_ioctl+0x33a/0x3b6
[    8.690758]  [<ffffffff813076d6>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.690763]  [<ffffffff811040ad>] ? do_mmap_pgoff+0x288/0x2d6
[    8.690766]  [<ffffffff810857e3>] ? sched_clock_local+0xc/0x6a
[    8.690770]  [<ffffffff8112f596>] ? do_vfs_ioctl+0x34f/0x419
[    8.690774]  [<ffffffff8108601c>] ? vtime_account_user+0x34/0x3e
[    8.690778]  [<ffffffff8112f6a6>] ? SyS_ioctl+0x46/0x71
[    8.690781]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    8.690784] ---[ end trace 4d814acb31cba20a ]---




[    8.816060] ------------[ cut here ]------------
[    8.816071] WARNING: CPU: 0 PID: 881 at
drivers/gpu/drm/drm_modeset_lock.c:90
drm_modeset_drop_locks+0x1d/0x38()
[    8.816074] Modules linked in: snd_hda_codec_idt
snd_hda_codec_generic usb_storage arc4 iwl3945 iwlegacy mac80211
dm_multipath dm_mod snd_hda_intel snd_hda_controller snd_hda_codec
coretemp snd_hwdep hwmon tifm_7xx1 tifm_core snd_pcm snd_seq
snd_seq_device snd_timer i915 cfg80211 snd drm_kms_helper tpm_infineon
tpm soundcore fuse firewire_ohci sr_mod cdrom firewire_core crc_itu_t
uhci_hcd sky2 thermal
[    8.816113] CPU: 0 PID: 881 Comm: plymouthd Tainted: G        W
3.15.0+ #39
[    8.816115] Hardware name: Sony Corporation VGN-XXXXXX
[    8.816118]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    8.816123]  ffffffff8130fc8d ffff8800c03b3be0 ffff8800c03b3bd0
ffff8800c0dae000
[    8.816126]  ffff8800c16b7000 ffffffff8130fc8d ffff8800c03e6c00
ffff8800c03b3bd0
[    8.816131] Call Trace:
[    8.816138]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    8.816145]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    8.816149]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    8.816152]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    8.816182]  [<ffffffffa0182c61>] ?
intel_release_load_detect_pipe+0xbe/0xce [i915]
[    8.816203]  [<ffffffffa01a53f3>] ? intel_tv_detect+0x3a2/0x439 [i915]
[    8.816212]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    8.816217]  [<ffffffff813077ab>] ? drm_mode_getconnector+0xd5/0x2e0
[    8.816222]  [<ffffffff810e9703>] ? get_page+0x9/0x25
[    8.816227]  [<ffffffff812fcb99>] ? drm_ioctl+0x33a/0x3b6
[    8.816230]  [<ffffffff813076d6>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.816236]  [<ffffffff811040ad>] ? do_mmap_pgoff+0x288/0x2d6
[    8.816240]  [<ffffffff810857e3>] ? sched_clock_local+0xc/0x6a
[    8.816245]  [<ffffffff8112f596>] ? do_vfs_ioctl+0x34f/0x419
[    8.816249]  [<ffffffff8108601c>] ? vtime_account_user+0x34/0x3e
[    8.816253]  [<ffffffff8112f6a6>] ? SyS_ioctl+0x46/0x71
[    8.816258]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    8.816261] ---[ end trace 4d814acb31cba20b ]---




[    8.816289] ------------[ cut here ]------------
[    8.816294] WARNING: CPU: 0 PID: 881 at
drivers/gpu/drm/drm_modeset_lock.c:108 modeset_lock+0x2a/0xd0()
[    8.816295] Modules linked in: snd_hda_codec_idt
snd_hda_codec_generic usb_storage arc4 iwl3945 iwlegacy mac80211
dm_multipath dm_mod snd_hda_intel snd_hda_controller snd_hda_codec
coretemp snd_hwdep hwmon tifm_7xx1 tifm_core snd_pcm snd_seq
snd_seq_device snd_timer i915 cfg80211 snd drm_kms_helper tpm_infineon
tpm soundcore fuse firewire_ohci sr_mod cdrom firewire_core crc_itu_t
uhci_hcd sky2 thermal
[    8.816324] CPU: 0 PID: 881 Comm: plymouthd Tainted: G        W
3.15.0+ #39
[    8.816327] Hardware name: Sony Corporation VGN-XXXXXX
[    8.816329]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    8.816333]  ffffffff8130fd07 ffff8800c03b3be0 ffff8800c0da9a28
0000000000000000
[    8.816337]  0000000000000000 ffffffff8130fd07 0000000000000001
ffff8800c03b3c10
[    8.816341] Call Trace:
[    8.816346]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    8.816350]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    8.816354]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.816357]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.816378]  [<ffffffffa0182842>] ?
intel_get_load_detect_pipe+0x89/0x3ea [i915]
[    8.816383]  [<ffffffff81061b3d>] ? warn_slowpath_common+0x79/0x89
[    8.816386]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    8.816390]  [<ffffffff8130fca3>] ? drm_modeset_drop_locks+0x33/0x38
[    8.816410]  [<ffffffffa01a5151>] ? intel_tv_detect+0x100/0x439 [i915]
[    8.816416]  [<ffffffff810f46de>] ? __mod_zone_page_state+0x51/0x5c
[    8.816423]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    8.816427]  [<ffffffff813077ab>] ? drm_mode_getconnector+0xd5/0x2e0
[    8.816431]  [<ffffffff810e9703>] ? get_page+0x9/0x25
[    8.816435]  [<ffffffff812fcb99>] ? drm_ioctl+0x33a/0x3b6
[    8.816439]  [<ffffffff813076d6>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.816443]  [<ffffffff811131c3>] ? kmem_cache_free+0xf6/0x12b
[    8.816447]  [<ffffffff81132028>] ? dput+0x12e/0x148
[    8.816451]  [<ffffffff8112f596>] ? do_vfs_ioctl+0x34f/0x419
[    8.816455]  [<ffffffff8112f6a6>] ? SyS_ioctl+0x46/0x71
[    8.816459]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    8.816462] ---[ end trace 4d814acb31cba20c ]---




[    8.816464] ------------[ cut here ]------------
[    8.816467] WARNING: CPU: 0 PID: 881 at
drivers/gpu/drm/drm_modeset_lock.c:108 modeset_lock+0x2a/0xd0()
[    8.816469] Modules linked in: snd_hda_codec_idt
snd_hda_codec_generic usb_storage arc4 iwl3945 iwlegacy mac80211
dm_multipath dm_mod snd_hda_intel snd_hda_controller snd_hda_codec
coretemp snd_hwdep hwmon tifm_7xx1 tifm_core snd_pcm snd_seq
snd_seq_device snd_timer i915 cfg80211 snd drm_kms_helper tpm_infineon
tpm soundcore fuse firewire_ohci sr_mod cdrom firewire_core crc_itu_t
uhci_hcd sky2 thermal
[    8.816498] CPU: 0 PID: 881 Comm: plymouthd Tainted: G        W
3.15.0+ #39
[    8.816500] Hardware name: Sony Corporation VGN-XXXXXX
[    8.816502]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    8.816506]  ffffffff8130fd07 ffff8800c03b3be0 ffff8800c16b7018
0000000000000000
[    8.816510]  0000000000000000 ffffffff8130fd07 ffff8800c16b7000
ffff8800c03b3c10
[    8.816514] Call Trace:
[    8.816519]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    8.816523]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    8.816526]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.816530]  [<ffffffff8130fd07>] ? modeset_lock+0x2a/0xd0
[    8.816551]  [<ffffffffa0182920>] ?
intel_get_load_detect_pipe+0x167/0x3ea [i915]
[    8.816555]  [<ffffffff81061b3d>] ? warn_slowpath_common+0x79/0x89
[    8.816559]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    8.816562]  [<ffffffff8130fca3>] ? drm_modeset_drop_locks+0x33/0x38
[    8.816582]  [<ffffffffa01a5151>] ? intel_tv_detect+0x100/0x439 [i915]
[    8.816587]  [<ffffffff810f46de>] ? __mod_zone_page_state+0x51/0x5c
[    8.816594]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    8.816598]  [<ffffffff813077ab>] ? drm_mode_getconnector+0xd5/0x2e0
[    8.816602]  [<ffffffff810e9703>] ? get_page+0x9/0x25
[    8.816606]  [<ffffffff812fcb99>] ? drm_ioctl+0x33a/0x3b6
[    8.816609]  [<ffffffff813076d6>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.816613]  [<ffffffff811131c3>] ? kmem_cache_free+0xf6/0x12b
[    8.816617]  [<ffffffff81132028>] ? dput+0x12e/0x148
[    8.816621]  [<ffffffff8112f596>] ? do_vfs_ioctl+0x34f/0x419
[    8.816625]  [<ffffffff8112f6a6>] ? SyS_ioctl+0x46/0x71
[    8.816629]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    8.816631] ---[ end trace 4d814acb31cba20d ]---




[    8.926029] ------------[ cut here ]------------
[    8.926039] WARNING: CPU: 0 PID: 881 at
drivers/gpu/drm/drm_modeset_lock.c:90
drm_modeset_drop_locks+0x1d/0x38()
[    8.926041] Modules linked in: snd_hda_codec_idt
snd_hda_codec_generic usb_storage arc4 iwl3945 iwlegacy mac80211
dm_multipath dm_mod snd_hda_intel snd_hda_controller snd_hda_codec
coretemp snd_hwdep hwmon tifm_7xx1 tifm_core snd_pcm snd_seq
snd_seq_device snd_timer i915 cfg80211 snd drm_kms_helper tpm_infineon
tpm soundcore fuse firewire_ohci sr_mod cdrom firewire_core crc_itu_t
uhci_hcd sky2 thermal
[    8.926079] CPU: 0 PID: 881 Comm: plymouthd Tainted: G        W
3.15.0+ #39
[    8.926081] Hardware name: Sony Corporation VGN-XXXXXX
[    8.926084]  0000000000000006 ffffffff8146b43b 0000000000000000
ffffffff81061b38
[    8.926088]  ffffffff8130fc8d ffff8800c03b3be0 ffff8800c03b3bd0
ffff8800c0dae000
[    8.926092]  ffff8800c16b7000 ffffffff8130fc8d ffff8800c03e6c00
ffff8800c03b3bd0
[    8.926096] Call Trace:
[    8.926103]  [<ffffffff8146b43b>] ? dump_stack+0x41/0x51
[    8.926110]  [<ffffffff81061b38>] ? warn_slowpath_common+0x74/0x89
[    8.926113]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    8.926117]  [<ffffffff8130fc8d>] ? drm_modeset_drop_locks+0x1d/0x38
[    8.926144]  [<ffffffffa0182c61>] ?
intel_release_load_detect_pipe+0xbe/0xce [i915]
[    8.926165]  [<ffffffffa01a53f3>] ? intel_tv_detect+0x3a2/0x439 [i915]
[    8.926173]  [<ffffffffa00a6e12>] ?
drm_helper_probe_single_connector_modes_merge_bits+0xb9/0x2c3
[drm_kms_helper]
[    8.926178]  [<ffffffff813077ab>] ? drm_mode_getconnector+0xd5/0x2e0
[    8.926183]  [<ffffffff810e9703>] ? get_page+0x9/0x25
[    8.926188]  [<ffffffff812fcb99>] ? drm_ioctl+0x33a/0x3b6
[    8.926192]  [<ffffffff813076d6>] ? drm_mode_getcrtc+0xb0/0xb0
[    8.926197]  [<ffffffff811131c3>] ? kmem_cache_free+0xf6/0x12b
[    8.926202]  [<ffffffff81132028>] ? dput+0x12e/0x148
[    8.926206]  [<ffffffff8112f596>] ? do_vfs_ioctl+0x34f/0x419
[    8.926209]  [<ffffffff8112f6a6>] ? SyS_ioctl+0x46/0x71
[    8.926214]  [<ffffffff8146f3d1>] ? tracesys+0xd4/0xd9
[    8.926217] ---[ end trace 4d814acb31cba20e ]---


Thanks
Kui.Z
