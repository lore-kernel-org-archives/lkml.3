Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3JKLrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:47:45 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:58635 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab3JKLrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:47:42 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: stern@rowland.harvard.edu
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        davidb@codeaurora.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 1/2] ehci-msm: Remove global struct usb_phy variable
Date: Fri, 11 Oct 2013 14:46:09 +0300
Message-Id: <1381491970-22896-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Use struct usb_hcd::phy to hold USB PHY instance.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/host/ehci-msm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 0f717dc..1bc9355 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -42,7 +42,6 @@
 
 static const char hcd_name[] = "ehci-msm";
 static struct hc_driver __read_mostly msm_hc_driver;
-static struct usb_phy *phy;
 
 static int ehci_msm_reset(struct usb_hcd *hcd)
 {
@@ -70,6 +69,7 @@ static int ehci_msm_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	struct resource *res;
+	struct usb_phy *phy;
 	int ret;
 
 	dev_dbg(&pdev->dev, "ehci_msm proble\n");
@@ -121,6 +121,7 @@ static int ehci_msm_probe(struct platform_device *pdev)
 		goto put_hcd;
 	}
 
+	hcd->phy = phy;
 	device_init_wakeup(&pdev->dev, 1);
 	/*
 	 * OTG device parent of HCD takes care of putting
@@ -147,7 +148,7 @@ static int ehci_msm_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
-	otg_set_host(phy->otg, NULL);
+	otg_set_host(hcd->phy->otg, NULL);
 
 	/* FIXME: need to call usb_remove_hcd() here? */
 
-- 
1.7.9.5

