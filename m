Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaIYPGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:06:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42132 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbaIYPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:06:23 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        <ben.dooks@codethink.co.uk>, <laurent.pinchart@ideasonboard.com>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 4/4] ARM: dts: k2hk-evm: add pm domains for net, qmss and knav_dmas
Date: Thu, 25 Sep 2014 18:05:37 +0300
Message-ID: <1411657537-25238-5-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
References: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Keystone PM domains nodes for NetCP, NetCPx, QMSS, KNAV-DMA
devices.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/k2hk-evm.dts | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
index 91371f7..a7b468c 100644
--- a/arch/arm/boot/dts/k2hk-evm.dts
+++ b/arch/arm/boot/dts/k2hk-evm.dts
@@ -58,6 +58,13 @@
 				clock-output-names = "refclk-ddr3b";
 			};
 		};
+
+		qmss_domain: qmss_pm_controller {
+			compatible = "ti,keystone-gpc";
+			clocks = <&chipclk13>;
+			#power-domain-cells = <0>;
+		};
+
 		qmss: qmss@2a40000 {
 			compatible = "ti,keystone-navigator-qmss";
 			dma-coherent;
@@ -65,6 +72,8 @@
 			#size-cells = <1>;
 			clocks = <&chipclk13>;
 			ranges;
+			power-domains = <&qmss_domain>;
+
 			queue-range	= <0 0x4000>;
 			linkram0	= <0x100000 0x8000>;
 			linkram1	= <0x0 0x10000>;
@@ -192,12 +201,20 @@
 			};
 		}; /* qmss */
 
+		knav_dmas_domain: knav_dmas_pm_controller {
+			compatible = "ti,keystone-gpc";
+			clocks = <&clkpa>, <&clkxge>;
+			#power-domain-cells = <0>;
+		};
+
 		knav_dmas: knav_dmas@0 {
 			compatible = "ti,keystone-navigator-dma";
 			clocks = <&clkpa>, <&clkxge>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
+			power-domains = <&knav_dmas_domain>;
+
 			ti,navigator-cloud-address = <0x23a80000 0x23a90000
 						   0x23aa0000 0x23ab0000>;
 
@@ -222,6 +239,12 @@
 			};
 		};
 
+		netcp_domain: netcp_pm_controller {
+			compatible = "ti,keystone-gpc";
+			clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
+			#power-domain-cells = <0>;
+		};
+
 		netcp: netcp@2090000 {
 			reg = <0x2620110 0x8>;
 			reg-names = "efuse";
@@ -229,6 +252,7 @@
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
+			power-domains = <&netcp_domain>;
 
 			clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
 			dma-coherent;
@@ -302,11 +326,18 @@
 			};
 		};
 
+		netcpx_domain: netcpx_pm_controller {
+			compatible = "ti,keystone-gpc";
+			clocks = <&clkxge>;
+			#power-domain-cells = <0>;
+		};
+
 		netcpx: netcpx@2f00000 {
 			compatible = "ti,netcp-1.0";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
+			power-domains = <&netcpx_domain>;
 
 			clocks = <&clkxge>;
 			clock-names = "clk_xge";
-- 
1.9.1

