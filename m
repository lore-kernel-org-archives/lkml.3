Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbbAZKTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:19:38 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:45454 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbbAZKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:18:41 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>
Subject: [PATCH 3/4] sound: soc: jz4740: Add DT support to jz4740-i2s driver
Date: Mon, 26 Jan 2015 10:18:30 +0000
Message-ID: <1422267511-6649-4-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for the jz4740 driver.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
---
 sound/soc/jz4740/jz4740-i2s.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 98c77a63..3c309fc 100644
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
@@ -425,6 +427,11 @@ static const struct snd_soc_component_driver jz4740_i2s_component = {
 	.name		= "jz4740-i2s",
 };
 
+static const struct of_device_id jz4740_of_matches[] = {
+	{ .compatible = "ingenic,jz4740-i2s" },
+	{ /* sentinel */ }
+};
+
 static int jz4740_i2s_dev_probe(struct platform_device *pdev)
 {
 	struct jz4740_i2s *i2s;
@@ -465,6 +472,7 @@ static struct platform_driver jz4740_i2s_driver = {
 	.probe = jz4740_i2s_dev_probe,
 	.driver = {
 		.name = "jz4740-i2s",
+		.of_match_table = jz4740_of_matches
 	},
 };
 
-- 
1.9.1

