Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921Ab3GSQyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:54:36 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.7]:36896 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760225Ab3GSQyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:54:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1374252861!7781029!20
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: ep93xx: fix build of ep93xx-ac97.c
Date: Fri, 19 Jul 2013 09:53:25 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
CC: <alsa-devel@alsa-project.org>, Ryan Mallon <rmallon@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201307190953.25957.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the build of this driver. It was broken by:

Commit 453807f3006757a5661c4000262d7d9284b5214c
ASoC: ep93xx: Use ep93xx_dma_params instead of ep93xx_pcm_dma_params

The removed struct ep93xx_pcm_dma_params use the member 'dma_port' to
select the dma channel. The struct ep93xx_dma_data uses the member
'port'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/soc/cirrus/ep93xx-ac97.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/cirrus/ep93xx-ac97.c b/sound/soc/cirrus/ep93xx-ac97.c
index ac73c60..04491f0 100644
--- a/sound/soc/cirrus/ep93xx-ac97.c
+++ b/sound/soc/cirrus/ep93xx-ac97.c
@@ -102,13 +102,13 @@ static struct ep93xx_ac97_info *ep93xx_ac97_info;
 
 static struct ep93xx_dma_data ep93xx_ac97_pcm_out = {
 	.name		= "ac97-pcm-out",
-	.dma_port	= EP93XX_DMA_AAC1,
+	.port		= EP93XX_DMA_AAC1,
 	.direction	= DMA_MEM_TO_DEV,
 };
 
 static struct ep93xx_dma_data ep93xx_ac97_pcm_in = {
 	.name		= "ac97-pcm-in",
-	.dma_port	= EP93XX_DMA_AAC1,
+	.port		= EP93XX_DMA_AAC1,
 	.direction	= DMA_DEV_TO_MEM,
 };
 
-- 
1.8.3.2

