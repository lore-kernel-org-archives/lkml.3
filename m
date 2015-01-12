Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbALPex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:34:53 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:52196 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbALPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:34:51 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: wim@iguana.be, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, matthias.bgg@gmail.com,
        greta.zhang@mediatek.com, eddie.huang@mediatek.com, wens@csie.org,
        linux@roeck-us.net, joe@perches.com
Subject: [PATCH v4 0/2] ARM: mediatek: Add watchdog driver
Date: Mon, 12 Jan 2015 16:34:42 +0100
Message-Id: <1421076884-15860-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mediatek SoCs have a watchdog driver. This patch set adds driver and DTS
binding. The driver also implements a restart handler to reboot the SoC.

Changes for v4:
- fix indentation errors
- delete unused include
- reorganize while loop to eliminate code duplication
- eliminate indirection to watchdog_device structure
- delete unnecessary brackets

Changes for v3:
- fix based on file name
- fix style problems
- fix error return value and warning message
- delete unnecessary watchdog_set_drvdata
- delete unused variable

Changes for v2:
- we don't need to have the watchdog enabled to do a software reset
- disable dual mode and irq mode when starting the watchdog
- update commit message to name the SoCs the driver supports

Matthias Brugger (2):
  watchdog: Add driver for Mediatek watchdog
  ARM: mediatek: dts: Add bindings for watchdog

 .../devicetree/bindings/watchdog/mtk-wdt.txt       |  13 ++
 drivers/watchdog/Kconfig                           |  10 +
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/mtk_wdt.c                         | 252 +++++++++++++++++++++
 4 files changed, 276 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
 create mode 100644 drivers/watchdog/mtk_wdt.c

-- 
1.9.1

