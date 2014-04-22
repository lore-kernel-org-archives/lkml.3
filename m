Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaDVJWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:22:01 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53509 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbaDVJVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:47 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 19/19] usb: phy: msm: Use usb_add_phy_dev() to register device
Date: Tue, 22 Apr 2014 12:20:38 +0300
Message-Id: <1398158438-21579-20-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

They could be more than one USB2.0 PHY's on the platform.
This will allow all of them to be registred successfuly.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 08c9b2b..1029ae0 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1660,6 +1660,7 @@ static int msm_otg_probe(struct platform_device *pdev)
 	phy->init = msm_phy_init;
 	phy->set_power = msm_otg_set_power;
 	phy->notify_disconnect = msm_phy_notify_disconnect;
+	phy->type = USB_PHY_TYPE_USB2;

 	phy->io_ops = &msm_otg_io_ops;

@@ -1669,7 +1670,7 @@ static int msm_otg_probe(struct platform_device *pdev)

 	msm_usb_reset(phy);

-	ret = usb_add_phy(&motg->phy, USB_PHY_TYPE_USB2);
+	ret = usb_add_phy_dev(&motg->phy);
 	if (ret) {
 		dev_err(&pdev->dev, "usb_add_phy failed\n");
 		goto disable_ldo;
--
1.8.3.2

