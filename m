Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3GIPsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:48:12 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50730 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3GIPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 4/7] usb: phy: msm: Remove unnecessarily check for valid regulators.
Date: Tue,  9 Jul 2013 18:47:10 +0300
Message-Id: <1373384833-18077-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Whether regulators are available or not is checked at driver
probe. If they are not available driver will refuse to load,
so no need to check them again.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 8289270..0e7d7ab 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -159,16 +159,6 @@ static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
 {
 	int ret = 0;
 
-	if (!motg->v1p8 || IS_ERR(motg->v1p8)) {
-		pr_err("%s: HSUSB_1p8 is not initialized\n", __func__);
-		return -ENODEV;
-	}
-
-	if (!motg->v3p3 || IS_ERR(motg->v3p3)) {
-		pr_err("%s: HSUSB_3p3 is not initialized\n", __func__);
-		return -ENODEV;
-	}
-
 	if (on) {
 		ret = regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_HPM_LOAD);
-- 
1.7.9.5

