Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab3CIB16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:27:58 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55358 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab3CIB15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:27:57 -0500
MIME-Version: 1.0
Date: Sat, 9 Mar 2013 01:27:56 +0000
Message-ID: <CAG=jzgAQjtbcu3GC-MZqFpbuvTCJ9DT6VXRVcUo8uOFzQMwMXg@mail.gmail.com>
Subject: screen failing to display after resume from hibernate
From: kernel kernel <kernel@kenobrien.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine resumes and fails to power on the screen.

Trace:

Mar  7 23:35:09 lenovo kernel: [33562.808041] [drm:intel_lvds_disable]
*ERROR* timed out waiting for panel to power off
Mar  7 23:35:09 lenovo kernel: [33562.808052] ------------[ cut here
]------------
Mar  7 23:35:09 lenovo kernel: [33562.808087] WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.4.28/linux-3.4/drivers/gpu/drm/i915/int
el_display.c:981 intel_crtc_disable+0x2e/0x80 [i915]()
Mar  7 23:35:09 lenovo kernel: [33562.808090] Hardware name: 6474B84
Mar  7 23:35:09 lenovo kernel: [33562.808092] plane B assertion
failure (expected off, current on)
Mar  7 23:35:09 lenovo kernel: [33562.808094] Modules linked in: fuse
af_packet rfcomm bnep cpufreq_conservative cpufreq_userspace
cpufreq_pow
ersave sha256_generic cbc dm_crypt dm_mod sg snd_hda_codec_conexant
thinkpad_acpi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_pcm_oss pc
mcia arc4 btusb acpi_cpufreq bluetooth sr_mod cdrom yenta_socket
pcmcia_rsrc wmi tpm_tis mperf kvm_intel snd_seq_device snd_pcm
snd_mixer_oss
mei(C) pcmcia_core tpm coretemp iTCO_wdt iTCO_vendor_support i2c_i801
iwlwifi mac80211 cfg80211 snd_timer e1000e joydev pcspkr rfkill snd
snd_
page_alloc kvm ac battery ata_generic tpm_bios soundcore edd microcode
autofs4 thermal i915 processor drm_kms_helper drm i2c_algo_bit button
v
ideo thermal_sys scsi_dh_emc scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh
Mar  7 23:35:09 lenovo kernel: [33562.808138] Pid: 19431, comm:
kworker/u:2 Tainted: G        WC   3.4.28-2.20-desktop #1
Mar  7 23:35:09 lenovo kernel: [33562.808140] Call Trace:
Mar  7 23:35:09 lenovo kernel: [33562.808159]  [<ffffffff81004648>]
dump_trace+0x88/0x300
Mar  7 23:35:09 lenovo kernel: [33562.808169]  [<ffffffff81582ddc>]
dump_stack+0x69/0x6f
Mar  7 23:35:09 lenovo kernel: [33562.808174]  [<ffffffff8103fd99>]
warn_slowpath_common+0x79/0xc0
Mar  7 23:35:09 lenovo kernel: [33562.808178]  [<ffffffff8103fe95>]
warn_slowpath_fmt+0x45/0x50
Mar  7 23:35:09 lenovo kernel: [33562.808188]  [<ffffffffa00d770e>]
intel_crtc_disable+0x2e/0x80 [i915]
Mar  7 23:35:09 lenovo kernel: [33562.808223]  [<ffffffffa009f655>]
drm_helper_disable_unused_functions+0x105/0x160 [drm_kms_helper]
Mar  7 23:35:09 lenovo kernel: [33562.808230]  [<ffffffffa00a0138>]
drm_helper_resume_force_mode+0x118/0x150 [drm_kms_helper]
Mar  7 23:35:09 lenovo kernel: [33562.808240]  [<ffffffffa00b01f5>]
i915_drm_thaw+0x115/0x170 [i915]
Mar  7 23:35:09 lenovo kernel: [33562.808248]  [<ffffffffa00b0395>]
i915_resume+0x45/0x70 [i915]
Mar  7 23:35:09 lenovo kernel: [33562.808253]  [<ffffffff813a2e54>]
dpm_run_callback+0x54/0xa0
Mar  7 23:35:09 lenovo kernel: [33562.808257]  [<ffffffff813a359a>]
device_resume+0x10a/0x240
Mar  7 23:35:09 lenovo kernel: [33562.808261]  [<ffffffff813a36e4>]
async_resume+0x14/0x40
Mar  7 23:35:09 lenovo kernel: [33562.808265]  [<ffffffff81067e6e>]
async_run_entry_fn+0x6e/0x160
Mar  7 23:35:09 lenovo kernel: [33562.808269]  [<ffffffff8105ada3>]
process_one_work+0x123/0x450
Mar  7 23:35:09 lenovo kernel: [33562.808272]  [<ffffffff8105b44d>]
worker_thread+0x12d/0x2e0
Mar  7 23:35:09 lenovo kernel: [33562.808275]  [<ffffffff81060c05>]
kthread+0x85/0x90
Mar  7 23:35:09 lenovo kernel: [33562.808279]  [<ffffffff81596f94>]
kernel_thread_helper+0x4/0x10
Mar  7 23:35:09 lenovo kernel: [33562.808282] ---[ end trace
9e35440e65239f66 ]---


--
Ken O'Brien
PhD Researcher
Simulation Science and Extreme Events Cluster,
3B1, UCD CASL,
8 Belfield Business Park,
Dublin 4,
Ireland.
