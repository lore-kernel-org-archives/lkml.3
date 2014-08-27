Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935501AbaH0R06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:26:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36322 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaH0R04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:26:56 -0400
From: Mark Brown <broonie@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Wed, 27 Aug 2014 18:26:42 +0100
Message-Id: <1409160402-30783-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] irq: Export handle_fasteoi_irq() to modules
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Currently handle_fasteoi_irq() is not exported which is causing build
failures in -next for ARM allmodconfig due to gpio-zynq using it. Since
it seems like a reasonable thing to use from a driver add an export for
the function.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 kernel/irq/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a2b28a2fd7b1..9ce0c5dd4489 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -517,6 +517,7 @@ out:
 		chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL(handle_fasteoi_irq);
 
 /**
  *	handle_edge_irq - edge type IRQ handler
-- 
2.1.0

