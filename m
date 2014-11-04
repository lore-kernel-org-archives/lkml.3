Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaKDC1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:27:01 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38229 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaKDCZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:41 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 23/27] phy: phy-rcar-usb: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:30 +0530
Message-Id: <1415067694-9473-24-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/usb/phy/phy-rcar-usb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/phy/phy-rcar-usb.c b/drivers/usb/phy/phy-rcar-usb.c
index 33265a5..e9f3a93 100644
--- a/drivers/usb/phy/phy-rcar-usb.c
+++ b/drivers/usb/phy/phy-rcar-usb.c
@@ -195,11 +195,9 @@ static int rcar_usb_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(reg0);
 
 	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res1) {
-		reg1 = devm_ioremap_resource(dev, res1);
-		if (IS_ERR(reg1))
-			return PTR_ERR(reg1);
-	}
+	reg1 = devm_ioremap_resource(dev, res1);
+	if (IS_ERR(reg1))
+		return PTR_ERR(reg1);
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
-- 
1.7.9.5

