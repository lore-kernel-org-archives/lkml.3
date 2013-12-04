Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3LDB4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:56:47 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:51216 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab3LDB4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:56:37 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: peter.chen@freescale.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 3/3 v5] usb: chipidea: put hw_phymode_configure before  ci_usb_phy_init
Date: Wed,  4 Dec 2013 09:56:19 +0800
Message-Id: <1386122179-4158-3-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386122179-4158-1-git-send-email-chris.ruehl@gtsys.com.hk>
References: <1386122179-4158-1-git-send-email-chris.ruehl@gtsys.com.hk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: chipidea: put hw_phymode_configure before ci_usb_phy_init

hw_phymode_configure configures the PORTSC registers and allow the
following phy_inits to operate on the right parameters. This fix a problem
where the UPLI (ISP1504) could not be detected, because the Viewport was not
available and read the viewport return 0's only.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Acked-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/usb/chipidea/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 2834801..43897dd 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -564,6 +564,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	hw_phymode_configure(ci);
+
 	ret = ci_usb_phy_init(ci);
 	if (ret) {
 		dev_err(dev, "unable to init phy: %d\n", ret);
@@ -581,8 +583,6 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 
 	ci_get_otg_capable(ci);
 
-	hw_phymode_configure(ci);
-
 	dr_mode = ci->platdata->dr_mode;
 	/* initialize role(s) before the interrupt is requested */
 	if (dr_mode == USB_DR_MODE_OTG || dr_mode == USB_DR_MODE_HOST) {
-- 
1.7.10.4

