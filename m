Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966507Ab3DQOCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:02:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55847 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966321Ab3DQOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:02:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] dw_dmac: Couple of small fixups; use of '_' over '-' and a cell-num typo
Date: Wed, 17 Apr 2013 15:02:10 +0100
Message-Id: <1366207330-1727-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Device Tree '-' is always preferred over '_'. This is corrected in
code as well as in the documentation. Also, there are one too many
populated cells in the dmas example. Let's remove one of them to aid
with clarity.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/dma/snps-dma.txt |    4 ++--
 drivers/dma/dw_dmac.c                              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
index d58675e..aaccb9d 100644
--- a/Documentation/devicetree/bindings/dma/snps-dma.txt
+++ b/Documentation/devicetree/bindings/dma/snps-dma.txt
@@ -20,7 +20,7 @@ Required properties:
 Optional properties:
 - interrupt-parent: Should be the phandle for the interrupt controller
   that services interrupts for this device
-- is_private: The device channels should be marked as private and not for by the
+- is-private: The device channels should be marked as private and not for by the
   general purpose DMA channel allocator. False if not passed.
 
 Example:
@@ -58,6 +58,6 @@ Example:
 		interrupts = <0 35 0x4>;
 		status = "disabled";
 		dmas = <&dmahost 12 0 1>,
-			<&dmahost 13 0 1 0>;
+			<&dmahost 13 0 1>;
 		dma-names = "rx", "rx";
 	};
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c599558..3448819 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1592,7 +1592,7 @@ dw_dma_parse_dt(struct platform_device *pdev)
 	if (of_property_read_u32(np, "dma-channels", &pdata->nr_channels))
 		return NULL;
 
-	if (of_property_read_bool(np, "is_private"))
+	if (of_property_read_bool(np, "is-private"))
 		pdata->is_private = true;
 
 	if (!of_property_read_u32(np, "chan_allocation_order", &tmp))
-- 
1.7.10.4

