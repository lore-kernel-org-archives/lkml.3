Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbaGCO6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:58:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51763 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755661AbaGCOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:49:51 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH RESEND 03/18] AT91: G45: DT: Declare a second ram controller
Date: Thu,  3 Jul 2014 16:41:18 +0200
Message-Id: <1404398493-28907-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The G45 has two identical ram controller, that are defined as a single one,
with two reg cells.

The proper way to support such a case is to have two separate DT nodes.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index ace6bf197b70..6f648b85b725 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -75,8 +75,12 @@
 
 			ramc0: ramc@ffffe400 {
 				compatible = "atmel,at91sam9g45-ddramc";
-				reg = <0xffffe400 0x200
-				       0xffffe600 0x200>;
+				reg = <0xffffe400 0x200>;
+			};
+
+			ramc1: ramc@ffffe600 {
+				compatible = "atmel,at91sam9g45-ddramc";
+				reg = <0xffffe600 0x200>;
 			};
 
 			pmc: pmc@fffffc00 {
-- 
2.0.1

