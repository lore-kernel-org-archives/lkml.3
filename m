Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaIOTgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:36:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbaIOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Johannes Stezenbach <js@sig21.net>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 087/158] ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE
Date: Mon, 15 Sep 2014 12:25:26 -0700
Message-Id: <20140915192545.496240877@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 9301503af016eb537ccce76adec0c1bb5c84871e upstream.

This mode is unsupported, as the DMA controller can't do zero-padding
of samples.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/pxa/pxa-ssp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -765,9 +765,7 @@ static int pxa_ssp_remove(struct snd_soc
 			  SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_64000 |	\
 			  SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000)
 
-#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
-			    SNDRV_PCM_FMTBIT_S24_LE |	\
-			    SNDRV_PCM_FMTBIT_S32_LE)
+#define PXA_SSP_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE)
 
 static const struct snd_soc_dai_ops pxa_ssp_dai_ops = {
 	.startup	= pxa_ssp_startup,


