Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaGGPMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:12:25 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35839 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaGGPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:12:21 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/4] ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes
Date: Mon,  7 Jul 2014 18:11:33 +0300
Message-Id: <1404745893-6379-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add nodes for PM8941 and PM8841 GPIO and MPP subfunctions.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index c7ae7ba..7daca4b 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -267,6 +267,14 @@
 					reg-names = "rtc", "alarm";
 					interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
 				};
+
+				pm8941_pinctrl: pins@a000 {
+					compatible = "qcom,pm8941-pinctrl";
+					reg = <0xa000>, <0xc000>;
+					gpio-controller;
+					#gpio-cells = <2>;
+					label = "pm8941-pinctrl";
+				};
 			};
 
 			usid1: pm8941@1 {
@@ -281,6 +289,14 @@
 				reg = <0x4 SPMI_USID>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+
+				pm8841_pinctrl: pins@a000 {
+					compatible = "qcom,pm8841-pinctrl";
+					reg = <0xa000>;
+					gpio-controller;
+					#gpio-cells = <2>;
+					label = "pm8841-pinctrl";
+				};
 			};
 
 			usid5: pm8841@5 {
-- 
1.8.3.2

