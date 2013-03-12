Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab3CLK0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:26:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab3CLK0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:26:16 -0400
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 3/6] mfd: omap-usb-host: Actually update hostconfig
Date: Tue, 12 Mar 2013 12:25:37 +0200
Message-ID: <1363083940-20050-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363083940-20050-1-git-send-email-rogerq@ti.com>
References: <1363083940-20050-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper functions omap_usbhs_rev1_hostconfig()
and omap_usbhs_rev2_hostconfig() don't write into
the hostconfig register. Make sure that we write
the return value into the hostconfig register.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 502a779..c3efe64 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -446,15 +446,15 @@ static void omap_usbhs_init(struct device *dev)
 
 	switch (omap->usbhs_rev) {
 	case OMAP_USBHS_REV1:
-		omap_usbhs_rev1_hostconfig(omap, reg);
+		reg = omap_usbhs_rev1_hostconfig(omap, reg);
 		break;
 
 	case OMAP_USBHS_REV2:
-		omap_usbhs_rev2_hostconfig(omap, reg);
+		reg = omap_usbhs_rev2_hostconfig(omap, reg);
 		break;
 
 	default:	/* newer revisions */
-		omap_usbhs_rev2_hostconfig(omap, reg);
+		reg = omap_usbhs_rev2_hostconfig(omap, reg);
 		break;
 	}
 
-- 
1.7.4.1

