Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaFIJFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:03 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58503 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/146] usb: gadget: at91-udc: fix irq and iomem resource retrieval
Date: Mon,  9 Jun 2014 10:49:51 +0200
Message-Id: <4999a062177c37f7ea1a21c45720cb36d3dbe8cf.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 886c7c426d465732ec9d1b2bbdda5642fc2e7e05 upstream.

When using dt resources retrieval (interrupts and reg properties) there is
no predefined order for these resources in the platform dev resource
table. Also don't expect the number of resource to be always 2.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/at91_udc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 4cc4fd6d1473..dfd29438a11e 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1710,16 +1710,6 @@ static int at91udc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (pdev->num_resources != 2) {
-		DBG("invalid num_resources\n");
-		return -ENODEV;
-	}
-	if ((pdev->resource[0].flags != IORESOURCE_MEM)
-			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
-		DBG("invalid resource type\n");
-		return -ENODEV;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;
-- 
1.9.3

