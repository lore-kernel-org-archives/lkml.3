Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3LAP7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 10:59:48 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:52475 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LAP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 10:59:39 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
Cc: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 0/3] regulator: tps6586x: add version detection and voltage tables
Date: Sun,  1 Dec 2013 16:59:12 +0100
Message-Id: <cover.1385913227.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator: tps6586x: add version detection and voltage tables

This is the 2nd version of this patchset which adds version detection
for the tps6586x mfd family. This is required because some regulator
versions use different voltage tables. The regulator driver now uses
the right voltage table according to the version. Is it still posible
to see this patch in v3.13?

While at it, there are a few other incorrect regulator entries in the
device tree, change them accordingly (this patch is new and grew out
of a patch with the same name which Lucas Stach posted in July).

Tested on Colibri T20 V1.1 and V1.2 which makes use of diffent version
of that regulator.

Changes since v1:
  - Merged DT and driver change (preserves bisectability)
  - Use different regulator tables for different regulator version
    * This also makes the TPS6586X_ANY version needless
  - Replaced enum with defines
  - Move version message in a sperate function
  - Include regulator bugfix, use correct supply voltage
  - Checked all voltages, fix SM0/SM1 (Core/CPU) and LDO6 voltage (VDAC/VI)
    in another commit
  - Rebased on top of v3.13-rc2

Stefan Agner (3):
  mfd: tps6586x: add version detection
  regulator: tps6586x: add and use correct voltage table
  ARM: tegra: correct Colibri T20 regulator settings

 arch/arm/boot/dts/tegra20-colibri-512.dtsi | 34 ++++++------
 drivers/mfd/tps6586x.c                     | 47 +++++++++++++---
 drivers/regulator/tps6586x-regulator.c     | 89 +++++++++++++++++++++++-------
 include/linux/mfd/tps6586x.h               |  7 +++
 4 files changed, 132 insertions(+), 45 deletions(-)

-- 
1.8.4.2

