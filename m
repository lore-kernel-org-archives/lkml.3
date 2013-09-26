Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3IZJeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:34:20 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:35602
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932114Ab3IZJeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:34:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: <hongbo.zhang@freescale.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <vinod.koul@intel.com>, <djbw@fb.com>
CC: <devicetree@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v11 1/3] DMA: Freescale: revise device tree binding document
Date: Thu, 26 Sep 2013 17:33:41 +0800
Message-ID: <1380188023-3936-2-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380188023-3936-1-git-send-email-hongbo.zhang@freescale.com>
References: <1380188023-3936-1-git-send-email-hongbo.zhang@freescale.com>
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
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 .../devicetree/bindings/powerpc/fsl/dma.txt        |   68 +++++++++-----------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
index 2a4b4bc..0584168 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
@@ -1,33 +1,30 @@
-* Freescale 83xx DMA Controller
+* Freescale DMA Controllers
 
-Freescale PowerPC 83xx have on chip general purpose DMA controllers.
+** Freescale Elo DMA Controller
+   This is a little-endian 4-channel DMA controller, used in Freescale mpc83xx
+   series chips such as mpc8315, mpc8349, mpc8379 etc.
 
 Required properties:
 
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-dma", where CHIP is the processor
-		 (mpc8349, mpc8360, etc.) and the second is
-		 "fsl,elo-dma"
-- reg               : <registers mapping for DMA general status reg>
-- ranges		: Should be defined as specified in 1) to describe the
-		  DMA controller channels.
+- compatible        : must include "fsl,elo-dma"
+- reg               : DMA General Status Register, i.e. DGSR which contains
+                      status for all the 4 DMA channels
+- ranges            : describes the mapping between the address space of the
+                      DMA channels and the address space of the DMA controller
 - cell-index        : controller index.  0 for controller @ 0x8100
-- interrupts        : <interrupt mapping for DMA IRQ>
+- interrupts        : interrupt specifier for DMA IRQ
 - interrupt-parent  : optional, if needed for interrupt mapping
 
-
 - DMA channel nodes:
-        - compatible        : compatible list, contains 2 entries, first is
-			 "fsl,CHIP-dma-channel", where CHIP is the processor
-			 (mpc8349, mpc8350, etc.) and the second is
-			 "fsl,elo-dma-channel". However, see note below.
-        - reg               : <registers mapping for channel>
-        - cell-index        : dma channel index starts at 0.
+        - compatible        : must include "fsl,elo-dma-channel"
+                              However, see note below.
+        - reg               : DMA channel specific registers
+        - cell-index        : DMA channel index starts at 0.
 
 Optional properties:
-        - interrupts        : <interrupt mapping for DMA channel IRQ>
-			  (on 83xx this is expected to be identical to
-			   the interrupts property of the parent node)
+        - interrupts        : interrupt specifier for DMA channel IRQ
+                              (on 83xx this is expected to be identical to
+                              the interrupts property of the parent node)
         - interrupt-parent  : optional, if needed for interrupt mapping
 
 Example:
@@ -70,30 +67,27 @@ Example:
 		};
 	};
 
-* Freescale 85xx/86xx DMA Controller
-
-Freescale PowerPC 85xx/86xx have on chip general purpose DMA controllers.
+** Freescale EloPlus DMA Controller
+   This is a 4-channel DMA controller with extended addresses and chaining,
+   mainly used in Freescale mpc85xx/86xx, Pxxx and BSC series chips, such as
+   mpc8540, mpc8641 p4080, bsc9131 etc.
 
 Required properties:
 
-- compatible        : compatible list, contains 2 entries, first is
-		 "fsl,CHIP-dma", where CHIP is the processor
-		 (mpc8540, mpc8540, etc.) and the second is
-		 "fsl,eloplus-dma"
-- reg               : <registers mapping for DMA general status reg>
+- compatible        : must include "fsl,eloplus-dma"
+- reg               : DMA General Status Register, i.e. DGSR which contains
+                      status for all the 4 DMA channels
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
-        - cell-index        : dma channel index starts at 0.
-        - reg               : <registers mapping for channel>
-        - interrupts        : <interrupt mapping for DMA channel IRQ>
+        - compatible        : must include "fsl,eloplus-dma-channel"
+                              However, see note below.
+        - cell-index        : DMA channel index starts at 0.
+        - reg               : DMA channel specific registers
+        - interrupts        : interrupt specifier for DMA channel IRQ
         - interrupt-parent  : optional, if needed for interrupt mapping
 
 Example:
-- 
1.7.9.5



