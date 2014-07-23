Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaGWRub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:50:31 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50658 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaGWRu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:50:29 -0400
Date: Wed, 23 Jul 2014 10:50:22 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: general protection fault on 3.15.6
Message-ID: <20140723175021.GA14128@amazon.com>
References: <CAKbGBLjYWrooGZjZS_MaDe9kxacoaL9dHJM1oDe7_a-vQuhsJw@mail.gmail.com>
 <20140721132937.GF12921@htj.dyndns.org>
 <CAKbGBLj4c_bbN-GV-DTJWT7+iKLBauxvvu0uDvtQQOLMmx4N5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKbGBLj4c_bbN-GV-DTJWT7+iKLBauxvvu0uDvtQQOLMmx4N5A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oops, LKML doesn't like rich text, resending. Was trying to avoid
GMail's bad line wrapping. Going to use Mutt instead.)

I'm starting to wonder if it's bad RAM or something. Just got a couple of
worrying warnings on boot from the same system (after it spontaneously
rebooted, with nothing revealing in the previous boot's logs).

Full kernel message log since boot available here: http://pastebin.com/ZzJjK862

Jul 23 09:43:20 orcus kernel: ------------[ cut here ]------------
Jul 23 09:43:20 orcus kernel: WARNING: CPU: 4 PID: 270 at include/linux/kref.h:47 kobject_get+0x46/0x60()
Jul 23 09:43:20 orcus kernel: Modules linked in: snd_hda_intel snd_hda_controller microcode(+) i2c_i801 r8169(+) snd_hda_codec snd_hwdep mii snd_pcm snd_timer thermal(+) fan snd acpi_cpufreq(+) battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
Jul 23 09:43:20 orcus kernel: CPU: 4 PID: 270 Comm: systemd-udevd Tainted: P         C O  3.15.6-1-ec2 #1
Jul 23 09:43:20 orcus kernel: Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
Jul 23 09:43:20 orcus kernel:  0000000000000009 ffff8804067b7858 ffffffff81505dd6 0000000000000000
Jul 23 09:43:20 orcus kernel:  ffff8804067b7890 ffffffff81066a3d ffff880405d80c00 0000000000000202
Jul 23 09:43:20 orcus kernel:  ffffffffffffffff ffff880406076c00 ffff880402b15000 ffff8804067b78a0
Jul 23 09:43:20 orcus kernel: Call Trace:
Jul 23 09:43:20 orcus kernel:  [<ffffffff81505dd6>] dump_stack+0x45/0x56
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066a3d>] warn_slowpath_common+0x7d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066b1a>] warn_slowpath_null+0x1a/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3d26>] kobject_get+0x46/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d0717>] cpufreq_cpu_get+0x77/0xc0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1909>] cpufreq_get_policy+0x19/0x70
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c059b>] acpi_processor_power_exit+0x164/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3116>] ? idr_get_empty_slot+0x1a6/0x3d0
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a2602>] ? get_from_free_list+0x42/0x50
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a369d>] ? ida_get_new_above+0x1ed/0x220
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a2d74>] ? ida_pre_get+0x54/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3755>] ? ida_simple_get+0x85/0x100
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123a818>] ? kernfs_next_descendant_post+0x48/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810b4637>] ? down_timeout+0x37/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c06ed>] acpi_processor_power_exit+0x2b6/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c0739>] acpi_processor_power_exit+0x302/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cc95e>] thermal_zone_bind_cooling_device+0xce/0x370
Jul 23 09:43:20 orcus kernel:  [<ffffffff8130eb63>] ? acpi_os_signal_semaphore+0x21/0x2d
Jul 23 09:43:20 orcus kernel:  [<ffffffff8133665b>] ? acpi_ut_release_mutex+0x5f/0x63
Jul 23 09:43:20 orcus kernel:  [<ffffffff8132e16b>] ? acpi_get_data_full+0x7d/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085addb>] 0xffffffffa085adda
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138d1c6>] ? device_create_file+0x46/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085af22>] 0xffffffffa085af21
Jul 23 09:43:20 orcus kernel:  [<ffffffff813ce949>] thermal_zone_device_register+0x669/0x8b0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085b164>] 0xffffffffa085b163
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123db21>] ? sysfs_do_create_link_sd.isra.2+0x71/0xe0
Jul 23 09:43:20 orcus kernel:  [<ffffffff8131217d>] acpi_device_probe+0x43/0xe9
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391bee>] driver_probe_device+0x8e/0x270
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e9b>] __driver_attach+0x8b/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e10>] ? __device_attach+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138fd2b>] bus_for_each_dev+0x6b/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813917fe>] driver_attach+0x1e/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391328>] bus_add_driver+0x178/0x230
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81392574>] driver_register+0x64/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81312a28>] acpi_bus_register_driver+0x40/0x42
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d067>] init_module+0x67/0x81 [thermal]
Jul 23 09:43:20 orcus kernel:  [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
Jul 23 09:43:20 orcus kernel:  [<ffffffff8108f142>] ? __blocking_notifier_call_chain+0x52/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e3f51>] load_module+0x1a11/0x2300
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1260>] ? store_uevent+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1eb1>] ? copy_module_from_fd.isra.39+0x111/0x170
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e497e>] SyS_finit_module+0x7e/0x80
Jul 23 09:43:20 orcus kernel:  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
Jul 23 09:43:20 orcus kernel: ---[ end trace 71a1e508f45dbd18 ]---
Jul 23 09:43:20 orcus kernel: ------------[ cut here ]------------
Jul 23 09:43:20 orcus kernel: WARNING: CPU: 4 PID: 270 at lib/kobject.c:670 kobject_put+0x58/0x60()
Jul 23 09:43:20 orcus kernel: kobject: '(null)' (ffff880405d80cb0): is not initialized, yet kobject_put() is being called.
Jul 23 09:43:20 orcus kernel: Modules linked in: snd_hda_intel snd_hda_controller microcode(+) i2c_i801 r8169(+) snd_hda_codec snd_hwdep mii snd_pcm snd_timer thermal(+) fan snd acpi_cpufreq(+) battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
Jul 23 09:43:20 orcus kernel: CPU: 4 PID: 270 Comm: systemd-udevd Tainted: P        WC O  3.15.6-1-ec2 #1
Jul 23 09:43:20 orcus kernel: Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
Jul 23 09:43:20 orcus kernel:  0000000000000009 ffff8804067b7818 ffffffff81505dd6 ffff8804067b7860
Jul 23 09:43:20 orcus kernel:  ffff8804067b7850 ffffffff81066a3d ffff880405d80cb0 ffffffffffffffff
Jul 23 09:43:20 orcus kernel:  ffffffffffffffff ffff880406076c00 ffff880402b15000 ffff8804067b78b0
Jul 23 09:43:20 orcus kernel: Call Trace:
Jul 23 09:43:20 orcus kernel:  [<ffffffff81505dd6>] dump_stack+0x45/0x56
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066a3d>] warn_slowpath_common+0x7d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066aac>] warn_slowpath_fmt+0x4c/0x50
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3e18>] kobject_put+0x58/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d0780>] cpufreq_cpu_put+0x20/0x30
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1949>] cpufreq_get_policy+0x59/0x70
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c059b>] acpi_processor_power_exit+0x164/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1cd0>] ? cpufreq_update_policy+0x140/0x140
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c06ed>] acpi_processor_power_exit+0x2b6/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c0739>] acpi_processor_power_exit+0x302/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cc95e>] thermal_zone_bind_cooling_device+0xce/0x370
Jul 23 09:43:20 orcus kernel:  [<ffffffff8130eb63>] ? acpi_os_signal_semaphore+0x21/0x2d
Jul 23 09:43:20 orcus kernel:  [<ffffffff8133665b>] ? acpi_ut_release_mutex+0x5f/0x63
Jul 23 09:43:20 orcus kernel:  [<ffffffff8132e16b>] ? acpi_get_data_full+0x7d/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085addb>] 0xffffffffa085adda
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138d1c6>] ? device_create_file+0x46/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085af22>] 0xffffffffa085af21
Jul 23 09:43:20 orcus kernel:  [<ffffffff813ce949>] thermal_zone_device_register+0x669/0x8b0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085b164>] 0xffffffffa085b163
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123db21>] ? sysfs_do_create_link_sd.isra.2+0x71/0xe0
Jul 23 09:43:20 orcus kernel:  [<ffffffff8131217d>] acpi_device_probe+0x43/0xe9
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391bee>] driver_probe_device+0x8e/0x270
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e9b>] __driver_attach+0x8b/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e10>] ? __device_attach+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138fd2b>] bus_for_each_dev+0x6b/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813917fe>] driver_attach+0x1e/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391328>] bus_add_driver+0x178/0x230
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81392574>] driver_register+0x64/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81312a28>] acpi_bus_register_driver+0x40/0x42
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d067>] init_module+0x67/0x81 [thermal]
Jul 23 09:43:20 orcus kernel:  [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
Jul 23 09:43:20 orcus kernel:  [<ffffffff8108f142>] ? __blocking_notifier_call_chain+0x52/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e3f51>] load_module+0x1a11/0x2300
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1260>] ? store_uevent+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1eb1>] ? copy_module_from_fd.isra.39+0x111/0x170
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e497e>] SyS_finit_module+0x7e/0x80
Jul 23 09:43:20 orcus kernel:  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
Jul 23 09:43:20 orcus kernel: ---[ end trace 71a1e508f45dbd19 ]---
Jul 23 09:43:20 orcus kernel: ------------[ cut here ]------------
Jul 23 09:43:20 orcus kernel: WARNING: CPU: 4 PID: 270 at lib/kobject.c:670 kobject_put+0x58/0x60()
Jul 23 09:43:20 orcus kernel: kobject: '(null)' (ffff880405d80cb0): is not initialized, yet kobject_put() is being called.
Jul 23 09:43:20 orcus kernel: Modules linked in: snd_hda_intel snd_hda_controller microcode(+) i2c_i801 r8169(+) snd_hda_codec snd_hwdep mii snd_pcm snd_timer thermal(+) fan snd acpi_cpufreq(+) battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
Jul 23 09:43:20 orcus kernel: CPU: 4 PID: 270 Comm: systemd-udevd Tainted: P        WC O  3.15.6-1-ec2 #1
Jul 23 09:43:20 orcus kernel: Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
Jul 23 09:43:20 orcus kernel:  0000000000000009 ffff8804067b7808 ffffffff81505dd6 ffff8804067b7850
Jul 23 09:43:20 orcus kernel:  ffff8804067b7840 ffffffff81066a3d ffff880405d80cb0 ffff880408619400
Jul 23 09:43:20 orcus kernel:  0000000000000001 0000000000000007 ffff880402b15318 ffff8804067b78a0
Jul 23 09:43:20 orcus kernel: Call Trace:
Jul 23 09:43:20 orcus kernel:  [<ffffffff81505dd6>] dump_stack+0x45/0x56
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066a3d>] warn_slowpath_common+0x7d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066aac>] warn_slowpath_fmt+0x4c/0x50
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3e18>] kobject_put+0x58/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d0780>] cpufreq_cpu_put+0x20/0x30
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1949>] cpufreq_get_policy+0x59/0x70
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c059b>] acpi_processor_power_exit+0x164/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1cd0>] ? cpufreq_update_policy+0x140/0x140
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c05e2>] acpi_processor_power_exit+0x1ab/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cf3fc>] thermal_zone_trip_update+0xcc/0x260
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cf5a6>] step_wise_throttle+0x16/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cdeec>] handle_thermal_trip+0x4c/0x150
Jul 23 09:43:20 orcus kernel:  [<ffffffff813ce06d>] thermal_zone_device_update+0x7d/0xc0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cea8d>] thermal_zone_device_register+0x7ad/0x8b0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085b164>] 0xffffffffa085b163
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123db21>] ? sysfs_do_create_link_sd.isra.2+0x71/0xe0
Jul 23 09:43:20 orcus kernel:  [<ffffffff8131217d>] acpi_device_probe+0x43/0xe9
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391bee>] driver_probe_device+0x8e/0x270
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e9b>] __driver_attach+0x8b/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e10>] ? __device_attach+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138fd2b>] bus_for_each_dev+0x6b/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813917fe>] driver_attach+0x1e/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391328>] bus_add_driver+0x178/0x230
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81392574>] driver_register+0x64/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81312a28>] acpi_bus_register_driver+0x40/0x42
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d067>] init_module+0x67/0x81 [thermal]
Jul 23 09:43:20 orcus kernel:  [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
Jul 23 09:43:20 orcus kernel:  [<ffffffff8108f142>] ? __blocking_notifier_call_chain+0x52/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e3f51>] load_module+0x1a11/0x2300
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1260>] ? store_uevent+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1eb1>] ? copy_module_from_fd.isra.39+0x111/0x170
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e497e>] SyS_finit_module+0x7e/0x80
Jul 23 09:43:20 orcus kernel:  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
Jul 23 09:43:20 orcus kernel: ---[ end trace 71a1e508f45dbd1a ]---
Jul 23 09:43:20 orcus kernel: ------------[ cut here ]------------
Jul 23 09:43:20 orcus kernel: WARNING: CPU: 4 PID: 270 at lib/kobject.c:670 kobject_put+0x58/0x60()
Jul 23 09:43:20 orcus kernel: kobject: '(null)' (ffff880405d80cb0): is not initialized, yet kobject_put() is being called.
Jul 23 09:43:20 orcus kernel: Modules linked in: snd_hda_intel snd_hda_controller microcode(+) i2c_i801 r8169(+) snd_hda_codec snd_hwdep mii snd_pcm snd_timer thermal(+) fan snd acpi_cpufreq(+) battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
Jul 23 09:43:20 orcus kernel: CPU: 4 PID: 270 Comm: systemd-udevd Tainted: P        WC O  3.15.6-1-ec2 #1
Jul 23 09:43:20 orcus kernel: Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
Jul 23 09:43:20 orcus kernel:  0000000000000009 ffff8804067b7850 ffffffff81505dd6 ffff8804067b7898
Jul 23 09:43:20 orcus kernel:  ffff8804067b7888 ffffffff81066a3d ffff880405d80cb0 ffff880406076c00
Jul 23 09:43:20 orcus kernel:  0000000000000000 ffff880402b15018 0000000000000000 ffff8804067b78e8
Jul 23 09:43:20 orcus kernel: Call Trace:
Jul 23 09:43:20 orcus kernel:  [<ffffffff81505dd6>] dump_stack+0x45/0x56
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066a3d>] warn_slowpath_common+0x7d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066aac>] warn_slowpath_fmt+0x4c/0x50
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d078c>] ? cpufreq_cpu_put+0x2c/0x30
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3e18>] kobject_put+0x58/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d0780>] cpufreq_cpu_put+0x20/0x30
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1949>] cpufreq_get_policy+0x59/0x70
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c059b>] acpi_processor_power_exit+0x164/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1cd0>] ? cpufreq_update_policy+0x140/0x140
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c077f>] acpi_processor_power_exit+0x348/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cc34d>] thermal_cdev_update+0x8d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cf5e9>] step_wise_throttle+0x59/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cdeec>] handle_thermal_trip+0x4c/0x150
Jul 23 09:43:20 orcus kernel:  [<ffffffff813ce06d>] thermal_zone_device_update+0x7d/0xc0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cea8d>] thermal_zone_device_register+0x7ad/0x8b0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085b164>] 0xffffffffa085b163
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123db21>] ? sysfs_do_create_link_sd.isra.2+0x71/0xe0
Jul 23 09:43:20 orcus kernel:  [<ffffffff8131217d>] acpi_device_probe+0x43/0xe9
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391bee>] driver_probe_device+0x8e/0x270
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e9b>] __driver_attach+0x8b/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e10>] ? __device_attach+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138fd2b>] bus_for_each_dev+0x6b/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813917fe>] driver_attach+0x1e/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391328>] bus_add_driver+0x178/0x230
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81392574>] driver_register+0x64/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81312a28>] acpi_bus_register_driver+0x40/0x42
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d067>] init_module+0x67/0x81 [thermal]
Jul 23 09:43:20 orcus kernel:  [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
Jul 23 09:43:20 orcus kernel:  [<ffffffff8108f142>] ? __blocking_notifier_call_chain+0x52/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e3f51>] load_module+0x1a11/0x2300
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1260>] ? store_uevent+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1eb1>] ? copy_module_from_fd.isra.39+0x111/0x170
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e497e>] SyS_finit_module+0x7e/0x80
Jul 23 09:43:20 orcus kernel:  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
Jul 23 09:43:20 orcus kernel: ---[ end trace 71a1e508f45dbd1b ]---
Jul 23 09:43:20 orcus kernel: ------------[ cut here ]------------
Jul 23 09:43:20 orcus kernel: WARNING: CPU: 4 PID: 270 at lib/kobject.c:670 kobject_put+0x58/0x60()
Jul 23 09:43:20 orcus kernel: kobject: '(null)' (ffff880405d80cb0): is not initialized, yet kobject_put() is being called.
Jul 23 09:43:20 orcus kernel: Modules linked in: snd_hda_intel snd_hda_controller microcode(+) i2c_i801 r8169(+) snd_hda_codec snd_hwdep mii snd_pcm snd_timer thermal(+) fan snd acpi_cpufreq(+) battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
Jul 23 09:43:20 orcus kernel: CPU: 4 PID: 270 Comm: systemd-udevd Tainted: P        WC O  3.15.6-1-ec2 #1
Jul 23 09:43:20 orcus kernel: Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
Jul 23 09:43:20 orcus kernel:  0000000000000009 ffff8804067b7838 ffffffff81505dd6 ffff8804067b7880
Jul 23 09:43:20 orcus kernel:  ffff8804067b7870 ffffffff81066a3d ffff880405d80cb0 0000000000000003
Jul 23 09:43:20 orcus kernel:  0000000000000000 ffff880402b15018 0000000000000000 ffff8804067b78d0
Jul 23 09:43:20 orcus kernel: Call Trace:
Jul 23 09:43:20 orcus kernel:  [<ffffffff81505dd6>] dump_stack+0x45/0x56
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066a3d>] warn_slowpath_common+0x7d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066aac>] warn_slowpath_fmt+0x4c/0x50
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3e18>] kobject_put+0x58/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d0780>] cpufreq_cpu_put+0x20/0x30
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1949>] cpufreq_get_policy+0x59/0x70
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c059b>] acpi_processor_power_exit+0x164/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1cd0>] ? cpufreq_update_policy+0x140/0x140
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c06ed>] acpi_processor_power_exit+0x2b6/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c0795>] acpi_processor_power_exit+0x35e/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cc34d>] thermal_cdev_update+0x8d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cf5e9>] step_wise_throttle+0x59/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cdeec>] handle_thermal_trip+0x4c/0x150
Jul 23 09:43:20 orcus kernel:  [<ffffffff813ce06d>] thermal_zone_device_update+0x7d/0xc0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cea8d>] thermal_zone_device_register+0x7ad/0x8b0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085b164>] 0xffffffffa085b163
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123db21>] ? sysfs_do_create_link_sd.isra.2+0x71/0xe0
Jul 23 09:43:20 orcus kernel:  [<ffffffff8131217d>] acpi_device_probe+0x43/0xe9
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391bee>] driver_probe_device+0x8e/0x270
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e9b>] __driver_attach+0x8b/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e10>] ? __device_attach+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138fd2b>] bus_for_each_dev+0x6b/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813917fe>] driver_attach+0x1e/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391328>] bus_add_driver+0x178/0x230
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81392574>] driver_register+0x64/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81312a28>] acpi_bus_register_driver+0x40/0x42
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d067>] init_module+0x67/0x81 [thermal]
Jul 23 09:43:20 orcus kernel:  [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
Jul 23 09:43:20 orcus kernel:  [<ffffffff8108f142>] ? __blocking_notifier_call_chain+0x52/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e3f51>] load_module+0x1a11/0x2300
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1260>] ? store_uevent+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1eb1>] ? copy_module_from_fd.isra.39+0x111/0x170
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e497e>] SyS_finit_module+0x7e/0x80
Jul 23 09:43:20 orcus kernel:  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
Jul 23 09:43:20 orcus kernel: ---[ end trace 71a1e508f45dbd1c ]---
Jul 23 09:43:20 orcus kernel: ------------[ cut here ]------------
Jul 23 09:43:20 orcus kernel: WARNING: CPU: 4 PID: 270 at lib/kobject.c:670 kobject_put+0x58/0x60()
Jul 23 09:43:20 orcus kernel: kobject: '(null)' (ffff880405d80cb0): is not initialized, yet kobject_put() is being called.
Jul 23 09:43:20 orcus kernel: Modules linked in: snd_hda_intel snd_hda_controller microcode(+) i2c_i801 r8169(+) snd_hda_codec snd_hwdep mii snd_pcm snd_timer thermal(+) fan snd acpi_cpufreq(+) battery soundcore lpc_ich mfd_core evdev processor zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O) tun usbip_host(C) usbip_core(C) msr loop kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common hid_generic usbhid hid ahci libahci crc32c_intel ehci_pci libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
Jul 23 09:43:20 orcus kernel: CPU: 4 PID: 270 Comm: systemd-udevd Tainted: P        WC O  3.15.6-1-ec2 #1
Jul 23 09:43:20 orcus kernel: Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
Jul 23 09:43:20 orcus kernel:  0000000000000009 ffff8804067b7820 ffffffff81505dd6 ffff8804067b7868
Jul 23 09:43:20 orcus kernel:  ffff8804067b7858 ffffffff81066a3d ffff880405d80cb0 0000000000000000
Jul 23 09:43:20 orcus kernel:  0000000000000007 ffff880402b15018 0000000000000000 ffff8804067b78b8
Jul 23 09:43:20 orcus kernel: Call Trace:
Jul 23 09:43:20 orcus kernel:  [<ffffffff81505dd6>] dump_stack+0x45/0x56
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066a3d>] warn_slowpath_common+0x7d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff81066aac>] warn_slowpath_fmt+0x4c/0x50
Jul 23 09:43:20 orcus kernel:  [<ffffffff812a3e18>] kobject_put+0x58/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d0780>] cpufreq_cpu_put+0x20/0x30
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1949>] cpufreq_get_policy+0x59/0x70
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c059b>] acpi_processor_power_exit+0x164/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813d1cd0>] ? cpufreq_update_policy+0x140/0x140
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c0645>] acpi_processor_power_exit+0x20e/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffffa07c07d0>] acpi_processor_power_exit+0x399/0x3c6 [processor]
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cc34d>] thermal_cdev_update+0x8d/0xa0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cf5e9>] step_wise_throttle+0x59/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cdeec>] handle_thermal_trip+0x4c/0x150
Jul 23 09:43:20 orcus kernel:  [<ffffffff813ce06d>] thermal_zone_device_update+0x7d/0xc0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813cea8d>] thermal_zone_device_register+0x7ad/0x8b0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085b164>] 0xffffffffa085b163
Jul 23 09:43:20 orcus kernel:  [<ffffffff8123db21>] ? sysfs_do_create_link_sd.isra.2+0x71/0xe0
Jul 23 09:43:20 orcus kernel:  [<ffffffff8131217d>] acpi_device_probe+0x43/0xe9
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391bee>] driver_probe_device+0x8e/0x270
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e9b>] __driver_attach+0x8b/0x90
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391e10>] ? __device_attach+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff8138fd2b>] bus_for_each_dev+0x6b/0xb0
Jul 23 09:43:20 orcus kernel:  [<ffffffff813917fe>] driver_attach+0x1e/0x20
Jul 23 09:43:20 orcus kernel:  [<ffffffff81391328>] bus_add_driver+0x178/0x230
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81392574>] driver_register+0x64/0xf0
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d000>] ? 0xffffffffa085cfff
Jul 23 09:43:20 orcus kernel:  [<ffffffff81312a28>] acpi_bus_register_driver+0x40/0x42
Jul 23 09:43:20 orcus kernel:  [<ffffffffa085d067>] init_module+0x67/0x81 [thermal]
Jul 23 09:43:20 orcus kernel:  [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
Jul 23 09:43:20 orcus kernel:  [<ffffffff8108f142>] ? __blocking_notifier_call_chain+0x52/0x60
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e3f51>] load_module+0x1a11/0x2300
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1260>] ? store_uevent+0x40/0x40
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e1eb1>] ? copy_module_from_fd.isra.39+0x111/0x170
Jul 23 09:43:20 orcus kernel:  [<ffffffff810e497e>] SyS_finit_module+0x7e/0x80
Jul 23 09:43:20 orcus kernel:  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
Jul 23 09:43:20 orcus kernel: ---[ end trace 71a1e508f45dbd1d ]---

