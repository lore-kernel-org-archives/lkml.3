Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbbAZOxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:53:44 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:9604 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbbAZOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:53:27 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>,
        <lars@metafoo.de>
Subject: [PATCH_V3 3/4] sound: soc: jz4740: Add DT support to jz4740-i2s driver
Date: Mon, 26 Jan 2015 14:53:12 +0000
Message-ID: <1422283993-53642-4-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for the jz4740 driver.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
V2 changes: Added ifdef config_of
---
 sound/soc/jz4740/jz4740-i2s.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index b7a7e82..07f7781 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -14,6 +14,8 @@
 
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -424,6 +426,13 @@ static const struct snd_soc_component_driver jz4740_i2s_component = {
 	.name		= "jz4740-i2s",
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id jz4740_of_matches[] = {
+	{ .compatible = "ingenic,jz4740-i2s" },
+	{ /* sentinel */ }
+};
+#endif
+
 static int jz4740_i2s_dev_probe(struct platform_device *pdev)
 {
 	struct jz4740_i2s *i2s;
@@ -464,6 +473,7 @@ static struct platform_driver jz4740_i2s_driver = {
 	.probe = jz4740_i2s_dev_probe,
 	.driver = {
 		.name = "jz4740-i2s",
+		.of_match_table = of_match_ptr(jz4740_of_matches)
 	},
 };
 
-- 
1.9.1

