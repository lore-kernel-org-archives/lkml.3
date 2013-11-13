Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3KMT6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:58:53 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:57490 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3KMT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:58:44 -0500
To: Borislav Petkov <bp@alien8.de>
Subject: Re: kernel 3.11.6 general protection fault
Content-Disposition: inline
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
Date: Wed, 13 Nov 2013 20:58:29 +0100
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201311132058.30310.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry it replys automaticaly only to the sender - now added the list)

What do the intel-gfx people think?

====== original mail follows =======
Hi sorry for bothering you once again. 

I noticed most of the issues are coming from drm (I have the stupid "Intel 
Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics 
Controller (rev 03)")

So I checked today the logs again and found out it crashed in the mornign when 
turning on the notebook in the office.

Is there something you can conclude from the trace below and another 
question - why is it checking CRTC as I have LVDS, VGA1 and DVI1 - actually 
using only the LVDS and DVI outputs

Thanks again for taking your time



Nov 13 09:36:21 maistor kernel: [   40.447271] ------------[ cut 
here ]------------
Nov 13 09:36:21 maistor kernel: [   40.447311] WARNING: CPU: 1 PID: 4142 at 
drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5cf/0xa60 [i915]
()
Nov 13 09:36:21 maistor kernel: [   40.447313] pipe state doesn't match!
Nov 13 09:36:21 maistor kernel: [   40.447315] Modules linked in: snd_hrtimer 
acpi_pad sbs sbshc fan binfmt_misc uinput fuse af_packet ipv6 firewire_sbp2 
snd
_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss 
snd_pcm snd_page_alloc snd_seq_dummy snd_seq_oss snd_seq_midi 
snd_seq_midi_eve
nt snd_rawmidi snd_seq snd_seq_device snd_timer arc4 iTCO_wdt snd gpio_ich 
iwl3945 dell_wmi sparse_keymap i2c_i801 iTCO_vendor_support ehci_pci iwlegacy 
mac8
0211 cfg80211 soundcore rfkill dell_laptop lpc_ich yenta_socket pcmcia_rsrc 
irda 8250 evdev wmi processor dcdbas rtc_cmos battery crc_ccitt ac joydev 
sha256_
ssse3 sha256_generic cbc hid_generic usbhid hid loop dm_crypt dm_mod sg b44 
sr_mod cdrom ssb i915 cfbfillrect cfbimgblt mmc_core mii pcmcia pcmcia_core 
uhci_
hcd i2c_algo_bit cfbcopyarea firewire_ohci video backlight firewire_core 
crc_itu_t drm_kms_helper drm ehci_hcd sd_mod i2c_core thermal thermal_sys 
freq_table
 usbcore usb_common button intel_agp intel_gtt agpgart
Nov 13 09:36:21 maistor kernel: [   40.447384] CPU: 1 PID: 4142 Comm: Xorg 
Tainted: P             3.11.6eko2 #3
Nov 13 09:36:21 maistor kernel: [   40.447386] Hardware name: Dell Inc. 
Latitude D520                   /0NF743, BIOS A04 12/18/2006
Nov 13 09:36:21 maistor kernel: [   40.447388]  0000000000000000 
0000000000000009 ffffffff813ce8ab ffff880079c8f888
Nov 13 09:36:21 maistor kernel: [   40.447392]  ffffffff81038001 
ffff88007a2596d8 ffff880079c8f900 ffff880037f3a000
Nov 13 09:36:21 maistor kernel: [   40.447395]  0000000000000001 
ffff880037f3a488 ffffffff810380e5 ffffffffa0295531
Nov 13 09:36:21 maistor kernel: [   40.447398] Call Trace:
Nov 13 09:36:21 maistor kernel: [   40.447407]  [<ffffffff813ce8ab>] ? 
dump_stack+0x41/0x51
Nov 13 09:36:21 maistor kernel: [   40.447412]  [<ffffffff81038001>] ? 
warn_slowpath_common+0x81/0xb0
Nov 13 09:36:21 maistor kernel: [   40.447415]  [<ffffffff810380e5>] ? 
warn_slowpath_fmt+0x45/0x50
Nov 13 09:36:21 maistor kernel: [   40.447427]  [<ffffffffa024338f>] ? 
check_crtc_state+0x5cf/0xa60 [i915]
Nov 13 09:36:21 maistor kernel: [   40.447440]  [<ffffffffa024db7d>] ? 
intel_modeset_check_state+0x2bd/0x730 [i915]
Nov 13 09:36:21 maistor kernel: [   40.447445]  [<ffffffff811ec219>] ? 
snprintf+0x39/0x40
Nov 13 09:36:21 maistor kernel: [   40.447456]  [<ffffffffa024e05d>] ? 
intel_set_mode+0x1d/0x30 [i915]
Nov 13 09:36:21 maistor kernel: [   40.447467]  [<ffffffffa024e81a>] ? 
intel_crtc_set_config+0x7aa/0x980 [i915]
Nov 13 09:36:21 maistor kernel: [   40.447481]  [<ffffffffa00f9155>] ? 
drm_mode_set_config_internal+0x55/0xd0 [drm]
Nov 13 09:36:21 maistor kernel: [   40.447490]  [<ffffffffa00fb118>] ? 
drm_mode_setcrtc+0x118/0x640 [drm]
Nov 13 09:36:21 maistor kernel: [   40.447497]  [<ffffffffa00ec11d>] ? 
drm_ioctl+0x4ed/0x5f0 [drm]
Nov 13 09:36:21 maistor kernel: [   40.447507]  [<ffffffffa00fb000>] ? 
drm_mode_setplane+0x3a0/0x3a0 [drm]
Nov 13 09:36:21 maistor kernel: [   40.447512]  [<ffffffff8111428b>] ? 
do_vfs_ioctl+0x8b/0x520
Nov 13 09:36:21 maistor kernel: [   40.447515]  [<ffffffff8111476d>] ? 
SyS_ioctl+0x4d/0xa0
Nov 13 09:36:21 maistor kernel: [   40.447519]  [<ffffffff813d4c56>] ? 
system_call_fastpath+0x1a/0x1f
Nov 13 09:36:21 maistor kernel: [   40.447521] ---[ end trace 
307df46ce6dc8ed1 ]---
