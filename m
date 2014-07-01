Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbaGANE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:04:56 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34571 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaGANEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:04:49 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Marvell Dove DRM for DT
Date: Tue,  1 Jul 2014 15:04:27 +0200
Message-Id: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Russell we have Armada DRM driver but currently DT support
for it is stalled in various discussions/improvements. We know there
are issues with the whole DRM chain (si5351,lcd,tda998x) that are not
easy to track down. To get at least some more code testing coverage,
this patch set picks up some patches from Russell slightly reworked
to allow Dove DT to register and use Armada DRM.

The approach taken is based on what we did in the past for mach-dove
to mach-mvebu/dove conversion: platform_devices are registered like
it was before DT and quirks are added to allow to register the
corresponsing device properly. Then we start removing each of the
quirks incrementally.

Russell currently has a quite huge gap [1,2,3] between his branch and
mainline Linux, so this is a tiny step forward to closen the gap and
free some of his time for more controversal discussion. Also, it will
allow us to participate in those discussions as we'll be able to test
them more easily.

Patches 1-3 add DT binding docs and corresponding nodes for the
LCD controllers found on Marvell Dove SoCs. The binding itself is
considered stable and not likely to change in the future.

Patch 4 then adds above platform_device registration for DRM driver
to Dove DT based setup. Currently, we require to steal some CMA mem
for the framebuffers, collect lcd resources, and clocks from
different nodes. As soon as DT for DRM driver and component framework
have settled, we can remove the quirks again.

Patches are based on v3.16-rc1 and have been tested on DT SolidRun
CuBox.

Sebastian

[1] http://lkml.kernel.org/r/20140630142516.GA32514@n2100.arm.linux.org.uk
[2] http://lkml.kernel.org/r/20140630165615.GE32514@n2100.arm.linux.org.uk
[3] http://lkml.kernel.org/r/20140630193540.GG32514@n2100.arm.linux.org.uk

Russell King (4):
  dt-bindings: add Marvell Dove LCD controller documentation
  ARM: dts: dove: add DT LCD controllers
  ARM: dts: dove: enable lcd0 on SolidRun CuBox
  ARM: mvebu: add armada drm init to Dove board setup

 .../bindings/drm/armada/marvell,dove-lcd.txt       |   14 ++++
 arch/arm/boot/dts/dove-cubox.dts                   |    6 ++
 arch/arm/boot/dts/dove.dtsi                        |   14 ++++
 arch/arm/mach-mvebu/dove.c                         |   70 +++++++++++++++++++-
 4 files changed, 103 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/armada/marvell,dove-lcd.txt

---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

