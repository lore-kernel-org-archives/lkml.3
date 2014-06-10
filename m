Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaFJTgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:36:12 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46985 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFJTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:36:09 -0400
Date: Tue, 10 Jun 2014 12:35:56 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: imre.deak@intel.com, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] REGRESSION 3.14 i915 warning & mouse cursor vanishing
Message-ID: <20140610193556.GA8510@amazon.com>
References: <20140414164010.GA1019@falcon>
 <867g6ryd2e.fsf@hiro.keithp.com>
 <20140414185602.GA892@falcon>
 <20140415194303.GH1023@phenom.ffwll.local>
 <1397591989.2715.18.camel@ideak-mobl>
 <87ppkhaqxz.fsf@intel.com>
 <CAKbGBLj98TZGiLQTbhSPg6b74WdFALRu-qo3nxrNENNarMGQow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKbGBLj98TZGiLQTbhSPg6b74WdFALRu-qo3nxrNENNarMGQow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 3:03 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Wed, Apr 16, 2014 at 2:46 PM, Jani Nikula
> <jani.nikula@linux.intel.com> wrote:
>> On Tue, 15 Apr 2014, Imre Deak <imre.deak@intel.com> wrote:
>>> On Tue, 2014-04-15 at 21:43 +0200, Daniel Vetter wrote:
>>>> On Mon, Apr 14, 2014 at 11:56:03AM -0700, Steven Noonan wrote:
>>>> > On Mon, Apr 14, 2014 at 11:35:05AM -0700, Keith Packard wrote:
>>>> > > Steven Noonan <steven@uplinklabs.net> writes:
>>>> > >
>>>> > > > Was using my machine normally, then my mouse cursor vanished. After switching
>>>> > > > to a VT and back to X11, my cursor came back. But I did notice a nasty trace in
>>>> > > > dmesg (below).
>>>> > >
>>>> > > I don't think the trace below is related to the cursor disappearing.
>>>> >
>>>> > Any idea what the trace is all about then? Seems it has something to do
>>>> > with runtime power management (maybe my aggressive kernel command-line
>>>> > options are triggering it).
>>>>
>>>> Please test without them. Currently runtime pm should be disabled still on
>>>> vlv (since it's incomplete in 3.14). If you've force-enabled that then you
>>>> get to keep all pieces ;-)
>>>>
>>>> In general don't set any i915 options if you're not a developer or someone
>>>> else who _really_ knows what's going on.
>>>
>>> Note that the lspci output and the
>>>
>>> [ 1795.275026] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed
>>> register before writing to 70084
>>>
>>> line suggests HSW and the specs for ThinkPad Yoga suggests the same. But
>>> I don't know how the vlv_* functions can possible end up in those traces
>>> then, perhaps just a coincidence, random data on stack?
>>
>> I'm wondering the same. Perhaps double check your kernel build and
>> modules are all right and matching?
>>
>
> It was a clean build (built in a clean chroot, no ccache or anything
> fancy), so those stack traces are as "right" as they could be under
> those conditions.
>
> The "good" news (or perhaps scary news) is that I've been running
> 3.14.1 for the past 36 hours and haven't been able to reproduce either
> problem since then (warnings or ninja mouse cursor). Nothing in the
> changelog for v3.14..v3.14.1 really stands out as a clear fix though.
> The only changes that appear to directly affect my configuration would
> be the futex changes, iwlwifi change, efi change, and ipv6 change.

This issue is haunting me again. This time I'm running 3.14.6. My mouse
cursor vanished, and I have a bunch of warnings in dmesg:

