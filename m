Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3ENLDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:03:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:11434 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3ENLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:03:39 -0400
X-Spam-Score: -100.8
Message-ID: <519219D5.6010907@asianux.com>
Date: Tue, 14 May 2013 19:02:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, grant.likely@linaro.org,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/irq/irqdomain.c: before use 'irq_data', need check
 it whether valid.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since irq_data may be NULL, if so, we WARN_ON(), and continue, 'hwirq'
which related with 'irq_data' has to initialize later, or it will cause
issue.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/irq/irqdomain.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index af804b5..61abbfa 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -400,11 +400,12 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 	while (count--) {
 		int irq = irq_base + count;
 		struct irq_data *irq_data = irq_get_irq_data(irq);
-		irq_hw_number_t hwirq = irq_data->hwirq;
+		irq_hw_number_t hwirq;
 
 		if (WARN_ON(!irq_data || irq_data->domain != domain))
 			continue;
 
+		hwirq = irq_data->hwirq;
 		irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 		/* remove chip and handler */
-- 
1.7.7.6
