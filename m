Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaENVqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:46:12 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:48307 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaENVqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:46:07 -0400
From: stefan@agner.ch
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com, stefan@agner.ch
Subject: [PATCH v2 0/4] ARM: tegra: initial support for Colibri T30
Date: Wed, 14 May 2014 23:45:55 +0200
Message-Id: <cover.1400103181.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

This device tree cooked a while in our repository and is now quite
complete. All is tested on several Colibri T30 modules and
evaluation boards by Marcel and me. The device tree is splitted
into a module part and the carrier board. The former is then
included by the latter (in this case the evaluation board). The
comments "Colibri: " represent the SO-DIMM Pin name as defined
in the Colibri standard, and should be helpful for users
adopting the device tree for other carrier boards.

The second revision has one new patch which adds Toradex default
demo panels to the simple-panel driver. One could argue that those
panels are not actually part of the evaluation board, but when
customer build something with TFT panels they usually are integrated
into one system. Hence I descided to add them to the evaluation board
as well to have such a complete system, including TFT panel.

Note: Patch 1 is already applied!

Changes since v1:
- Extended with two TFT LCD panels from EDT
- Removed version specific compatible string and add modules compatible
  string in the carrier board file
- Removed serial alias and dr_mode property from USB controller
- Removed PMC status since this is enabled in tegra30.dtsi
- Lowered voltage of VDD_CPU to 1.15V again (tests were done with 1.15V)
- Added pinmux for lcd_m1 which makes data enable based panels working

Stefan Agner (3):
  ARM: tegra: enable MCP251x CAN controller and DS1307 RTC
  drm/panel: add support for EDT panels
  ARM: tegra: initial add of Colibri T30

 .../devicetree/bindings/panel/edt,et057090dhu.txt  |   7 +
 .../devicetree/bindings/panel/edt,et070080dh6.txt  |   7 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts      | 205 +++++++++++
 arch/arm/boot/dts/tegra30-colibri.dtsi             | 377 +++++++++++++++++++++
 arch/arm/configs/tegra_defconfig                   |   6 +
 drivers/gpu/drm/panel/panel-simple.c               |  52 +++
 7 files changed, 655 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/edt,et057090dhu.txt
 create mode 100644 Documentation/devicetree/bindings/panel/edt,et070080dh6.txt
 create mode 100644 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/tegra30-colibri.dtsi

-- 
1.9.2

