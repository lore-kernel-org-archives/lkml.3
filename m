Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3CPM3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:29:04 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:52134 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3CPM3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:29:02 -0400
Date: Sat, 16 Mar 2013 13:28:50 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: drm/i915: new warning (regression) in 3.7.10 and 3.8.3
Message-ID: <20130316122849.GA3753@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have an Acer Aspire One netbook, and on it I get the following
warning when closing and opening the lid. I think this warning first
appeared in 3.7.

Does this need fixing? If so, who can do it?

Thanks,
Richard

** close lid

Mar 16 11:32:03 netboy kernel: [  287.429404] [drm:i9xx_crtc_mode_set] *ERROR* Couldn't find PLL settings for mode!
Mar 16 11:32:03 netboy kernel: [  287.429440] ------------[ cut here ]------------
Mar 16 11:32:03 netboy kernel: [  287.429526] WARNING: at /home/richard/git/linux/drivers/gpu/drm/i915/intel_display.c:7877 intel_modeset_check_state+0x2f8/0x452 [i915]()
Mar 16 11:32:03 netboy kernel: [  287.429537] Hardware name: AOD257
Mar 16 11:32:03 netboy kernel: [  287.429548] encoder's hw state doesn't match sw tracking (expected 1, found 0)
Mar 16 11:32:03 netboy kernel: [  287.429556] Modules linked in: mmc_block bluetooth crc16 cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conservative uinput fuse loop snd_hda_codec_realtek joydev arc4 iwldvm snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mac80211 i915 snd_timer snd iwlwifi cfg80211 tpm_tis psmouse serio_raw drm_kms_helper tpm i2c_i801 soundcore evdev hid_generic drm i2c_algo_bit video pcspkr tpm_bios i2c_core ehci_pci snd_page_alloc acpi_cpufreq mperf battery ac rfkill wmi processor button ext3 jbd mbcache sd_mod crc_t10dif usbhid hid rtsx_pci_sdmmc mmc_core ahci libahci libata scsi_mod uhci_hcd ehci_hcd usbcore usb_common thermal thermal_sys rtsx_pci mfd_core r8169 mii
Mar 16 11:32:03 netboy kernel: [  287.429771] Pid: 34, comm: kworker/0:1 Not tainted 3.8.3 #74
Mar 16 11:32:03 netboy kernel: [  287.429781] Call Trace:
Mar 16 11:32:03 netboy kernel: [  287.429808]  [<c102623a>] ? warn_slowpath_common+0x6a/0x7b
Mar 16 11:32:03 netboy kernel: [  287.429882]  [<f859e387>] ? intel_modeset_check_state+0x2f8/0x452 [i915]
Mar 16 11:32:03 netboy kernel: [  287.429904]  [<c10262b1>] ? warn_slowpath_fmt+0x28/0x2c
Mar 16 11:32:03 netboy kernel: [  287.429975]  [<f859e387>] ? intel_modeset_check_state+0x2f8/0x452 [i915]
Mar 16 11:32:03 netboy kernel: [  287.430017]  [<f85a429c>] ? intel_set_mode+0x61a/0x6aa [i915]
Mar 16 11:32:03 netboy kernel: [  287.430162]  [<f85a42d6>] ? intel_set_mode+0x654/0x6aa [i915]
Mar 16 11:32:03 netboy kernel: [  287.430290]  [<f85a85ea>] ? intel_modeset_setup_hw_state+0x5e0/0x70a [i915]
Mar 16 11:32:03 netboy kernel: [  287.430386]  [<f85a9bd4>] ? intel_lid_notify+0x7a/0x8a [i915]
Mar 16 11:32:03 netboy kernel: [  287.430409]  [<c12e2baf>] ? notifier_call_chain+0x23/0x46
Mar 16 11:32:03 netboy kernel: [  287.430449]  [<c1041912>] ? __blocking_notifier_call_chain+0x39/0x4c
Mar 16 11:32:03 netboy kernel: [  287.430470]  [<c104192e>] ? blocking_notifier_call_chain+0x9/0xc
Mar 16 11:32:03 netboy kernel: [  287.430500]  [<f82300b7>] ? acpi_lid_send_state+0x7d/0xa0 [button]
Mar 16 11:32:03 netboy kernel: [  287.430532]  [<f823011d>] ? acpi_button_notify+0x2b/0x95 [button]
Mar 16 11:32:03 netboy kernel: [  287.430557]  [<c11aaa17>] ? acpi_device_notify+0xf/0x11
Mar 16 11:32:03 netboy kernel: [  287.430578]  [<c11b5ef1>] ? acpi_ev_notify_dispatch+0x2b/0x42
Mar 16 11:32:03 netboy kernel: [  287.430597]  [<c11a8002>] ? acpi_os_execute_deferred+0x18/0x21
Mar 16 11:32:03 netboy kernel: [  287.430617]  [<c103a099>] ? process_one_work+0x1b1/0x27e
Mar 16 11:32:03 netboy kernel: [  287.430637]  [<c103a27b>] ? worker_thread+0x115/0x203
Mar 16 11:32:03 netboy kernel: [  287.430656]  [<c103a166>] ? process_one_work+0x27e/0x27e
Mar 16 11:32:03 netboy kernel: [  287.430672]  [<c103d2cb>] ? kthread+0x8d/0x92
Mar 16 11:32:03 netboy kernel: [  287.430691]  [<c12e51f7>] ? ret_from_kernel_thread+0x1b/0x28
Mar 16 11:32:03 netboy kernel: [  287.430707]  [<c103d23e>] ? kthread_freezable_should_stop+0x4b/0x4b
Mar 16 11:32:03 netboy kernel: [  287.430720] ---[ end trace 4a7da2dcc2431943 ]---

