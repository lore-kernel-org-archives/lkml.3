Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3ECFhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:37:51 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41038 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761442Ab3ECFhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:37:50 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de
Cc: zonque@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH] ASoC: McASP: Fix receive clock polarity in DAIFMT_NB_NF mode.
Date: Fri,  3 May 2013 07:37:36 +0200
Message-Id: <1367559456-20208-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According documentation bit ACLKRPOL is set to 0 (receiver samples data
on falling edge) and when set to 1 (receiver samples data on rising edge).

I2S data are always sampled on falling edge and valid during rising edge
of bit clock. So in case of capture data transmitter sample data on falling
edge and macsp must read then on rising edge.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 sound/soc/davinci/davinci-mcasp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 849a187..c46112e 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -568,7 +568,7 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		mcasp_set_bits(base + DAVINCI_MCASP_ACLKXCTL_REG, ACLKXPOL);
 		mcasp_clr_bits(base + DAVINCI_MCASP_TXFMCTL_REG, FSXPOL);
 
-		mcasp_clr_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRPOL);
+		mcasp_set_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRPOL);
 		mcasp_clr_bits(base + DAVINCI_MCASP_RXFMCTL_REG, FSRPOL);
 		break;
 
-- 
1.7.9.5

