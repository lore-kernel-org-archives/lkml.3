Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaLHAel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 19:34:41 -0500
Received: from imap.thunk.org ([74.207.234.97]:44458 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaLHAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 19:34:40 -0500
Date: Sun, 7 Dec 2014 19:34:33 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: WARNING:
 /usr/projects/linux/linux/drivers/gpu/drm/i915/intel_pm.c:6585
 intel_display_power_put+0x4b/0x116 [i915]()
Message-ID: <20141208003433.GA3353@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
References: <20140902040527.GA5508@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902040527.GA5508@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update to a problem which I reported several months ago
(see below).  The symptoms have changed a bit since then, but they've
stablized since 3.17 and 3.18-rcX, and while annoying, it's tolerable,
so I've been living with it.

What I'm basically seeing now is that any external monitor (either a
Dell 30" or Dell 24") will be seen after a reboot or a restart of the
X server.  But if suspend the laptop, disconnect from the dock, and
resume, and then later on, reconnect to the dock, the external
monitors are not visible until I kill and restart the X server.
Another part of the symptom is when I try to probe for the monitors,
using either xrandr or xfce4-display-settings, the system freezes for
a second or two, and then when it recovers, if I look in the logs, I
see the following warning message, repeated twice:

[246289.614639] WARNING: CPU: 0 PID: 29875 at /usr/projects/linux/linux/drivers/gpu/drm/i915/intel_pm.c:6585 intel_display_power_put+0x4b/0x116 [i915]()
[246289.614640] Modules linked in: iptable_filter ip_tables x_tables rfcomm ctr ccm binfmt_misc bnep hid_generic usbhid uvcvideo hid videobuf2_vmalloc videobuf2_memops videobuf2_core btusb bluetooth snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp crc32_pclmul ghash_clmulni_intel pcspkr serio_raw i2c_i801 thinkpad_acpi nvram snd_hda_codec_realtek snd_hda_codec_generic tpm_tis iwlmvm mac80211 i915 drm_kms_helper drm iwlwifi intel_smartconnect intel_gtt snd_hda_intel cfg80211 lpc_ich mfd_core snd_hda_controller snd_hda_codec xhci_pci snd_hwdep xhci_hcd kvm_intel kvm ecryptfs encrypted_keys trusted tpm parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq microcode ehci_pci ehci_hcd e1000e ptp pps_core
[246289.614675] CPU: 0 PID: 29875 Comm: Xorg Tainted: G        W      3.18.0-rc7-00028-g455e143 #108
[246289.614676] Hardware name: LENOVO 20BECTO1WW/20BECTO1WW, BIOS GMET59WW (2.07 ) 02/12/2014
[246289.614677]  0000000000000009 ffff8802048e3a68 ffffffff815cb640 0000000000000006
[246289.614679]  0000000000000000 ffff8802048e3aa8 ffffffff8106de00 ffff8802048e3aa8
[246289.614681]  ffffffffa04a7441 ffff880405610044 ffff880405610000 ffff880405438890
[246289.614683] Call Trace:
[246289.614689]  [<ffffffff815cb640>] dump_stack+0x4e/0x68
[246289.614692]  [<ffffffff8106de00>] warn_slowpath_common+0x81/0x9b
[246289.614702]  [<ffffffffa04a7441>] ? intel_display_power_put+0x4b/0x116 [i915]
[246289.614704]  [<ffffffff8106debd>] warn_slowpath_null+0x1a/0x1c
[246289.614713]  [<ffffffffa04a7441>] intel_display_power_put+0x4b/0x116 [i915]
[246289.614731]  [<ffffffffa04e6d0c>] modeset_update_crtc_power_domains+0xd8/0x117 [i915]
[246289.614746]  [<ffffffffa04e7153>] haswell_modeset_global_resources+0xe/0x10 [i915]
[246289.614760]  [<ffffffffa04e8122>] __intel_set_mode+0x9a5/0x1204 [i915]
[246289.614775]  [<ffffffffa04ef271>] ? intel_crtc_set_config+0x151/0xa98 [i915]
[246289.614789]  [<ffffffffa04eec0a>] intel_set_mode+0x16/0x2f [i915]
[246289.614802]  [<ffffffffa04ef8d2>] intel_crtc_set_config+0x7b2/0xa98 [i915]
[246289.614815]  [<ffffffffa0426b83>] drm_mode_set_config_internal+0x59/0xe5 [drm]
[246289.614823]  [<ffffffffa0426c9d>] drm_framebuffer_remove+0x8e/0x104 [drm]
[246289.614832]  [<ffffffffa042a046>] drm_mode_rmfb+0xdc/0x101 [drm]
[246289.614839]  [<ffffffffa041de40>] drm_ioctl+0x38a/0x429 [drm]
[246289.614847]  [<ffffffffa0429f6a>] ? drm_mode_addfb2+0x30/0x30 [drm]
[246289.614849]  [<ffffffff8127fe04>] ? avc_has_perm+0x35/0x99
[246289.614852]  [<ffffffff810c5e4c>] ? read_seqcount_begin.constprop.25+0x5a/0x70
[246289.614855]  [<ffffffff81194eb1>] do_vfs_ioctl+0x3ab/0x45e
[246289.614857]  [<ffffffff8128075f>] ? file_has_perm+0x5d/0x81
[246289.614859]  [<ffffffff810ededf>] ? __audit_syscall_entry+0xcd/0xef
[246289.614861]  [<ffffffff81194fbe>] SyS_ioctl+0x5a/0x7f
[246289.614864]  [<ffffffff815d39d6>] system_call_fastpath+0x16/0x1b
[246289.614865] ---[ end trace 238ba2a27a19ffce ]---

(The above stack trace came from a 3.17-rc7 based kernel.)

Looking at the code, we seem to be triggering on the following WARN_ON
in intel_display_power_put:

	WARN_ON(!power_domains->domain_use_count[domain]);
	power_domains->domain_use_count[domain]--;

This warning does *not* appear after a fresh reboot, logging in, and
then running xfce4-display-settings, so I assume that part of the
problem is that the internal kernel state is getting corrupted when
the laptop is undocked and the display disappears while the laptop is
suspend, and the internal state inconsistency / corruption persists
even though killing and restarting the X server seems to make things
the external display monitor become visible again.

This is consistent with the observation that sometimes the laptop will
lock up after either (a) resuming with the dock attached or (b) if the
external monitor is accidentally powered off (the power button on the
dell monitor is way too easy to accidentally hit), and the only way to
recover is with a magic sysrq reboot or a forced power cycle.

This is a not a regression, and it's been this way for several months
(including 3.17.0), but I've been too busy to really try to debug this
until now.

Hopefully the above is helpful; if there's anything more debugging
information I can get, let me know!!

					- Ted


On Tue, Sep 02, 2014 at 12:05:27AM -0400, Theodore Ts'o wrote:
> I recently upgraded to v3.17-rc3, and on my Lenovo T540p, I can no
> longer see the my Dell 30" monitor when it is connected via the
> docking station using a Displayport connector.  This worked using 3.16
> kernel.
> 
> If I connect to the monitor using the mini-display, by passing the
> docking station, things work fine (but of course it's annoying not to
> be able to use the docking station).
> 
> Is this a known problem?  This is not the first time that we've had
> regressions with this docking station.   It's vaguely reminsicent of 
> 
> 	https://bugs.freedesktop.org/show_bug.cgi?id=71267
> 
> Except the system isn't hanging; it's just not seeing the monitor at all.
> 
