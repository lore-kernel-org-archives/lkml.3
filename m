Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaJXBY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:24:56 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:36605 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753571AbaJXBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:24:27 -0400
From: Feng Kan <fkan@apm.com>
To: catalin.marinas@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 4/7] arm64: dts: Add Designware GPIO dts binding to APM X-Gene platform
Date: Thu, 23 Oct 2014 18:24:19 -0700
Message-Id: <1414113862-15067-5-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414113862-15067-1-git-send-email-fkan@apm.com>
References: <1414113862-15067-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Designware GPIO dts binding to APM X-Gene platform

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 9532aa3..d84cf33 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -525,6 +525,21 @@
 			interrupts = <0x0 0x4f 0x4>;
 		};
 
+		dwgpio: dwgpio@1c024000 {
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
1.9.1

