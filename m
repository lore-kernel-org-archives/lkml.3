Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbaGCOcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:32:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50881 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757952AbaGCOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:09 -0400
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
Subject: [PATCH 09/18] AT91: Call at91_register_devices in the board files
Date: Thu,  3 Jul 2014 16:14:47 +0200
Message-Id: <1404396906-25194-15-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make every board call the register_devices callback so that the devices
declared by the SoC are registered.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/board-afeb-9260v1.c  | 2 ++
 arch/arm/mach-at91/board-cam60.c        | 2 ++
 arch/arm/mach-at91/board-cpu9krea.c     | 2 ++
 arch/arm/mach-at91/board-flexibity.c    | 2 ++
 arch/arm/mach-at91/board-sam9-l9260.c   | 2 ++
 arch/arm/mach-at91/board-sam9260ek.c    | 2 ++
 arch/arm/mach-at91/board-sam9261ek.c    | 2 ++
 arch/arm/mach-at91/board-sam9263ek.c    | 2 ++
 arch/arm/mach-at91/board-sam9m10g45ek.c | 2 ++
 arch/arm/mach-at91/board-sam9rlek.c     | 2 ++
 arch/arm/mach-at91/board-snapper9260.c  | 2 ++
 11 files changed, 22 insertions(+)

diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index 597c649170aa..fc9621ccb606 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -167,6 +167,8 @@ static struct at91_cf_data afeb9260_cf_data = {
 
 static void __init afeb9260_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index a30502c8d379..283655bd86c1 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -170,6 +170,8 @@ static void __init cam60_add_device_nand(void)
 
 static void __init cam60_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 2037f78c84e7..29a89032bb9a 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -322,6 +322,8 @@ static struct mci_platform_data __initdata cpu9krea_mci0_data = {
 
 static void __init cpu9krea_board_init(void)
 {
+	at91_register_devices();
+
 	/* NOR */
 	cpu9krea_add_device_nor();
 	/* Serial */
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 68f1ab6bd08f..79bd411b0cee 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -138,6 +138,8 @@ static struct gpio_led flexibity_leds[] = {
 
 static void __init flexibity_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index d24dda67e2d3..70309404f366 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -187,6 +187,8 @@ static struct gpio_led ek_leds[] = {
 
 static void __init ek_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 65dea12d685e..da9c5f1f2c49 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -307,6 +307,8 @@ static void __init ek_add_device_buttons(void) {}
 
 static void __init ek_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 4637432de08f..d1be10b09ab3 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -561,6 +561,8 @@ static struct gpio_led ek_leds[] = {
 
 static void __init ek_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index cd2726ee5add..3f613d962d9b 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -405,6 +405,8 @@ static struct at91_can_data ek_can_data = {
 
 static void __init ek_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 1ea61328f30d..33a7b19f7400 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -450,6 +450,8 @@ static struct platform_device *devices[] __initdata = {
 
 static void __init ek_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DGBU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index b64648b4a1fc..262e3f957d9f 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -292,6 +292,8 @@ static void __init ek_add_device_buttons(void) {}
 
 static void __init ek_board_init(void)
 {
+	at91_register_devices();
+
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 1b870e6def0c..2a817b85569f 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -154,6 +154,8 @@ static void __init snapper9260_add_device_nand(void)
 
 static void __init snapper9260_board_init(void)
 {
+	at91_register_devices();
+
 	at91_add_device_i2c(snapper9260_i2c_devices,
 			    ARRAY_SIZE(snapper9260_i2c_devices));
 
-- 
2.0.1

