Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3AYDNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:13:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35888 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab3AYDMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:12:53 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v1 8/8] usb: otg: palmas-usb: fix cold plug issue
Date: Fri, 25 Jan 2013 08:42:31 +0530
Message-ID: <1359083551-8524-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359083551-8524-1-git-send-email-kishon@ti.com>
References: <1359083551-8524-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if the cable is connected even before the palmas-usb is loaded, the
cable connect detection event will be missed. It's fixed here by checking
for VBUS line states when palmas-usb is loaded.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/palmas-usb.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/otg/palmas-usb.c b/drivers/usb/otg/palmas-usb.c
index 07629cd..d62f673 100644
--- a/drivers/usb/otg/palmas-usb.c
+++ b/drivers/usb/otg/palmas-usb.c
@@ -187,6 +187,11 @@ static int palmas_enable_irq(struct palmas_usb *palmas_usb)
 	palmas_usb_write(palmas_usb->palmas, PALMAS_USB_ID_INT_EN_HI_SET,
 			PALMAS_USB_ID_INT_EN_HI_SET_ID_GND);
 
+	palmas_vbus_wakeup_irq(palmas_usb->irq4, palmas_usb);
+
+	if (palmas_usb->linkstat == OMAP_DWC3_UNKNOWN)
+		palmas_id_wakeup_irq(palmas_usb->irq2, palmas_usb);
+
 	return 0;
 }
 
-- 
1.7.9.5

