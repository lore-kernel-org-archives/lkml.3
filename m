Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3K0LAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:00:00 -0500
Received: from ares07.inai.de ([5.9.24.206]:54125 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab3K0K76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:59:58 -0500
Date: Wed, 27 Nov 2013 11:59:56 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: i915: pipe state still does not match
Message-ID: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.


Despite the i915/drm fixes added in v3.11.8, the X server still 
terminates due to some pipe state bug in 3.11.9.

I have a fb setup to span two crtcs in below's configuration,
and the kernel problem is easily triggerable for me by moving
an Xv window (such as by using mplayer) forth and back
between the two crtc.
The problem did not exist in 3.9.9.

> xrandr
Screen 0: minimum 320 x 200, current 1280 x 1624, maximum 32767 x 32767
LVDS1 connected primary 1024x600+0+1024 (normal left inverted right x axis y axis) 220mm x 129mm
   1024x600       60.0*+
   800x600        60.3     56.2  
   640x480        59.9  
VGA1 connected 1280x1024+0+0 (normal left inverted right x axis y axis) 376mm x 301mm
   1280x1024      60.0*+   75.0     72.0  
   1152x864       75.0  
   1024x768       75.1     70.1     60.0  
   832x624        74.6  
   800x600        72.2     75.0     60.3  
   640x480        75.0     72.8     66.7     60.0  
   720x400        70.1  
   640x350        70.1  
VIRTUAL1 disconnected (normal left inverted right x axis y axis)



[drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags (expected 4, found 0)
------------[ cut here ]------------
WARNING: CPU: 1 PID: 714 at /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.9~jng20/linux-3.11/drivers/gpu/drm/i915/intel_display.c:8329 check_crtc_state+0x637/0x6a5 [i915]()
pipe state doesn't match!
Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_REJECT xt_tcpudp xt_owner xt_multiport xt_conntrack iptable_filter af_packet ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 cpufreq_conservative nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack xt_mark iptable_mangle ip_tables x_tables snd_hda_codec_realtek uvcvideo videobuf2_core snd_hda_intel snd_hda_codec snd_hwdep videodev snd_pcm_oss snd_pcm videobuf2_vmalloc iTCO_wdt jme gpio_ich coretemp snd_seq snd_timer pcspkr jmb38x_ms videobuf2_memops iTCO_vendor_support sdhci_pci lpc_ich memstick i2c_i801 snd_seq_device mii sdhci joydev mfd_core snd_mixer_oss led_class mmc_core serio_raw ata_generic acpi_cpufreq battery snd mperf ac shpchp soundcore snd_page_alloc sg tcp_veno sony_laptop rfkill autofs4
 btrfs raid6_pq zlib_deflate xor libcrc32c sha256_generic cbc hid_generic usbhid hid uhci_hcd ata_piix i915 drm_kms_helper ehci_pci ehci_hcd drm usbcore usb_common i2c_algo_bit i2c_core video intel_agp intel_gtt agpgart button processor thermal_sys hwmon scsi_dh_emc scsi_dh_alua scsi_dh_rdac scsi_dh_hp_sw scsi_dh dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod xts gf128mul aes_x86_64
CPU: 1 PID: 714 Comm: X Tainted: G        W    3.11.9-jng20-desktop #1
Hardware name: Sony Corporation VPCM11M1E/VAIO, BIOS R0090Z4 01/23/2010
 0000000000000000 ffffffff8141925d ffff88003b5d1788 ffffffff8103ba85
 ffffffffa01a689b ffff880037462000 ffff88003b5d17d8 ffff88003b5d1800
 ffff8800374626d0 ffffffff8103bae1 ffffffffa01e97bb ffffffff00000018
Call Trace:
 [<ffffffff810040d1>] dump_trace+0x8c/0x296
 [<ffffffff81004419>] show_stack_log_lvl+0x13e/0x14d
 [<ffffffff81005307>] show_stack+0x2f/0x31
 [<ffffffff8141925d>] dump_stack+0x50/0x89
 [<ffffffff8103ba85>] warn_slowpath_common+0x74/0x89
 [<ffffffff8103bae1>] warn_slowpath_fmt+0x47/0x49
 [<ffffffffa01a689b>] check_crtc_state+0x637/0x6a5 [i915]
 [<ffffffffa01af812>] intel_modeset_check_state+0x37e/0x604 [i915]
 [<ffffffffa01afaeb>] intel_set_mode+0x1b/0x22 [i915]
 [<ffffffffa01b01e1>] intel_crtc_set_config+0x612/0x789 [i915]
 [<ffffffffa00e56ab>] drm_mode_set_config_internal+0x44/0xac [drm]
 [<ffffffffa014fea9>] drm_fb_helper_set_par+0x55/0x98 [drm_kms_helper]
 [<ffffffff812583eb>] fb_set_var+0x250/0x33b
 [<ffffffff812613a2>] fbcon_blank+0x75/0x1c0
 [<ffffffff812c5b50>] do_unblank_screen+0xca/0x136
 [<ffffffff812be1dc>] vt_ioctl+0x4d5/0xf28
 [<ffffffff812b63db>] tty_ioctl+0x910/0x976
 [<ffffffff8113461b>] vfs_ioctl+0x1b/0x28
 [<ffffffff81134d37>] do_vfs_ioctl+0x32d/0x3e8
 [<ffffffff81134e40>] SyS_ioctl+0x4e/0x7e
 [<ffffffff814232ad>] system_call_fastpath+0x1a/0x1f
 [<00007fe31322a1e7>] 0x7fe31322a1e6
---[ end trace 36d598c7e5fa5f63 ]---
