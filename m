Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3ILSfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:35:45 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43013 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3ILSfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:35:42 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-kernel@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH v4 0/2] ARM: dts: Beaglebone MMC fixes
Date: Thu, 12 Sep 2013 20:35:31 +0200
Message-Id: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
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
+ 564fc88cc64387af5312e2abd8019c75a13223b2 ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
+ e5133ed98acc1c3e01c370b851041a8ca629cd15 ARM: EDMA: Fix clearing of unused list for DT DMA resources
+ ac71bb58605d3bdd5d14af770a639fb3ff11c612 ARM: dts: add AM33XX EDMA support
+ 31a8270a299c57c7de7510f44d9dc36fd1787243 ARM: dts: add AM33XX SPI DMA support
+ 4fa0a4cb9ea17da30cf43085c03e5ec1361a4fc2 ARM: dts: add AM33XX MMC support and documentation
+ 0553f50bd45f019a0cc11050e2f20bddbf07dfe0 ARM: dts: am335x-bone: add CD for mmc1
+ 7d64f765630a2921a63b82f93f9959a6de37f29d ARM: dts: am335x-boneblack: add eMMC DT entry
+ dc96cd4003e2668d8ec7e7fe19e402e97a198f81 ARM: dts: am335x-bone-common: switch mmc1 to 4-bit mode
+ f8262e78830cda56c936724549ba9f04dddde312 ARM: dts: am335x-bone-common: add cpu0 and mmc1 triggers

Also available as a git branch at https://github.com/koenkooi/linux/commits/mainline

Changes since v3:
	Addressed Nishants nitpicks for commit messages
	Addressed Russ' comments about moving LDO3 for mmc1 out of the common dtsi

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
 arch/arm/boot/dts/am335x-bone.dts         |  1 -
 arch/arm/boot/dts/am335x-boneblack.dts    | 14 +++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)

-- 
1.8.2.1
