Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3FYJxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:53:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FYJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:53:19 -0400
Date: Tue, 25 Jun 2013 02:52:17 -0700
From: tip-bot for Javier Martinez Canillas <tipbot@zytor.com>
Message-ID: <tip-1f6236bfd7c38d5f9f7648fae7215e65274b9e63@git.kernel.org>
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
In-Reply-To: <1371228049-27080-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1371228049-27080-2-git-send-email-javier.martinez@collabora.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add irq_get_trigger_type()
  to get IRQ flags
Git-Commit-ID: 1f6236bfd7c38d5f9f7648fae7215e65274b9e63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 02:52:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f6236bfd7c38d5f9f7648fae7215e65274b9e63
Gitweb:     http://git.kernel.org/tip/1f6236bfd7c38d5f9f7648fae7215e65274b9e63
Author:     Javier Martinez Canillas <javier.martinez@collabora.co.uk>
AuthorDate: Fri, 14 Jun 2013 18:40:43 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 11:48:24 +0200

genirq: Add irq_get_trigger_type() to get IRQ flags

Drivers that want to get the trigger edge/level type flags for a given
interrupt have to call irq_get_irq_data(irq) to get the struct
irq_data and then irqd_get_trigger_type(irq_data) to obtain the IRQ
flags.

This is not only error prone but also unnecessary exposes the struct
irq_data to callers.

It's better to have an irq_get_trigger_type() function to obtain the
edge/level flags for an IRQ.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/1371228049-27080-2-git-send-email-javier.martinez@collabora.co.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 298a9b9..f04d3ba 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -584,6 +584,12 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 	return d->msi_desc;
 }
 
+static inline u32 irq_get_trigger_type(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? irqd_get_trigger_type(d) : 0;
+}
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
