Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaE3Noq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:44:46 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43218 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbaE3NoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:44:06 -0400
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
Subject: [RFC PATCH 10/11] coresight: adding support for beagleXM
Date: Fri, 30 May 2014 07:43:10 -0600
Message-Id: <1401457391-12242-11-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Currently supporting ETM and ETB.  Support for TPIU
and SDTI are yet to be added.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 447e714..b39bede 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -86,6 +86,36 @@
 		reset-gpios = <&gpio5 19 GPIO_ACTIVE_LOW>; /* gpio_147 */
 		vcc-supply = <&hsusb2_power>;
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

