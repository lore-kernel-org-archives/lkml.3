Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaHVPsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:48:52 -0400
Received: from mout.web.de ([212.227.17.12]:50659 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466AbaHVPsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:48:50 -0400
Date: Fri, 22 Aug 2014 17:48:46 +0200
From: Julian Wollrath <jwollrath@web.de>
To: linux-kernel@vger.kernel.org
Subject: Trace with v3.17-rc1 while trying to enable power saving for pci
 device
Message-ID: <20140822174846.18eba9a2@saldaea>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:41Iy4J5yIOt5+jhDEIrYUGFYzoQNiJyp9Et4TYHl94Ls9EWpcPj
 1+37iHEzJ+wEjMlPqgkBDUHkzZs84/NHSWiJ42E27BUDXw2hSBij/DONe6tmE+xtCUeM3qN
 E/D1GqqVAMLPml4f3jzlmHaSdCrImW+1INGROHOi8ezext4iNUi+BfxUVaNv9ZDFdv6lqLh
 hatiMewh2myVNLFLfxOpw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just tried out the current git master (commit 5317821c08) and got the
following trace:
[   25.637181] ------------[ cut here ]------------
[   25.637191] WARNING: CPU: 0 PID: 756 at fs/proc/generic.c:521 remove_proc_entry+0x170/0x180()
[   25.637194] remove_proc_entry: removing non-empty directory 'irq/23', leaking at least 'ehci_hcd:usb4'
[   25.637196] Modules linked in: ecb btusb bluetooth crc16 arc4 iwldvm x86_pkg_temp_thermal mac80211 intel_powerclamp snd_hda_codec_hdmi snd_hda_codec_realtek i915 snd_hda_codec_generic snd_hda_intel intel_rapl coretemp kvm_intel snd_hda_controller snd_hda_codec kvm snd_hwdep iwlwifi psmouse snd_pcm thinkpad_acpi uvcvideo cfg80211 evdev serio_raw nvram snd_timer i2c_algo_bit videobuf2_vmalloc videobuf2_memops drm_kms_helper videobuf2_core snd v4l2_common drm soundcore wmi pcspkr tpm_tis tpm rfkill videodev battery ac video i2c_i801 i2ccore button processor sch_fq fuse autofs4 dm_crypt dm_mod sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel ahci libahci libata scsi_mod ehci_pci ehci_hcd xhci_hcd sdhci_pci e1000e sdhci ptp pps_core mmc_core usbcore thermal usb_common thermal_sys
[   25.637257] CPU: 0 PID: 756 Comm: rc.local Not tainted 3.17.0-rc1+ #1
[   25.637259] Hardware name: LENOVO 23250BM/23250BM, BIOS G2ETA1WW (2.61 ) 04/22/2014
[   25.637261]  0000000000000009 ffffffff814b56ef ffff8800c9b7fc30 ffffffff8106eb42
[   25.637265]  ffff880037648c40 ffff8800c9b7fc80 0000000000000002 ffff8800c9b7fce6
[   25.637268]  ffff8800c9b7fce6 ffffffff8106eba7 ffffffff81719f08 ffff880000000030
[   25.637271] Call Trace:
[   25.637277]  [<ffffffff814b56ef>] ? dump_stack+0x41/0x51
[   25.637283]  [<ffffffff8106eb42>] ? warn_slowpath_common+0x72/0x90
[   25.637286]  [<ffffffff8106eba7>] ? warn_slowpath_fmt+0x47/0x50
[   25.637291]  [<ffffffff811da561>] ? proc_entry_rundown+0x41/0x80
[   25.637294]  [<ffffffff811de740>] ? remove_proc_entry+0x170/0x180
[   25.637300]  [<ffffffff810b7db7>] ? unregister_irq_proc+0xb7/0xc0
[   25.637303]  [<ffffffff810b2ab2>] ? free_desc+0x22/0x60
[   25.637307]  [<ffffffff810b2b22>] ? irq_free_descs+0x32/0x80
[   25.637312]  [<ffffffff810335f4>] ? mp_unmap_irq+0x74/0xb0
[   25.637316]  [<ffffffff812d733c>] ? do_pci_disable_device+0x4c/0x60
[   25.637319]  [<ffffffff812d7390>] ? pci_disable_device+0x40/0xb0
[   25.637330]  [<ffffffffa0038fc2>] ? suspend_common+0x52/0x150 [usbcore]
[   25.637335]  [<ffffffff812d8ff7>] ? pci_pm_runtime_suspend+0x57/0x150
[   25.637340]  [<ffffffff8137e636>] ? __rpm_callback+0x26/0x60
[   25.637343]  [<ffffffff8137e688>] ? rpm_callback+0x18/0x80
[   25.637346]  [<ffffffff8137f137>] ? rpm_suspend+0x107/0x600
[   25.637350]  [<ffffffff810a1c6f>] ? __wake_up+0x2f/0x50
[   25.637353]  [<ffffffff8137fcad>] ? pm_runtime_allow+0x4d/0x50 
[   25.637357]  [<ffffffff8137c75d>] ? control_store+0xbd/0xc0
[   25.637361]  [<ffffffff811e91bb>] ? kernfs_fop_write+0xdb/0x160
[   25.637365]  [<ffffffff811835ed>] ? vfs_write+0xad/0x1e0
[   25.637368]  [<ffffffff811840fd>] ? SyS_write+0x3d/0xa0
[   25.637373]  [<ffffffff814bb052>] ? system_call_fastpath+0x16/0x1b
[   25.637375] ---[ end trace 40fa9ae9acda7087 ]---

I get the trace due to enabling power saving via
'echo 'auto' > /sys/bus/pci/devices/0000:00:1d.0/power/control'
with 00:1d.0 being the USB controller (according to lspci):
00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)

If you need more information, please do not hesitate to ask.


With best regards,
Julian Wollrath
