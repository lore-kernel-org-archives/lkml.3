Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3KRNdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:33:42 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57640 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 05/10] mfd: stmicro: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:33:01 +0100
Message-Id: <1384781586-4798-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
References: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
mfd_add_devices() is "const" again. Hence make all cell data passed to
mfd_add_devices() const where possible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Split in groups

 drivers/mfd/stmpe.c |   10 +++++-----
 drivers/mfd/stmpe.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index fff63a41862c..42ccd0544513 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -297,14 +297,14 @@ static struct resource stmpe_gpio_resources[] = {
 	},
 };
 
-static struct mfd_cell stmpe_gpio_cell = {
+static const struct mfd_cell stmpe_gpio_cell = {
 	.name		= "stmpe-gpio",
 	.of_compatible	= "st,stmpe-gpio",
 	.resources	= stmpe_gpio_resources,
 	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
 };
 
-static struct mfd_cell stmpe_gpio_cell_noirq = {
+static const struct mfd_cell stmpe_gpio_cell_noirq = {
 	.name		= "stmpe-gpio",
 	.of_compatible	= "st,stmpe-gpio",
 	/* gpio cell resources consist of an irq only so no resources here */
@@ -325,7 +325,7 @@ static struct resource stmpe_keypad_resources[] = {
 	},
 };
 
-static struct mfd_cell stmpe_keypad_cell = {
+static const struct mfd_cell stmpe_keypad_cell = {
 	.name		= "stmpe-keypad",
 	.of_compatible  = "st,stmpe-keypad",
 	.resources	= stmpe_keypad_resources,
@@ -409,7 +409,7 @@ static struct resource stmpe_ts_resources[] = {
 	},
 };
 
-static struct mfd_cell stmpe_ts_cell = {
+static const struct mfd_cell stmpe_ts_cell = {
 	.name		= "stmpe-ts",
 	.of_compatible	= "st,stmpe-ts",
 	.resources	= stmpe_ts_resources,
@@ -1064,7 +1064,7 @@ static int stmpe_chip_init(struct stmpe *stmpe)
 	return stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_ICR_LSB], icr);
 }
 
-static int stmpe_add_device(struct stmpe *stmpe, struct mfd_cell *cell)
+static int stmpe_add_device(struct stmpe *stmpe, const struct mfd_cell *cell)
 {
 	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
 			       NULL, stmpe->irq_base, stmpe->domain);
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index ff2b09ba8797..6639f1b0fef5 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -38,7 +38,7 @@ static inline void stmpe_dump_bytes(const char *str, const void *buf,
  *		enable and altfunc callbacks
  */
 struct stmpe_variant_block {
-	struct mfd_cell		*cell;
+	const struct mfd_cell	*cell;
 	int			irq;
 	enum stmpe_block	block;
 };
-- 
1.7.9.5

