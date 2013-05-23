Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3EWJNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:13:51 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:52755 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757158Ab3EWJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:13:20 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH 3/3] ARM: at91: use set_handle_irq instead of machine specific handle_irq
Date: Thu, 23 May 2013 11:05:09 +0200
Message-Id: <1369299909-10078-4-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 15836345141831185484
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set machine specific irq handler using set_handle_irq inside aic init functions
instead of handle_irq pointer from machine_desc.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/board-1arm.c            |    1 -
 arch/arm/mach-at91/board-afeb-9260v1.c     |    1 -
 arch/arm/mach-at91/board-cam60.c           |    1 -
 arch/arm/mach-at91/board-carmeva.c         |    1 -
 arch/arm/mach-at91/board-cpu9krea.c        |    1 -
 arch/arm/mach-at91/board-cpuat91.c         |    1 -
 arch/arm/mach-at91/board-csb337.c          |    1 -
 arch/arm/mach-at91/board-csb637.c          |    1 -
 arch/arm/mach-at91/board-dt-rm9200.c       |    1 -
 arch/arm/mach-at91/board-dt-sam9.c         |    1 -
 arch/arm/mach-at91/board-dt-sama5.c        |    1 -
 arch/arm/mach-at91/board-eb01.c            |    1 -
 arch/arm/mach-at91/board-eb9200.c          |    1 -
 arch/arm/mach-at91/board-ecbat91.c         |    1 -
 arch/arm/mach-at91/board-eco920.c          |    1 -
 arch/arm/mach-at91/board-flexibity.c       |    1 -
 arch/arm/mach-at91/board-foxg20.c          |    1 -
 arch/arm/mach-at91/board-gsia18s.c         |    1 -
 arch/arm/mach-at91/board-kafa.c            |    1 -
 arch/arm/mach-at91/board-kb9202.c          |    1 -
 arch/arm/mach-at91/board-pcontrol-g20.c    |    1 -
 arch/arm/mach-at91/board-picotux200.c      |    1 -
 arch/arm/mach-at91/board-qil-a9260.c       |    1 -
 arch/arm/mach-at91/board-rm9200dk.c        |    1 -
 arch/arm/mach-at91/board-rm9200ek.c        |    1 -
 arch/arm/mach-at91/board-rsi-ews.c         |    1 -
 arch/arm/mach-at91/board-sam9-l9260.c      |    1 -
 arch/arm/mach-at91/board-sam9260ek.c       |    1 -
 arch/arm/mach-at91/board-sam9261ek.c       |    1 -
 arch/arm/mach-at91/board-sam9263ek.c       |    1 -
 arch/arm/mach-at91/board-sam9g20ek.c       |    2 --
 arch/arm/mach-at91/board-sam9m10g45ek.c    |    1 -
 arch/arm/mach-at91/board-sam9rlek.c        |    1 -
 arch/arm/mach-at91/board-snapper9260.c     |    1 -
 arch/arm/mach-at91/board-stamp9g20.c       |    2 --
 arch/arm/mach-at91/board-usb-a926x.c       |    3 ---
 arch/arm/mach-at91/board-yl-9200.c         |    1 -
 arch/arm/mach-at91/include/mach/at91_aic.h |    3 ---
 drivers/irqchip/irq-at91.c                 |    6 ++++++
 39 files changed, 6 insertions(+), 44 deletions(-)

diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 8037dfe..33366d04 100644
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
index 28bea23..c2026ff 100644
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
index 6ebdf32..64deb3d 100644
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
index 842db49..6c4a243 100644
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
index 4714e9e..80c5a94 100644
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
index c1663ed..d91ec57 100644
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
index 3231703..f660331 100644
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
index d58c7e6..27ce1ce 100644
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
index 523a9ae..72a0658 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -40,7 +40,6 @@ static const char *at91rm9200_dt_board_compat[] __initdata = {
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.init_time      = at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91rm9200_dt_initialize,
 	.init_machine	= at91rm9200_dt_device_init,
 	.dt_compat	= at91rm9200_dt_board_compat,
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index a07da3b..404a45c 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -41,7 +41,6 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
 	.init_machine	= at91_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 65cf099..68619a8 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -68,7 +68,6 @@ DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_dt_board_compat,
diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
index 4097ede..6159ba1 100644
--- a/arch/arm/mach-at91/board-eb01.c
+++ b/arch/arm/mach-at91/board-eb01.c
@@ -46,7 +46,6 @@ static void __init at91eb01_init_early(void)
 MACHINE_START(AT91EB01, "Atmel AT91 EB01")
 	/* Maintainer: Greg Ungerer <gerg@snapgear.com> */
 	.init_time	= at91x40_timer_init,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91eb01_init_early,
 	.init_irq	= at91eb01_init_irq,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index afa5ebb..f1459c5 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -119,7 +119,6 @@ static void __init eb9200_board_init(void)
 MACHINE_START(ATEB9200, "Embest ATEB9200")
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= eb9200_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= eb9200_board_init,
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index c794768..38e4fec 100644
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
index fc3e373..f89904f 100644
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
index 59a1958..090b17a 100644
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
index 4b4df05..6c90394 100644
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
index 1babcbd..07ebfd3 100644
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
index aca52d3..82d2113 100644
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
index 7768df0..3a2040f 100644
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
index 6df21db..0df7d60 100644
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
index 566b30c..eada86d 100644
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
index 0ae5eb1..19096a1 100644
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
index 82f0335e..30b23cc 100644
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
index 5e8a4f7..e31b069 100644
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
index e7d0a69..5fc429b 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -225,7 +225,6 @@ MACHINE_START(RSI_EWS, "RSI EWS")
 	/* Maintainer: Josef Holzmayr <holzmayr@rsi-elektrotechnik.de> */
 	.init_time	= at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= rsi_ews_init_early,
 	.init_irq	= at91_init_irq_default,
 	.init_machine	= rsi_ews_board_init,
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 2e400cd..d2e1d70 100644
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
index 66ee7ac..a7b2e65 100644
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
index 515957e..3971f1d 100644
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
index 1099272..3530eff 100644
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
index 9fe718b..154f71e 100644
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
index 1846647..d87ffb5 100644
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
index 623f2d1..1a0737a 100644
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
index 8fef38a..2c1cfeb 100644
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
index 6bda942..9ded44b 100644
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
index cedbc66..b51978a 100644
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
index c61d8c9..874a6b7 100644
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
diff --git a/arch/arm/mach-at91/include/mach/at91_aic.h b/arch/arm/mach-at91/include/mach/at91_aic.h
index eaea661..be8680d 100644
--- a/arch/arm/mach-at91/include/mach/at91_aic.h
+++ b/arch/arm/mach-at91/include/mach/at91_aic.h
@@ -93,7 +93,4 @@ extern void __iomem *at91_aic_base;
 #define AT91_AIC_FFSR		0x148			/* Fast Forcing Status Register [SAM9 only] */
 #define AT91_AIC5_FFSR		0x58			/* Fast Forcing Status Register [AIC5] */
 
-void at91_aic_handle_irq(struct pt_regs *regs);
-void at91_aic5_handle_irq(struct pt_regs *regs);
-
 #endif
diff --git a/drivers/irqchip/irq-at91.c b/drivers/irqchip/irq-at91.c
index b45fe2c..d20053f 100644
--- a/drivers/irqchip/irq-at91.c
+++ b/drivers/irqchip/irq-at91.c
@@ -471,6 +471,8 @@ int __init at91_aic_of_init(struct device_node *node,
 
 	at91_aic_hw_init(n_irqs);
 
+	set_handle_irq(at91_aic_handle_irq);
+
 	return 0;
 }
 IRQCHIP_DECLARE(at91rm9200_aic, "atmel,at91rm9200-aic", at91_aic_of_init);
@@ -494,6 +496,8 @@ int __init at91_aic5_of_init(struct device_node *node,
 
 	at91_aic5_hw_init(n_irqs);
 
+	set_handle_irq(at91_aic5_handle_irq);
+
 	return 0;
 }
 IRQCHIP_DECLARE(sama5d3_aic, "atmel,sama5d3-aic", at91_aic5_of_init);
@@ -548,4 +552,6 @@ void __init at91_aic_init(unsigned int *priority, unsigned int ext_irq_mask)
 	}
 
 	at91_aic_hw_init(n_irqs);
+
+	set_handle_irq(at91_aic_handle_irq);
 }
-- 
1.7.9.5

