Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaDTM0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:26:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33472 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbaDTM01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:26:27 -0400
Date: Sun, 20 Apr 2014 14:26:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Christian =?utf-8?B?S8O2bmln?= <deathsimple@vodafone.de>,
        Alex Deucher <alexdeucher@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: more radeon fun: uvd this time
Message-ID: <20140420122621.GE19667@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

while we're on the topic, I'm seeing this on an older F14h laptop
(E-350). I'm guessing the UVD won't get up on that machine, maybe we
want to tone down the output a bit. I mean, for your sake, before it
hits a release and people flood you with bug reports.

:-)

[    1.448294] [drm] Initialized drm 1.1.0 20060810
[   11.669812] [drm] radeon kernel modesetting enabled.
[   11.676972] [drm] initializing kernel modesetting (PALM 0x1002:0x9802 0x17AA:0x21EC).
[   11.677301] [drm] register mmio base: 0xF0300000
[   11.677426] [drm] register mmio size: 262144
[   11.678243] [drm] Detected VRAM RAM=384M, BAR=256M
[   11.678321] [drm] RAM width 32bits DDR
[   11.681367] [drm] radeon: 384M of VRAM memory ready
[   11.681520] [drm] radeon: 1024M of GTT memory ready.
[   11.681751] [drm] Loading PALM Microcode
[   11.981767] [drm] Internal thermal controller without fan control
[   11.982742] [drm] Found smc ucode version: 0x00010601
[   11.983189] [drm] radeon: dpm initialized
[   12.011690] [drm] GART: num cpu pages 262144, num gpu pages 262144
[   12.096379] [drm] PCIE GART of 1024M enabled (table at 0x0000000000273000).
[   12.116168] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   12.116356] [drm] Driver supports precise vblank timestamp query.
[   12.117470] [drm] radeon: irq initialized.
[   12.186579] [drm] ring test on 0 succeeded in 0 usecs
[   12.186826] [drm] ring test on 3 succeeded in 1 usecs
[   14.029987] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   15.084697] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   16.098856] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   17.110795] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   18.122720] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   19.134692] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   20.146596] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   21.158570] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   22.171389] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   23.184846] [drm:uvd_v1_0_start] *ERROR* UVD not responding, trying to reset the VCPU!!!
[   23.204904] [drm:uvd_v1_0_start] *ERROR* UVD not responding, giving up!!!
[   23.224948] [drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1).
[   23.226911] [drm] ib test on ring 0 succeeded in 0 usecs
[   23.227165] [drm] ib test on ring 3 succeeded in 0 usecs
[   23.284404] [drm] radeon atom DIG backlight initialized
[   23.284625] [drm] Radeon Display Connectors
[   23.284772] [drm] Connector 0:
[   23.284917] [drm]   LVDS-1
[   23.285057] [drm]   HPD1
[   23.285200] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[   23.285390] [drm]   Encoders:
[   23.285531] [drm]     LCD1: INTERNAL_UNIPHY
[   23.285675] [drm] Connector 1:
[   23.285817] [drm]   HDMI-A-1
[   23.285957] [drm]   HPD2
[   23.286098] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[   23.286287] [drm]   Encoders:
[   23.286428] [drm]     DFP1: INTERNAL_UNIPHY
[   23.286571] [drm] Connector 2:
[   23.286713] [drm]   VGA-1
[   23.286855] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[   23.287044] [drm]   Encoders:
[   23.287184] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   23.720985] [drm] fb mappable at 0xE0477000
[   23.721185] [drm] vram apper at 0xE0000000
[   23.721318] [drm] size 4325376
[   23.721400] [drm] fb depth is 24
[   23.721482] [drm]    pitch is 5632
[   23.725697] fbcon: radeondrmfb (fb0) is primary device
[   24.296791] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[   24.299140] [drm] Initialized radeon 2.38.0 20080528 for 0000:00:01.0 on minor 0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
