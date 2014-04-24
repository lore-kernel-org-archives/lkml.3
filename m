Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaDXP4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:56:43 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51298 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287AbaDXPtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:49:14 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v7 11/20] usb: phy: msm: Properly check result from platform_get_irq()
Date: Thu, 24 Apr 2014 18:48:06 +0300
Message-Id: <1398354495-20782-12-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
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
index 5d64038..8a7a324 100644
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

