Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaDVJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:26:25 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53523 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbaDVJVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:40 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 10/19] usb: phy: msm: Properly check result from platform_get_irq()
Date: Tue, 22 Apr 2014 12:20:29 +0300
Message-Id: <1398158438-21579-11-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Function return negative code on error.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 6b44826..2dc7948 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1412,7 +1412,7 @@ static int msm_otg_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);

 	motg->irq = platform_get_irq(pdev, 0);
-	if (!motg->irq) {
+	if (motg->irq < 0) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
 		return motg->irq;
 	}
--
1.8.3.2

