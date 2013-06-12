Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3FLJY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:24:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41556 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab3FLJYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:24:20 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 1/3] usb: dwc3: omap: Adding am437x specific register map changes
Date: Wed, 12 Jun 2013 14:53:45 +0530
Message-ID: <1371029027-9100-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1371029027-9100-1-git-send-email-george.cherian@ti.com>
References: <1371029027-9100-1-git-send-email-george.cherian@ti.com>
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

