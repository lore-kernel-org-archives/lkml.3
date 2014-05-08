Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaEHNxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:53:10 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64264 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaEHNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:53:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Mathias Nyman <mathias.nyman@intel.com>
Subject: [PATCH 6/8] usb: xhci: avoid warning for !PM_SLEEP
Date: Thu,  8 May 2014 15:52:19 +0200
Message-Id: <1399557141-1346645-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rU60RFVzzbP7egJHIwxmaUOPiCVUrvBuFR6NHVT2TPv
 uoCuGPt4RfJIdmzk3RIRNRqNZxEEeFi70s0qiN7tRZGmmRfGkV
 IywlTvh+IhwiH0LuCRFczLQXL9C4ovvsCQEE+0ECaHdYouZ7zm
 rpLoO1WNOdgY3wmHWCRNE+lf1y42+8XfEhjI+EwPljuh775/Ug
 R3nkr/zGz7uB+RF5wIC+tQ081GVr6h2L8ObCqaIyKGBpjEsEkB
 hwOd32rvNjf6ppmO5DJ/2bYbykr9GgC1fhxsIGoXQYIULgVv57
 iq4COthqk46DOSaSfshqxQPvVG1M8nolxXYBI0oO6gvjd45CoR
 dTjHsXmKHuftQcDXRv/Emst6ZxCeceGxXVu+rX1N/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we build a kernel with PM_SUSPEND set and no PM_SLEEP,
we get a build warning in the xhci-plat driver about unused
functions.

To fix this, use "#ifdef CONFIG_PM_SLEEP", like we do in most
other drivers nowadays.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mathias Nyman <mathias.nyman@intel.com>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 151901c..3473296 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -202,7 +202,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int xhci_plat_suspend(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
-- 
1.8.3.2

