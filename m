Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3HRMc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 08:32:57 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:50369 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3HRMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 08:32:55 -0400
Message-ID: <5210BEEE.4090108@mni.thm.de>
Date: Sun, 18 Aug 2013 14:32:46 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:26.0) Gecko/20100101 Thunderbird/26.0a1
MIME-Version: 1.0
To: daniel.vetter@ffwll.ch
CC: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: I915 DRI_PRIME Bug Resend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,
while testing my "Optimus" Notebook i saw a stack trace in my logs, 
maybe someone is interested!
I can easily reproduce this any time. It happens when offloading a GL 
app, here Unigine Heaven 3.0 to the nvidia card. To be more exactly: 
When starting Unigine the window stays black. To get something useful i 
have to minimize and maximize the window. Exactly when maximizing the 
window the trace happens.

Hope this helps anyway!

------------[ cut here ]------------
WARNING: CPU: 7 PID: 718 at drivers/gpu/drm/i915/i915_gem.c:3967 
i915_gem_free_object+0x124/0x150 [i915]()
Modules linked in: af_packet bnep fuse snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec ath3k btusb bluetooth 
uvcvideo snd_hwdep videobuf2_core videodev videobuf2_vmalloc 
videobuf2_memops snd_pcm snd_seq snd_timer arc4 ath9k snd_seq_device 
mac80211 ath9k_common ath9k_hw ath snd iTCO_wdt sdhci_pci sdhci mmc_core 
sr_mod sg tg3 ptp pps_core iTCO_vendor_support cfg80211 lpc_ich i2c_i801 
pcspkr joydev acer_wmi sparse_keymap rfkill cdrom soundcore 
snd_page_alloc mperf battery ac autofs4 i915 xhci_hcd processor 
scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh nouveau ttm 
drm_kms_helper drm i2c_algo_bit mxm_wmi video thermal_sys wmi button
CPU: 7 PID: 718 Comm: Xorg Not tainted 3.11.0-rc5-desktop+ #27
Hardware name: Acer Aspire V3-571G/VA50_HC_CR, BIOS V1.13 10/09/2012
  0000000000000000 0000000000000009 ffffffff81568703 0000000000000000
  ffffffff81047f81 ffff88021cf1ab00 ffff88024f1d0000 ffff88025e421930
  ffff88021c7bcd40 ffff8802540f2da0 ffffffffa0210a44 ffff88021cf1ab00
Call Trace:
  [<ffffffff81568703>] ? dump_stack+0x50/0x80
  [<ffffffff81047f81>] ? warn_slowpath_common+0x81/0xb0
  [<ffffffffa0210a44>] ? i915_gem_free_object+0x124/0x150 [i915]
  [<ffffffffa02574d0>] ? i915_gem_dmabuf_release+0x80/0x90 [i915]
  [<ffffffff813761c3>] ? dma_buf_release+0x23/0x80
  [<ffffffff8113e4dd>] ? __fput+0xcd/0x230
  [<ffffffff81063167>] ? task_work_run+0x97/0xd0
  [<ffffffff81002ab9>] ? do_notify_resume+0x79/0xa0
  [<ffffffff8156f92a>] ? int_signal+0x12/0x17
---[ end trace 99a0c147e69ddcd1 ]---

Thanks,
Tobias Klausmann
