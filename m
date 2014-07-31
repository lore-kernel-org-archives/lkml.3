Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaGaOll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:41:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37755 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaGaOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:41:40 -0400
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Thu, 31 Jul 2014 15:41:30 +0100
Message-Id: <1406817690-5922-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm8994: Allow modular build
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The interfaces that used to be built in only (interrupts IIRC) no longer
are so allow the driver to be built as a module fixing arm64 allmodconfig
builds.

Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf244746..8d5fad23a4b7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1228,11 +1228,11 @@ config MFD_WM8350_I2C
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
2.0.1

