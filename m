Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaIXQth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:49:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:49715 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaIXQrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749924"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 26/27] usb: musb: omap2430: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:16 +0530
Message-Id: <1411575342-31048-27-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/usb/musb/omap2430.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index d369bf1..17c6c49 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -293,8 +293,7 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_NONE;
 		if (musb->gadget_driver) {
 			omap2430_musb_set_vbus(musb, 0);
-			pm_runtime_mark_last_busy(dev);
-			pm_runtime_put_autosuspend(dev);
+			pm_runtime_last_busy_and_autosuspend(dev);
 		}
 
 		if (data->interface_type == MUSB_INTERFACE_UTMI)
@@ -321,8 +320,7 @@ static void omap_musb_mailbox_work(struct work_struct *mailbox_work)
 
 	pm_runtime_get_sync(dev);
 	omap_musb_set_mailbox(glue);
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
+	pm_runtime_last_busy_and_autosuspend(dev);
 }
 
 static irqreturn_t omap2430_musb_interrupt(int irq, void *__hci)
-- 
1.7.0.4

