Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHRO6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:58:50 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51527 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaHRO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:58:48 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, olof@lixom.net, arnd@arndb.de,
        jason@lakedaemon.net, thomas.petazzoni@free-electrons.com,
        swarren@nvidia.com, sebastian.hesselbarth@gmail.com, stefan@agner.ch,
        maxime.ripard@free-electrons.com, matthias.bgg@gmail.com,
        anders.berg@lsi.com, linus.walleij@linaro.org, lee.jones@linaro.org,
        heiko@sntech.de, srv_yingjoe.chen@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/9] arm: mediatek: Add more basic features
Date: Mon, 18 Aug 2014 16:58:28 +0200
Message-Id: <1408373917-10002-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds some minor changes to the Mediatek mt6589 support.

The most important patch enables the arm arch timer for mt6589. As already seen
on other vendor SoCs, to enable the arch timer we have to enable a SoC timer.
This should be normally done by the bootloader. As up to now no open source
bootloader exists for the mt6589, I added the functionality to the init_time
function.

Other features are low-level debugging on the mt6589, the addition to the
"make dtbs" and multi_v7_defconfig, as well as a small typo in the dtsi file.

The patch set is based on v3.17-rc1

Changes for v2:
- rebased on v3.17-rc1
- add patch for the compatible property of aquaris5
- add patch setting GIC compatible string to new "arm,cortex-a7-gic"
- set ARM arch timer frequency in DTS

--- 

Matthias Brugger (9):
  arm: dts: Build dtb for Mediatek board
  arm: multi_v7_defconfig: Enable Mediatek platform
  arm: dts: mt6589: Fix typo in GIC unit address
  arm: mediatek: Add earlyprintk support for mt6589
  arm: dts: mt6589-aquaris5: Add boot argument earlyprintk
  arm: mediatek: enable gpt6 on boot up to make arch timer working
  arm: dts: mt6589: Add arm arch timer node
  arm: dts: mediatek: Add compatible property for aquaris5
  arm: dts: mt6589: Change compatible string for GIC

 Documentation/devicetree/bindings/arm/mediatek.txt |    6 +++++
 arch/arm/Kconfig.debug                             |   10 ++++++++
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/mt6589-aquaris5.dts              |    5 ++++
 arch/arm/boot/dts/mt6589.dtsi                      |   17 ++++++++++---
 arch/arm/configs/multi_v7_defconfig                |    1 +
 arch/arm/mach-mediatek/mediatek.c                  |   26 ++++++++++++++++++++
 7 files changed, 62 insertions(+), 4 deletions(-)

-- 
1.7.9.5

