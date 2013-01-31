Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab3AaMwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:52:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50195 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab3AaMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:52:23 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <rob@landley.net>,
        <grant.likely@secretlab.ca>
Subject: [PATCH v4 3/3] ASoC: davinci: remove __dev* attributes
Date: Thu, 31 Jan 2013 18:23:06 +0530
Message-ID: <1359636786-7056-4-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359636786-7056-1-git-send-email-gururaja.hebbar@ti.com>
References: <1359636786-7056-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG is going away as an option.  As result the __dev*
markings will be going away.

Remove use of __devexit_p and __devexit.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
---
Changes in v4
	 - No change

Changes in v3
	 - New patch

:100644 100644 e6009a4... 37b8e78... M	sound/soc/davinci/davinci-evm.c
 sound/soc/davinci/davinci-evm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index e6009a4..37b8e78 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -390,7 +390,7 @@ static int davinci_evm_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __devexit davinci_evm_remove(struct platform_device *pdev)
+static int davinci_evm_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
@@ -401,7 +401,7 @@ static int __devexit davinci_evm_remove(struct platform_device *pdev)
 
 static struct platform_driver davinci_evm_driver = {
 	.probe		= davinci_evm_probe,
-	.remove		= __devexit_p(davinci_evm_remove),
+	.remove		= davinci_evm_remove,
 	.driver		= {
 		.name	= "davinci_evm",
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

