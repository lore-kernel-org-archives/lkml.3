Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaCECIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:08:51 -0500
Received: from nasmtp02.atmel.com ([204.2.163.16]:44459 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754243AbaCECIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:08:49 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <broonie@kernel.org>, <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 2/2] ARM: dts: sama5d36ek: add spi pinctrl sleep state
Date: Wed, 5 Mar 2014 09:58:50 +0800
Message-ID: <1393984730-14828-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393984730-14828-1-git-send-email-wenyou.yang@atmel.com>
References: <1393984730-14828-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/boot/dts/sama5d36ek.dts |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d36ek.dts b/arch/arm/boot/dts/sama5d36ek.dts
index 59576c6..676d121 100644
--- a/arch/arm/boot/dts/sama5d36ek.dts
+++ b/arch/arm/boot/dts/sama5d36ek.dts
@@ -18,6 +18,8 @@
 	ahb {
 		apb {
 			spi0: spi@f0004000 {
+				pinctrl-names = "default", "sleep";
+				pinctrl-1 = <&pinctrl_spi0_sleep>;
 				status = "okay";
 			};
 
@@ -44,6 +46,18 @@
 			macb1: ethernet@f802c000 {
 				status = "okay";
 			};
+
+			pinctrl@fffff200 {
+				spi0 {
+					pinctrl_spi0_sleep: spi0-1 {
+						atmel,pins =
+							<AT91_PIOD 10 AT91_PERIPH_GPIO AT91_PINCTRL_OUTPUT_LOW	/* PD10 GPIO Output Low */
+							 AT91_PIOD 11 AT91_PERIPH_GPIO AT91_PINCTRL_OUTPUT_LOW	/* PD11 GPIO Output Low */
+							 AT91_PIOD 12 AT91_PERIPH_GPIO AT91_PINCTRL_OUTPUT_LOW>;	/* PD12 GPIO Output Low */
+					};
+				};
+
+			};
 		};
 	};
 
-- 
1.7.9.5

