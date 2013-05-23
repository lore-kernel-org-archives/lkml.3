Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab3EWQOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:14:48 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:36625 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759404Ab3EWQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:14:45 -0400
X-Greylist: delayed 1546 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 12:14:45 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH v2 1/3] ARM: at91: use set_handle_irq instead of machine specific handle_irq
Date: Thu, 23 May 2013 17:48:53 +0200
Message-Id: <1369324135-31211-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369324135-31211-1-git-send-email-b.brezillon@overkiz.com>
References: <1369324135-31211-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4256183123667170380
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set machine specific irq handler using set_handle_irq inside aic init
functions instead of handle_irq pointer from machine_desc.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91_aic.h           |    3 ---
 arch/arm/mach-at91/board-1arm.c         |    1 -
 arch/arm/mach-at91/board-afeb-9260v1.c  |    1 -
 arch/arm/mach-at91/board-cam60.c        |    1 -
 arch/arm/mach-at91/board-carmeva.c      |    1 -
 arch/arm/mach-at91/board-cpu9krea.c     |    1 -
 arch/arm/mach-at91/board-cpuat91.c      |    1 -
 arch/arm/mach-at91/board-csb337.c       |    1 -
 arch/arm/mach-at91/board-csb637.c       |    1 -
 arch/arm/mach-at91/board-dt-rm9200.c    |    1 -
 arch/arm/mach-at91/board-dt-sam9.c      |    1 -
 arch/arm/mach-at91/board-dt-sama5.c     |    1 -
 arch/arm/mach-at91/board-eb01.c         |    1 -
 arch/arm/mach-at91/board-eb9200.c       |    1 -
 arch/arm/mach-at91/board-ecbat91.c      |    1 -
 arch/arm/mach-at91/board-eco920.c       |    1 -
 arch/arm/mach-at91/board-flexibity.c    |    1 -
 arch/arm/mach-at91/board-foxg20.c       |    1 -
 arch/arm/mach-at91/board-gsia18s.c      |    1 -
 arch/arm/mach-at91/board-kafa.c         |    1 -
 arch/arm/mach-at91/board-kb9202.c       |    1 -
 arch/arm/mach-at91/board-pcontrol-g20.c |    1 -
 arch/arm/mach-at91/board-picotux200.c   |    1 -
 arch/arm/mach-at91/board-qil-a9260.c    |    1 -
 arch/arm/mach-at91/board-rm9200dk.c     |    1 -
 arch/arm/mach-at91/board-rm9200ek.c     |    1 -
 arch/arm/mach-at91/board-rsi-ews.c      |    1 -
 arch/arm/mach-at91/board-sam9-l9260.c   |    1 -
 arch/arm/mach-at91/board-sam9260ek.c    |    1 -
 arch/arm/mach-at91/board-sam9261ek.c    |    1 -
 arch/arm/mach-at91/board-sam9263ek.c    |    1 -
 arch/arm/mach-at91/board-sam9g20ek.c    |    2 --
 arch/arm/mach-at91/board-sam9m10g45ek.c |    1 -
 arch/arm/mach-at91/board-sam9rlek.c     |    1 -
 arch/arm/mach-at91/board-snapper9260.c  |    1 -
 arch/arm/mach-at91/board-stamp9g20.c    |    2 --
 arch/arm/mach-at91/board-usb-a926x.c    |    3 ---
 arch/arm/mach-at91/board-yl-9200.c      |    1 -
 arch/arm/mach-at91/irq.c                |    6 ++++++
 39 files changed, 6 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-at91/at91_aic.h b/arch/arm/mach-at91/at91_aic.h
index eaea661..be8680d 100644
--- a/arch/arm/mach-at91/at91_aic.h
+++ b/arch/arm/mach-at91/at91_aic.h
@@ -93,7 +93,4 @@ extern void __iomem *at91_aic_base;
 #define AT91_AIC_FFSR		0x148			/* Fast Forcing Status Register [SAM9 only] */
 #define AT91_AIC5_FFSR		0x58			/* Fast Forcing Status Register [AIC5] */
 
-void at91_aic_handle_irq(struct pt_regs *regs);
-void at91_aic5_handle_irq(struct pt_regs *regs);
-
 #endif
diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 35ab632..8389e81 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -92,7 +92,6 @@ MACHINE_START(ONEARM, "Ajeco 1ARM single board computer")
 	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= onearm_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= onearm_board_init,
diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index f95e31c..82832f1 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -212,7 +212,6 @@ MACHINE_START(AFEB9260, "Custom afeb9260 board")
 	/* Maintainer: Sergey Lapin <slapin@ossfans.org> */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= afeb9260_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= afeb9260_board_init,
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index ade948b..c1146d9 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -189,7 +189,6 @@ MACHINE_START(CAM60, "KwikByte CAM60")
 	/* Maintainer: KwikByte */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= cam60_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= cam60_board_init,
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index 9298305..c0aac79 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -159,7 +159,6 @@ MACHINE_START(CARMEVA, "Carmeva")
 	/* Maintainer: Conitec Datasystems */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= carmeva_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= carmeva_board_init,
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 008527e..c8ddf60 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -376,7 +376,6 @@ MACHINE_START(CPUAT9G20, "Eukrea CPU9G20")
 	/* Maintainer: Eric Benard - EUKREA Electromatique */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= cpu9krea_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= cpu9krea_board_init,
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index 42f1353..b7675c8 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -180,7 +180,6 @@ MACHINE_START(CPUAT91, "Eukrea")
 	/* Maintainer: Eric Benard - EUKREA Electromatique */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= cpuat91_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= cpuat91_board_init,
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index e5fde215..746120d 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -253,7 +253,6 @@ MACHINE_START(CSB337, "Cogent CSB337")
 	/* Maintainer: Bill Gatliff */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= csb337_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= csb337_board_init,
diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
index fdf1106..c61f7d9 100644
--- a/arch/arm/mach-at91/board-csb637.c
+++ b/arch/arm/mach-at91/board-csb637.c
@@ -134,7 +134,6 @@ MACHINE_START(CSB637, "Cogent CSB637")
 	/* Maintainer: Bill Gatliff */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= csb637_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= csb637_board_init,
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 3fcb662..13d7c62 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -49,7 +49,6 @@ static const char *at91rm9200_dt_board_compat[] __initdata = {
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.init_time      = at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91rm9200_dt_initialize,
 	.init_irq	= at91rm9200_dt_init_irq,
 	.init_machine	= at91rm9200_dt_device_init,
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 8db3013..4d291ae 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -51,7 +51,6 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
 	.init_irq	= at91_dt_init_irq,
 	.init_machine	= at91_dt_device_init,
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 705305e..d39a459 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -78,7 +78,6 @@ DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
 	.init_irq	= at91_dt_init_irq,
 	.init_machine	= sama5_dt_device_init,
diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
index becf0a6..8d84f46 100644
--- a/arch/arm/mach-at91/board-eb01.c
+++ b/arch/arm/mach-at91/board-eb01.c
@@ -45,7 +45,6 @@ static void __init at91eb01_init_early(void)
 MACHINE_START(AT91EB01, "Atmel AT91 EB01")
 	/* Maintainer: Greg Ungerer <gerg@snapgear.com> */
 	.init_time	= at91x40_timer_init,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91eb01_init_early,
 	.init_irq	= at91eb01_init_irq,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index f9be816..95a4a65 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -118,7 +118,6 @@ static void __init eb9200_board_init(void)
 MACHINE_START(ATEB9200, "Embest ATEB9200")
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= eb9200_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= eb9200_board_init,
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index b2fcd71..4bababc 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -183,7 +183,6 @@ MACHINE_START(ECBAT91, "emQbit's ECB_AT91")
 	/* Maintainer: emQbit.com */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ecb_at91init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ecb_at91board_init,
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 77de410..ba6c6f7 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -151,7 +151,6 @@ MACHINE_START(ECO920, "eco920")
 	/* Maintainer: Sascha Hauer */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= eco920_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= eco920_board_init,
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 737c085..b9b1f59 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -161,7 +161,6 @@ MACHINE_START(FLEXIBITY, "Flexibity Connect")
 	/* Maintainer: Maxim Osipov */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= flexibity_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= flexibity_board_init,
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index c20a870..816db05 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -264,7 +264,6 @@ MACHINE_START(ACMENETUSFOXG20, "Acme Systems srl FOX Board G20")
 	/* Maintainer: Sergio Tanzilli */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= foxg20_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= foxg20_board_init,
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index c1d61d2..af6a925 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -576,7 +576,6 @@ static void __init gsia18s_board_init(void)
 MACHINE_START(GSIA18S, "GS_IA18_S")
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= gsia18s_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= gsia18s_board_init,
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 88e2f5d..31bd8c9 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -105,7 +105,6 @@ MACHINE_START(KAFA, "Sperry-Sun KAFA")
 	/* Maintainer: Sergei Sharonov */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= kafa_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= kafa_board_init,
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 0c519d9..df43c2e 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -151,7 +151,6 @@ MACHINE_START(KB9200, "KB920x")
 	/* Maintainer: KwikByte, Inc. */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= kb9202_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= kb9202_board_init,
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index 65c0d6b..724c91b 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -219,7 +219,6 @@ MACHINE_START(PCONTROL_G20, "PControl G20")
 	/* Maintainer: pgsellmann@portner-elektronik.at */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= pcontrol_g20_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= pcontrol_g20_board_init,
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index ab2b2ec..479a034 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -121,7 +121,6 @@ MACHINE_START(PICOTUX2XX, "picotux 200")
 	/* Maintainer: Kleinhenz Elektronik GmbH */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= picotux200_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= picotux200_board_init,
diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
index aa3bc9b..1d7a4e7 100644
--- a/arch/arm/mach-at91/board-qil-a9260.c
+++ b/arch/arm/mach-at91/board-qil-a9260.c
@@ -259,7 +259,6 @@ MACHINE_START(QIL_A9260, "CALAO QIL_A9260")
 	/* Maintainer: calao-systems */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index 690541b..cc04718 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -221,7 +221,6 @@ MACHINE_START(AT91RM9200DK, "Atmel AT91RM9200-DK")
 	/* Maintainer: SAN People/Atmel */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= dk_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= dk_board_init,
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 8b17dad..13a121a 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -188,7 +188,6 @@ MACHINE_START(AT91RM9200EK, "Atmel AT91RM9200-EK")
 	/* Maintainer: SAN People/Atmel */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index f6d7f19..d15ef0c 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -224,7 +224,6 @@ MACHINE_START(RSI_EWS, "RSI EWS")
 	/* Maintainer: Josef Holzmayr <holzmayr@rsi-elektrotechnik.de> */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= rsi_ews_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= rsi_ews_board_init,
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 43ee4dc..0907df4 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -220,7 +220,6 @@ MACHINE_START(SAM9_L9260, "Olimex SAM9-L9260")
 	/* Maintainer: Olimex */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 0b153c8..0361c4d 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -345,7 +345,6 @@ MACHINE_START(AT91SAM9260EK, "Atmel AT91SAM9260-EK")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index b446645..c28401a 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -614,7 +614,6 @@ MACHINE_START(AT91SAM9G10EK, "Atmel AT91SAM9G10-EK")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 3284df0..1287d81 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -445,7 +445,6 @@ MACHINE_START(AT91SAM9263EK, "Atmel AT91SAM9263-EK")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index f9cd1f2..c6ea31d 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -411,7 +411,6 @@ MACHINE_START(AT91SAM9G20EK, "Atmel AT91SAM9G20-EK")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
@@ -421,7 +420,6 @@ MACHINE_START(AT91SAM9G20EK_2MMC, "Atmel AT91SAM9G20-EK 2 MMC Slot Mod")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 2a94896..139a67e 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -504,7 +504,6 @@ MACHINE_START(AT91SAM9M10G45EK, "Atmel AT91SAM9M10G45-EK")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index aa265dc..fdcb1cc 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -322,7 +322,6 @@ MACHINE_START(AT91SAM9RLEK, "Atmel AT91SAM9RL-EK")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 3aaa978..c07e86a 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -179,7 +179,6 @@ static void __init snapper9260_board_init(void)
 MACHINE_START(SNAPPER_9260, "Bluewater Systems Snapper 9260/9G20 module")
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= snapper9260_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= snapper9260_board_init,
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 869cbec..4977e6e 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -275,7 +275,6 @@ MACHINE_START(PORTUXG20, "taskit PortuxG20")
 	/* Maintainer: taskit GmbH */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= stamp9g20_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= portuxg20_board_init,
@@ -285,7 +284,6 @@ MACHINE_START(STAMP9G20, "taskit Stamp9G20")
 	/* Maintainer: taskit GmbH */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= stamp9g20_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= stamp9g20evb_board_init,
diff --git a/arch/arm/mach-at91/board-usb-a926x.c b/arch/arm/mach-at91/board-usb-a926x.c
index 2487d94..a0f7d74 100644
--- a/arch/arm/mach-at91/board-usb-a926x.c
+++ b/arch/arm/mach-at91/board-usb-a926x.c
@@ -357,7 +357,6 @@ MACHINE_START(USB_A9263, "CALAO USB_A9263")
 	/* Maintainer: calao-systems */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
@@ -367,7 +366,6 @@ MACHINE_START(USB_A9260, "CALAO USB_A9260")
 	/* Maintainer: calao-systems */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
@@ -377,7 +375,6 @@ MACHINE_START(USB_A9G20, "CALAO USB_A92G0")
 	/* Maintainer: Jean-Christophe PLAGNIOL-VILLARD */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= ek_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= ek_board_init,
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index be08377..ac3b263 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -589,7 +589,6 @@ MACHINE_START(YL9200, "uCdragon YL-9200")
 	/* Maintainer: S.Birtles */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= yl9200_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= yl9200_board_init,
diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
index e0ca591..18c653f 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/arch/arm/mach-at91/irq.c
@@ -469,6 +469,8 @@ int __init at91_aic_of_init(struct device_node *node,
 
 	at91_aic_hw_init(n_irqs);
 
+	set_handle_irq(at91_aic_handle_irq);
+
 	return 0;
 }
 
@@ -491,6 +493,8 @@ int __init at91_aic5_of_init(struct device_node *node,
 
 	at91_aic5_hw_init(n_irqs);
 
+	set_handle_irq(at91_aic5_handle_irq);
+
 	return 0;
 }
 #endif
@@ -544,4 +548,6 @@ void __init at91_aic_init(unsigned int *priority, unsigned int ext_irq_mask)
 	}
 
 	at91_aic_hw_init(n_irqs);
+
+	set_handle_irq(at91_aic_handle_irq);
 }
-- 
1.7.9.5

