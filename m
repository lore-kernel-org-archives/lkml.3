Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3EOME4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64091 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab3EOMEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:53 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 06/10] usb: phy: ab8500-usb: add platform_device_id table
Date: Wed, 15 May 2013 14:03:29 +0200
Message-Id: <1368619413-24647-7-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an initial platform_device_id table to the ab8500-usb driver to
allow probing additional variants of the ab8500 family chips.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index d105cce..2e8db60 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -945,11 +945,18 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id ab8500_usb_devtype[] = {
+	{ .name = "ab8500-usb", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, ab8500_usb_devtype);
+
 static struct platform_driver ab8500_usb_driver = {
 	.probe		= ab8500_usb_probe,
 	.remove		= ab8500_usb_remove,
+	.id_table	= ab8500_usb_devtype,
 	.driver		= {
-		.name	= "ab8500-usb",
+		.name	= "abx5x0-usb",
 		.owner	= THIS_MODULE,
 	},
 };
@@ -966,7 +973,6 @@ static void __exit ab8500_usb_exit(void)
 }
 module_exit(ab8500_usb_exit);
 
-MODULE_ALIAS("platform:ab8500_usb");
 MODULE_AUTHOR("ST-Ericsson AB");
 MODULE_DESCRIPTION("AB8500 usb transceiver driver");
 MODULE_LICENSE("GPL");
-- 
1.8.2

