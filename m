Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3FVJrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 05:47:47 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52171 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3FVJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 05:47:45 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: i2c: ths8200: add OF support
Date: Sat, 22 Jun 2013 15:16:35 +0530
Message-Id: <1371894395-14414-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371894395-14414-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371894395-14414-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

add OF support for the ths8200 driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 .../devicetree/bindings/media/i2c/ths8200.txt      |   19 +++++++++++++++++++
 drivers/media/i2c/ths8200.c                        |    9 +++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths8200.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ths8200.txt b/Documentation/devicetree/bindings/media/i2c/ths8200.txt
new file mode 100644
index 0000000..285f6ae
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ths8200.txt
@@ -0,0 +1,19 @@
+* Texas Instruments THS8200 video encoder
+
+The ths8200 device is a digital to analog converter used in DVD players, video
+recorders, set-top boxes.
+
+Required Properties :
+- compatible : value must be "ti,ths8200"
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		...
+		ths8200@5c {
+			compatible = "ti,ths8200";
+			reg = <0x5c>;
+		};
+		...
+	};
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index cc1339a..8a29810 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -550,10 +550,19 @@ static struct i2c_device_id ths8200_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ths8200_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id ths8200_of_match[] = {
+	{ .compatible = "ti,ths8200", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, ths8200_of_match);
+#endif
+
 static struct i2c_driver ths8200_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "ths8200",
+		.of_match_table = of_match_ptr(ths8200_of_match),
 	},
 	.probe = ths8200_probe,
 	.remove = ths8200_remove,
-- 
1.7.9.5

