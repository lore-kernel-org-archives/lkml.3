Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3LaQhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:37:13 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:58516 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3LaQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:37:09 -0500
From: jjhiblot@traphandler.com
To: nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] at91: ohci: fixed broken sanity check
Date: Tue, 31 Dec 2013 17:33:44 +0100
Message-Id: <1388507624-10636-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>

The test (pdev->resource[1].flags != IORESOURCE_IRQ) is broken because the flags
value may contain not only the information IORESSOURCE_IRQ but also the IRQ type
(IORESOURCE_IRQ_HIGHLEVEL for example).

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/usb/host/ohci-at91.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 418444e..df9c8a4 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -142,8 +142,8 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		return -ENODEV;
 	}
 
-	if ((pdev->resource[0].flags != IORESOURCE_MEM)
-			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
+	if (!(pdev->resource[0].flags & IORESOURCE_MEM)
+			|| !(pdev->resource[1].flags & IORESOURCE_IRQ)) {
 		pr_debug("hcd probe: invalid resource type\n");
 		return -ENODEV;
 	}
-- 
1.8.4.2

