Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbaE3NoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:44:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47711 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbaE3NoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:44:01 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: [RFC PATCH 08/11] coresight: adding support for beagle board
Date: Fri, 30 May 2014 07:43:08 -0600
Message-Id: <1401457391-12242-9-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>

Added support for coresight device in dts for Beagle Board, by adding
blocks of coresight, ETM, ETB blocks.

Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
---
 arch/arm/boot/dts/omap3-beagle.dts | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 5053766..0017084 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -80,6 +80,36 @@
 		};
 
 	};
+
+	coresight {
+		compatible = "arm,coresight";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		clocks = <&emu_src_ck>;
+		ranges;
+
+		etb: etb@540000000 {
+			compatible = "arm,coresight-etb";
+			reg = <0x5401b000 0x1000>;
+
+			coresight-id = <0>;
+			coresight-name = "coresight-etb";
+			coresight-nr-inports = <1>;
+			coresight-default-sink;
+		};
+
+		etm@54010000 {
+			compatible = "arm,coresight-etm";
+			reg = <0x54010000 0x1000>;
+
+			coresight-id = <1>;
+			coresight-name = "coresight-etm";
+			coresight-nr-inports = <0>;
+			coresight-outports = <0>;
+			coresight-child-list = <&etb>;
+			coresight-child-ports = <0>;
+		};
+	};
 };
 
 &omap3_pmx_wkup {
-- 
1.9.1

