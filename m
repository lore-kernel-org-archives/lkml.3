Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab3LQX37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:29:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49913 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3LQX36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:29:58 -0500
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@opensource.wolfsonmicro.com, Mark Brown <broonie@linaro.org>
Date: Tue, 17 Dec 2013 23:29:51 +0000
Message-Id: <1387322991-13092-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm8994: Allow modular build
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The interfaces that used to be built in only (interrupts IIRC) no longer
are so allow the driver to be built as a module fixing arm64 allmodconfig
builds.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445d846a..920ddfd85faa 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1170,11 +1170,11 @@ config MFD_WM8350_I2C
 	  selected to enable support for the functionality of the chip.
 
 config MFD_WM8994
-	bool "Wolfson Microelectronics WM8994"
+	tristate "Wolfson Microelectronics WM8994"
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C=y
+	depends on I2C
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
 	  smartphone applicatiosn.  As well as audio functionality it
-- 
1.8.5.1

