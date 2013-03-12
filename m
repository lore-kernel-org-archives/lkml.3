Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3CLL1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:27:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53375 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab3CLLZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:25:46 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <mark.rutland@arm.com>, <mkl@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 6/8] usb: phy: nop: use new PHY API to register PHY
Date: Tue, 12 Mar 2013 13:24:24 +0200
Message-ID: <1363087466-32444-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363087466-32444-1-git-send-email-rogerq@ti.com>
References: <1363087466-32444-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would need to support multiple PHYs of the same type
so use the new PHY API usb_add_phy_dev() to register the PHY.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/otg/nop-usb-xceiv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 6efc9b7..fe7a460 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -198,12 +198,13 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	nop->phy.init		= nop_init;
 	nop->phy.shutdown	= nop_shutdown;
 	nop->phy.state		= OTG_STATE_UNDEFINED;
+	nop->phy.type		= type;
 
 	nop->phy.otg->phy		= &nop->phy;
 	nop->phy.otg->set_host		= nop_set_host;
 	nop->phy.otg->set_peripheral	= nop_set_peripheral;
 
-	err = usb_add_phy(&nop->phy, type);
+	err = usb_add_phy_dev(&nop->phy);
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
-- 
1.7.4.1

