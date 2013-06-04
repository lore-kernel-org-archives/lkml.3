Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3FDQ5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:57:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3FDQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 10/75] ARM: at91/dt: fix macb node declaration
Date: Tue,  4 Jun 2013 09:54:54 -0700
Message-Id: <1370364959-9475-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 509ea1b804a9d6b480de7a7d3041418a79c9bd71 upstream.

Macb0 node cannot be activated in generic sam9x5ek.dtsi file
as the sam9g15 does not have one.
Move the macb0 & macb1 activation in board .dts file that
support them.

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/at91sam9g25ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9g35ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9x25ek.dts | 14 ++++++++++++++
 arch/arm/boot/dts/at91sam9x35ek.dts |  9 +++++++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi |  5 -----
 5 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g25ek.dts b/arch/arm/boot/dts/at91sam9g25ek.dts
index c5ab16f..a1c511f 100644
--- a/arch/arm/boot/dts/at91sam9g25ek.dts
+++ b/arch/arm/boot/dts/at91sam9g25ek.dts
@@ -13,4 +13,13 @@
 / {
 	model = "Atmel AT91SAM9G25-EK";
 	compatible = "atmel,at91sam9g25ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
+
+	ahb {
+		apb {
+			macb0: ethernet@f802c000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9g35ek.dts b/arch/arm/boot/dts/at91sam9g35ek.dts
index 95944bd..6f58ab8 100644
--- a/arch/arm/boot/dts/at91sam9g35ek.dts
+++ b/arch/arm/boot/dts/at91sam9g35ek.dts
@@ -13,4 +13,13 @@
 / {
 	model = "Atmel AT91SAM9G35-EK";
 	compatible = "atmel,at91sam9g35ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
+
+	ahb {
+		apb {
+			macb0: ethernet@f802c000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9x25ek.dts b/arch/arm/boot/dts/at91sam9x25ek.dts
index af907ea..3b40d11 100644
--- a/arch/arm/boot/dts/at91sam9x25ek.dts
+++ b/arch/arm/boot/dts/at91sam9x25ek.dts
@@ -13,4 +13,18 @@
 / {
 	model = "Atmel AT91SAM9G25-EK";
 	compatible = "atmel,at91sam9x25ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
+
+	ahb {
+		apb {
+			macb0: ethernet@f802c000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+
+			macb1: ethernet@f8030000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9x35ek.dts b/arch/arm/boot/dts/at91sam9x35ek.dts
index 5ccb607..6ad19a0 100644
--- a/arch/arm/boot/dts/at91sam9x35ek.dts
+++ b/arch/arm/boot/dts/at91sam9x35ek.dts
@@ -13,4 +13,13 @@
 / {
 	model = "Atmel AT91SAM9X35-EK";
 	compatible = "atmel,at91sam9x35ek", "atmel,at91sam9x5ek", "atmel,at91sam9x5", "atmel,at91sam9";
+
+	ahb {
+		apb {
+			macb0: ethernet@f802c000 {
+				phy-mode = "rmii";
+				status = "okay";
+			};
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index ccab256..a0b4ff9 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -52,11 +52,6 @@
 				status = "okay";
 			};
 
-			macb0: ethernet@f802c000 {
-				phy-mode = "rmii";
-				status = "okay";
-			};
-
 			i2c0: i2c@f8010000 {
 				status = "okay";
 			};
-- 
1.8.1.2

