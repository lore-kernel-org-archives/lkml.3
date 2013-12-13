Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3LMBGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:06:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38141 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3LMBGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:06:39 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] usb: host: xhci: Move suspend ops under PM_SLEEP to avoid warning
Date: Thu, 12 Dec 2013 20:06:24 -0500
Message-ID: <1386896784-23916-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise you get below build warnings

drivers/usb/host/xhci-plat.c:201:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
drivers/usb/host/xhci-plat.c:209:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]

Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/usb/host/xhci-plat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index d9c169f..4875be5 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -197,7 +197,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int xhci_plat_suspend(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
@@ -220,7 +220,7 @@ static const struct dev_pm_ops xhci_plat_pm_ops = {
 #define DEV_PM_OPS	(&xhci_plat_pm_ops)
 #else
 #define DEV_PM_OPS	NULL
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_OF
 static const struct of_device_id usb_xhci_of_match[] = {
-- 
1.7.9.5

