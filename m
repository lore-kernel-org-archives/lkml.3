Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaDAHMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:12:32 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:37698 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777AbaDAHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:12:30 -0400
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] ARM: at91: fix spi cs on sama5d3 Xplained board
Date: Tue, 1 Apr 2014 15:12:43 +0800
Message-ID: <1396336363-13709-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PD16 is the CS3 for SPI0 while not SPI1.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
This patch is based on v3.14-rc8

 arch/arm/boot/dts/at91-sama5d3_xplained.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
index ce13755..4537259 100644
--- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
@@ -34,7 +34,7 @@
 			};
 
 			spi0: spi@f0004000 {
-				cs-gpios = <&pioD 13 0>;
+				cs-gpios = <&pioD 13 0>, <0>, <0>, <&pioD 16 0>;
 				status = "okay";
 			};
 
@@ -79,7 +79,7 @@
 			};
 
 			spi1: spi@f8008000 {
-				cs-gpios = <&pioC 25 0>, <0>, <0>, <&pioD 16 0>;
+				cs-gpios = <&pioC 25 0>;
 				status = "okay";
 			};
 
-- 
1.8.5.2

