Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab3GEJtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:49:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3GEJtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:49:15 -0400
Date: Fri, 5 Jul 2013 02:48:57 -0700
From: tip-bot for Axel Lin <tipbot@zytor.com>
Message-ID: <tip-002fca5df168922103a2bb52748f9984e6de80b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tony@atomide.com, arnd@arndb.de, tglx@linutronix.de,
        axel.lin@ingics.com
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, arnd@arndb.de,
        tglx@linutronix.de, axel.lin@ingics.com
In-Reply-To: <1373015592.18252.2.camel@phoenix>
References: <1373015592.18252.2.camel@phoenix>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: generic chip:
  Use DIV_ROUND_UP to calculate numchips
Git-Commit-ID: 002fca5df168922103a2bb52748f9984e6de80b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 02:49:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  002fca5df168922103a2bb52748f9984e6de80b2
Gitweb:     http://git.kernel.org/tip/002fca5df168922103a2bb52748f9984e6de80b2
Author:     Axel Lin <axel.lin@ingics.com>
AuthorDate: Fri, 5 Jul 2013 17:13:12 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 5 Jul 2013 11:39:25 +0200

genirq: generic chip: Use DIV_ROUND_UP to calculate numchips

The number of interrupts in a domain may be not divisible by the
number of interrupts each chip handles. Integer division may truncate
the result, thus use DIV_ROUND_UP to count numchips.

Seems all users of irq_alloc_domain_generic_chips() in current code do
not have this issue. I just found the issue while reading the code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: http://lkml.kernel.org/r/1373015592.18252.2.camel@phoenix
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 1c39ecc..2f274f3 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -278,7 +278,7 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	if (d->revmap_type != IRQ_DOMAIN_MAP_LINEAR)
 		return -EINVAL;
 
-	numchips = d->revmap_data.linear.size / irqs_per_chip;
+	numchips = DIV_ROUND_UP(d->revmap_data.linear.size, irqs_per_chip);
 	if (!numchips)
 		return -EINVAL;
 
