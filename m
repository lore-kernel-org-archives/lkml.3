Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaD1Ngb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:36:31 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58349 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053AbaD1NfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:35:23 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v8 20/20] usb: phy: msm: Use usb_add_phy_dev() to register device
Date: Mon, 28 Apr 2014 16:34:23 +0300
Message-Id: <1398692063-11372-21-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

There could be more than one USB2.0 PHY's on the platform.
This will allow all of them to be registered successfully.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 8e7956e..9dc7918 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1663,6 +1663,7 @@ static int msm_otg_probe(struct platform_device *pdev)
 	phy->init = msm_phy_init;
 	phy->set_power = msm_otg_set_power;
 	phy->notify_disconnect = msm_phy_notify_disconnect;
+	phy->type = USB_PHY_TYPE_USB2;

 	phy->io_ops = &msm_otg_io_ops;

@@ -1672,7 +1673,7 @@ static int msm_otg_probe(struct platform_device *pdev)

 	msm_usb_reset(phy);

-	ret = usb_add_phy(&motg->phy, USB_PHY_TYPE_USB2);
+	ret = usb_add_phy_dev(&motg->phy);
 	if (ret) {
 		dev_err(&pdev->dev, "usb_add_phy failed\n");
 		goto disable_ldo;
--
1.8.3.2

