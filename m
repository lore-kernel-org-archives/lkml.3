Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbaDXPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:49:18 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51225 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbaDXPtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:49:12 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v7 04/20] usb: phy: msm: Enable deferred driver probing
Date: Thu, 24 Apr 2014 18:47:59 +0300
Message-Id: <1398354495-20782-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Using platform_driver_probe() prevent driver from requesting
probe deferral. Fix this.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 6bae936..b7d73f2 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1736,6 +1736,7 @@ static const struct dev_pm_ops msm_otg_dev_pm_ops = {
 };

 static struct platform_driver msm_otg_driver = {
+	.probe = msm_otg_probe,
 	.remove = msm_otg_remove,
 	.driver = {
 		.name = DRIVER_NAME,
@@ -1744,7 +1745,7 @@ static struct platform_driver msm_otg_driver = {
 	},
 };

-module_platform_driver_probe(msm_otg_driver, msm_otg_probe);
+module_platform_driver(msm_otg_driver);

 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MSM USB transceiver driver");
--
1.8.3.2