On Mon, Jul 21, 2014 at 10:41:45AM -0700, Steven Noonan wrote:
> On Mon, Jul 21, 2014 at 6:29 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Steven.
> >
> > On Sun, Jul 20, 2014 at 09:27:42PM -0700, Steven Noonan wrote:
> >> My router/storage box suddenly stopped responding (originally noticed
> >> because dnsmasq wasn't responding) and I had to reboot it. I checked
> >> the systemd journal when it came back and these were the last thing in
> >> there for the previous boot. Any ideas about pinning down the cause?
> >>
> >> general protection fault: 0000 [#1] SMP
> > ...
> >> CPU: 3 PID: 8881 Comm: systemd Tainted: P        WC O  3.15.6 #1
> >> Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
> >> task: ffff8802f473d880 ti: ffff8802f0abc000 task.ti: ffff8802f0abc000
> >> RIP: 0010:[<ffffffff811ad226>]  [<ffffffff811ad226>]
> >> __kmalloc_track_caller+0x86/0x260
> >
> > So, GFP in kmalloc,
> >
> >> Call Trace:
> >>  [<ffffffff8116fb11>] kstrdup+0x31/0x60
> >
> > called from kstrdup()
> >
> >>  [<ffffffff8123a4f4>] __kernfs_new_node+0x34/0xf0
> >>  [<ffffffff8123b386>] kernfs_new_node+0x26/0x50
> >
> > which was invoked to copy the node name while creating a new kernfs
> > node.
> >
> >>  [<ffffffff8123cc59>] __kernfs_create_file+0x39/0xa0
> >>  [<ffffffff810edb60>] cgroup_addrm_files+0x110/0x250
> >>  [<ffffffff810ee9ab>] cgroup_mkdir+0x21b/0x540
> >>  [<ffffffff8125ca36>] ? security_inode_notifysecctx+0x16/0x20
> >>  [<ffffffff8123b30a>] kernfs_iop_mkdir+0x5a/0x90
> >>  [<ffffffff811d3120>] vfs_mkdir+0xe0/0x180
> >>  [<ffffffff811d7bea>] SyS_mkdirat+0xaa/0xe0
> >>  [<ffffffff811d7c39>] SyS_mkdir+0x19/0x20
> >>  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
> >> Code: 25 88 dd 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 50 01 00 00
> >> 49 83 78 10 00 0f 84 45 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49>
> >> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 bb 49 63
> >> RIP  [<ffffffff811ad226>] __kmalloc_track_caller+0x86/0x260
> >>  RSP <ffff8802f0abfc88>
> >
> > followed by another GPF
> >
> >> general protection fault: 0000 [#2] SMP
> > ...
> >> RIP: 0010:[<ffffffff811aa26a>]  [<ffffffff811aa26a>] __kmalloc+0x8a/0x280
> >
> > in __kmalloc()
> >
> >>  [<ffffffff8132d81f>] acpi_ns_internalize_name+0x68/0xad
> >
> > called from acpi to copy a different name.
> >
> > I don't think the problem is anything cgroup / kernfs specific.  The
> > allocator is GPFing inside it from multiple callers and it's not even
> > using a caller-provided cache.  It looks like something screwed up the
> > memory allocator and it's now faulting on unrelated callers.  Most
> > likely illegal free or use-after-free.
> >
> > Steven, can you please post the full kernel log from boot till reboot?
> > It usually is a good idea to include full log when reporting bugs as
> > it's very easy to exclude the actually relevant part.
> >
> 
> I would if I could, but I've had to set up some rather draconian
> limits on my systemd journal sizes because of some incessant kernel
> messages filling up the logs (related to 6to4 SIT tunnels) -- this has
> unfortunately truncated most of the log. Are there any particular
> kernel config options I should enable to make tracking this down
> easier if it comes up again?
> 
> - Steven
