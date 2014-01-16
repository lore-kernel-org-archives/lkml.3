Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaAPBiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:38:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49030 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAPBim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:38:42 -0500
Date: Wed, 15 Jan 2014 17:38:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] devicetree: bindings: Document Krait CPU/L1 EDAC
Message-ID: <20140116013840.GA674@codeaurora.org>
References: <1389735034-21430-1-git-send-email-sboyd@codeaurora.org>
 <1389735034-21430-3-git-send-email-sboyd@codeaurora.org>
 <20140115102701.GA27314@e102568-lin.cambridge.arm.com>
 <20140115165623.GJ14405@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115165623.GJ14405@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Stephen Boyd wrote:
> 
> Ah sorry, I forgot to put the compatible property here like in
> the dts change. I'll do that in the next revision. Yes we need a
> compatible property here to match the platform driver.
> 

This is the replacement patch

-----8<------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v9] devicetree: bindings: Document Krait CPU/L1 EDAC

The Krait CPU/L1 error reporting device is made up a per-CPU
interrupt. While we're here, document the next-level-cache
property that's used by the Krait EDAC driver.

Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt | 58 ++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 91304353eea4..03a529e791c4 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -62,6 +62,20 @@ nodes to be present and contain the properties described below.
 		Value type: <u32>
 		Definition: must be set to 0
 
+	- compatible
+		Usage: optional
+		Value type: <string>
+		Definition: should be one of the compatible strings listed
+			    in the cpu node compatible property. This property
+			    shall only be present if all the cpu nodes have the
+			    same compatible property.
+
+	- interrupts
+		Usage: required when node contains cpus with compatible
+		       string "qcom,krait".
+		Value type: <prop-encoded-array>
+		Definition: L1/CPU error interrupt
+
 - cpu node
 
 	Description: Describes a CPU in an ARM based system
@@ -191,6 +205,11 @@ nodes to be present and contain the properties described below.
 			  property identifying a 64-bit zero-initialised
 			  memory location.
 
+	- next-level-cache
+		Usage: optional
+		Value type: <phandle>
+		Definition: phandle pointing to the next level cache
+
 Example 1 (dual-cluster big.LITTLE system 32-bit):
 
 	cpus {
@@ -382,3 +401,42 @@ cpus {
 		cpu-release-addr = <0 0x20000000>;
 	};
 };
+
+
+Example 5 (Krait 32-bit system):
+
+cpus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	interrupts = <1 9 0xf04>;
+	compatible = "qcom,krait";
+
+	cpu@0 {
+		device_type = "cpu";
+		reg = <0>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@1 {
+		device_type = "cpu";
+		reg = <1>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@2 {
+		device_type = "cpu";
+		reg = <2>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@3 {
+		device_type = "cpu";
+		reg = <3>;
+		next-level-cache = <&L2>;
+	};
+
+	L2: l2-cache {
+		compatible = "cache";
+		interrupts = <0 2 0x4>;
+	};
+};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
