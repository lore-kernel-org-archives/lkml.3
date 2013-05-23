Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3EWGBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:01:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50597 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3EWGBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:01:45 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 7/9] usb: musb: dsps: use get-usb-phy by phandle for multi instance
Date: Thu, 23 May 2013 11:31:26 +0530
Message-ID: <1369288888-8614-8-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of mutli instance support, use get-phy object using phandle
to return to repsective phy xceiv object for each instance

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 0096aad..0d8581b 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -416,7 +416,11 @@ static int dsps_musb_init(struct musb *musb)
 	musb->mregs += wrp->musb_core_offset;
 
 	/* NOP driver needs change if supporting dual instance */
-	musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
+	if (dev->parent->of_node)
+		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
+				"usb-phy", pdev->id);
+	else
+		musb->xceiv = devm_usb_get_phy_dev(dev, pdev->id);
 	if (IS_ERR_OR_NULL(musb->xceiv))
 		return -EPROBE_DEFER;
 
-- 
1.7.0.4

