Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaHMKr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:47:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54269 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaHMKr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:47:27 -0400
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] ASoC: wm_hubs: Fix DC Servo readback
Date: Wed, 13 Aug 2014 11:47:20 +0100
Message-Id: <1407926840-8576-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm_hubs is a common driver code shared by WM8958, WM1811, WM8944
and WM8993 all these codecs have the DC Servo Values either in register
57h or 59h. Current code was reading register 58h for WM8958 and WM8994
revisions 2 and 3 but looking at the data sheet the DC Servo Values are
stored in register 57h for these codecs. This patch fixes it by reading
the correct register for DC Servo

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm_hubs.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 916817f..95c5d71 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -210,9 +210,6 @@ static int wm_hubs_read_dc_servo(struct snd_soc_codec *codec,
 	case 2:
 		dcs_reg = WM8994_DC_SERVO_4E;
 		break;
-	case 1:
-		dcs_reg = WM8994_DC_SERVO_READBACK;
-		break;
 	default:
 		dcs_reg = WM8993_DC_SERVO_3;
 		break;
-- 
1.7.9.5

