Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbaGXXCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:02:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbaGXXBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:19 -0400
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
Subject: [PATCH v2 08/11] ARM: dts: zynq: Add VDMA to Parallella
Date: Fri, 25 Jul 2014 01:00:17 +0200
Message-Id: <1406242820-20140-9-git-send-email-afaerber@suse.de>
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
 
 arch/arm/boot/dts/zynq-parallella.dts | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index e60a0a9..8beaacc 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -32,6 +32,31 @@
 		bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
 		linux,stdout-path = "/amba/serial@e0001000";
 	};
+
+	fpga {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		axi_vdma: axi-vdma@43000000 {
+			compatible = "xlnx,axi-vdma-1.00.a";
+			reg = <0x43000000 0x1000>;
+			#dma-cells = <1>;
+			xlnx,num-fstores = <3>;
+			xlnx,include-sg = <0>;
+			xlnx,flush-fsync = <2>;
+
+			dma-channel@43000000 {
+				compatible = "xlnx,axi-vdma-mm2s-channel";
+				interrupt-parent = <&intc>;
+				interrupts = <0 59 4>;
+				xlnx,datawidth = <64>;
+				xlnx,include-dre = <0>;
+				xlnx,genlock-mode = <0>;
+			};
+		};
+	};
 };
 
 &dmac_s {
-- 
1.9.3

