Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbaDVWFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:05:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:23488 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaDVWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:05:45 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: add pull-up to i2c[02] on SAMA5D3 Xplained
Date: Wed, 23 Apr 2014 00:05:41 +0200
Message-ID: <1398204341-13653-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there are no pull-up resistors on the board itself it can be useful to
use the SoC pad pull-up to be able to easily connect usual i2c devices.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index ce1375595e5f..ff8a159bb600 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -43,6 +43,7 @@
 			};
 
 			i2c0: i2c@f0014000 {
+				pinctrl-0 = <&pinctrl_i2c0_pu>;
 				status = "okay";
 			};
 
@@ -102,6 +103,7 @@
 
 			i2c2: i2c@f801c000 {
 				dmas = <0>, <0>;	/* Do not use DMA for i2c2 */
+				pinctrl-0 = <&pinctrl_i2c2_pu>;
 				status = "okay";
 			};
 
@@ -116,6 +118,18 @@
 
 			pinctrl@fffff200 {
 				board {
+					pinctrl_i2c0_pu: i2c0_pu {
+						atmel,pins =
+							<AT91_PIOA 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>,
+							<AT91_PIOA 31 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;
+					};
+
+					pinctrl_i2c2_pu: i2c2_pu {
+						atmel,pins =
+							<AT91_PIOA 18 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>,
+							<AT91_PIOA 19 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;
+					};
+
 					pinctrl_mmc0_cd: mmc0_cd {
 						atmel,pins =
 							<AT91_PIOE 0 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
-- 
1.8.2.2

