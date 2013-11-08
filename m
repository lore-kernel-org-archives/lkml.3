Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab3KHKMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:12:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62727 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3KHKMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:12:41 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v5 4/7] gpio: davinci: remove unused variable intc_irq_num
Date: Fri,  8 Nov 2013 15:41:47 +0530
Message-Id: <1383905510-31760-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

As the davinci-gpio driver is migrated to use irqdomain
there is no need to pass the irq base for the gpio driver.
This patch removes this variable from davinci_gpio_platform_data
and also the references from the machine file.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/da830.c              |    1 -
 arch/arm/mach-davinci/da850.c              |    1 -
 arch/arm/mach-davinci/dm355.c              |    1 -
 arch/arm/mach-davinci/dm365.c              |    1 -
 arch/arm/mach-davinci/dm644x.c             |    1 -
 arch/arm/mach-davinci/dm646x.c             |    1 -
 include/linux/platform_data/gpio-davinci.h |    1 -
 7 files changed, 7 deletions(-)

diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index 0813b51..fb72035 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -1153,7 +1153,6 @@ static struct davinci_id da830_ids[] = {
 
 static struct davinci_gpio_platform_data da830_gpio_platform_data = {
 	.ngpio = 128,
-	.intc_irq_num = DA830_N_CP_INTC_IRQ,
 };
 
 int __init da830_register_gpio(void)
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 352984e..4379317 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -1283,7 +1283,6 @@ int __init da850_register_vpif_capture(struct vpif_capture_config
 
 static struct davinci_gpio_platform_data da850_gpio_platform_data = {
 	.ngpio = 144,
-	.intc_irq_num = DA850_N_CP_INTC_IRQ,
 };
 
 int __init da850_register_gpio(void)
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 536ce52..a1713cc 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -900,7 +900,6 @@ static struct resource dm355_gpio_resources[] = {
 
 static struct davinci_gpio_platform_data dm355_gpio_platform_data = {
 	.ngpio		= 104,
-	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
 };
 
 int __init dm355_gpio_register(void)
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 9c96520..2595097 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -713,7 +713,6 @@ static struct resource dm365_gpio_resources[] = {
 
 static struct davinci_gpio_platform_data dm365_gpio_platform_data = {
 	.ngpio		= 104,
-	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
 	.gpio_unbanked	= 8,
 };
 
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 72a3aa7..d83436d 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -786,7 +786,6 @@ static struct resource dm644_gpio_resources[] = {
 
 static struct davinci_gpio_platform_data dm644_gpio_platform_data = {
 	.ngpio		= 71,
-	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
 };
 
 int __init dm644x_gpio_register(void)
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index d1b646c..5d289f4 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -763,7 +763,6 @@ static struct resource dm646x_gpio_resources[] = {
 
 static struct davinci_gpio_platform_data dm646x_gpio_platform_data = {
 	.ngpio		= 43,
-	.intc_irq_num	= DAVINCI_N_AINTC_IRQ,
 };
 
 int __init dm646x_gpio_register(void)
diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
index 0c3551b..fbe2f75 100644
--- a/include/linux/platform_data/gpio-davinci.h
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -28,7 +28,6 @@ enum davinci_gpio_type {
 struct davinci_gpio_platform_data {
 	u32	ngpio;
 	u32	gpio_unbanked;
-	u32	intc_irq_num;
 };
 
 
-- 
1.7.9.5

