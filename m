Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaHTREz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:04:55 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59427 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaHTRE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:04:29 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        00regkh@linuxfoundation.org
Cc: mathieu.poirier@linaro.org, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com,
        daniel.thompson@linaro.org, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11 v4] coresight: adding support for beagle and beagleXM
Date: Wed, 20 Aug 2014 11:03:49 -0600
Message-Id: <1408554231-24321-10-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408554231-24321-1-git-send-email-mathieu.poirier@linaro.org>
References: <1408554231-24321-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Currently supporting ETM and ETB.  Support for TPIU
and SDTI are yet to be added.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts | 28 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap3-beagle.dts    | 28 ++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 1becefc..eec73d8 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -145,6 +145,34 @@
 			};
 		};
 	};
+
+	etb@5401b000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0x5401b000 0x1000>;
+
+		coresight-default-sink;
+		clocks = <&emu_src_ck>;
+		clock-names = "apb_pclk";
+		port {
+			etb_in: endpoint {
+				slave-mode;
+				remote-endpoint = <&etm_out>;
+			};
+		};
+	};
+
+	etm@54010000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0x54010000 0x1000>;
+
+		clocks = <&emu_src_ck>;
+		clock-names = "apb_pclk";
+		port {
+			etm_out: endpoint {
+				remote-endpoint = <&etb_in>;
+			};
+		};
+	};
 };
 
 &omap3_pmx_wkup {
diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 3c3e6da..a151daf 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -140,6 +140,34 @@
 			};
 		};
 	};
+
+	etb@540000000 {
+		compatible = "arm,coresight-etb10", "arm,primecell";
+		reg = <0x5401b000 0x1000>;
+
+		coresight-default-sink;
+		clocks = <&emu_src_ck>;
+		clock-names = "apb_pclk";
+		port {
+			etb_in: endpoint {
+				slave-mode;
+				remote-endpoint = <&etm_out>;
+			};
+		};
+	};
+
+	etm@54010000 {
+		compatible = "arm,coresight-etm3x", "arm,primecell";
+		reg = <0x54010000 0x1000>;
+
+		clocks = <&emu_src_ck>;
+		clock-names = "apb_pclk";
+		port {
+			etm_out: endpoint {
+				remote-endpoint = <&etb_in>;
+			};
+		};
+	};
 };
 
 &omap3_pmx_wkup {
-- 
1.9.1

