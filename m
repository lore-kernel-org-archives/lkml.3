Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3GHJvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:51:02 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:54425
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab3GHJux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:50:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <lars@metafoo.de>,
        <robin.getz@analog.com>, <Michael.Hennerich@analog.com>,
        <lars-peter.clausen@analog.com>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH v2 3/4] binding: Add device tree bindings for freescale AIC
Date: Mon, 8 Jul 2013 15:20:01 +0530
Message-ID: <1373277002-14009-4-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1373277002-14009-3-git-send-email-akhil.goyal@freescale.com>
References: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
 <1373277002-14009-2-git-send-email-akhil.goyal@freescale.com>
 <1373277002-14009-3-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

For platforms like BSC9131 and BSC9132, a Radio framework for supporting
various network modes comprise of an Antenna interface controller driver
and a phy driver.
A combination of AIC lane and phy is called a rf device which can be used
to operate on a particular network mode.

This patch explain various device tree properties required for AIC driver

Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 Documentation/devicetree/bindings/rf/fsl-aic.txt |   47 ++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rf/fsl-aic.txt

diff --git a/Documentation/devicetree/bindings/rf/fsl-aic.txt b/Documentation/devicetree/bindings/rf/fsl-aic.txt
new file mode 100644
index 0000000..4f54a92
--- /dev/null
+++ b/Documentation/devicetree/bindings/rf/fsl-aic.txt
@@ -0,0 +1,47 @@
+Freescale Antenna Interface Controller
+
+AIC is the antenna interface controller found in bsc913x
+family of SOCs. It supports NCDMA, WCDMA-FDD, LTE-FDD, LTE-TDD
+and GSM-SNIFF network modes. AIC has multiple lanes on which RFICs
+can be connected. And AIC supports 4 RFICs working simultaneously.
+
+Required Properties:
+- #address-cells : should be 1
+- #size-cells : should be 1
+- compatible : should be fsl,bsc9131-aic or fsl,bsc9132-aic or both
+- reg : offset and length of common register set of AIC
+- interrupts : For AIC, first is capture complete interrupt
+		second is dsp general interrupt
+aic node can have multiple sub nodes of aiclanes for each lane.
+- aiclane : Required Properties
+	- reg : offset and length of common register set of AIC lane
+	- lane_id : it can be 0, 1, 2, 3, 4, 5
+	- interrupts : lane specific TTI interrupt line
+
+For Example:
+
+aic@50000 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "fsl,bsc9131-aic", "fsl,bsc9132-aic";
+	reg = <0x50000 0x200>;
+	interrupts = <49 2 0 0 53 2 0 0>;
+	lane0: aiclane@200 {
+		reg = <0x200 0x200>;
+		lane_id = <0>;
+		interrupts = <45 2 0 0>;
+	};
+
+	lane1: aiclane@400 {
+		reg = <0x400 0x200>;
+		lane_id = <1>;
+		interrupts = <46 2 0 0>;
+	};
+
+	lane2: aiclane@600 {
+		reg = <0x600 0x200>;
+		lane_id = <2>;
+		interrupts = <47 2 0 0>;
+	};
+};
+
-- 
1.6.3.1



