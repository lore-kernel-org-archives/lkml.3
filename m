Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3FGPmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:42:24 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:53407 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756370Ab3FGPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:42:21 -0400
X-Greylist: delayed 22189 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 11:42:21 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 23/50] ARM: at91: move at91rm9200 boards to new at91 clk implem
Date: Fri,  7 Jun 2013 17:42:09 +0200
Message-Id: <1370619732-19069-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 18368212557245741084
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move at91 clk init from early_init to timer_init for all at91rm9200 non dt
boards.


Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/board-1arm.c       |   12 ++++++++++--
 arch/arm/mach-at91/board-carmeva.c    |   13 ++++++++-----
 arch/arm/mach-at91/board-cpuat91.c    |   12 ++++++++++--
 arch/arm/mach-at91/board-csb337.c     |   11 +++++++----
 arch/arm/mach-at91/board-csb637.c     |   11 +++++++----
 arch/arm/mach-at91/board-dt-rm9200.c  |    9 ++++++++-
 arch/arm/mach-at91/board-eb9200.c     |   11 +++++++----
 arch/arm/mach-at91/board-ecbat91.c    |   12 ++++++++++--
 arch/arm/mach-at91/board-eco920.c     |   13 +++++++++++--
 arch/arm/mach-at91/board-kafa.c       |   12 ++++++++++--
 arch/arm/mach-at91/board-kb9202.c     |   12 ++++++++++--
 arch/arm/mach-at91/board-picotux200.c |   11 +++++++----
 arch/arm/mach-at91/board-rm9200dk.c   |   11 +++++++----
 arch/arm/mach-at91/board-rm9200ek.c   |   11 +++++++----
 arch/arm/mach-at91/board-rsi-ews.c    |   12 ++++++++----
 arch/arm/mach-at91/board-yl-9200.c    |   12 ++++++++++--
 16 files changed, 137 insertions(+), 48 deletions(-)

diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 35ab632..1ccfa2d 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -46,8 +46,16 @@ static void __init onearm_init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
+	at91_initialize();
+}
+
+static void __init onearm_timer_init(void)
+{
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata onearm_eth_data = {
@@ -90,7 +98,7 @@ static void __init onearm_board_init(void)
 
 MACHINE_START(ONEARM, "Ajeco 1ARM single board computer")
 	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= onearm_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= onearm_init_early,
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index 9298305..591ff4c 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -41,10 +41,13 @@
 #include "generic.h"
 
 
-static void __init carmeva_init_early(void)
+static void __init carmeva_timer_init(void)
 {
-	/* Initialize processor: 20.000 MHz crystal */
-	at91_initialize(20000000);
+	/* Initialize processor: 18.432 MHz crystal */
+	at91_clk_init(20000000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata carmeva_eth_data = {
@@ -157,10 +160,10 @@ static void __init carmeva_board_init(void)
 
 MACHINE_START(CARMEVA, "Carmeva")
 	/* Maintainer: Conitec Datasystems */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= carmeva_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= carmeva_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= carmeva_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index 42f1353..42b51d9 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -58,8 +58,16 @@ static void __init cpuat91_init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
+	at91_initialize();
+}
+
+static void __init cpuat91_timer_init(void)
+{
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata cpuat91_eth_data = {
@@ -178,7 +186,7 @@ static void __init cpuat91_board_init(void)
 
 MACHINE_START(CPUAT91, "Eukrea")
 	/* Maintainer: Eric Benard - EUKREA Electromatique */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= cpuat91_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= cpuat91_init_early,
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index e5fde215..b772ec2 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -44,10 +44,13 @@
 #include "generic.h"
 
 
-static void __init csb337_init_early(void)
+static void __init csb337_timer_init(void)
 {
 	/* Initialize processor: 3.6864 MHz crystal */
-	at91_initialize(3686400);
+	at91_clk_init(3686400);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata csb337_eth_data = {
@@ -251,10 +254,10 @@ static void __init csb337_board_init(void)
 
 MACHINE_START(CSB337, "Cogent CSB337")
 	/* Maintainer: Bill Gatliff */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= csb337_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= csb337_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= csb337_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
index fdf1106..4815dbe 100644
--- a/arch/arm/mach-at91/board-csb637.c
+++ b/arch/arm/mach-at91/board-csb637.c
@@ -41,10 +41,13 @@
 #include "generic.h"
 
 
-static void __init csb637_init_early(void)
+static void __init csb637_timer_init(void)
 {
 	/* Initialize processor: 3.6864 MHz crystal */
-	at91_initialize(3686400);
+	at91_clk_init(3686400);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata csb637_eth_data = {
@@ -132,10 +135,10 @@ static void __init csb637_board_init(void)
 
 MACHINE_START(CSB637, "Cogent CSB637")
 	/* Maintainer: Bill Gatliff */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= csb637_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= csb637_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= csb637_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 3fcb662..4f3882e 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/clk-provider.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -26,6 +27,12 @@
 #include "generic.h"
 
 
+static void __init at91rm9200_dt_timer_init(void)
+{
+	of_clk_init(NULL);
+	at91rm9200_timer_init();
+}
+
 static const struct of_device_id irq_of_match[] __initconst = {
 	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
 	{ /*sentinel*/ }
@@ -47,7 +54,7 @@ static const char *at91rm9200_dt_board_compat[] __initdata = {
 };
 
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
-	.init_time      = at91rm9200_timer_init,
+	.init_time      = at91rm9200_dt_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91rm9200_dt_initialize,
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index f9be816..84cc538 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -40,10 +40,13 @@
 #include "generic.h"
 
 
-static void __init eb9200_init_early(void)
+static void __init eb9200_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata eb9200_eth_data = {
@@ -116,10 +119,10 @@ static void __init eb9200_board_init(void)
 }
 
 MACHINE_START(ATEB9200, "Embest ATEB9200")
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= eb9200_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= eb9200_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= eb9200_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index b2fcd71..fc767bd 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -49,8 +49,16 @@ static void __init ecb_at91init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
+	at91_initialize();
+}
+
+static void __init ecbat91_timer_init(void)
+{
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata ecb_at91eth_data = {
@@ -181,7 +189,7 @@ static void __init ecb_at91board_init(void)
 
 MACHINE_START(ECBAT91, "emQbit's ECB_AT91")
 	/* Maintainer: emQbit.com */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= ecbat91_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ecb_at91init_early,
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 77de410..b910c41 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -37,7 +37,16 @@ static void __init eco920_init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
-	at91_initialize(18432000);
+	at91_initialize();
+}
+
+static void __init eco920_timer_init(void)
+{
+	/* Initialize processor: 18.432 MHz crystal */
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata eco920_eth_data = {
@@ -149,7 +158,7 @@ static void __init eco920_board_init(void)
 
 MACHINE_START(ECO920, "eco920")
 	/* Maintainer: Sascha Hauer */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= eco920_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= eco920_init_early,
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 88e2f5d..e7378c4 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -46,8 +46,16 @@ static void __init kafa_init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
+	at91_initialize();
+}
+
+static void __init kafa_timer_init(void)
+{
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata kafa_eth_data = {
@@ -103,7 +111,7 @@ static void __init kafa_board_init(void)
 
 MACHINE_START(KAFA, "Sperry-Sun KAFA")
 	/* Maintainer: Sergei Sharonov */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= kafa_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= kafa_init_early,
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 0c519d9..58f2069 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -49,8 +49,16 @@ static void __init kb9202_init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
+	at91_initialize();
+}
+
+static void __init kafa_timer_init(void)
+{
 	/* Initialize processor: 10 MHz crystal */
-	at91_initialize(10000000);
+	at91_clk_init(10000000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata kb9202_eth_data = {
@@ -149,7 +157,7 @@ static void __init kb9202_board_init(void)
 
 MACHINE_START(KB9200, "KB920x")
 	/* Maintainer: KwikByte, Inc. */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= kafa_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= kb9202_init_early,
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index ab2b2ec..8855fad 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -45,10 +45,13 @@
 #include "generic.h"
 
 
-static void __init picotux200_init_early(void)
+static void __init picotux200_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata picotux200_eth_data = {
@@ -119,10 +122,10 @@ static void __init picotux200_board_init(void)
 
 MACHINE_START(PICOTUX2XX, "picotux 200")
 	/* Maintainer: Kleinhenz Elektronik GmbH */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= picotux200_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= picotux200_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= picotux200_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index 690541b..1a0c830 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -47,10 +47,13 @@
 #include "generic.h"
 
 
-static void __init dk_init_early(void)
+static void __init dk_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata dk_eth_data = {
@@ -219,10 +222,10 @@ static void __init dk_board_init(void)
 
 MACHINE_START(AT91RM9200DK, "Atmel AT91RM9200-DK")
 	/* Maintainer: SAN People/Atmel */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= dk_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= dk_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= dk_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 8b17dad..5d3abac 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -47,10 +47,13 @@
 #include "generic.h"
 
 
-static void __init ek_init_early(void)
+static void __init ek_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 static struct macb_platform_data __initdata ek_eth_data = {
@@ -186,10 +189,10 @@ static void __init ek_board_init(void)
 
 MACHINE_START(AT91RM9200EK, "Atmel AT91RM9200-EK")
 	/* Maintainer: SAN People/Atmel */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= ek_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= ek_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index f6d7f19..31738f9 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -32,10 +32,14 @@
 #include "board.h"
 #include "generic.h"
 
-static void __init rsi_ews_init_early(void)
+
+static void __init rsi_ews_timer_init(void)
 {
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 /*
@@ -222,10 +226,10 @@ static void __init rsi_ews_board_init(void)
 
 MACHINE_START(RSI_EWS, "RSI EWS")
 	/* Maintainer: Josef Holzmayr <holzmayr@rsi-elektrotechnik.de> */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= rsi_ews_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
-	.init_early	= rsi_ews_init_early,
+	.init_early	= at91_initialize,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= rsi_ews_board_init,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index be08377..78a0780 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -57,8 +57,16 @@ static void __init yl9200_init_early(void)
 	/* Set cpu type: PQFP */
 	at91rm9200_set_type(ARCH_REVISON_9200_PQFP);
 
+	at91_initialize();
+}
+
+static void __init yl9200_timer_init(void)
+{
 	/* Initialize processor: 18.432 MHz crystal */
-	at91_initialize(18432000);
+	at91_clk_init(18432000);
+
+	/* Init rm9200 timer */
+	at91rm9200_timer_init();
 }
 
 /*
@@ -587,7 +595,7 @@ static void __init yl9200_board_init(void)
 
 MACHINE_START(YL9200, "uCdragon YL-9200")
 	/* Maintainer: S.Birtles */
-	.init_time	= at91rm9200_timer_init,
+	.init_time	= yl9200_timer_init,
 	.map_io		= at91_map_io,
 	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= yl9200_init_early,
-- 
1.7.9.5

