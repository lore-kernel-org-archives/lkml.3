Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3FYJxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:53:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3FYJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:53:37 -0400
Date: Tue, 25 Jun 2013 02:53:13 -0700
From: tip-bot for Javier Martinez Canillas <tipbot@zytor.com>
Message-ID: <tip-fbab62c5cd57a6acd9ed80903532c86897d2d560@git.kernel.org>
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
In-Reply-To: <1371228049-27080-8-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-8-git-send-email-javier.martinez@collabora.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqdomain: Use irq_get_trigger_type()
  to get IRQ flags
Git-Commit-ID: fbab62c5cd57a6acd9ed80903532c86897d2d560
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 02:53:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbab62c5cd57a6acd9ed80903532c86897d2d560
Gitweb:     http://git.kernel.org/tip/fbab62c5cd57a6acd9ed80903532c86897d2d560
Author:     Javier Martinez Canillas <javier.martinez@collabora.co.uk>
AuthorDate: Fri, 14 Jun 2013 18:40:49 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 11:48:25 +0200

irqdomain: Use irq_get_trigger_type() to get IRQ flags

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_desc_get_irq_data(virq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/1371228049-27080-8-git-send-email-javier.martinez@collabora.co.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1db9e70..489921e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -687,7 +687,7 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
-	    type != (irqd_get_trigger_type(irq_get_irq_data(virq))))
+	    type != irq_get_trigger_type(virq))
 		irq_set_irq_type(virq, type);
 	return virq;
 }
