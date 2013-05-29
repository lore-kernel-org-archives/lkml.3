Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414Ab3E2JZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965389Ab3E2JZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:25:13 -0400
Date: Wed, 29 May 2013 02:24:53 -0700
From: tip-bot for Andreas Fenkart <tipbot@zytor.com>
Message-ID: <tip-d671a605580d2caafc77f1a25bcf8435795df6fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.fenkart@streamunlimited.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.fenkart@streamunlimited.com, tglx@linutronix.de
In-Reply-To: <1368181290-1583-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <1368181290-1583-1-git-send-email-andreas.fenkart@streamunlimited.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add kerneldoc for irq_disable.
Git-Commit-ID: d671a605580d2caafc77f1a25bcf8435795df6fe
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

Commit-ID:  d671a605580d2caafc77f1a25bcf8435795df6fe
Gitweb:     http://git.kernel.org/tip/d671a605580d2caafc77f1a25bcf8435795df6fe
Author:     Andreas Fenkart <andreas.fenkart@streamunlimited.com>
AuthorDate: Fri, 10 May 2013 12:21:30 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 May 2013 11:09:10 +0200

genirq: Add kerneldoc for irq_disable.

Document the lazy disable functionality. comment based on changelog of
d209a699a0b975ad

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Cc: balbi@ti.com
Link: http://lkml.kernel.org/r/1368181290-1583-1-git-send-email-andreas.fenkart@streamunlimited.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cbd97ce..a3bb14f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -213,6 +213,19 @@ void irq_enable(struct irq_desc *desc)
 	irq_state_clr_masked(desc);
 }
 
+/**
+ * irq_disable - Mark interupt disabled
+ * @desc:	irq descriptor which should be disabled
+ *
+ * If the chip does not implement the irq_disable callback, we
+ * use a lazy disable approach. That means we mark the interrupt
+ * disabled, but leave the hardware unmasked. That's an
+ * optimization because we avoid the hardware access for the
+ * common case where no interrupt happens after we marked it
+ * disabled. If an interrupt happens, then the interrupt flow
+ * handler masks the line at the hardware level and marks it
+ * pending.
+ */
 void irq_disable(struct irq_desc *desc)
 {
 	irq_state_set_disabled(desc);
