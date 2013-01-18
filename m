Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab3ARHju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:39:50 -0500
Received: from norkia.v3.sk ([91.210.183.14]:33055 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3ARHjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:39:48 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, Bing Zhao <bzhao@marvell.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        libertas-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas sdio: look for 8688 firmware in common location
Date: Fri, 18 Jan 2013 08:39:41 +0100
Message-Id: <1358494781-30160-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1357771504.12030.59.camel@dcbw.foobar.com>
References: <1357771504.12030.59.camel@dcbw.foobar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd8688 is not only used by libertas WiFi, but shared with btmrvl bluetooth as
well.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/libertas/if_sdio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 739309e..be16a76 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -85,6 +85,7 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8686, "libertas/sd8686_v9_helper.bin", "libertas/sd8686_v9.bin" },
 	{ MODEL_8686, "libertas/sd8686_v8_helper.bin", "libertas/sd8686_v8.bin" },
 	{ MODEL_8686, "sd8686_helper.bin", "sd8686.bin" },
+	{ MODEL_8688, "mrvl/sd8688_helper.bin", "mrvl/sd8688.bin" },
 	{ MODEL_8688, "libertas/sd8688_helper.bin", "libertas/sd8688.bin" },
 	{ MODEL_8688, "sd8688_helper.bin", "sd8688.bin" },
 	{ 0, NULL, NULL }
@@ -99,6 +100,8 @@ MODULE_FIRMWARE("libertas/sd8686_v8_helper.bin");
 MODULE_FIRMWARE("libertas/sd8686_v8.bin");
 MODULE_FIRMWARE("sd8686_helper.bin");
 MODULE_FIRMWARE("sd8686.bin");
+MODULE_FIRMWARE("mrvl/sd8688_helper.bin");
+MODULE_FIRMWARE("mrvl/sd8688.bin");
 MODULE_FIRMWARE("libertas/sd8688_helper.bin");
 MODULE_FIRMWARE("libertas/sd8688.bin");
 MODULE_FIRMWARE("sd8688_helper.bin");
-- 
1.7.1