** open lid

Mar 16 11:32:03 netboy kernel: [  287.430746] ------------[ cut here ]------------
Mar 16 11:32:03 netboy kernel: [  287.430849] WARNING: at /home/richard/git/linux/drivers/gpu/drm/i915/intel_display.c:7911 intel_modeset_check_state+0x3f3/0x452 [i915]()
Mar 16 11:32:03 netboy kernel: [  287.430889] Hardware name: AOD257
Mar 16 11:32:03 netboy kernel: [  287.430928] crtc's computed active state doesn't match tracked active state (expected 1, found 0)
Mar 16 11:32:03 netboy kernel: [  287.430964] Modules linked in: mmc_block bluetooth crc16 cpufreq_stats cpufreq_userspace cpufreq_powersave cpufreq_conservative uinput fuse loop snd_hda_codec_realtek joydev arc4 iwldvm snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm mac80211 i915 snd_timer snd iwlwifi cfg80211 tpm_tis psmouse serio_raw drm_kms_helper tpm i2c_i801 soundcore evdev hid_generic drm i2c_algo_bit video pcspkr tpm_bios i2c_core ehci_pci snd_page_alloc acpi_cpufreq mperf battery ac rfkill wmi processor button ext3 jbd mbcache sd_mod crc_t10dif usbhid hid rtsx_pci_sdmmc mmc_core ahci libahci libata scsi_mod uhci_hcd ehci_hcd usbcore usb_common thermal thermal_sys rtsx_pci mfd_core r8169 mii
Mar 16 11:32:03 netboy kernel: [  287.431233] Pid: 34, comm: kworker/0:1 Tainted: G        W    3.8.3 #74
Mar 16 11:32:03 netboy kernel: [  287.431243] Call Trace:
Mar 16 11:32:03 netboy kernel: [  287.431267]  [<c102623a>] ? warn_slowpath_common+0x6a/0x7b
Mar 16 11:32:03 netboy kernel: [  287.431342]  [<f859e482>] ? intel_modeset_check_state+0x3f3/0x452 [i915]
Mar 16 11:32:03 netboy kernel: [  287.431363]  [<c10262b1>] ? warn_slowpath_fmt+0x28/0x2c
Mar 16 11:32:03 netboy kernel: [  287.431439]  [<f859e482>] ? intel_modeset_check_state+0x3f3/0x452 [i915]
Mar 16 11:32:03 netboy kernel: [  287.431513]  [<f85a429c>] ? intel_set_mode+0x61a/0x6aa [i915]
Mar 16 11:32:03 netboy kernel: [  287.431640]  [<f85a42d6>] ? intel_set_mode+0x654/0x6aa [i915]
Mar 16 11:32:03 netboy kernel: [  287.431740]  [<f85a85ea>] ? intel_modeset_setup_hw_state+0x5e0/0x70a [i915]
Mar 16 11:32:03 netboy kernel: [  287.431817]  [<f85a9bd4>] ? intel_lid_notify+0x7a/0x8a [i915]
Mar 16 11:32:03 netboy kernel: [  287.431841]  [<c12e2baf>] ? notifier_call_chain+0x23/0x46
Mar 16 11:32:03 netboy kernel: [  287.431877]  [<c1041912>] ? __blocking_notifier_call_chain+0x39/0x4c
Mar 16 11:32:03 netboy kernel: [  287.431898]  [<c104192e>] ? blocking_notifier_call_chain+0x9/0xc
Mar 16 11:32:03 netboy kernel: [  287.431927]  [<f82300b7>] ? acpi_lid_send_state+0x7d/0xa0 [button]
Mar 16 11:32:03 netboy kernel: [  287.431985]  [<f823011d>] ? acpi_button_notify+0x2b/0x95 [button]
Mar 16 11:32:03 netboy kernel: [  287.432068]  [<c11aaa17>] ? acpi_device_notify+0xf/0x11
Mar 16 11:32:03 netboy kernel: [  287.432090]  [<c11b5ef1>] ? acpi_ev_notify_dispatch+0x2b/0x42
Mar 16 11:32:03 netboy kernel: [  287.432109]  [<c11a8002>] ? acpi_os_execute_deferred+0x18/0x21
Mar 16 11:32:03 netboy kernel: [  287.432129]  [<c103a099>] ? process_one_work+0x1b1/0x27e
Mar 16 11:32:03 netboy kernel: [  287.432146]  [<c103a27b>] ? worker_thread+0x115/0x203
Mar 16 11:32:03 netboy kernel: [  287.432165]  [<c103a166>] ? process_one_work+0x27e/0x27e
Mar 16 11:32:03 netboy kernel: [  287.432182]  [<c103d2cb>] ? kthread+0x8d/0x92
Mar 16 11:32:03 netboy kernel: [  287.432203]  [<c12e51f7>] ? ret_from_kernel_thread+0x1b/0x28
Mar 16 11:32:03 netboy kernel: [  287.432250]  [<c103d23e>] ? kthread_freezable_should_stop+0x4b/0x4b
Mar 16 11:32:03 netboy kernel: [  287.432288] ---[ end trace 4a7da2dcc2431944 ]---
