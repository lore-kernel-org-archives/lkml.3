Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3GHJvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:51:07 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:32193
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab3GHJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:50:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <lars@metafoo.de>,
        <robin.getz@analog.com>, <Michael.Hennerich@analog.com>,
        <lars-peter.clausen@analog.com>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH v2 4/4] BSC9131rdb/dts: Add nodes for supporting AIC
Date: Mon, 8 Jul 2013 15:20:02 +0530
Message-ID: <1373277002-14009-5-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1373277002-14009-4-git-send-email-akhil.goyal@freescale.com>
References: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
 <1373277002-14009-2-git-send-email-akhil.goyal@freescale.com>
 <1373277002-14009-3-git-send-email-akhil.goyal@freescale.com>
 <1373277002-14009-4-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

BSC9131 is a hetrogenous system where Antenna interface controller
(AIC) is a part of DSP subsystem. But its configuration is done from
PA side. So a DSP node is added with appropriate CCSR address visible
to PA and hence the address space for AIC will be visible to PA.

BSC9131 support 3 AIC lanes for ADI interface and 3 for MAXIM type of
interface. This patch support only ADI lanes.

Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
Signed-off-by: Shaveta Leekha <shaveta@freescale.com>
Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 arch/powerpc/boot/dts/bsc9131rdb.dts          |    4 ++
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi |   38 +++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/bsc9131rdb.dts b/arch/powerpc/boot/dts/bsc9131rdb.dts
index e13d2d4..c134de7 100644
--- a/arch/powerpc/boot/dts/bsc9131rdb.dts
+++ b/arch/powerpc/boot/dts/bsc9131rdb.dts
@@ -28,6 +28,10 @@
 	board_soc: soc: soc@ff700000 {
 		ranges = <0x0 0x0 0xff700000 0x100000>;
 	};
+
+	dsp_soc: sc3850@ff600000 {
+		ranges = <0x0 0x0 0xff600000 0x100000>;
+	};
 };
 
 /include/ "bsc9131rdb.dtsi"
diff --git a/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi b/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
index 5180d9d..487e949 100644
--- a/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
@@ -191,3 +191,41 @@ global-utilities@e0000 {
 		fsl,has-rstcr;
 	};
 };
+
+&dsp_soc {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "simple-bus";
+	gcr@18000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,bsc9131-gcr", "fsl,bsc9132-gcr";
+		reg = <0x18000 0x200>;
+	};
+	aic@50000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,bsc9131-aic", "fsl,bsc9132-aic";
+		reg = <0x50000 0x200>;
+		interrupts = <49 2 0 0 53 2 0 0>;
+		lane0: aiclane@200 {
+			reg = <0x200 0x200>;
+			lane_id = <0>;
+			interrupts = <45 2 0 0>;
+		};
+
+		lane1: aiclane@400 {
+			reg = <0x400 0x200>;
+			lane_id = <1>;
+			interrupts = <46 2 0 0>;
+		};
+
+		lane2: aiclane@600 {
+			reg = <0x600 0x200>;
+			lane_id = <2>;
+			interrupts = <47 2 0 0>;
+		};
+	};
+};
+
+
-- 
1.6.3.1



