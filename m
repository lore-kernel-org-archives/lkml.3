Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbbAHAeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:34:36 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:55704 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbbAHAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:34:34 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V3 4/7] arm64: dts: Add Designware GPIO dts binding to APM X-Gene platform
Date: Wed,  7 Jan 2015 17:33:35 -0700
Message-Id: <1420677218-30743-5-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1420677218-30743-1-git-send-email-fkan@apm.com>
References: <1420677218-30743-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Designware GPIO dts binding to APM X-Gene platform

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm/apm-storm.dtsi |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
index f31e8df..a58f9a2 100644
--- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
@@ -525,6 +525,21 @@
 			interrupts = <0x0 0x4f 0x4>;
 		};
 
+		dwgpio: gpio@1c024000 {
+			compatible = "snps,dw-apb-gpio";
+			reg = <0x0 0x1c024000 0x0 0x1000>;
+			reg-io-width = <4>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			porta: gpio-controller@0 {
+				compatible = "snps,dw-apb-gpio-port";
+				gpio-controller;
+				snps,nr-gpios = <32>;
+				reg = <0>;
+			};
+		};
+
 		phy1: phy@1f21a000 {
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f21a000 0x0 0x100>;
-- 
1.7.1

