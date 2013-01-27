Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3A0EIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 23:08:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47880 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777Ab3A0EIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 23:08:20 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/10] mfd: wm5102: Mark only extant DSP registers volatile
Date: Sun, 27 Jan 2013 12:07:24 +0800
Message-Id: <1359259652-8565-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regmap sometimes uses volatile as a proxy for readable simply
having a blanket condition can mark too many registers as readable.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 4a01192..0317d11 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1837,9 +1837,6 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 
 static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 {
-	if (reg > 0xffff)
-		return true;
-
 	switch (reg) {
 	case ARIZONA_SOFTWARE_RESET:
 	case ARIZONA_DEVICE_REVISION:
@@ -1884,7 +1881,13 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_DETECT_3:
 		return true;
 	default:
-		return false;
+		if ((reg >= 0x100000 && reg < 0x106000) ||
+		    (reg >= 0x180000 && reg < 0x180800) ||
+		    (reg >= 0x190000 && reg < 0x194800) ||
+		    (reg >= 0x1a8000 && reg < 0x1a9800))
+			return true;
+		else
+			return false;
 	}
 }
 
-- 
1.7.10.4

