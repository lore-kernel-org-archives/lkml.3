Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3FYJx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:53:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FYJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:53:19 -0400
Date: Tue, 25 Jun 2013 02:52:55 -0700
From: tip-bot for Javier Martinez Canillas <tipbot@zytor.com>
Message-ID: <tip-f88704c95b5a2634eff99e2d720031555c67fe81@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jason@lakedaemon.net,
        grant.likely@linaro.org, hpa@zytor.com, mingo@kernel.org,
        javier.martinez@collabora.co.uk, benh@kernel.crashing.org,
        ralf@linux-mips.org, linux@arm.linux.org.uk, andrew@lunn.ch,
        tglx@linutronix.de, sameo@linux.intel.com, linus.walleij@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        jason@lakedaemon.net, linux-kernel@vger.kernel.org,
        javier.martinez@collabora.co.uk, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, ralf@linux-mips.org, andrew@lunn.ch,
        sameo@linux.intel.com, tglx@linutronix.de, linus.walleij@linaro.org
In-Reply-To: <1371228049-27080-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-6-git-send-email-javier.martinez@collabora.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] arm: orion: Use irq_get_trigger_type()
  to get IRQ flags
Git-Commit-ID: f88704c95b5a2634eff99e2d720031555c67fe81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 02:53:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f88704c95b5a2634eff99e2d720031555c67fe81
Gitweb:     http://git.kernel.org/tip/f88704c95b5a2634eff99e2d720031555c67fe81
Author:     Javier Martinez Canillas <javier.martinez@collabora.co.uk>
AuthorDate: Fri, 14 Jun 2013 18:40:47 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 11:48:25 +0200

arm: orion: Use irq_get_trigger_type() to get IRQ flags

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_get_irq_data(irq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/1371228049-27080-6-git-send-email-javier.martinez@collabora.co.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/plat-orion/gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index 249fe63..6816192 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -426,7 +426,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		if (!(cause & (1 << i)))
 			continue;
 
-		type = irqd_get_trigger_type(irq_get_irq_data(irq));
+		type = irq_get_trigger_type(irq);
 		if ((type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
 			/* Swap polarity (race with GPIO line) */
 			u32 polarity;
