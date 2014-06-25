Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaFYNKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:10:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35621 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756852AbaFYNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:10:03 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 01/13] AT91: PIT: Follow the general coding rules
Date: Wed, 25 Jun 2014 15:06:33 +0200
Message-Id: <1403701605-26678-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all masks and bits definitions by matching calls to BIT and GENMASK.
While we're at it, also fix a few style issues.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam926x_time.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
index 0a9e2fc8f796..fd3170b65fbb 100644
--- a/arch/arm/mach-at91/at91sam926x_time.c
+++ b/arch/arm/mach-at91/at91sam926x_time.c
@@ -9,11 +9,12 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
-#include <linux/clk.h>
-#include <linux/clockchips.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -22,17 +23,17 @@
 #include <mach/hardware.h>
 
 #define AT91_PIT_MR		0x00			/* Mode Register */
-#define		AT91_PIT_PITIEN		(1 << 25)		/* Timer Interrupt Enable */
-#define		AT91_PIT_PITEN		(1 << 24)		/* Timer Enabled */
-#define		AT91_PIT_PIV		(0xfffff)		/* Periodic Interval Value */
+#define AT91_PIT_PITIEN			BIT(25)			/* Timer Interrupt Enable */
+#define AT91_PIT_PITEN			BIT(24)			/* Timer Enabled */
+#define AT91_PIT_PIV			GENMASK(19, 0)		/* Periodic Interval Value */
 
 #define AT91_PIT_SR		0x04			/* Status Register */
-#define		AT91_PIT_PITS		(1 << 0)		/* Timer Status */
+#define AT91_PIT_PITS			BIT(0)			/* Timer Status */
 
 #define AT91_PIT_PIVR		0x08			/* Periodic Interval Value Register */
 #define AT91_PIT_PIIR		0x0c			/* Periodic Interval Image Register */
-#define		AT91_PIT_PICNT		(0xfff << 20)		/* Interval Counter */
-#define		AT91_PIT_CPIV		(0xfffff)		/* Inverval Value */
+#define AT91_PIT_PICNT			GENMASK(31, 20)		/* Interval Counter */
+#define AT91_PIT_CPIV			GENMASK(19, 0)		/* Inverval Value */
 
 #define PIT_CPIV(x)	((x) & AT91_PIT_CPIV)
 #define PIT_PICNT(x)	(((x) & AT91_PIT_PICNT) >> 20)
-- 
2.0.0

