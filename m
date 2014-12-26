Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaLZMfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:35:45 -0500
Received: from ring0.de ([5.45.105.125]:36914 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaLZMfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:35:40 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 3/3] ARM: dts: OMAP34xx/36xx: Add temperature sensor
Date: Fri, 26 Dec 2014 13:34:54 +0100
Message-Id: <1419597294-21487-4-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419597294-21487-1-git-send-email-sre@kernel.org>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP34xx and OMAP36xx processors contain a register in the
syscon area, which can be used to determine the SoCs temperature.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/boot/dts/omap34xx.dtsi | 7 +++++++
 arch/arm/boot/dts/omap36xx.dtsi | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
index 3819c1e..64679ee 100644
--- a/arch/arm/boot/dts/omap34xx.dtsi
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -38,6 +38,13 @@
 			pinctrl-single,function-mask = <0xff1f>;
 		};
 	};
+
+	omap3_temperature_sensor: temperature-sensor {
+		compatible = "ti,omap34xx-temperature-sensor";
+		syscon = <&omap3_scm_general>;
+		clocks = <&ts_fck>;
+		clock-names = "fck";
+	};
 };
 
 &ssi {
diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 541704a..be9ee1d 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -70,6 +70,13 @@
 			pinctrl-single,function-mask = <0xff1f>;
 		};
 	};
+
+	omap3_temperature_sensor: temperature-sensor {
+		compatible = "ti,omap36xx-temperature-sensor";
+		syscon = <&omap3_scm_general>;
+		clocks = <&ts_fck>;
+		clock-names = "fck";
+	};
 };
 
 /* OMAP3630 needs dss_96m_fck for VENC */
-- 
2.1.3

