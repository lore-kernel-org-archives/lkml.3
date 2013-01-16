Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3APPET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:04:19 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46118 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab3APPCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:02:34 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <horms@verge.net.au>, <magnus.damm@gmail.com>, <cbou@mail.ru>,
        <dwmw2@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <leoli@freescale.com>,
        <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <stern@rowland.harvard.edu>, <kishon@ti.com>
Subject: [RFC PATCH 6/6] USB: MUSB: OMAP: get PHY by phandle for dt boot
Date: Wed, 16 Jan 2013 20:31:02 +0530
Message-ID: <1358348462-27693-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358348462-27693-1-git-send-email-kishon@ti.com>
References: <1358348462-27693-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP glue has been modified to get PHY by phandle for dt boot.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 3628a50..08709cf 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -346,7 +346,12 @@ static int omap2430_musb_init(struct musb *musb)
 	 * up through ULPI.  TWL4030-family PMICs include one,
 	 * which needs a driver, drivers aren't always needed.
 	 */
-	musb->xceiv = devm_usb_get_phy(dev, 0);
+	if (dev->parent->of_node)
+		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
+		    "usb_phy", 0);
+	else
+		musb->xceiv = devm_usb_get_phy(dev, 0);
+
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -ENODEV;
-- 
1.7.9.5

