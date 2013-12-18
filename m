Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3LRSvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:51:17 -0500
Received: from top.free-electrons.com ([176.31.233.9]:56674 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755688Ab3LRSvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:51:16 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/2] ARM: dts: mxs: Add iio-hwmon to mx23 soc
Date: Wed, 18 Dec 2013 19:50:56 +0100
Message-Id: <1387392656-28037-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387392656-28037-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1387392656-28037-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to read the SoC on-die temperature sensor available on the LRADC by
using:
 cat /sys/class/hwmon/hwmon0/device/temp1_input

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx23.dtsi | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index c96ceaef7ddf..cd5e662d72f1 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -426,7 +426,7 @@
 				status = "disabled";
 			};
 
-			lradc@80050000 {
+			lradc: lradc@80050000 {
 				compatible = "fsl,imx23-lradc";
 				reg = <0x80050000 0x2000>;
 				interrupts = <36 37 38 39 40 41 42 43 44>;
@@ -524,4 +524,9 @@
 			status = "disabled";
 		};
 	};
+
+	iio_hwmon {
+		compatible = "iio-hwmon";
+		io-channels = <&lradc 8>;
+	};
 };
-- 
1.8.3.2

