Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaJVPeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:34:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50068 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaJVPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:34:34 -0400
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, wsa@the-dreams.de, lars@metafoo.de,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] adv7604: Add DT parsing support
Date: Wed, 22 Oct 2014 17:34:21 +0200
Message-Id: <1413992061-28678-1-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DT parsing of ADV7604 as well as ADV7611.
It needs to be improved in order to get ports parsing too.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 Documentation/devicetree/bindings/media/i2c/adv7604.txt | 1 +
 drivers/media/i2c/adv7604.c                             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
index c27cede..5c8b3e6 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
@@ -10,6 +10,7 @@ Required Properties:
 
   - compatible: Must contain one of the following
     - "adi,adv7611" for the ADV7611
+    - "adi,adv7604" for the ADV7604
 
   - reg: I2C slave address
 
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 47795ff..421035f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2677,6 +2677,7 @@ MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
 
 static struct of_device_id adv7604_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
+	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, adv7604_of_id);
-- 
2.1.2

