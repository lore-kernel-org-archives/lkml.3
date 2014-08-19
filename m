Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaHSVlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:41:16 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:44379 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaHSVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:41:14 -0400
Message-ID: <53F3C477.7070004@lwfinger.net>
Date: Tue, 19 Aug 2014 16:41:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
CC: intel-gfx@lists.freedesktop.org, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: WARNING in 3.17-rc1 for i915
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Toshiba A50 with graphics adapter described by

00:02.0 VGA compatible controller [0300]: Intel Corporation 4th Gen Core
Processor Integrated Graphics Controller [8086:0416] (rev 06) gets the following
warning on 3.17-rc1:


[ 1271.563533] ------------[ cut here ]------------
[ 1271.563568] WARNING: CPU: 1 PID: 1050 at
drivers/gpu/drm/i915/intel_display.c:1234 assert_cursor.constprop.79+0x99/0xa0
[i915]()
[ 1271.563571] cursor on pipe A assertion failure (expected off, current on)
[ 1271.563573] Modules linked in: ctr ccm fuse nfs bnep bluetooth af_packet
fscache arc4 x86_pkg_temp_thermal kvm_intel iwlmvm kvm mac80211 crct10dif_pclmul
crc32_pclmul crc32c_intel snd_hda_codec_generic i915 snd_hda_intel
ghash_clmulni_intel aesni_intel aes_x86_64 snd_hda_controller lrw gf128mul
snd_hda_codec glue_helper iwlwifi ablk_helper rtsx_pci_sdmmc cryptd snd_hwdep
snd_pcm rtsx_pci_ms memstick mmc_core snd_seq acpi_cpufreq cfg80211
drm_kms_helper processor drm microcode pcspkr serio_raw thermal video
thermal_sys sr_mod cdrom lpc_ich snd_seq_device snd_timer rfkill rtsx_pci
mfd_core snd soundcore e1000e i2c_algo_bit hwmon ptp pps_core wmi xhci_hcd ac
battery button sg dm_mod autofs4
[ 1271.563659] CPU: 1 PID: 1050 Comm: Xorg Not tainted 3.17.0-rc1+ #9
[ 1271.563661] Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20
  04/17/2014
[ 1271.563664]  0000000000000009 ffff8800c72f7aa8 ffffffff816a009b ffff8800c72f7af0
[ 1271.563670]  ffff8800c72f7ae0 ffffffff8105bdfd 0000000000000000 0000000000000000
[ 1271.563675]  0000000000000003 ffff8800c6741000 ffff8800c6741000 ffff8800c72f7b40
[ 1271.563681] Call Trace:
[ 1271.563688]  [<ffffffff816a009b>] dump_stack+0x4d/0x6f
[ 1271.563695]  [<ffffffff8105bdfd>] warn_slowpath_common+0x7d/0xa0
[ 1271.563699]  [<ffffffff8105be6c>] warn_slowpath_fmt+0x4c/0x50
[ 1271.563720]  [<ffffffffa04d2029>] assert_cursor.constprop.79+0x99/0xa0 [i915]
[ 1271.563737]  [<ffffffffa04d4cb9>] intel_enable_pipe+0x49/0x1f0 [i915]
[ 1271.563757]  [<ffffffffa04dd806>] haswell_crtc_enable+0x486/0xa80 [i915]
[ 1271.563774]  [<ffffffffa04d9662>] __intel_set_mode+0x822/0xac0 [i915]
[ 1271.563793]  [<ffffffffa04e1246>] intel_set_mode+0x16/0x30 [i915]
[ 1271.563811]  [<ffffffffa04e221c>] intel_crtc_set_config+0x92c/0xe70 [i915]
[ 1271.563828]  [<ffffffffa018e727>] drm_mode_set_config_internal+0x67/0xf0 [drm]
[ 1271.563843]  [<ffffffffa019304c>] drm_mode_setcrtc+0xdc/0x590 [drm]
[ 1271.563855]  [<ffffffffa0185016>] drm_ioctl+0x1a6/0x640 [drm]
[ 1271.563862]  [<ffffffff811ebf15>] ? __fget+0x5/0xe0
[ 1271.563867]  [<ffffffff811e0f40>] do_vfs_ioctl+0x300/0x520
[ 1271.563871]  [<ffffffff811ebfbd>] ? __fget+0xad/0xe0
[ 1271.563876]  [<ffffffff811ebf15>] ? __fget+0x5/0xe0
[ 1271.563880]  [<ffffffff811e11e1>] SyS_ioctl+0x81/0xa0
[ 1271.563887]  [<ffffffff816a93d2>] system_call_fastpath+0x16/0x1b
[ 1271.563889] ---[ end trace 2327ac1a479ad52b ]---


Larry
