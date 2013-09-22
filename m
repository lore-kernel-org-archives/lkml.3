Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3IVTwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:52:00 -0400
Received: from svenfoo.org ([82.94.215.22]:59105 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab3IVTv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:51:57 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, devicetree@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH 3/4] drivers: misc: ti_dac7512: provide a SPI ID table
Date: Sun, 22 Sep 2013 21:51:48 +0200
Message-Id: <1379879509-3608-4-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379879509-3608-1-git-send-email-zonque@gmail.com>
References: <1379879509-3608-1-git-send-email-zonque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way, the module can be autoloaded by the SPI core.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 drivers/misc/ti_dac7512.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index 46dfbf3..6393a68 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -72,6 +72,12 @@ static int dac7512_remove(struct spi_device *spi)
 	return 0;
 }
 
+static const struct spi_device_id dac7512_id_table[] = {
+	{ "dac7512", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, dac7512_id_table);
+
 static struct spi_driver dac7512_driver = {
 	.driver = {
 		.name	= "dac7512",
@@ -79,6 +85,7 @@ static struct spi_driver dac7512_driver = {
 	},
 	.probe	= dac7512_probe,
 	.remove	= dac7512_remove,
+	.id_table = dac7512_id_table,
 };
 
 module_spi_driver(dac7512_driver);
-- 
1.8.3.1

