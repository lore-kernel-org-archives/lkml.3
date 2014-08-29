Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaH2R7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:59:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40402 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaH2R7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:59:03 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Ezra Savard <ezras@xilinx.com>, Ezra Savard <ezra.savard@xilinx.com>
Subject: [PATCH 1/3] gpio: zynq: Mask non-wakeup GPIO interrupts on suspend
Date: Fri, 29 Aug 2014 10:58:45 -0700
Message-Id: <1409335127-26712-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezra Savard <ezra.savard@xilinx.com>

Added flag to the GPIO chip so that IRQ from non-wakeup GPIO will
not wake the system.

Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/gpio/gpio-zynq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index dccadea9d830..d80d722529ad 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -451,7 +451,8 @@ static struct irq_chip zynq_gpio_level_irqchip = {
 	.irq_unmask	= zynq_gpio_irq_unmask,
 	.irq_set_type	= zynq_gpio_set_irq_type,
 	.irq_set_wake	= zynq_gpio_set_wake,
-	.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED,
+	.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED |
+			  IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static struct irq_chip zynq_gpio_edge_irqchip = {
@@ -462,6 +463,7 @@ static struct irq_chip zynq_gpio_edge_irqchip = {
 	.irq_unmask	= zynq_gpio_irq_unmask,
 	.irq_set_type	= zynq_gpio_set_irq_type,
 	.irq_set_wake	= zynq_gpio_set_wake,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static void zynq_gpio_handle_bank_irq(struct zynq_gpio *gpio,
-- 
2.1.0.1.g27b9230

