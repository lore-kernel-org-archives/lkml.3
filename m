Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3JHM0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:26:15 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61616 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3JHMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:24:45 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] ARM: l2x0: add Marvell Tauros3 compatible
Date: Tue,  8 Oct 2013 14:24:28 +0200
Message-Id: <1381235073-17134-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add a compatible for the Marvell Tauros3 cache controller which
is compatible with l2x0 cache controllers. While updating the binding
documentation, clean up the list of possible compatibles.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/devicetree/bindings/arm/l2cc.txt |   22 +++++++++++-----------
 arch/arm/mm/cache-l2x0.c                       |    1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index c0c7626..a1d0cbd 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -7,20 +7,20 @@ The ARM L2 cache representation in the device tree should be done as follows:
 Required properties:
 
 - compatible : should be one of:
-	"arm,pl310-cache"
-	"arm,l220-cache"
-	"arm,l210-cache"
-	"marvell,aurora-system-cache": Marvell Controller designed to be
+  "arm,pl310-cache"
+  "arm,l220-cache"
+  "arm,l210-cache"
+  "bcm,bcm11351-a2-pl310-cache": DEPRECATED by "brcm,bcm11351-a2-pl310-cache"
+  "brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
+     offset needs to be added to the address before passing down to the L2
+     cache controller
+  "marvell,aurora-system-cache": Marvell Controller designed to be
      compatible with the ARM one, with system cache mode (meaning
      maintenance operations on L1 are broadcasted to the L2 and L2
      performs the same operation).
-	"marvell,"aurora-outer-cache: Marvell Controller designed to be
-	 compatible with the ARM one with outer cache mode.
-	"brcm,bcm11351-a2-pl310-cache": For Broadcom bcm11351 chipset where an
-	offset needs to be added to the address before passing down to the L2
-	cache controller
-	"bcm,bcm11351-a2-pl310-cache": DEPRECATED by
-	                               "brcm,bcm11351-a2-pl310-cache"
+  "marvell,aurora-outer-cache": Marvell Controller designed to be
+     compatible with the ARM one with outer cache mode.
+  "marvell,tauros3-cache": Marvell Tauros3 cache controller.
 - cache-unified : Specifies the cache is a unified cache.
 - cache-level : Should be set to 2 for a level 2 cache.
 - reg : Physical base address and size of cache controller's memory mapped
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 447da6f..90c776e 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -929,6 +929,7 @@ static const struct of_device_id l2x0_ids[] __initconst = {
 	  .data = (void *)&aurora_no_outer_data},
 	{ .compatible = "marvell,aurora-outer-cache",
 	  .data = (void *)&aurora_with_outer_data},
+	{ .compatible = "marvell,tauros3-cache", .data = (void *)&l2x0_data },
 	{ .compatible = "brcm,bcm11351-a2-pl310-cache",
 	  .data = (void *)&bcm_l2x0_data},
 	{ .compatible = "bcm,bcm11351-a2-pl310-cache", /* deprecated name */
-- 
1.7.10.4

