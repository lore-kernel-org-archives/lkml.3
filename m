Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaAVVEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:04:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaAVVET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:04:19 -0500
Date: Wed, 22 Jan 2014 13:03:56 -0800
From: tip-bot for Magnus Damm <tipbot@zytor.com>
Message-ID: <tip-3aba55605326be6d7e624090858aa921ab519cda@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        damm@opensource.se, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        damm@opensource.se, tglx@linutronix.de
In-Reply-To: <20131204120546.29642.15772.sendpatchset@w520>
References: <20131204120546.29642.15772.sendpatchset@w520>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: renesas-irqc: Use lazy disable
Git-Commit-ID: 3aba55605326be6d7e624090858aa921ab519cda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 22 Jan 2014 13:04:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aba55605326be6d7e624090858aa921ab519cda
Gitweb:     http://git.kernel.org/tip/3aba55605326be6d7e624090858aa921ab519cda
Author:     Magnus Damm <damm@opensource.se>
AuthorDate: Wed, 4 Dec 2013 21:05:46 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Jan 2014 21:48:55 +0100

irqchip: renesas-irqc: Use lazy disable

Set the ->irq_enable() and ->irq_disable() methods to NULL
to enable lazy disable of interrupts. This by itself provides
some level of optimization, but is mainly enabled as ground
work for future Suspend-to-RAM wake up support.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: rob.herring@calxeda.com
Cc: grant.likely@secretlab.ca
Cc: horms@verge.net.au
Link: http://lkml.kernel.org/r/20131204120546.29642.15772.sendpatchset@w520
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-renesas-irqc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-irqc.c b/drivers/irqchip/irq-renesas-irqc.c
index 2f404ba..8fdd7d6 100644
--- a/drivers/irqchip/irq-renesas-irqc.c
+++ b/drivers/irqchip/irq-renesas-irqc.c
@@ -212,8 +212,6 @@ static int irqc_probe(struct platform_device *pdev)
 	irq_chip->name = name;
 	irq_chip->irq_mask = irqc_irq_disable;
 	irq_chip->irq_unmask = irqc_irq_enable;
-	irq_chip->irq_enable = irqc_irq_enable;
-	irq_chip->irq_disable = irqc_irq_disable;
 	irq_chip->irq_set_type = irqc_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
 
