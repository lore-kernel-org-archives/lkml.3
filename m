Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaIZJq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbaIZJqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/142] ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE
Date: Fri, 26 Sep 2014 11:44:52 +0200
Message-Id: <d45c7fbe6a5cc48f8f666c15cbc2322384d3c56d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9301503af016eb537ccce76adec0c1bb5c84871e upstream.

This mode is unsupported, as the DMA controller can't do zero-padding
of samples.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/pxa/pxa-ssp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index e4558e31a9ee..6c6b35e471c8 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -767,9 +767,7 @@ static int pxa_ssp_remove(struct snd_soc_dai *dai)
 			  SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_64000 |	\
 			  SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000)
 
-#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
-			    SNDRV_PCM_FMTBIT_S24_LE |	\
-			    SNDRV_PCM_FMTBIT_S32_LE)
+#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE)
 
 static const struct snd_soc_dai_ops pxa_ssp_dai_ops = {
 	.startup	= pxa_ssp_startup,
-- 
2.1.0

