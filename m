Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3ASTBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 14:01:30 -0500
Received: from norkia.v3.sk ([91.210.183.14]:39238 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab3ASTBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 14:01:18 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>, Bing Zhao <bzhao@marvell.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        libertas-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bluetooth: btmrvl_sdio: look for sd8688 firmware in proper location
Date: Sat, 19 Jan 2013 20:01:04 +0100
Message-Id: <1358622064-782-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358495893.5510.0.camel@aeonflux>
References: <1358495893.5510.0.camel@aeonflux>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware images are shared with libertas_sdio WiFi chip and used to be in
libertas/ subtree in linux-firmware. As btmrvl_sdio used to look into the
linux-firmware root, it ended up being unsuccessful. Since the firmware files
are not specific to the libertas hardware, they're being moved into mrvl/ now.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/bluetooth/btmrvl_sdio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 9959d4c..1cb5183 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -83,8 +83,8 @@ static const struct btmrvl_sdio_card_reg btmrvl_reg_87xx = {
 };
 
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
-	.helper		= "sd8688_helper.bin",
-	.firmware	= "sd8688.bin",
+	.helper		= "mrvl/sd8688_helper.bin",
+	.firmware	= "mrvl/sd8688.bin",
 	.reg		= &btmrvl_reg_8688,
 	.sd_blksz_fw_dl	= 64,
 };
@@ -1185,7 +1185,7 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell BT-over-SDIO driver ver " VERSION);
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE("sd8688_helper.bin");
-MODULE_FIRMWARE("sd8688.bin");
+MODULE_FIRMWARE("mrvl/sd8688_helper.bin");
+MODULE_FIRMWARE("mrvl/sd8688.bin");
 MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8797_uapsta.bin");
-- 
1.7.1

