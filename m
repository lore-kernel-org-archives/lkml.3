Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3FQISE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:18:04 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:56657
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab3FQIR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:17:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH 4/5] binding: Add device tree bindings for freescale AIC and AD phy
Date: Mon, 17 Jun 2013 13:39:25 +0530
Message-ID: <1371456566-4934-5-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-3-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

For platforms like BSC9131 and BSC9132, a Radio framework for supporting
various network modes comprise of an Antenna interface controller driver
and a phy driver(AD9361 in this case).
A combination of AIC lane and AD phy is called a rf device which can be used
to operate on a particular network mode.

This patch explain various device tree properties required for AIC and
AD9361 drivers.

Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 .../devicetree/bindings/rf/ad9361-phy.txt          |   53 ++++++++++++++++++++
 Documentation/devicetree/bindings/rf/fsl-aic.txt   |   47 +++++++++++++++++
 2 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rf/ad9361-phy.txt
 create mode 100644 Documentation/devicetree/bindings/rf/fsl-aic.txt

diff --git a/Documentation/devicetree/bindings/rf/ad9361-phy.txt b/Documentation/devicetree/bindings/rf/ad9361-phy.txt
new file mode 100644
index 0000000..9dbf736
--- /dev/null
+++ b/Documentation/devicetree/bindings/rf/ad9361-phy.txt
@@ -0,0 +1,53 @@
+* AD9361-phy
+
+Required Properties:
+- compatible : should be "adi,ad9361"
+- reg : chipselect of the spi controller
+- spi-max-frequency :  maximum spi bus frequency for this device (Hz).
+- spi-cpha : (optional) Empty property indicating device requires
+		shifted clock phase (CPHA) mode
+- fsl,ad9361-gpios : Specifies GPIOs being used for AD9361
+		This sequence shall be maintained.
+		Here, <&gpio1 2 1> denotes reset gpio
+		<&gpio0 18 1> denotes pa_en gpio
+		<&gpio0 17 1> denotes lna_en gpio
+- fsl,ad9361-band-grpX : denotes group of LTE/WCDMA bands available for a
+  particular combination of values of pa_en and lna_en gpios.
+  where X can be 1,2,3,4
+	- fsl,ad9361-bands : denotes LTE/WCDMA band numbers for normal DL/UL
+	- fsl,ad9361-sniff-bands : denotes LTE/WCDMA band numbers for sniffing
+	- fsl,ad9361-lna : if present in the node then, lna_en gpio is enabled
+	- fsl,ad9361-pa : if present in the node then, pa_en gpio is enabled
+
+For Example:
+
+rfphy0: ad9361-phy@0{
+	compatible = "adi,ad9361";
+	reg = <0>;
+	spi-max-frequency = <20000000>;
+	spi-cpha;
+	fsl,ad9361-gpios = <&gpio1 2 1 &gpio0 18 1 &gpio0 17 1>;
+	fsl,ad9361-band-grp1 {
+		fsl,ad9361-bands = <1 7>;
+		fsl,ad9361-sniff-bands = <>;
+	};
+	fsl,ad9361-band-grp2 {
+		fsl,ad9361-lna;
+		fsl,ad9361-bands= <41>;
+		fsl,ad9361-sniff-bands = <13>;
+	};
+	fsl,ad9361-band-grp3 {
+		fsl,ad9361-pa;
+		fsl,ad9361-bands = <>;
+		fsl,ad9361-sniff-bands = <1 7>;
+	};
+	fsl,ad9361-band-grp4 {
+		fsl,ad9361-pa;
+		fsl,ad9361-lna;
+		fsl,ad9361-bands = <13 40>;
+		fsl,ad9361-sniff-bands = <>;
+	};
+};
+
+
+
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



