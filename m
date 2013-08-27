Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3H0KpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:45:01 -0400
Received: from [65.55.88.11] ([65.55.88.11]:36799 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab3H0Ko6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:44:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: <hongbo.zhang@freescale.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <vinod.koul@intel.com>, <djbw@fb.com>
CC: <devicetree@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v8 1/3] DMA: Freescale: revise device tree binding document
Date: Tue, 27 Aug 2013 18:42:01 +0800
Message-ID: <1377600123-5746-2-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377600123-5746-1-git-send-email-hongbo.zhang@freescale.com>
References: <1377600123-5746-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

This patch updates the discription of each type of DMA controller and its
channels, it is preparation for adding another new DMA controller binding, it
also fixes some defects of indent for text alignment at the same time.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 .../devicetree/bindings/powerpc/fsl/dma.txt        |   62 +++++++++-----------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
index 2a4b4bc..ddf17af 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
@@ -1,33 +1,29 @@
-* Freescale 83xx DMA Controller
+* Freescale DMA Controllers
 
-Freescale PowerPC 83xx have on chip general purpose DMA controllers.
+** Freescale Elo DMA Controller
+   This is a little-endian DMA controller, used in Freescale mpc83xx series
+   chips such as mpc8315, mpc8349, mpc8379 etc.
 
 Required properties:
 
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-dma", where CHIP is the processor
-		 (mpc8349, mpc8360, etc.) and the second is
-		 "fsl,elo-dma"
-- reg               : <registers mapping for DMA general status reg>
-- ranges		: Should be defined as specified in 1) to describe the
-		  DMA controller channels.
+- compatible        : must include "fsl,elo-dma"
+- reg               : <registers specifier for DMA general status reg>
+- ranges            : describes the mapping between the address space of the
+                      DMA channels and the address space of the DMA controller
 - cell-index        : controller index.  0 for controller @ 0x8100
-- interrupts        : <interrupt mapping for DMA IRQ>
+- interrupts        : <interrupt specifier for DMA IRQ>
 - interrupt-parent  : optional, if needed for interrupt mapping
 
-
 - DMA channel nodes:
-        - compatible        : compatible list, contains 2 entries, first is
-			 "fsl,CHIP-dma-channel", where CHIP is the processor
-			 (mpc8349, mpc8350, etc.) and the second is
-			 "fsl,elo-dma-channel". However, see note below.
-        - reg               : <registers mapping for channel>
+        - compatible        : must include "fsl,elo-dma-channel"
+                              However, see note below.
+        - reg               : <registers specifier for channel>
         - cell-index        : dma channel index starts at 0.
 
 Optional properties:
-        - interrupts        : <interrupt mapping for DMA channel IRQ>
-			  (on 83xx this is expected to be identical to
-			   the interrupts property of the parent node)
+        - interrupts        : <interrupt specifier for DMA channel IRQ>
+                              (on 83xx this is expected to be identical to
+                              the interrupts property of the parent node)
         - interrupt-parent  : optional, if needed for interrupt mapping
 
 Example:
@@ -70,30 +66,26 @@ Example:
 		};
 	};
 
-* Freescale 85xx/86xx DMA Controller
-
-Freescale PowerPC 85xx/86xx have on chip general purpose DMA controllers.
+** Freescale EloPlus DMA Controller
+   This is DMA controller with extended addresses and chaining, mainly used in
+   Freescale mpc85xx/86xx, Pxxx and BSC series chips, such as mpc8540, mpc8641
+   p4080, bsc9131 etc.
 
 Required properties:
 
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-dma", where CHIP is the processor
-		 (mpc8540, mpc8540, etc.) and the second is
-		 "fsl,eloplus-dma"
-- reg               : <registers mapping for DMA general status reg>
+- compatible        : must include "fsl,eloplus-dma"
+- reg               : <registers specifier for DMA general status reg>
 - cell-index        : controller index.  0 for controller @ 0x21000,
                                          1 for controller @ 0xc000
-- ranges		: Should be defined as specified in 1) to describe the
-		  DMA controller channels.
+- ranges            : describes the mapping between the address space of the
+                      DMA channels and the address space of the DMA controller
 
 - DMA channel nodes:
-        - compatible        : compatible list, contains 2 entries, first is
-			 "fsl,CHIP-dma-channel", where CHIP is the processor
-			 (mpc8540, mpc8560, etc.) and the second is
-			 "fsl,eloplus-dma-channel". However, see note below.
+        - compatible        : must include "fsl,eloplus-dma-channel"
+                              However, see note below.
         - cell-index        : dma channel index starts at 0.
-        - reg               : <registers mapping for channel>
-        - interrupts        : <interrupt mapping for DMA channel IRQ>
+        - reg               : <registers specifier for channel>
+        - interrupts        : <interrupt specifier for DMA channel IRQ>
         - interrupt-parent  : optional, if needed for interrupt mapping
 
 Example:
-- 
1.7.9.5



