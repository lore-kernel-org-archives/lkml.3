Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3FKHSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:18:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48687 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3FKHSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:18:05 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v2 3/7] usb: musb: dsps: remove nop_xceiv_(un)register APIs from dsps glue
Date: Tue, 11 Jun 2013 12:47:48 +0530
Message-ID: <1370935072-21056-4-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed nop xceiv (un_)register API's references from musb dsps
platform, as it uses saperate phy driver.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 590dd0b..0ecedb3 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -36,7 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
-#include <linux/usb/nop-usb-xceiv.h>
 #include <linux/platform_data/usb-omap.h>
 #include <linux/sizes.h>
 
@@ -416,7 +415,6 @@ static int dsps_musb_init(struct musb *musb)
 	musb->mregs += wrp->musb_core_offset;
 
 	/* NOP driver needs change if supporting dual instance */
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
@@ -449,7 +447,6 @@ static int dsps_musb_init(struct musb *musb)
 	return 0;
 err0:
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 	return status;
 }
 
@@ -466,7 +463,6 @@ static int dsps_musb_exit(struct musb *musb)
 
 	/* NOP driver needs change if supporting dual instance */
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 
 	return 0;
 }
-- 
1.7.0.4

