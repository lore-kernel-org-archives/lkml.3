Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab3KMSUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:20:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759374Ab3KMSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:19:55 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 5/7] extcon: arizona: Add support for headphone detection on wm5110 rev D
Date: Wed, 13 Nov 2013 18:04:35 +0000
Message-Id: <1384365877-12355-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384365877-12355-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm5110 rev D is the first chip to use headphone detection IP 2, specify
such and make a small correction as the impedance value is actually read
in 0.5 ohm increments now.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index e311c52..d08e342 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -435,6 +435,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		}
 
 		val &= ARIZONA_HP_LVL_B_MASK;
+		val /= 2;
 
 		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
 			    &range);
@@ -1149,6 +1150,16 @@ static int arizona_extcon_probe(struct platform_device *pdev)
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

