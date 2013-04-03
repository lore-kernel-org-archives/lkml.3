Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380Ab3DCIsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:48:03 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48054 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762331Ab3DCIrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:47:55 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 08/12] usb: phy: ab8500-usb: fix unbalanced clock and regulator disable warnings
Date: Wed,  3 Apr 2013 10:45:09 +0200
Message-Id: <1364978713-19612-9-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

To prevent clock and regulator frameworks from complaining, only disable
the host or peripheral phy if they were enabled.

Reported-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 803ad93..b7f6639 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -887,8 +887,10 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&ab->phy);
 
-	ab8500_usb_host_phy_dis(ab);
-	ab8500_usb_peri_phy_dis(ab);
+	if (ab->mode == USB_HOST)
+		ab8500_usb_host_phy_dis(ab);
+	else if (ab->mode == USB_PERIPHERAL)
+		ab8500_usb_peri_phy_dis(ab);
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.8.1.3

