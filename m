Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3EJJcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:32:36 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43545 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3EJJcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:32:35 -0400
Message-ID: <1368178348.8343.1.camel@phoenix>
Subject: [PATCH] gpio: stmpe: Staticize non-exported symbols
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 10 May 2013 17:32:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both stmpe_gpio_irq_map() and stmpe_gpio_irq_unmap() are not referenced
outside of this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-stmpe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 3ce5bc3..987da1d 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -271,8 +271,8 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-int stmpe_gpio_irq_map(struct irq_domain *d, unsigned int virq,
-		       irq_hw_number_t hwirq)
+static int stmpe_gpio_irq_map(struct irq_domain *d, unsigned int virq,
+			      irq_hw_number_t hwirq)
 {
 	struct stmpe_gpio *stmpe_gpio = d->host_data;
 
@@ -292,7 +292,7 @@ int stmpe_gpio_irq_map(struct irq_domain *d, unsigned int virq,
 	return 0;
 }
 
-void stmpe_gpio_irq_unmap(struct irq_domain *d, unsigned int virq)
+static void stmpe_gpio_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
 #ifdef CONFIG_ARM
 	set_irq_flags(virq, 0);
-- 
1.8.1.2



