Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaCNMzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:55:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52808 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaCNMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:55:50 -0400
Date: Fri, 14 Mar 2014 05:55:34 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-649ff46e5e29868e915354ed1e9bebcf0faec3ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
In-Reply-To: <1394733834-26839-4-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-4-git-send-email-hdegoede@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: sun4i:
  Fix a comment about mask register initialization
Git-Commit-ID: 649ff46e5e29868e915354ed1e9bebcf0faec3ae
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

Commit-ID:  649ff46e5e29868e915354ed1e9bebcf0faec3ae
Gitweb:     http://git.kernel.org/tip/649ff46e5e29868e915354ed1e9bebcf0faec3ae
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Thu, 13 Mar 2014 19:03:53 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Mar 2014 13:43:33 +0100

irqchip: sun4i: Fix a comment about mask register initialization

The comment was claiming that we were masking all irqs, while the code actually
*un*masks all of them.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Link: http://lkml.kernel.org/r/1394733834-26839-4-git-send-email-hdegoede@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sun4i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 7ae85ec..60a28c6 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -109,7 +109,7 @@ static int __init sun4i_of_init(struct device_node *node,
 	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_ENABLE_REG(2));
 
-	/* Mask all the interrupts */
+	/* Unmask all the interrupts, ENABLE_REG(x) is used for masking */
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(0));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(1));
 	writel(0, sun4i_irq_base + SUN4I_IRQ_MASK_REG(2));
