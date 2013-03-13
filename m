Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3CMIr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:47:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46121 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3CMIrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:47:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 1/5] usb: musb: omap: remove the check before calling otg_set_vbus
Date: Wed, 13 Mar 2013 14:17:06 +0530
Message-ID: <1363164430-19118-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363164430-19118-1-git-send-email-kishon@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
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
index 558c1d6..78bfc50 100644
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
@@ -293,10 +292,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
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

