Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3FYJx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:53:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3FYJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:53:19 -0400
Date: Tue, 25 Jun 2013 02:52:38 -0700
From: tip-bot for Javier Martinez Canillas <tipbot@zytor.com>
Message-ID: <tip-5dbf79d496f3a9ad141dfd1ce4a9c4d7e12c9e2c@git.kernel.org>
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
In-Reply-To: <1371228049-27080-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-4-git-send-email-javier.martinez@collabora.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mfd: twl4030-irq: Use irq_get_trigger_type()
  to get IRQ flags
Git-Commit-ID: 5dbf79d496f3a9ad141dfd1ce4a9c4d7e12c9e2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 02:52:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dbf79d496f3a9ad141dfd1ce4a9c4d7e12c9e2c
Gitweb:     http://git.kernel.org/tip/5dbf79d496f3a9ad141dfd1ce4a9c4d7e12c9e2c
Author:     Javier Martinez Canillas <javier.martinez@collabora.co.uk>
AuthorDate: Fri, 14 Jun 2013 18:40:45 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 11:48:25 +0200

mfd: twl4030-irq: Use irq_get_trigger_type() to get IRQ flags

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_get_irq_data(irq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/1371228049-27080-4-git-send-email-javier.martinez@collabora.co.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/twl4030-irq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index a5f9888..9d2d1ba 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -537,16 +537,13 @@ static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
 		/* Modify only the bits we know must change */
 		while (edge_change) {
 			int		i = fls(edge_change) - 1;
-			struct irq_data	*idata;
 			int		byte = i >> 2;
 			int		off = (i & 0x3) * 2;
 			unsigned int	type;
 
-			idata = irq_get_irq_data(i + agent->irq_base);
-
 			bytes[byte] &= ~(0x03 << off);
 
-			type = irqd_get_trigger_type(idata);
+			type = irq_get_trigger_type(i + agent->irq_base);
 			if (type & IRQ_TYPE_EDGE_RISING)
 				bytes[byte] |= BIT(off + 1);
 			if (type & IRQ_TYPE_EDGE_FALLING)
