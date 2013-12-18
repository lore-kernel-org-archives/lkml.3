Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3LRBil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:38:41 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42113 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LRBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:38:40 -0500
Date: Wed, 18 Dec 2013 01:38:35 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org
Subject: 3.13.0-rc4+: Warning at drivers/gpu/drm/i915/intel_display.c
Message-ID: <20131218013835.GA6448@rMBP.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been using an external monitor with my retina Macbook and sometimes I see
the warning below. I think it happens when I unplug the monitor from the
thunderbolt port (I use a converter to VGA).

[10906.327043] ------------[ cut here ]------------
[10906.327059] WARNING: CPU: 3 PID: 643 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:9212 intel_modeset_check_state+0x618/0x760()
[10906.327062] encoder's hw state doesn't match sw tracking (expected 1, found 0)
[ 7529.213883] waiting module removal not supported: please upgrade
[10906.327064] Modules linked in: b43 mac80211 cfg80211 ssb rfkill ctr ccm uvcvideo videobuf2_core videobuf2_vmalloc videobuf2_memops snd_hda_codec_hdmi snd_hda_codec_cirrus arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd_page_alloc bcm5974 rtc_cmos [last unloaded: ssb]
[10906.327094] CPU: 3 PID: 643 Comm: Xorg Not tainted 3.13.0-rc4+ #32
[10906.327096] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
[10906.327099]  0000000000000009 ffff880082d7bac8 ffffffff8169b7e1 0000000000000007
[10906.327105]  ffff880082d7bb18 ffff880082d7bb08 ffffffff8104d382 ffff880082d7bb18
[10906.327109]  0000000000000001 ffff880264618328 ffff880264618000 ffff8802600f0800
[10906.327114] Call Trace:
[10906.327123]  [<ffffffff8169b7e1>] dump_stack+0x4e/0x71
[10906.327131]  [<ffffffff8104d382>] warn_slowpath_common+0x82/0xb0
[10906.327135]  [<ffffffff8104d451>] warn_slowpath_fmt+0x41/0x50
[10906.327140]  [<ffffffff8142b478>] intel_modeset_check_state+0x618/0x760
[10906.327146]  [<ffffffff8142b5e0>] intel_set_mode+0x20/0x30
[10906.327151]  [<ffffffff8142bdcb>] intel_crtc_set_config+0x7db/0x9d0
[10906.327158]  [<ffffffff813e13ad>] drm_mode_set_config_internal+0x5d/0xe0
[10906.327163]  [<ffffffff813e391f>] drm_mode_setcrtc+0xff/0x590
[10906.327170]  [<ffffffff813d4a69>] drm_ioctl+0x509/0x630
[10906.327175]  [<ffffffff813e3820>] ? drm_mode_setplane+0x3b0/0x3b0
[10906.327181]  [<ffffffff811454ee>] do_vfs_ioctl+0x7e/0x510
[10906.327189]  [<ffffffff81134979>] ? ____fput+0x9/0x10
[10906.327193]  [<ffffffff81145a11>] SyS_ioctl+0x91/0xb0
[10906.327198]  [<ffffffff81133ddd>] ? SyS_writev+0x4d/0xc0
[10906.327204]  [<ffffffff816a43e6>] system_call_fastpath+0x1a/0x1f
[10906.327207] ---[ end trace 1d89c5dbe70372e7 ]---
[10906.327235] [drm:intel_pipe_config_compare] *ERROR* mismatch in has_dp_encoder (expected 1, found 0)
[10906.327236] ------------[ cut here ]------------
[10906.327242] WARNING: CPU: 3 PID: 643 at /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:9285 check_crtc_state+0x225/0x300()
[10906.327244] pipe state doesn't match!
[10906.327245] Modules linked in: b43 mac80211 cfg80211 ssb rfkill ctr ccm uvcvideo videobuf2_core videobuf2_vmalloc videobuf2_memops snd_hda_codec_hdmi snd_hda_codec_cirrus arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd_page_alloc bcm5974 rtc_cmos [last unloaded: ssb]
[10906.327265] CPU: 3 PID: 643 Comm: Xorg Tainted: G        W    3.13.0-rc4+ #32
[10906.327267] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B01.1208311637 08/31/2012
[10906.327269]  0000000000000009 ffff880082d7b7f8 ffffffff8169b7e1 0000000000000007
[10906.327273]  ffff880082d7b848 ffff880082d7b838 ffffffff8104d382 ffff880082d7b810
[10906.327277]  ffff8802601746e0 ffff880082d7b8d8 ffff880264618000 ffff880260174000
[10906.327281] Call Trace:
[10906.327285]  [<ffffffff8169b7e1>] dump_stack+0x4e/0x71
[10906.327289]  [<ffffffff8104d382>] warn_slowpath_common+0x82/0xb0
[10906.327293]  [<ffffffff8104d451>] warn_slowpath_fmt+0x41/0x50
[10906.327298]  [<ffffffff8141d8d5>] check_crtc_state+0x225/0x300
[10906.327305]  [<ffffffff810a6ccd>] ? __module_text_address+0xd/0x60
[10906.327312]  [<ffffffff8142b105>] intel_modeset_check_state+0x2a5/0x760
[10906.327318]  [<ffffffff8142b5e0>] intel_set_mode+0x20/0x30
[10906.327323]  [<ffffffff8142bdcb>] intel_crtc_set_config+0x7db/0x9d0
[10906.327328]  [<ffffffff813e13ad>] drm_mode_set_config_internal+0x5d/0xe0
[10906.327333]  [<ffffffff813e391f>] drm_mode_setcrtc+0xff/0x590
[10906.327338]  [<ffffffff813d4a69>] drm_ioctl+0x509/0x630
[10906.327343]  [<ffffffff813e3820>] ? drm_mode_setplane+0x3b0/0x3b0
[10906.327347]  [<ffffffff811454ee>] do_vfs_ioctl+0x7e/0x510
[10906.327352]  [<ffffffff81134979>] ? ____fput+0x9/0x10
[10906.327356]  [<ffffffff81145a11>] SyS_ioctl+0x91/0xb0
[10906.327361]  [<ffffffff81133ddd>] ? SyS_writev+0x4d/0xc0
[10906.327365]  [<ffffffff816a43e6>] system_call_fastpath+0x1a/0x1f
[10906.327368] ---[ end trace 1d89c5dbe70372e8 ]---

My config contains these options

CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y

and I should be able to upload the full config somewhere if necessary.

I'm happy to provide any other information.
