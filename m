Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab3L1UBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 15:01:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52795 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab3L1UBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 15:01:08 -0500
X-Sasl-enc: a0o9+d951hDzx/ot0DI6/PRkBzjId6/hc4BRFtkpXDTv 1388260867
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"
Date: Sat, 28 Dec 2013 21:00:38 +0100
Message-Id: <1388260839-3873-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On my Acer 8510TZ, the backlight now turns off completely as soon as X
starts. I bisected the problem to ee1452d74584 "drm/i915: assume all GM45
Acer laptops use inverted backlight PWM", which says:

    There is plenty of evidence suggesting all of the GM45 based Acer
    laptops (including their eMachines and Packard Bell brands) use inverted
    backlight PWM. Assume this is really the case, and quirk them all.

It seems mine is the exception to the rule :-/.

The revert patch of ee1452d74584 on top of Linus' current tree (the reply
to this cover letter) makes it all work as before. The lspci output added
below. Ask if you need more info and/or testing.

Greetings,
    Alexander


The bisect log
--------------
git bisect start
# good: [31d141e3a666269a3b6fcccddb0351caf7454240] Linux 3.12-rc6
git bisect good 31d141e3a666269a3b6fcccddb0351caf7454240
# bad: [f41bfc9423aac4e589d2b3bedf26b3c249c61146] Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect bad f41bfc9423aac4e589d2b3bedf26b3c249c61146
# good: [42a2d923cc349583ebf6fdd52a7d35e1c2f7e6bd] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good 42a2d923cc349583ebf6fdd52a7d35e1c2f7e6bd
# bad: [0bde7294e2ada03d0f1cc61cec51274081d9a9cf] Merge tag 'pwm/for-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm
git bisect bad 0bde7294e2ada03d0f1cc61cec51274081d9a9cf
# good: [d8fe4acc88da8fbbe360b6592c9d0abbb85117dc] Merge branch 'akpm' (patch-bomb from Andrew Morton)
git bisect good d8fe4acc88da8fbbe360b6592c9d0abbb85117dc
# bad: [8d0a2215931f1ffd77aef65cae2c0becc3f5d560] Merge branch 'drm-next-3.13' of git://people.freedesktop.org/~agd5f/linux into drm-next
git bisect bad 8d0a2215931f1ffd77aef65cae2c0becc3f5d560
# bad: [7cd6ccff85a13a8e5755cffa50129032d83c7c72] drm/i915: Add log messages when CRCs collection is started/stopped
git bisect bad 7cd6ccff85a13a8e5755cffa50129032d83c7c72
# bad: [65427b1e94eca5923e0f723d1dd000f47e6d1696] drm: Remove synth_clock from struct drm_display_mode
git bisect bad 65427b1e94eca5923e0f723d1dd000f47e6d1696
# good: [5113bc9b2357bbfe64c8c36bb05dad3eeeabd166] drm/i915: Document the inteded use of requested_mode
git bisect good 5113bc9b2357bbfe64c8c36bb05dad3eeeabd166
# bad: [311a20949f047a70935d6591010f42336f5402e7] drm/i915: don't init DP or HDMI when not supported by DDI port
git bisect bad 311a20949f047a70935d6591010f42336f5402e7
# good: [a2b23fe04e183ef58ed45183e39dbc696f9600b1] drm/i915/vlv: honor i915_enable_rc6 boot param on VLV
git bisect good a2b23fe04e183ef58ed45183e39dbc696f9600b1
# bad: [b599c89e8c5cf0c37352e0871be240291f8ce922] Merge tag 'v3.12-rc2' into drm-intel-next
git bisect bad b599c89e8c5cf0c37352e0871be240291f8ce922
# good: [6765625e0b677a86dbd533f045ab4e52e2761d79] drm/i915: Add intel_display_power_{get, put} to request power for specific domains
git bisect good 6765625e0b677a86dbd533f045ab4e52e2761d79
# good: [d6317290bfd8673d1cf3b6f8a12c72b3297eac36] drm/i915: Pull intel_init_power_well() out of intel_modeset_init_hw()
git bisect good d6317290bfd8673d1cf3b6f8a12c72b3297eac36
# bad: [ee1452d7458451a7508e0663553ce88d63958157] drm/i915: assume all GM45 Acer laptops use inverted backlight PWM
git bisect bad ee1452d7458451a7508e0663553ce88d63958157


lspci -vmmnn
------------
Slot:	00:00.0
Class:	Host bridge [0600]
Vendor:	Intel Corporation [8086]
Device:	Mobile 4 Series Chipset Memory Controller Hub [2a40]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	07

Slot:	00:02.0
Class:	VGA compatible controller [0300]
Vendor:	Intel Corporation [8086]
Device:	Mobile 4 Series Chipset Integrated Graphics Controller [2a42]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	07

Slot:	00:02.1
Class:	Display controller [0380]
Vendor:	Intel Corporation [8086]
Device:	Mobile 4 Series Chipset Integrated Graphics Controller [2a43]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	07

Slot:	00:1a.0
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB UHCI Controller #4 [2937]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1a.1
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB UHCI Controller #5 [2938]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1a.7
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB2 EHCI Controller #2 [293c]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03
ProgIf:	20

Slot:	00:1b.0
Class:	Audio device [0403]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) HD Audio Controller [293e]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1c.0
Class:	PCI bridge [0604]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) PCI Express Port 1 [2940]
Rev:	03

Slot:	00:1c.1
Class:	PCI bridge [0604]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) PCI Express Port 2 [2942]
Rev:	03

Slot:	00:1d.0
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB UHCI Controller #1 [2934]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1d.1
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB UHCI Controller #2 [2935]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1d.2
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB UHCI Controller #3 [2936]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1d.3
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB UHCI Controller #6 [2939]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1d.7
Class:	USB controller [0c03]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) USB2 EHCI Controller #1 [293a]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03
ProgIf:	20

Slot:	00:1e.0
Class:	PCI bridge [0604]
Vendor:	Intel Corporation [8086]
Device:	82801 Mobile PCI Bridge [2448]
Rev:	93
ProgIf:	01

Slot:	00:1f.0
Class:	ISA bridge [0601]
Vendor:	Intel Corporation [8086]
Device:	ICH9M-E LPC Interface Controller [2917]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1f.2
Class:	SATA controller [0106]
Vendor:	Intel Corporation [8086]
Device:	82801IBM/IEM (ICH9M/ICH9M-E) 4 port SATA Controller [AHCI mode] [2929]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03
ProgIf:	01

Slot:	00:1f.3
Class:	SMBus [0c05]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) SMBus Controller [2930]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	00:1f.6
Class:	Signal processing controller [1180]
Vendor:	Intel Corporation [8086]
Device:	82801I (ICH9 Family) Thermal Subsystem [2932]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	03

Slot:	01:00.0
Class:	Ethernet controller [0200]
Vendor:	Qualcomm Atheros [1969]
Device:	AR8131 Gigabit Ethernet [1063]
SVendor:	Acer Incorporated [ALI] [1025]
SDevice:	Device [022b]
Rev:	c0

Slot:	02:00.0
Class:	Network controller [0280]
Vendor:	Intel Corporation [8086]
Device:	Centrino Wireless-N 1000 [Condor Peak] [0083]
SVendor:	Intel Corporation [8086]
SDevice:	Centrino Wireless-N 1000 BGN [1305]

-- 
1.8.3.2

