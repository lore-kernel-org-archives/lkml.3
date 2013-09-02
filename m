Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3IBPyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:54:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3IBPy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:54:29 -0400
Message-ID: <5224B499.4010600@infradead.org>
Date: Mon, 02 Sep 2013 08:54:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org
Subject: [PATCH] of_irq.h: fix build warnings when CONFIG_OF is not enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build warnings when CONFIG_OF is not enabled:

include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Grant Likely <grant.likely@linaro.org>
Cc:	Rob Herring <rob.herring@calxeda.com>
Cc:	devicetree@vger.kernel.org
---
 include/linux/of_irq.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20130830.orig/include/linux/of_irq.h
+++ linux-next-20130830/include/linux/of_irq.h
@@ -78,6 +78,8 @@ extern void of_irq_init(const struct of_
 #endif /* CONFIG_OF_IRQ */
 
 #else /* !CONFIG_OF */
+struct device_node;
+
 static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
 						int index)
 {
