Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaCVKgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 06:36:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaCVKgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 06:36:49 -0400
Date: Sat, 22 Mar 2014 03:36:27 -0700
From: tip-bot for Alexander Shiyan <tipbot@zytor.com>
Message-ID: <tip-d6ee6d2325faeec3fb0122a4840678a2ba62b04b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, shc_work@mail.ru
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, shc_work@mail.ru
In-Reply-To: <1395476431-16070-1-git-send-email-shc_work@mail.ru>
References: <1395476431-16070-1-git-send-email-shc_work@mail.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Export symbol no_action()
Git-Commit-ID: d6ee6d2325faeec3fb0122a4840678a2ba62b04b
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

Commit-ID:  d6ee6d2325faeec3fb0122a4840678a2ba62b04b
Gitweb:     http://git.kernel.org/tip/d6ee6d2325faeec3fb0122a4840678a2ba62b04b
Author:     Alexander Shiyan <shc_work@mail.ru>
AuthorDate: Sat, 22 Mar 2014 12:20:31 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 22 Mar 2014 11:33:09 +0100

genirq: Export symbol no_action()

This will allow to use the dummy IRQ handler no_action() from drivers
compiled as module. Drivers which use ARM FIQ interrupts can use this
to request the interrupt via the normal request_irq() mechanism w/o
having to copy the dummy handler to their own code.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Link: http://lkml.kernel.org/r/1395476431-16070-1-git-send-email-shc_work@mail.ru
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index bfec453..6354802 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -41,6 +41,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
 {
 	return IRQ_NONE;
 }
+EXPORT_SYMBOL_GPL(no_action);
 
 static void warn_no_thread(unsigned int irq, struct irqaction *action)
 {
