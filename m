Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3EWGDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:03:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38716 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3EWGBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:01:36 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 2/9] usb: musb: nop: remove unused nop_xceiv_(un)register APIs from glue
Date: Thu, 23 May 2013 11:31:21 +0530
Message-ID: <1369288888-8614-3-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed unused nop xceiv (un_)register API's from all musb
platform drivers

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/am35x.c     |    2 --
 drivers/usb/musb/blackfin.c  |    2 --
 drivers/usb/musb/da8xx.c     |    2 --
 drivers/usb/musb/davinci.c   |    3 ---
 drivers/usb/musb/musb_dsps.c |    3 ---
 drivers/usb/musb/tusb6010.c  |    3 ---
 6 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 2231850..1074c5e 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -362,7 +362,6 @@ static int am35x_musb_init(struct musb *musb)
 	if (!rev)
 		return -ENODEV;
 
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
@@ -404,7 +403,6 @@ static int am35x_musb_exit(struct musb *musb)
 		data->set_phy_power(0);
 
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 
 	return 0;
 }
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 5e63b16..8e338d4 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -402,7 +402,6 @@ static int bfin_musb_init(struct musb *musb)
 	}
 	gpio_direction_output(musb->config->gpio_vrsel, 0);
 
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		gpio_free(musb->config->gpio_vrsel);
@@ -427,7 +426,6 @@ static int bfin_musb_exit(struct musb *musb)
 	gpio_free(musb->config->gpio_vrsel);
 
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 	return 0;
 }
 
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index ea7e591..11dcb6c 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -419,7 +419,6 @@ static int da8xx_musb_init(struct musb *musb)
 	if (!rev)
 		goto fail;
 
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		ret = -EPROBE_DEFER;
@@ -454,7 +453,6 @@ static int da8xx_musb_exit(struct musb *musb)
 	phy_off();
 
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 
 	return 0;
 }
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index bea6cc3..94bc1fe 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -382,7 +382,6 @@ static int davinci_musb_init(struct musb *musb)
 	u32		revision;
 	int 		ret = -ENODEV;
 
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		ret = -EPROBE_DEFER;
@@ -440,7 +439,6 @@ static int davinci_musb_init(struct musb *musb)
 fail:
 	usb_put_phy(musb->xceiv);
 unregister:
-	usb_nop_xceiv_unregister();
 	return ret;
 }
 
@@ -488,7 +486,6 @@ static int davinci_musb_exit(struct musb *musb)
 	phy_off();
 
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 
 	return 0;
 }
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 590dd0b..14067a1 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -416,7 +416,6 @@ static int dsps_musb_init(struct musb *musb)
 	musb->mregs += wrp->musb_core_offset;
 
 	/* NOP driver needs change if supporting dual instance */
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
@@ -449,7 +448,6 @@ static int dsps_musb_init(struct musb *musb)
 	return 0;
 err0:
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 	return status;
 }
 
@@ -466,7 +464,6 @@ static int dsps_musb_exit(struct musb *musb)
 
 	/* NOP driver needs change if supporting dual instance */
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 
 	return 0;
 }
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 7369ba3..2810d2b 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1066,7 +1066,6 @@ static int tusb_musb_init(struct musb *musb)
 	void __iomem		*sync = NULL;
 	int			ret;
 
-	usb_nop_xceiv_register();
 	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
@@ -1118,7 +1117,6 @@ done:
 			iounmap(sync);
 
 		usb_put_phy(musb->xceiv);
-		usb_nop_xceiv_unregister();
 	}
 	return ret;
 }
@@ -1134,7 +1132,6 @@ static int tusb_musb_exit(struct musb *musb)
 	iounmap(musb->sync_va);
 
 	usb_put_phy(musb->xceiv);
-	usb_nop_xceiv_unregister();
 	return 0;
 }
 
-- 
1.7.0.4

