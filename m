Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaHUXbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:31:38 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:25827 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbaHUXbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:31:36 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-next@vger.kernel.org, linux-gpio@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH linux-next] irq: export handle_fasteoi_irq
Date: Fri, 22 Aug 2014 01:31:20 +0200
Message-Id: <1408663880-29179-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.1.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export handle_fasteoi_irq to be able to use it in e.g. the Zynq gpio driver
since commit 6dd859508336 ("gpio: zynq: Fix IRQ handlers").

This fixes the following link issue:

  ERROR: "handle_fasteoi_irq" [drivers/gpio/gpio-zynq.ko] undefined!

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
---

Hi,

This can be seen in Linux next-20140822 with e.g. arm allmodconfig.

Zync gpio seems to be the first code to use handle_fasteoi_irq, which can be
compiled as a module.

Best regards,

V.

 kernel/irq/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a2b28a2..6223fab 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -517,6 +517,7 @@ out:
 		chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL_GPL(handle_fasteoi_irq);
 
 /**
  *	handle_edge_irq - edge type IRQ handler
-- 
2.1.0.rc1

