Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaIWCeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:34:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:37392 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaIWCd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:33:59 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Mark Brown <broonie@linaro.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 02/45] ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE
Date: Tue, 23 Sep 2014 10:31:04 +0800
Message-Id: <1411439507-30391-2-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 9301503af016eb537ccce76adec0c1bb5c84871e upstream.

This mode is unsupported, as the DMA controller can't do zero-padding
of samples.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/soc/pxa/pxa-ssp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index fd04ce1..540e30b 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -779,9 +779,7 @@ static int pxa_ssp_remove(struct snd_soc_dai *dai)
 			  SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_64000 |	\
 			  SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000)
 
-#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
-			    SNDRV_PCM_FMTBIT_S24_LE |	\
-			    SNDRV_PCM_FMTBIT_S32_LE)
+#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE)
 
 static const struct snd_soc_dai_ops pxa_ssp_dai_ops = {
 	.startup	= pxa_ssp_startup,
-- 
1.7.9.5

