Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3GWIql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:46:41 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:38307 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab3GWIqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:46:35 -0400
Date: Tue, 23 Jul 2013 10:46:41 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@vger.kernel.org
Subject: [PATCH] ARM: kirkwood: extend the kirkwood pcm/dma driver for DT
 usage
Message-ID: <20130723104641.6ee0b9ec@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kirkwood pcm/dma driver is used without DT in the Kirkwood machine.
This patch adds a DT compatible definition for use in other Marvell
machines as the Armada 88AP510 (Dove).

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/sound/kirkwood-dma.txt | 11 +++++++++++
 sound/soc/kirkwood/kirkwood-dma.c                        | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/kirkwood-dma.txt b/Documentation/devicetree/bindings/sound/kirkwood-dma.txt
new file mode 100644
index 0000000..9dd2989
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/kirkwood-dma.txt
@@ -0,0 +1,11 @@
+* mvebu (Kirkwood, Dove, Armada 370) PCM/DMA controller
+
+Required properties:
+
+- compatible: "marvell,mvebu-pcm-audio"
+
+Example:
+
+pcm: pcm {
+	compatible = "marvell,mvebu-pcm-audio";
+};
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index a9f1453..b91045a 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -19,6 +19,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/mbus.h>
 #include <sound/soc.h>
+#include <linux/of.h>
+
 #include "kirkwood.h"
 
 #define KIRKWOOD_RATES \
@@ -383,10 +385,19 @@ static int kirkwood_soc_platform_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id kirkwood_pcm_of_match[] = {
+	{ .compatible = "marvell,mvebu-pcm-audio" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, kirkwood_pcm_of_match);
+#endif
+
 static struct platform_driver kirkwood_pcm_driver = {
 	.driver = {
 			.name = "kirkwood-pcm-audio",
 			.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(kirkwood_pcm_of_match),
 	},
 
 	.probe = kirkwood_soc_platform_probe,


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
