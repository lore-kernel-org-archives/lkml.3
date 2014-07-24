Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbaGXXBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:01:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274AbaGXXBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:16 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 06/11] ARM: dts: zynq: Add DMAC for Parallella
Date: Fri, 25 Jul 2014 01:00:15 +0200
Message-Id: <1406242820-20140-7-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2: New
 
 arch/arm/boot/dts/zynq-7000.dtsi      | 17 +++++++++++++++++
 arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index eed3df0..1a70277 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -223,6 +223,23 @@
 			};
 		};
 
+		dmac_s: dmac@f8003000 {
+			compatible = "arm,pl330", "arm,primecell";
+			reg = <0xf8003000 0x1000>;
+			status = "disabled";
+			interrupt-parent = <&intc>;
+			interrupts = <0 13 4>,
+			             <0 14 4>, <0 15 4>,
+			             <0 16 4>, <0 17 4>,
+			             <0 40 4>, <0 41 4>,
+			             <0 42 4>, <0 43 4>;
+			#dma-cells = <1>;
+			#dma-channels = <8>;
+			#dma-requests = <4>;
+			clocks = <&clkc 27>;
+			clock-names = "apb_pclk";
+		};
+
 		devcfg: devcfg@f8007000 {
 			compatible = "xlnx,zynq-devcfg-1.0";
 			reg = <0xf8007000 0x100>;
diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index 56f68ea..e60a0a9 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -34,6 +34,10 @@
 	};
 };
 
+&dmac_s {
+	status = "okay";
+};
+
 &gem0 {
 	status = "okay";
 	phy-mode = "rgmii-id";
-- 
1.9.3

