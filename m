Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaJBH2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:28:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54340 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaJBH2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:28:03 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: tas2552: Fix compilation warning for !PM_RUNTIME
Date: Thu,  2 Oct 2014 09:28:00 +0200
Message-Id: <1412234880-8308-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The tas2552_sw_shutdown() function is only used by runtime suspend
support, so only build it when necessary.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 sound/soc/codecs/tas2552.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
index 1ed57a7e57b6..f039dc825971 100644
--- a/sound/soc/codecs/tas2552.c
+++ b/sound/soc/codecs/tas2552.c
@@ -115,6 +115,7 @@ static const struct snd_soc_dapm_route tas2552_audio_map[] = {
 	{"ClassD", NULL, "PLL"},
 };
 
+#ifdef CONFIG_PM_RUNTIME
 static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
 {
 	u8 cfg1_reg;
@@ -127,6 +128,7 @@ static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
 	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
 						 TAS2552_SWS_MASK, cfg1_reg);
 }
+#endif
 
 static int tas2552_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params,
-- 
2.1.0

