Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaHMP1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:27:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56266 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaHMP1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:27:38 -0400
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH v2] mfd: wm8994: declare dc servo register for wm8958 as volatile
Date: Wed, 13 Aug 2014 16:27:29 +0100
Message-Id: <1407943649-9535-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DC Servo register 57h holds the DC offset value after the hardware has
completed the DC Servo Correction, so declare this register as volatile
because it is changed by the hardware.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-regmap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 2fbce9c..fa1630d 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -1169,6 +1169,7 @@ static bool wm8958_volatile_register(struct device *dev, unsigned int reg)
 	case WM8958_FW_MINOR_0:
 	case WM8958_FW_PATCH_1:
 	case WM8958_FW_PATCH_0:
+	case WM8994_DC_SERVO_4:
 		return true;
 	default:
 		return wm8994_volatile_register(dev, reg);
-- 
1.7.9.5

