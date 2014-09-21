Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaIUDAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 23:00:55 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37074 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaIUDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 23:00:37 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        zonque@gmail.com, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH 2/3] cap1106: support for active-high interrupt option
Date: Sat, 20 Sep 2014 20:01:08 -0700
Message-Id: <1411268469-21283-3-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some applications need to use the active-high push-pull interrupt
option. This allows it be enabled in the device tree child node.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 drivers/input/keyboard/cap1106.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
index b9c43b5..33e2590 100644
--- a/drivers/input/keyboard/cap1106.c
+++ b/drivers/input/keyboard/cap1106.c
@@ -234,6 +234,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
 			dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
 	}
 
+	if (of_property_read_bool(node, "microchip,active-high")) {
+		error = regmap_write(priv->regmap, CAP1106_REG_CONFIG2, 0);
+		if (error)
+			return error;
+	}
+
 	/* Provide some useful defaults */
 	for (i = 0; i < priv->num_channels; i++)
 		priv->keycodes[i] = KEY_A + i;
-- 
1.9.1

