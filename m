Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaHMKqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:46:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54252 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbaHMKqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:46:35 -0400
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] mfd: wm8994: declare dc servo register for wm8958 as volatile
Date: Wed, 13 Aug 2014 11:46:25 +0100
Message-Id: <1407926786-8528-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DC Servo register 57h holds the DC offset value after the hardware has
completed the DC Servo Correction, so declare this register as volatile
because it is changed by the hardware.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-regmap.c          |    1 +
 include/linux/mfd/wm8994/registers.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 2fbce9c..e775565 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -1169,6 +1169,7 @@ static bool wm8958_volatile_register(struct device *dev, unsigned int reg)
 	case WM8958_FW_MINOR_0:
 	case WM8958_FW_PATCH_1:
 	case WM8958_FW_PATCH_0:
+	case WM8958_DC_SERVO:
 		return true;
 	default:
 		return wm8994_volatile_register(dev, reg);
diff --git a/include/linux/mfd/wm8994/registers.h b/include/linux/mfd/wm8994/registers.h
index db8cef3..85b4fec 100644
--- a/include/linux/mfd/wm8994/registers.h
+++ b/include/linux/mfd/wm8994/registers.h
@@ -71,6 +71,7 @@
 #define WM8994_DC_SERVO_1                       0x54
 #define WM8994_DC_SERVO_2                       0x55
 #define WM8994_DC_SERVO_4                       0x57
+#define WM8958_DC_SERVO			0x57
 #define WM8994_DC_SERVO_READBACK                0x58
 #define WM8994_DC_SERVO_4E			0x59
 #define WM8994_ANALOGUE_HP_1                    0x60
-- 
1.7.9.5

