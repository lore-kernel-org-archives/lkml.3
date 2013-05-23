Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3EWGDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:03:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab3EWGBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:01:40 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 4/9] usb: phy: nop: removing unused usb_nop_xceiv_(un_)register API
Date: Thu, 23 May 2013 11:31:23 +0530
Message-ID: <1369288888-8614-5-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the unused the usb_nop_xceiv_register & _unregister API's
from phy-nop driver. The glue platform driver should use DT bindings
use usb-nop-xceiv driver

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c      |    1 -
 drivers/usb/phy/phy-nop.c         |   21 ---------------------
 include/linux/usb/nop-usb-xceiv.h |   14 --------------
 3 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 14067a1..0ecedb3 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -36,7 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
-#include <linux/usb/nop-usb-xceiv.h>
 #include <linux/platform_data/usb-omap.h>
 #include <linux/sizes.h>
 
diff --git a/drivers/usb/phy/phy-nop.c b/drivers/usb/phy/phy-nop.c
index 2b10cc9..52d3fdd 100644
--- a/drivers/usb/phy/phy-nop.c
+++ b/drivers/usb/phy/phy-nop.c
@@ -44,27 +44,6 @@ struct nop_usb_xceiv {
 	struct regulator *reset;
 };
 
-static struct platform_device *pd;
-
-void usb_nop_xceiv_register(void)
-{
-	if (pd)
-		return;
-	pd = platform_device_register_simple("nop_usb_xceiv", -1, NULL, 0);
-	if (!pd) {
-		printk(KERN_ERR "Unable to register usb nop transceiver\n");
-		return;
-	}
-}
-EXPORT_SYMBOL(usb_nop_xceiv_register);
-
-void usb_nop_xceiv_unregister(void)
-{
-	platform_device_unregister(pd);
-	pd = NULL;
-}
-EXPORT_SYMBOL(usb_nop_xceiv_unregister);
-
 static int nop_set_suspend(struct usb_phy *x, int suspend)
 {
 	return 0;
diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-usb-xceiv.h
index 148d351..b23c942 100644
--- a/include/linux/usb/nop-usb-xceiv.h
+++ b/include/linux/usb/nop-usb-xceiv.h
@@ -12,18 +12,4 @@ struct nop_usb_xceiv_platform_data {
 	unsigned int needs_reset:1;
 };
 
-#if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
-/* sometimes transceivers are accessed only through e.g. ULPI */
-extern void usb_nop_xceiv_register(void);
-extern void usb_nop_xceiv_unregister(void);
-#else
-static inline void usb_nop_xceiv_register(void)
-{
-}
-
-static inline void usb_nop_xceiv_unregister(void)
-{
-}
-#endif
-
 #endif /* __LINUX_USB_NOP_XCEIV_H */
-- 
1.7.0.4

