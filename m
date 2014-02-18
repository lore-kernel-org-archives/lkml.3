Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaBRPc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:32:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50551 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320AbaBRPbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:31:02 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 12/17 v2] ASoC: omap: n810: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:23 +0000
Message-Id: <1392736948-26623-13-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/omap/n810.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/sound/soc/omap/n810.c b/sound/soc/omap/n810.c
index 3fde9e4..480a39c 100644
--- a/sound/soc/omap/n810.c
+++ b/sound/soc/omap/n810.c
@@ -68,26 +68,30 @@ static void n810_ext_control(struct snd_soc_dapm_context *dapm)
 		break;
 	}
 
+	snd_soc_dapm_mutex_lock(dapm);
+
 	if (n810_spk_func)
-		snd_soc_dapm_enable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Ext Spk");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Ext Spk");
 
 	if (hp)
-		snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headphone Jack");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphone Jack");
 	if (line1l)
-		snd_soc_dapm_enable_pin(dapm, "LINE1L");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "LINE1L");
 	else
-		snd_soc_dapm_disable_pin(dapm, "LINE1L");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "LINE1L");
 
 	if (n810_dmic_func)
-		snd_soc_dapm_enable_pin(dapm, "DMic");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "DMic");
 	else
-		snd_soc_dapm_disable_pin(dapm, "DMic");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "DMic");
+
+	snd_soc_dapm_sync_unlocked(dapm);
 
-	snd_soc_dapm_sync(dapm);
+	snd_soc_dapm_mutex_unlock(dapm);
 }
 
 static int n810_startup(struct snd_pcm_substream *substream)
-- 
1.7.2.5

