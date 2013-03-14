Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3CNGYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:24:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40617 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab3CNGYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:24:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v2 1/4] usb: musb: omap: remove the check before calling otg_set_vbus
Date: Thu, 14 Mar 2013 11:53:56 +0530
Message-ID: <1363242239-1061-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363242239-1061-1-git-send-email-kishon@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. otg_set_vbus is already protected so removed the
check before calling otg_set_vbus.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 29014c0..6071484 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -174,8 +174,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 				}
 			}
 
-			if (otg->set_vbus)
-				otg_set_vbus(otg, 1);
+			otg_set_vbus(otg, 1);
 		} else {
 			musb->is_active = 1;
 			otg->default_a = 1;
@@ -297,10 +296,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		}
 
 		omap2430_musb_set_vbus(musb, 0);
-		if (data->interface_type == MUSB_INTERFACE_UTMI) {
-			if (musb->xceiv->otg->set_vbus)
-				otg_set_vbus(musb->xceiv->otg, 0);
-		}
+		if (data->interface_type == MUSB_INTERFACE_UTMI)
+			otg_set_vbus(musb->xceiv->otg, 0);
 		omap_control_usb_set_mode(glue->control_otghs,
 			USB_MODE_DISCONNECT);
 		break;
-- 
1.7.10.4

