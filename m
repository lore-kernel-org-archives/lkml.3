Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3HAWAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:00:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39783 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab3HAWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:00:36 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 26/51] DMA-API: usb: ohci-sa1111: add a note about DMA
 masks
Message-Id: <E1V50un-0006ry-AB@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:00:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment to explain why this driver doesn't call any of the DMA
API dma_set_mask() functions.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/usb/host/ohci-sa1111.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ohci-sa1111.c b/drivers/usb/host/ohci-sa1111.c
index 17b2a7d..aa9e127 100644
--- a/drivers/usb/host/ohci-sa1111.c
+++ b/drivers/usb/host/ohci-sa1111.c
@@ -185,6 +185,12 @@ static int ohci_hcd_sa1111_probe(struct sa1111_dev *dev)
 	if (usb_disabled())
 		return -ENODEV;
 
+	/*
+	 * We don't call dma_set_mask_and_coherent() here because the
+	 * DMA mask has already been appropraitely setup by the core
+	 * SA-1111 bus code (which includes bug workarounds.)
+	 */
+
 	hcd = usb_create_hcd(&ohci_sa1111_hc_driver, &dev->dev, "sa1111");
 	if (!hcd)
 		return -ENOMEM;
-- 
1.7.4.4

