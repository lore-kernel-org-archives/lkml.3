Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3FNQlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:41:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47006 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3FNQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:41:10 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 6/7] MIPS: octeon: use irq_get_trigger_type() to get IRQ flags
Date: Fri, 14 Jun 2013 18:40:48 +0200
Message-Id: <1371228049-27080-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_desc_get_irq_data(irq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/mips/cavium-octeon/octeon-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index a22f06a..7181def 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -607,7 +607,7 @@ static void octeon_irq_ciu_gpio_ack(struct irq_data *data)
 
 static void octeon_irq_handle_gpio(unsigned int irq, struct irq_desc *desc)
 {
-	if (irqd_get_trigger_type(irq_desc_get_irq_data(desc)) & IRQ_TYPE_EDGE_BOTH)
+	if (irq_get_trigger_type(irq) & IRQ_TYPE_EDGE_BOTH)
 		handle_edge_irq(irq, desc);
 	else
 		handle_level_irq(irq, desc);
-- 
1.7.7.6

