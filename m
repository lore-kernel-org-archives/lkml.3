Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab3HNQC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:02:58 -0400
Received: from mail2.unitix.de ([176.9.2.175]:60124 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3HNQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:02:57 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2013 12:02:56 EDT
Message-ID: <520BA834.1020207@arndnet.de>
Date: Wed, 14 Aug 2013 17:54:28 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: daniel.vetter@ffwll.ch
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: 3.11.0-rc5: WARNING: at drivers/gpu/drm/i915/intel_display.c:8286
 check_crtc_state
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when changing the refresh rate of my laptop display with xrandr on 3.11.0-rc5, like:
xrandr --output LVDS1 --rate 59.9 --mode 1920x1080

The following WARNING is generated:

[   50.018055] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags (expected 1, found 0)
[   50.018060] ------------[ cut here ]------------
[   50.018105] WARNING: CPU: 0 PID: 1819 at /home/arnd/Projekte/kernel/linux-2.6/drivers/gpu/drm/i915/intel_display.c:8286 check_crtc_state+0x59f/0xa30 [i915]()
[   50.018106] pipe state doesn't match!
[   50.018107] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables joydev deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 bridge stp llc serpent_sse2_x86_64 serpent_generic ablk_helper cryptd xts lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cmac xcbc rmd160 sha512_generic dm_crypt crypto_null af_key xfrm_algo arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm dm_multipath snd_page_alloc snd_seq_midi snd_seq_midi_event uvcvideo videobuf2_vmalloc thinkpad_acpi videobuf2_memops snd_rawmidi videobuf2_core nvram videodev media snd_seq snd_seq_device snd_timer psmouse se
 rio_raw q
cserial usb_wwan usbserial intel_ips tpm_tis snd btusb bnep iwlwifi lpc_ich rfcomm bluetooth cfg80211 soundcore binfmt_misc btrfs xor zlib_deflate raid6_pq libcrc32c mmc_block mxm_wmi firewire_ohci firewire_core crc_itu_t wmi i915 video i2c_algo_bit drm_kms_helper drm e1000e sdhci_pci ptp sdhci ahci pps_core libahci
[   50.018156] CPU: 0 PID: 1819 Comm: Xorg Not tainted 3.11.0-rc5aha+ #3
[   50.018157] Hardware name: LENOVO 4384GEG/4384GEG, BIOS 6MET86WW (1.46 ) 05/24/2011
[   50.018159]  0000000000000009 ffff880223b39870 ffffffff81633b7d ffff880223b398b8
[   50.018160]  ffff880223b398a8 ffffffff8104a69c ffff8802322fc6d0 0000000000000001
[   50.018162]  ffff88022d99d000 ffff8802322fc000 ffff88022d99d478 ffff880223b39908
[   50.018164] Call Trace:
[   50.018172]  [<ffffffff81633b7d>] dump_stack+0x45/0x56
[   50.018177]  [<ffffffff8104a69c>] warn_slowpath_common+0x8c/0xc0
[   50.018178]  [<ffffffff8104a78c>] warn_slowpath_fmt+0x4c/0x50
[   50.018191]  [<ffffffffa011c68f>] check_crtc_state+0x59f/0xa30 [i915]
[   50.018204]  [<ffffffffa0127a4d>] intel_modeset_check_state+0x2cd/0x750 [i915]
[   50.018215]  [<ffffffffa0127f65>] intel_set_mode+0x25/0x30 [i915]
[   50.018225]  [<ffffffffa0128722>] intel_crtc_set_config+0x7b2/0x990 [i915]
[   50.018241]  [<ffffffffa009181d>] drm_mode_set_config_internal+0x5d/0xe0 [drm]
[   50.018250]  [<ffffffffa0093cdb>] drm_mode_setcrtc+0xfb/0x620 [drm]
[   50.018260]  [<ffffffffa011dfb2>] ? intel_crtc_load_lut+0xd2/0x190 [i915]
[   50.018267]  [<ffffffffa00843c9>] drm_ioctl+0x539/0x670 [drm]
[   50.018276]  [<ffffffffa0093be0>] ? drm_mode_setplane+0x3b0/0x3b0 [drm]
[   50.018282]  [<ffffffff81189bdc>] do_vfs_ioctl+0x8c/0x4f0
[   50.018284]  [<ffffffff8117a2a1>] ? __sb_end_write+0x31/0x60
[   50.018286]  [<ffffffff811785be>] ? vfs_write+0x17e/0x1e0
[   50.018288]  [<ffffffff8118a0d1>] SyS_ioctl+0x91/0xb0
[   50.018291]  [<ffffffff81642642>] system_call_fastpath+0x16/0x1b
[   50.018293] ---[ end trace d0d4c4e12439b0ce ]---

This is pretty reproducable on a newly booted system, and already present since
-rc1 or such. The update of the refresh rate seems to work nevertheless, though.

Best regards
Arnd
