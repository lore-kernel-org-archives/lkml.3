Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaDVJ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:26:43 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53505 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbaDVJVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:40 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 05/19] usb: phy: msm: Remove unnecessarily check for valid regulators.
Date: Tue, 22 Apr 2014 12:20:24 +0300
Message-Id: <1398158438-21579-6-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Whether regulators are available or not is checked at driver
probe. If they are not available driver will refuse to load,
so no need to check them again.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 67cac96..4045301 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -133,16 +133,6 @@ static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
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
1.8.3.2

