Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbaLKDO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:14:58 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:10537 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933176AbaLKDO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:14:57 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>, Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, Alexander Morozov <linux@meltdown.ru>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 1/3] ASoC: codecs: wm8904: add dt ids table
Date: Thu, 11 Dec 2014 11:14:39 +0800
Message-ID: <1418267681-4091-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Morozov <linux@meltdown.ru>

Signed-off-by: Alexander Morozov <linux@meltdown.ru>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 sound/soc/codecs/wm8904.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 4d2d2b1..23831a5 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2255,10 +2255,19 @@ static const struct i2c_device_id wm8904_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm8904_i2c_id);
 
+static const struct of_device_id wm8904_of_match[] = {
+	{ .compatible = "wlf,wm8904", },
+	{ .compatible = "wlf,wm8912", },
+	{ .compatible = "wlf,wm8918", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wm8904_of_match);
+
 static struct i2c_driver wm8904_i2c_driver = {
 	.driver = {
 		.name = "wm8904",
 		.owner = THIS_MODULE,
+		.of_match_table = wm8904_of_match,
 	},
 	.probe =    wm8904_i2c_probe,
 	.remove =   wm8904_i2c_remove,
-- 
2.1.0.24.g4109c28

