Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbaHEKMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:12:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51613 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbaHEKMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:12:45 -0400
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <pekon.gupta@gmail.com>, <artem.bityutskiy@linux.intel.com>,
        <dwmw2@infradead.org>, <jg1.han@samsung.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 3/3] ARM: dts: omap3430-sdp: Revert to using software ECC for NAND
Date: Tue, 5 Aug 2014 13:11:22 +0300
Message-ID: <1407233482-11642-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407233482-11642-1-git-send-email-rogerq@ti.com>
References: <1407233482-11642-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v3.14 and prior, 1-bit Hamming code ECC via software was used
for NAND on this board.
Commit c06c52701695 in v3.15 changed the behaviour
to use 1-bit Hamming code via Hardware using a different ECC layout
i.e. (ROM code layout) than what is used by software ECC.

This ECC layout change causes NAND filesystems created in v3.14
and prior to be unusable in v3.15 and later. So revert back to
using software ECC scheme.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3430-sdp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3430-sdp.dts b/arch/arm/boot/dts/omap3430-sdp.dts
index 02f69f4..9bad94e 100644
--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -107,7 +107,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <1 0 0x08000000>;
-		ti,nand-ecc-opt = "ham1";
+		ti,nand-ecc-opt = "sw";
 		nand-bus-width = <8>;
 		gpmc,cs-on-ns = <0>;
 		gpmc,cs-rd-off-ns = <36>;
-- 
1.8.3.2

