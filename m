Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbaHYTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:16:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaHYTQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:16:57 -0400
Date: Mon, 25 Aug 2014 12:16:18 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVmluY2VudCBTdGVobMOp?=" <tipbot@zytor.com>
Message-ID: <tip-7cad45eea3849faeb34591b60d16b50d13a38d77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.stehle@laposte.net, arnd@arndb.de, tglx@linutronix.de,
        lars@metafoo.de, linus.walleij@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.stehle@laposte.net, arnd@arndb.de, tglx@linutronix.de,
        lars@metafoo.de, linus.walleij@linaro.org
In-Reply-To: <1408663880-29179-1-git-send-email-vincent.stehle@laposte.net>
References: <1408663880-29179-1-git-send-email-vincent.stehle@laposte.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq: Export handle_fasteoi_irq
Git-Commit-ID: 7cad45eea3849faeb34591b60d16b50d13a38d77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cad45eea3849faeb34591b60d16b50d13a38d77
Gitweb:     http://git.kernel.org/tip/7cad45eea3849faeb34591b60d16b50d13a38d77
Author:     Vincent Stehlé <vincent.stehle@laposte.net>
AuthorDate: Fri, 22 Aug 2014 01:31:20 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 25 Aug 2014 21:13:30 +0200

irq: Export handle_fasteoi_irq

Export handle_fasteoi_irq to be able to use it in e.g. the Zynq gpio driver
since commit 6dd859508336 ("gpio: zynq: Fix IRQ handlers").

This fixes the following link issue:

  ERROR: "handle_fasteoi_irq" [drivers/gpio/gpio-zynq.ko] undefined!

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Vincent Stehle <vincent.stehle@laposte.net>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Link: http://lkml.kernel.org/r/1408663880-29179-1-git-send-email-vincent.stehle@laposte.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
