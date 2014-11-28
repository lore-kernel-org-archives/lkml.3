Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaK1SGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:06:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42111 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbaK1SGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:06:07 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Josh Wu <josh.wu@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3 3/3] ARM: at91: sama5d4: Add SFR
Date: Fri, 28 Nov 2014 19:06:02 +0100
Message-Id: <1417197962-19441-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417197962-19441-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1417197962-19441-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sama5d4 has Special Function Registers that allow to manage DDR, OHCI, EBI
and AIC interrupt redirection.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
Changes in v3:
 - corrected a typo in the commit message

Changes in v2:
 - corrected reg address

 arch/arm/boot/dts/sama5d4.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index e0157b0f075c..9e281e22d591 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -826,6 +826,11 @@
 				status = "disabled";
 			};
 
+			sfr: sfr@f8028000 {
+				compatible = "atmel,sama5d4-sfr", "syscon";
+				reg = <0xf8028000 0x4000>;
+			};
+
 			mmc1: mmc@fc000000 {
 				compatible = "atmel,hsmci";
 				reg = <0xfc000000 0x600>;
-- 
2.1.0

