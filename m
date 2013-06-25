Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3FYJxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3FYJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:53:19 -0400
Date: Tue, 25 Jun 2013 02:52:47 -0700
From: tip-bot for Javier Martinez Canillas <tipbot@zytor.com>
Message-ID: <tip-1a5595cb288411840298f25dc3d8944a90e4b5ab@git.kernel.org>
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
In-Reply-To: <1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mfd: stmpe: use irq_get_trigger_type()
  to get IRQ flags
Git-Commit-ID: 1a5595cb288411840298f25dc3d8944a90e4b5ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 02:52:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a5595cb288411840298f25dc3d8944a90e4b5ab
Gitweb:     http://git.kernel.org/tip/1a5595cb288411840298f25dc3d8944a90e4b5ab
Author:     Javier Martinez Canillas <javier.martinez@collabora.co.uk>
AuthorDate: Fri, 14 Jun 2013 18:40:46 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 11:48:25 +0200

mfd: stmpe: use irq_get_trigger_type() to get IRQ flags

Use irq_get_trigger_type() to get the IRQ trigger type flags
instead calling irqd_get_trigger_type(irq_get_irq_data(irq))

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Grant Likely <grant.likely@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/1371228049-27080-5-git-send-email-javier.martinez@collabora.co.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/stmpe.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index bbccd51..5d5e6f9 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1208,8 +1208,7 @@ int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		}
 		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
 	} else if (pdata->irq_trigger == IRQF_TRIGGER_NONE) {
-		pdata->irq_trigger =
-			irqd_get_trigger_type(irq_get_irq_data(stmpe->irq));
+		pdata->irq_trigger = irq_get_trigger_type(stmpe->irq);
 	}
 
 	ret = stmpe_chip_init(stmpe);
