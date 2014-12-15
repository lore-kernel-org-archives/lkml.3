Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaLODbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:31:31 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:41470 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbaLODbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:31:25 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>, Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, Alexander Morozov <linux@meltdown.ru>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 1/3] ASoC: codecs: wm8904: add dt ids table
Date: Mon, 15 Dec 2014 11:31:11 +0800
Message-ID: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Morozov <linux@meltdown.ru>

Signed-off-by: Alexander Morozov <linux@meltdown.ru>
[Add driver data to distinguish device type]
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

Changes in v2:
- Add driver data for distinguish the device capability.

 sound/soc/codecs/wm8904.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 4d2d2b1..6e3f175 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2255,10 +2255,32 @@ static const struct i2c_device_id wm8904_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm8904_i2c_id);
 
+#ifdef CONFIG_OF
+static enum wm8904_type wm8904_data = WM8904;
+static enum wm8904_type wm8912_data = WM8912;
+
+static const struct of_device_id wm8904_of_match[] = {
+	{
+		.compatible = "wlf,wm8904",
+		.data = &wm8904_data,
+	}, {
+		.compatible = "wlf,wm8912",
+		.data = &wm8912_data,
+	}, {
+		.compatible = "wlf,wm8918",
+		.data = &wm8904_data,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, wm8904_of_match);
+#endif
+
 static struct i2c_driver wm8904_i2c_driver = {
 	.driver = {
 		.name = "wm8904",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(wm8904_of_match),
 	},
 	.probe =    wm8904_i2c_probe,
 	.remove =   wm8904_i2c_remove,
-- 
2.1.0.24.g4109c28

