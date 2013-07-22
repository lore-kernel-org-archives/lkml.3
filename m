Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3GVF4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 01:56:47 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:39917
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab3GVF4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 01:56:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <vakul@freescale.com>, Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v4 2/3] DMA: Freescale: Add new 8-channel DMA engine device tree nodes
Date: Mon, 22 Jul 2013 13:55:39 +0800
Message-ID: <1374472540-21177-3-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374472540-21177-1-git-send-email-hongbo.zhang@freescale.com>
References: <1374472540-21177-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch add
the device tree nodes for them.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 .../devicetree/bindings/powerpc/fsl/dma.txt        |   66 ++++++++++++++++
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81 ++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81 ++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
 5 files changed, 232 insertions(+), 4 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
index 0650171..aa44e3c 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
@@ -138,6 +138,72 @@ Example:
 		};
 	};
 
+** Freescale ELO3 DMA Controller
+   This is ELOPLUS controller with 8 channels.
+   Used in Freescale new Txxx and Bxxx series chips, such as:
+   t4240, b4860, t1040
+
+Required properties:
+
+- compatible        : should be "fsl,elo3-dma"
+- reg               : <registers mapping for DMA general status reg>
+- ranges            : physical address range of DMA controller channels
+
+- DMA channel nodes:
+        - compatible        : should be "fsl,eloplus-dma-channel"
+        - reg               : <registers mapping for channel>
+        - interrupts        : <interrupt mapping for DMA channel IRQ>
+        - interrupt-parent  : optional, if needed for interrupt mapping
+
+Example:
+dma@100300 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "fsl,elo3-dma";
+	reg = <0x100300 0x4 0x100600 0x4>;
+	ranges = <0x0 0x100100 0x500>;
+	dma-channel@0 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x0 0x80>;
+		interrupts = <28 2 0 0>;
+	};
+	dma-channel@80 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x80 0x80>;
+		interrupts = <29 2 0 0>;
+	};
+	dma-channel@100 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x100 0x80>;
+		interrupts = <30 2 0 0>;
+	};
+	dma-channel@180 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x180 0x80>;
+		interrupts = <31 2 0 0>;
+	};
+	dma-channel@300 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x300 0x80>;
+		interrupts = <76 2 0 0>;
+	};
+	dma-channel@380 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x380 0x80>;
+		interrupts = <77 2 0 0>;
+	};
+	dma-channel@400 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x400 0x80>;
+		interrupts = <78 2 0 0>;
+	};
+	dma-channel@480 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x480 0x80>;
+		interrupts = <79 2 0 0>;
+	};
+};
+
 Note on DMA channel compatible properties: The compatible property must say
 "fsl,elo-dma-channel" or "fsl,eloplus-dma-channel" to be used by the Elo DMA
 driver (fsldma).  Any DMA channel used by fsldma cannot be used by another
diff --git a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
index 7399154..ea53ea1 100644
--- a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
@@ -223,13 +223,13 @@
 		reg = <0xe2000 0x1000>;
 	};
 
-/include/ "qoriq-dma-0.dtsi"
+/include/ "elo3-dma-0.dtsi"
 	dma@100300 {
 		fsl,iommu-parent = <&pamu0>;
 		fsl,liodn-reg = <&guts 0x580>; /* DMA1LIODNR */
 	};
 
-/include/ "qoriq-dma-1.dtsi"
+/include/ "elo3-dma-1.dtsi"
 	dma@101300 {
 		fsl,iommu-parent = <&pamu0>;
 		fsl,liodn-reg = <&guts 0x584>; /* DMA2LIODNR */
diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
new file mode 100644
index 0000000..bc8dc29
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
@@ -0,0 +1,81 @@
+/*
+ * QorIQ DMA device tree stub [ controller @ offset 0x100000 ]
+ *
+ * Copyright 2011-2013 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+dma0: dma@100300 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "fsl,elo3-dma";
+	reg = <0x100300 0x4 0x100600 0x4>;
+	ranges = <0x0 0x100100 0x500>;
+	dma-channel@0 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x0 0x80>;
+		interrupts = <28 2 0 0>;
+	};
+	dma-channel@80 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x80 0x80>;
+		interrupts = <29 2 0 0>;
+	};
+	dma-channel@100 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x100 0x80>;
+		interrupts = <30 2 0 0>;
+	};
+	dma-channel@180 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x180 0x80>;
+		interrupts = <31 2 0 0>;
+	};
+	dma-channel@300 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x300 0x80>;
+		interrupts = <76 2 0 0>;
+	};
+	dma-channel@380 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x380 0x80>;
+		interrupts = <77 2 0 0>;
+	};
+	dma-channel@400 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x400 0x80>;
+		interrupts = <78 2 0 0>;
+	};
+	dma-channel@480 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x480 0x80>;
+		interrupts = <79 2 0 0>;
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi b/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
new file mode 100644
index 0000000..06b38ff
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
@@ -0,0 +1,81 @@
+/*
+ * QorIQ DMA device tree stub [ controller @ offset 0x101000 ]
+ *
+ * Copyright 2011-2013 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+dma1: dma@101300 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "fsl,elo3-dma";
+	reg = <0x101300 0x4 0x101600 0x4>;
+	ranges = <0x0 0x101100 0x500>;
+	dma-channel@0 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x0 0x80>;
+		interrupts = <32 2 0 0>;
+	};
+	dma-channel@80 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x80 0x80>;
+		interrupts = <33 2 0 0>;
+	};
+	dma-channel@100 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x100 0x80>;
+		interrupts = <34 2 0 0>;
+	};
+	dma-channel@180 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x180 0x80>;
+		interrupts = <35 2 0 0>;
+	};
+	dma-channel@300 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x300 0x80>;
+		interrupts = <80 2 0 0>;
+	};
+	dma-channel@380 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x380 0x80>;
+		interrupts = <81 2 0 0>;
+	};
+	dma-channel@400 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x400 0x80>;
+		interrupts = <82 2 0 0>;
+	};
+	dma-channel@480 {
+		compatible = "fsl,eloplus-dma-channel";
+		reg = <0x480 0x80>;
+		interrupts = <83 2 0 0>;
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
index bd611a9..ec95c60 100644
--- a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
@@ -387,8 +387,8 @@
 		reg	   = <0xea000 0x4000>;
 	};
 
-/include/ "qoriq-dma-0.dtsi"
-/include/ "qoriq-dma-1.dtsi"
+/include/ "elo3-dma-0.dtsi"
+/include/ "elo3-dma-1.dtsi"
 
 /include/ "qoriq-espi-0.dtsi"
 	spi@110000 {
-- 
1.7.9.5



