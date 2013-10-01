Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3JAKkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 06:40:10 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:35012 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab3JAKj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:39:59 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, srinivas.kandagatla@st.com,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Cc: stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com,
        kernel@stlinux.com, Maxime Coquelin <maxime.coquelin@st.com>
Subject: [PATCH 4/4] ARM: STi: Add I2C config to B2000 and B2020 boards
Date: Tue,  1 Oct 2013 12:39:12 +0200
Message-Id: <1380623952-4252-5-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380623952-4252-1-git-send-email-maxime.coquelin@st.com>
References: <1380623952-4252-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supplies I2C configuration to B2000 and B2020
based on either STiH415 or STiH416 SoCs.

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih41x-b2000.dtsi |    9 +++++++++
 arch/arm/boot/dts/stih41x-b2020.dtsi |   22 ++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
index 8e694d2..1e6aa92 100644
--- a/arch/arm/boot/dts/stih41x-b2000.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
@@ -37,5 +37,14 @@
 			};
 		};
 
+		/* HDMI Tx I2C */
+		i2c@fed41000 {
+			/* HDMI V1.3a supports Standard mode only */
+			clock-frequency = <100000>;
+			i2c-min-scl-pulse-width-us = <0>;
+			i2c-min-sda-pulse-width-us = <5>;
+
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index 133e181..0ef0a69 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -38,5 +38,27 @@
 				default-state = "off";
 			};
 		};
+
+		i2c@fed40000 {
+			status = "okay";
+		};
+
+		/* HDMI Tx I2C */
+		i2c@fed41000 {
+			/* HDMI V1.3a supports Standard mode only */
+			clock-frequency = <100000>;
+			i2c-min-scl-pulse-width-us = <0>;
+			i2c-min-sda-pulse-width-us = <5>;
+
+			status = "okay";
+		};
+
+		i2c@fe540000 {
+			status = "okay";
+		};
+
+		i2c@fe541000 {
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5

