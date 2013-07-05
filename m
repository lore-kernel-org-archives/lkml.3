Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3GEJtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:49:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59866 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3GEJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:48:56 -0400
Date: Fri, 5 Jul 2013 02:48:39 -0700
From: tip-bot for Axel Lin <tipbot@zytor.com>
Message-ID: <tip-baaecfa7249f1d5553a31f8ad0b9c7ffabcaa339@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, maxime.ripard@free-electrons.com,
        axel.lin@ingics.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, axel.lin@ingics.com,
        maxime.ripard@free-electrons.com
In-Reply-To: <1373010070.14756.2.camel@phoenix>
References: <1373010070.14756.2.camel@phoenix>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: sun4i: Staticize sun4i_irq_ack()
Git-Commit-ID: baaecfa7249f1d5553a31f8ad0b9c7ffabcaa339
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 02:48:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  baaecfa7249f1d5553a31f8ad0b9c7ffabcaa339
Gitweb:     http://git.kernel.org/tip/baaecfa7249f1d5553a31f8ad0b9c7ffabcaa339
Author:     Axel Lin <axel.lin@ingics.com>
AuthorDate: Fri, 5 Jul 2013 15:41:10 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 5 Jul 2013 11:39:24 +0200

irqchip: sun4i: Staticize sun4i_irq_ack()

sun4i_irq_ack() is only referenced in this file, so make it static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Link: http://lkml.kernel.org/r/1373010070.14756.2.camel@phoenix
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sun4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index b66d4ae..a5438d8 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -38,7 +38,7 @@ static struct irq_domain *sun4i_irq_domain;
 
 static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
-void sun4i_irq_ack(struct irq_data *irqd)
+static void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
 	unsigned int irq_off = irq % 32;
