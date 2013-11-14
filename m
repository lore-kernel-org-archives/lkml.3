Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3KNQfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:35:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46508 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859Ab3KNQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:33:52 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v3 5/7] extcon: arizona: Add support for headphone detection on wm5110 rev D
Date: Thu, 14 Nov 2013 16:18:25 +0000
Message-Id: <1384445907-12859-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm5110 rev D is the first chip to use headphone detection IP 2, specify
such and make a small correction as the impedance value is actually read
in 0.5 ohm increments now.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 1a48b10..f4fe2d1 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -435,6 +435,8 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		}
 
 		val &= ARIZONA_HP_LVL_B_MASK;
+		/* Convert to ohms, the value is in 0.5 ohm increments */
+		val /= 2;
 
 		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
 			    &range);
@@ -1146,6 +1148,16 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 			break;
 		}
 		break;
+	case WM5110:
+		switch (arizona->rev) {
+		case 0 ... 2:
+			break;
+		default:
+			info->micd_clamp = true;
+			info->hpdet_ip = 2;
+			break;
+		}
+		break;
 	default:
 		break;
 	}
-- 
1.7.2.5

