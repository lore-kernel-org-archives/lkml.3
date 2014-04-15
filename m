Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaDOHCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:02:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34437 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbaDOHCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:02:07 -0400
Date: Tue, 15 Apr 2014 09:02:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: dri-devel@lists.freedesktop.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: 15-rc1: radeon modesetting fails
Message-ID: <20140415070204.GA4806@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

so I'm booting 15-rc1 + tip/master and around the time modesetting gets
initialized, the screen blanks and on it appears a message from the
monitors:

"The current input timing is not supported by the monitor display.
Please change your input timing to 1920x1200@60Hz or any other monitor
listed timing as per the monitor specifications."

The box is still responsive, I can reboot it with Ctrl-Alt-Del but
screens are blank.

If I boot with radeon.modeset=0, I see the normal nomodeset big letters
on the console and not very optimal screen resolution.

Diffing drm init chatter from dmesg shows only this:

--- /tmp/working        2014-04-15 08:40:21.979985352 +0200
+++ /tmp/b0rked 2014-04-15 08:40:11.983985364 +0200
@@ -44,4 +44,5 @@
 [drm]    pitch is 7680
 fbcon: radeondrmfb (fb0) is primary device
 radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
-[drm] Initialized radeon 2.37.0 20080528 for 0000:01:00.0 on minor 0
+[drm] Initialized radeon 2.38.0 20080528 for 0000:01:00.0 on minor 0
+

Below is the whole thing, btw.

Anyway, if you guys have any ideas, I'm all ears. Otherwise, would a quick
bisect on the 59 patches touching drivers/gpu/drm/radeon/ make sense?

git log --oneline v3.14.. drivers/gpu/drm/radeon/ | wc -l
59

Thanks.

[drm] Initialized drm 1.1.0 20060810
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RV635 0x1002:0x9598 0x1043:0x01DA).
[drm] register mmio base: 0xFEA20000
[drm] register mmio size: 65536
[drm] Detected VRAM RAM=512M, BAR=256M
[drm] RAM width 128bits DDR
[drm] radeon: 512M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Loading RV635 Microcode
[drm] Internal thermal controller without fan control
[drm] radeon: power management initialized
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] ring test on 0 succeeded in 0 usecs
[drm] ib test on ring 0 succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DVI-I-1
[drm]   HPD1
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 1:
[drm]   DIN-1
[drm]   Encoders:
[drm]     TV1: INTERNAL_KLDSCP_DAC2
[drm] Connector 2:
[drm]   DVI-I-2
[drm]   HPD2
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[drm] fb mappable at 0xC0141000
[drm] vram apper at 0xC0000000
[drm] size 9216000
[drm] fb depth is 24
[drm]    pitch is 7680
fbcon: radeondrmfb (fb0) is primary device
radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[drm] Initialized radeon 2.38.0 20080528 for 0000:01:00.0 on minor 0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
