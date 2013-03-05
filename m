Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3CEVNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:13:16 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:46687 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3CEVNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:13:04 -0500
From: Matt Porter <mporter@ti.com>
To: Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 3/3] mmc: omap_hsmmc: add generic DMA request support to the DT binding
Date: Tue,  5 Mar 2013 16:13:24 -0500
Message-Id: <1362518004-7083-4-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362518004-7083-1-git-send-email-mporter@ti.com>
References: <1362518004-7083-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binding definition is based on the generic DMA request binding.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   26 +++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index ed271fc..8c8908a 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -20,8 +20,29 @@ ti,dual-volt: boolean, supports dual voltage cards
 ti,non-removable: non-removable slot (like eMMC)
 ti,needs-special-reset: Requires a special softreset sequence
 ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
+dmas: List of DMA specifiers with the controller specific format
+as described in the generic DMA client binding. A tx and rx
+specifier is required.
+dma-names: List of DMA request names. These strings correspond
+1:1 with the DMA specifiers listed in dmas. The string naming is
+to be "rx" and "tx" for RX and TX DMA requests, respectively.
+
+Examples:
+
+[hwmod populated DMA resources]
+
+	mmc1: mmc@0x4809c000 {
+		compatible = "ti,omap4-hsmmc";
+		reg = <0x4809c000 0x400>;
+		ti,hwmods = "mmc1";
+		ti,dual-volt;
+		bus-width = <4>;
+		vmmc-supply = <&vmmc>; /* phandle to regulator node */
+		ti,non-removable;
+	};
+
+[generic DMA request binding]
 
-Example:
 	mmc1: mmc@0x4809c000 {
 		compatible = "ti,omap4-hsmmc";
 		reg = <0x4809c000 0x400>;
@@ -30,4 +51,7 @@ Example:
 		bus-width = <4>;
 		vmmc-supply = <&vmmc>; /* phandle to regulator node */
 		ti,non-removable;
+		dmas = <&edma 24
+			&edma 25>;
+		dma-names = "tx", "rx";
 	};
-- 
1.7.9.5

