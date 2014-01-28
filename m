Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaA1Bc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:32:26 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22902 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA1BcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:32:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,732,1384329600"; 
   d="scan'208";a="11614567"
From: Markus Mayer <markus.mayer@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Linaro Patches <patches@linaro.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH] gpio: bcm281xx: Use "unsigned gpio" consistently throughout the code
Date: Mon, 27 Jan 2014 17:32:18 -0800
Message-ID: <1390872738-822-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some inconsistencies caused by the use of "int gpio"
in some parts of the code and "unsigned gpio" in others.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/gpio/gpio-bcm-kona.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index e5aa4d0..b4f20f7 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -323,7 +323,7 @@ static void bcm_kona_gpio_irq_ack(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio;
 	void __iomem *reg_base;
-	int gpio = d->hwirq;
+	unsigned gpio = d->hwirq;
 	int bank_id = GPIO_BANK(gpio);
 	int bit = GPIO_BIT(gpio);
 	u32 val;
@@ -344,7 +344,7 @@ static void bcm_kona_gpio_irq_mask(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio;
 	void __iomem *reg_base;
-	int gpio = d->hwirq;
+	unsigned gpio = d->hwirq;
 	int bank_id = GPIO_BANK(gpio);
 	int bit = GPIO_BIT(gpio);
 	u32 val;
@@ -365,7 +365,7 @@ static void bcm_kona_gpio_irq_unmask(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio;
 	void __iomem *reg_base;
-	int gpio = d->hwirq;
+	unsigned gpio = d->hwirq;
 	int bank_id = GPIO_BANK(gpio);
 	int bit = GPIO_BIT(gpio);
 	u32 val;
@@ -386,7 +386,7 @@ static int bcm_kona_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct bcm_kona_gpio *kona_gpio;
 	void __iomem *reg_base;
-	int gpio = d->hwirq;
+	unsigned gpio = d->hwirq;
 	u32 lvl_type;
 	u32 val;
 	unsigned long flags;
-- 
1.7.9.5

