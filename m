Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3LTFWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:22:40 -0500
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:5198
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab3LTFWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:22:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: fsl-sai: Use devm_snd_dmaengine_pcm_register()
Date: Fri, 20 Dec 2013 12:30:26 +0800
Message-ID: <1387513826-15846-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the code slightly shorter

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 50a797e..39cb9ee 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -454,19 +454,8 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = snd_dmaengine_pcm_register(&pdev->dev, NULL,
+	return devm_snd_dmaengine_pcm_register(&pdev->dev, NULL,
 			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int fsl_sai_remove(struct platform_device *pdev)
-{
-	snd_dmaengine_pcm_unregister(&pdev->dev);
-
-	return 0;
 }
 
 static const struct of_device_id fsl_sai_ids[] = {
@@ -476,8 +465,6 @@ static const struct of_device_id fsl_sai_ids[] = {
 
 static struct platform_driver fsl_sai_driver = {
 	.probe = fsl_sai_probe,
-	.remove = fsl_sai_remove,
-
 	.driver = {
 		.name = "fsl-sai",
 		.owner = THIS_MODULE,
-- 
1.8.4


