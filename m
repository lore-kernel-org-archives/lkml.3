Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3DZMib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:38:31 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:40811 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3DZMi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:38:29 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, zonque@gmail.com,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH] ASoC: McASP: Add pins output direction for rx clocks when configured in CBS_CFS format.
Date: Fri, 26 Apr 2013 14:38:11 +0200
Message-Id: <1366979891-15434-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When McASP is bit clock and frame clock master enable pin output for rx clocks.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 sound/soc/davinci/davinci-mcasp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index d54e0d9..2953c55 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -505,7 +505,10 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		mcasp_set_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
 		mcasp_set_bits(base + DAVINCI_MCASP_RXFMCTL_REG, AFSRE);
 
-		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG, ACLKX | AFSX);
+		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG,
+				ACLKX | ACLKR);
+		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG,
+				AFSX | AFSR);
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		/* codec is clock master and frame slave */
-- 
1.7.9.5

