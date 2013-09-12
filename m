Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3ILPmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:42:23 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:50493 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3ILPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:42:21 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-kernel@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCHv3 0/2] ARM: dts: Beaglebone MMC fixes
Date: Thu, 12 Sep 2013 17:42:08 +0200
Message-Id: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two patches to fix MMC on beaglebone, one fixes card detect on BBW,
the other adds the eMMC entry for BBB and its fixed regulator. After that mmc1
gets a nice speed boost by moving to 4-bit mode and LED triggers get assigned.

This series depends on:

http://comments.gmane.org/gmane.linux.kernel.stable/63648
https://lkml.org/lkml/2013/9/10/454
http://comments.gmane.org/gmane.linux.kernel.mmc/22381

Or as git-cherry would put it:

[koen@rrMBP patches]$ git cherry -v
+ 53aafdbc63c9b30c23f562855c8f359c0893bc40 ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
+ 084f262cb1058e00cf082739cf7ee93cb70761c9 ARM: EDMA: Fix clearing of unused list for DT DMA resources
+ 6080eee0ef0ee3ab235cc267a69a0a7d3673266e ARM: dts: add AM33XX EDMA support
+ 7312f68fb49202b65498865bd64680c95ec2f7ea ARM: dts: add AM33XX SPI DMA support
+ 5580c3d400cefad5a1eb3c5a8e467353e22d526e ARM: dts: add AM33XX MMC support and documentation
+ a11eddaa0a89c24d2b9768a82519ac096bb793f1 arm: bone: dts: add CD for mmc1
+ b1e87bfc52775c2666b6c4a89d409193319d33f2 am335x-boneblack: add eMMC DT entry
+ 090e095b74ba211b2cfbd2c87ae06c52d151453d ARM: am335x-bone-common: switch mmc1 to 4-bit mode
+ 39f747078f0b01724cfa94ce19fd2e6029ac0bee ARM: dts: am335x-bone-common: add cpu0 and mmc1 triggers

Also available as a git branch at https://github.com/koenkooi/linux/commits/mainline

Changes since v2:
	Missing pinmux entries for eMMC added

Changes since v1:
	Removed ti,non-removable entry from eMMC node, see http://marc.info/?l=linux-arm-kernel&m=137889435710552&w=2
---

Alexander Holler (1):
  arm: bone: dts: add CD for mmc1

Koen Kooi (3):
  am335x-boneblack: add eMMC DT entry
  ARM: am335x-bone-common: switch mmc1 to 4-bit mode
  ARM: dts: am335x-bone-common: add cpu0 and mmc1 triggers

 arch/arm/boot/dts/am335x-bone-common.dtsi | 39 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts         |  4 ----
 arch/arm/boot/dts/am335x-boneblack.dts    | 14 +++++++++++
 3 files changed, 53 insertions(+), 4 deletions(-)

-- 
1.8.2.1