[ 5622.922652] ------------[ cut here ]------------
[ 5622.922707] WARNING: CPU: 0 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5622.922710] Device suspended
[ 5622.922714] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5622.922796]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5622.922853] CPU: 0 PID: 312 Comm: X Tainted: G           O 3.14.6-1-ec2 #1
[ 5622.922856] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5622.922860]  0000000000000009 ffff880212319c08 ffffffff814fd4c3 ffff880212319c50
[ 5622.922867]  ffff880212319c40 ffffffff810664ad 0000000000070088 ffff8802119b8000
[ 5622.922873]  ffff8802119b8028 ffff8802119b8020 0000000003bb0611 ffff880212319ca0
[ 5622.922880] Call Trace:
[ 5622.922891]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5622.922900]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5622.922906]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5622.922922]  [<ffffffff811dcaf0>] ? poll_select_copy_remaining+0x130/0x130
[ 5622.922942]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5622.922963]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5622.922986]  [<ffffffffa00f364b>] i915_restore_display_reg+0x198b/0x8430 [i915]
[ 5622.922995]  [<ffffffff81501062>] ? mutex_lock+0x12/0x30
[ 5622.923017]  [<ffffffffa00f390f>] i915_restore_display_reg+0x1c4f/0x8430 [i915]
[ 5622.923044]  [<ffffffffa006d060>] drm_mode_set_config_internal+0x180/0x260 [drm]
[ 5622.923053]  [<ffffffff81075ed7>] ? __dequeue_signal+0x117/0x200
[ 5622.923083]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5622.923102]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5622.923131]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5622.923140]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5622.923149]  [<ffffffff811c90b7>] ? vfs_read+0x97/0x160
[ 5622.923156]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5622.923167]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5622.923175]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5622.923179] ---[ end trace 5e18fb54489137d5 ]---
[ 5622.923185] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70088
[ 5622.923190] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70088
[ 5622.923194] ------------[ cut here ]------------
[ 5622.923213] WARNING: CPU: 0 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5622.923215] Device suspended
[ 5622.923217] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5622.923290]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5622.923339] CPU: 0 PID: 312 Comm: X Tainted: G        W  O 3.14.6-1-ec2 #1
[ 5622.923343] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5622.923345]  0000000000000009 ffff880212319c08 ffffffff814fd4c3 ffff880212319c50
[ 5622.923352]  ffff880212319c40 ffffffff810664ad 0000000000070084 ffff8802119b8000
[ 5622.923358]  ffff8802119b8028 ffff8802119b8020 00000000010a2000 ffff880212319ca0
[ 5622.923364] Call Trace:
[ 5622.923370]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5622.923377]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5622.923383]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5622.923406]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5622.923426]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5622.923449]  [<ffffffffa00f3751>] i915_restore_display_reg+0x1a91/0x8430 [i915]
[ 5622.923471]  [<ffffffffa00f390f>] i915_restore_display_reg+0x1c4f/0x8430 [i915]
[ 5622.923496]  [<ffffffffa006d060>] drm_mode_set_config_internal+0x180/0x260 [drm]
[ 5622.923504]  [<ffffffff81075ed7>] ? __dequeue_signal+0x117/0x200
[ 5622.923533]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5622.923552]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5622.923581]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5622.923590]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5622.923597]  [<ffffffff811c90b7>] ? vfs_read+0x97/0x160
[ 5622.923604]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5622.923612]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5622.923619]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5622.923623] ---[ end trace 5e18fb54489137d6 ]---
[ 5622.923627] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70084
[ 5622.923632] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70084
[ 5622.936512] ------------[ cut here ]------------
[ 5622.936534] WARNING: CPU: 0 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5622.936535] Device suspended
[ 5622.936536] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5622.936554]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5622.936567] CPU: 0 PID: 312 Comm: X Tainted: G        W  O 3.14.6-1-ec2 #1
[ 5622.936568] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5622.936569]  0000000000000009 ffff880212319c08 ffffffff814fd4c3 ffff880212319c50
[ 5622.936571]  ffff880212319c40 ffffffff810664ad 0000000000070088 ffff8802119b8000
[ 5622.936573]  ffff8802119b8028 ffff8802119b8020 0000000003ba0610 ffff880212319ca0
[ 5622.936574] Call Trace:
[ 5622.936578]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5622.936581]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5622.936582]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5622.936586]  [<ffffffff811dcaf0>] ? poll_select_copy_remaining+0x130/0x130
[ 5622.936591]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5622.936595]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5622.936601]  [<ffffffffa00f364b>] i915_restore_display_reg+0x198b/0x8430 [i915]
[ 5622.936603]  [<ffffffff81501062>] ? mutex_lock+0x12/0x30
[ 5622.936608]  [<ffffffffa00f390f>] i915_restore_display_reg+0x1c4f/0x8430 [i915]
[ 5622.936615]  [<ffffffffa006d060>] drm_mode_set_config_internal+0x180/0x260 [drm]
[ 5622.936618]  [<ffffffff81075ed7>] ? __dequeue_signal+0x117/0x200
[ 5622.936625]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5622.936629]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5622.936636]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5622.936638]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5622.936640]  [<ffffffff811c90b7>] ? vfs_read+0x97/0x160
[ 5622.936642]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5622.936644]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5622.936646]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5622.936647] ---[ end trace 5e18fb54489137d7 ]---
[ 5622.936649] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70088
[ 5622.936651] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70088
[ 5622.936652] ------------[ cut here ]------------
[ 5622.936656] WARNING: CPU: 0 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5622.936657] Device suspended
[ 5622.936657] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5622.936674]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5622.936686] CPU: 0 PID: 312 Comm: X Tainted: G        W  O 3.14.6-1-ec2 #1
[ 5622.936687] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5622.936687]  0000000000000009 ffff880212319c08 ffffffff814fd4c3 ffff880212319c50
[ 5622.936689]  ffff880212319c40 ffffffff810664ad 0000000000070084 ffff8802119b8000
[ 5622.936690]  ffff8802119b8028 ffff8802119b8020 00000000010a2000 ffff880212319ca0
[ 5622.936692] Call Trace:
[ 5622.936693]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5622.936694]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5622.936695]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5622.936701]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5622.936705]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5622.936710]  [<ffffffffa00f3751>] i915_restore_display_reg+0x1a91/0x8430 [i915]
[ 5622.936714]  [<ffffffffa00f390f>] i915_restore_display_reg+0x1c4f/0x8430 [i915]
[ 5622.936720]  [<ffffffffa006d060>] drm_mode_set_config_internal+0x180/0x260 [drm]
[ 5622.936722]  [<ffffffff81075ed7>] ? __dequeue_signal+0x117/0x200
[ 5622.936728]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5622.936733]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5622.936738]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5622.936740]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5622.936742]  [<ffffffff811c90b7>] ? vfs_read+0x97/0x160
[ 5622.936744]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5622.936745]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5622.936747]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5622.936748] ---[ end trace 5e18fb54489137d8 ]---
[ 5622.936749] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70084
[ 5622.936750] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70084
[ 5835.487021] ------------[ cut here ]------------
[ 5835.487045] WARNING: CPU: 2 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5835.487045] Device suspended
[ 5835.487046] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5835.487066]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5835.487081] CPU: 2 PID: 312 Comm: X Tainted: G        W  O 3.14.6-1-ec2 #1
[ 5835.487082] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5835.487083]  0000000000000009 ffff880212319bd0 ffffffff814fd4c3 ffff880212319c18
[ 5835.487085]  ffff880212319c08 ffffffff810664ad 0000000000070088 ffff8802119b8000
[ 5835.487087]  ffff8802119b8028 ffff8802119b8020 00000000025202e8 ffff880212319c68
[ 5835.487089] Call Trace:
[ 5835.487093]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5835.487096]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5835.487097]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5835.487101]  [<ffffffff813f892a>] ? sock_def_readable+0x3a/0x70
[ 5835.487106]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5835.487111]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5835.487117]  [<ffffffffa00f364b>] i915_restore_display_reg+0x198b/0x8430 [i915]
[ 5835.487122]  [<ffffffffa00f675a>] i915_restore_display_reg+0x4a9a/0x8430 [i915]
[ 5835.487130]  [<ffffffffa006d0e4>] drm_mode_set_config_internal+0x204/0x260 [drm]
[ 5835.487138]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5835.487143]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5835.487150]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5835.487153]  [<ffffffff811ca0b5>] ? do_readv_writev+0x195/0x220
[ 5835.487155]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5835.487157]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5835.487160]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5835.487162]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5835.487163] ---[ end trace 5e18fb54489137d9 ]---
[ 5835.487165] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70088
[ 5835.487167] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70088
[ 5835.487168] ------------[ cut here ]------------
[ 5835.487172] WARNING: CPU: 2 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5835.487173] Device suspended
[ 5835.487174] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5835.487193]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5835.487206] CPU: 2 PID: 312 Comm: X Tainted: G        W  O 3.14.6-1-ec2 #1
[ 5835.487206] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5835.487207]  0000000000000009 ffff880212319bd0 ffffffff814fd4c3 ffff880212319c18
[ 5835.487209]  ffff880212319c08 ffffffff810664ad 0000000000070080 ffff8802119b8000
[ 5835.487210]  ffff8802119b8028 ffff8802119b8020 00000000ffffbfff ffff880212319c68
[ 5835.487212] Call Trace:
[ 5835.487213]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5835.487215]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5835.487216]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5835.487222]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5835.487226]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5835.487232]  [<ffffffffa00f36fe>] i915_restore_display_reg+0x1a3e/0x8430 [i915]
[ 5835.487236]  [<ffffffffa00f675a>] i915_restore_display_reg+0x4a9a/0x8430 [i915]
[ 5835.487243]  [<ffffffffa006d0e4>] drm_mode_set_config_internal+0x204/0x260 [drm]
[ 5835.487250]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5835.487255]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5835.487261]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5835.487263]  [<ffffffff811ca0b5>] ? do_readv_writev+0x195/0x220
[ 5835.487265]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5835.487267]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5835.487269]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5835.487271]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5835.487272] ---[ end trace 5e18fb54489137da ]---
[ 5835.487273] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70080
[ 5835.487274] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70080
[ 5835.487275] ------------[ cut here ]------------
[ 5835.487288] WARNING: CPU: 2 PID: 312 at drivers/gpu/drm/i915/intel_uncore.c:455 vlv_flisdsi_write+0x1d69/0x2cc0 [i915]()
[ 5835.487289] Device suspended
[ 5835.487289] Modules linked in: cpufreq_stats fuse ctr ccm hid_generic hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf hid_sensor_iio_common industrialio hid_sensor_hub hid_multitouch usbhid wacom hid btusb joydev bnep bluetooth 6lowpan_iphc tun arc4 nls_cp437 vfat fat iwlmvm mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi iTCO_wdt kvm_intel iTCO_vendor_support kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper iwlwifi ablk_helper cryptd microcode psmouse cfg80211 serio_raw snd_hda_codec_conexant i2c_i801 lpc_ich snd_hda_codec_generic mfd_core tpm_tis snd_hda_intel thermal tpm wmi thinkpad_acpi snd_hda_codec snd_hwdep nvram battery snd_pcm
[ 5835.487307]  ac evdev snd_timer snd soundcore intel_smartconnect acpi_cpufreq processor vmnet(O) vmblock(O) vmci(O) vmmon(O) msr ax88179_178a(O) usbnet mii efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata xhci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
[ 5835.487318] CPU: 2 PID: 312 Comm: X Tainted: G        W  O 3.14.6-1-ec2 #1
[ 5835.487319] Hardware name: LENOVO 20CDCTO1WW/20CDCTO1WW, BIOS GQET35WW (1.15 ) 04/21/2014
[ 5835.487319]  0000000000000009 ffff880212319bd0 ffffffff814fd4c3 ffff880212319c18
[ 5835.487321]  ffff880212319c08 ffffffff810664ad 0000000000070084 ffff8802119b8000
[ 5835.487322]  ffff8802119b8028 ffff8802119b8020 00000000010a2000 ffff880212319c68
[ 5835.487323] Call Trace:
[ 5835.487325]  [<ffffffff814fd4c3>] dump_stack+0x45/0x56
[ 5835.487326]  [<ffffffff810664ad>] warn_slowpath_common+0x7d/0xa0
[ 5835.487327]  [<ffffffff8106651c>] warn_slowpath_fmt+0x4c/0x50
[ 5835.487332]  [<ffffffffa013a849>] vlv_flisdsi_write+0x1d69/0x2cc0 [i915]
[ 5835.487336]  [<ffffffffa013af46>] vlv_flisdsi_write+0x2466/0x2cc0 [i915]
[ 5835.487341]  [<ffffffffa00f3751>] i915_restore_display_reg+0x1a91/0x8430 [i915]
[ 5835.487345]  [<ffffffffa00f675a>] i915_restore_display_reg+0x4a9a/0x8430 [i915]
[ 5835.487351]  [<ffffffffa006d0e4>] drm_mode_set_config_internal+0x204/0x260 [drm]
[ 5835.487357]  [<ffffffffa0070d21>] drm_mode_cursor_ioctl+0x41/0x50 [drm]
[ 5835.487361]  [<ffffffffa0061bb2>] drm_ioctl+0x4c2/0x700 [drm]
[ 5835.487367]  [<ffffffffa0070ce0>] ? drm_mode_setcrtc+0x5e0/0x5e0 [drm]
[ 5835.487369]  [<ffffffff811ca0b5>] ? do_readv_writev+0x195/0x220
[ 5835.487371]  [<ffffffff811dbf28>] do_vfs_ioctl+0x2c8/0x4a0
[ 5835.487372]  [<ffffffff811dc181>] SyS_ioctl+0x81/0xa0
[ 5835.487374]  [<ffffffff811002d6>] ? __audit_syscall_exit+0x236/0x2e0
[ 5835.487375]  [<ffffffff8150bfad>] system_call_fastpath+0x1a/0x1f
[ 5835.487376] ---[ end trace 5e18fb54489137db ]---
[ 5835.487377] [drm:hsw_unclaimed_reg_clear] *ERROR* Unknown unclaimed register before writing to 70084
[ 5835.487379] [drm:hsw_unclaimed_reg_check] *ERROR* Unclaimed write to 70084

I was able to get my mouse cursor back this time by using a hotkey to
start my screen saver (in KDE), and then unlocking the screen.
