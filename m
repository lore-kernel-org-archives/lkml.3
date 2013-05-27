Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3E0ID2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:03:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47648 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab3E0IDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:03:24 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 1/3] usb: dwc3: omap: Adding am437x specific register map changes
Date: Mon, 27 May 2013 13:32:55 +0530
Message-ID: <1369641777-4509-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
References: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM437x and OMAP5 dwc3 subsytem have different register map.
Major differences are as follows.

OMAP5 has one main interrupt and one misc interrupt
Aegis has four main interrupts and one misc interrupt.

Miscellanous Interrupt offsets are changed.
UTMI OTG Control and Status Registers offsets are changed.
DEBUG Configuration and Status Registers are changed.

The main intend of the patch is to re-use the same wrapper driver
for both OMAP5 and AM437x, by using the x_major in revision
register and adjusting the offsets.

This patch adds the register map offsets and adds offset variables
in struct dwc3_omap to cache the offsets

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 34638b9..a354b4c 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -122,6 +122,12 @@ struct dwc3_omap {
 	void __iomem		*base;
 
 	u32			utmi_otg_status;
+	u32			utmi_otg_offset;
+	u32			irqmisc_offset;
+	u32			irq_eoi_offset;
+	u32			debug_offset;
+	u32			irq0_offset;
+	u32			revision;
 
 	u32			dma_status:1;
 };
-- 
1.8.1.4

