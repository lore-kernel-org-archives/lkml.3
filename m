Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab3K2IHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:07:47 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:34123
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985Ab3K2IHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:07:46 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: <hongbo.zhang@freescale.com>
To: <scottwood@freescale.com>, <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH] DTS: DMA: Fix DMA3 interrupts
Date: Fri, 29 Nov 2013 16:07:26 +0800
Message-ID: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

MPIC registers for internal interrupts is non-continous in address, any
internal interrupt number greater than 159 should be added (16+208) to work.
16 is due to external interrupts as usual, 208 is due to the non-continous MPIC
register space.
Tested on T4240 rev2 with SRIO2 disabled.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi b/arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi
index b89d816..d3cc8d0 100644
--- a/arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/elo3-dma-2.dtsi
@@ -42,41 +42,41 @@ dma2: dma@102300 {
 	dma-channel@0 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x0 0x80>;
-		interrupts = <256 2 0 0>;
+		interrupts = <464 2 0 0>;
 	};
 	dma-channel@80 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x80 0x80>;
-		interrupts = <257 2 0 0>;
+		interrupts = <465 2 0 0>;
 	};
 	dma-channel@100 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x100 0x80>;
-		interrupts = <258 2 0 0>;
+		interrupts = <466 2 0 0>;
 	};
 	dma-channel@180 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x180 0x80>;
-		interrupts = <259 2 0 0>;
+		interrupts = <467 2 0 0>;
 	};
 	dma-channel@300 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x300 0x80>;
-		interrupts = <260 2 0 0>;
+		interrupts = <468 2 0 0>;
 	};
 	dma-channel@380 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x380 0x80>;
-		interrupts = <261 2 0 0>;
+		interrupts = <469 2 0 0>;
 	};
 	dma-channel@400 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x400 0x80>;
-		interrupts = <262 2 0 0>;
+		interrupts = <470 2 0 0>;
 	};
 	dma-channel@480 {
 		compatible = "fsl,eloplus-dma-channel";
 		reg = <0x480 0x80>;
-		interrupts = <263 2 0 0>;
+		interrupts = <471 2 0 0>;
 	};
 };
-- 
1.7.9.5



