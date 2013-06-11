Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3FKHTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:19:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36584 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab3FKHSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:18:08 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v2 5/7] usb: musb: dsps: use get-usb-phy by phandle for multi instance
Date: Tue, 11 Jun 2013 12:47:50 +0530
Message-ID: <1370935072-21056-6-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
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

