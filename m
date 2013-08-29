Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3H2BdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:33:18 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38131 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3H2BdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:33:16 -0400
Date: Wed, 28 Aug 2013 18:28:28 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] of/irq: Provide struct device_node forward-declaration for
 !OF case
Message-ID: <20130829012828.GA15558@lizard.sbx00571.losalca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following warnings:

  CC      drivers/power/bq24190_charger.o
  In file included from drivers/power/bq24190_charger.c:14:0:
  include/linux/of_irq.h:82:7: warning: ‘struct device_node’ declared
  inside parameter list [enabled by default]
  include/linux/of_irq.h:82:7: warning: its scope is only this definition
  or declaration, which is probably not what you want [enabled by default]
  include/linux/of_irq.h:87:118: warning: ‘struct device_node’ declared
  inside parameter list [enabled by default]

Signed-off-by: Anton Vorontsov <anton@enomsg.org>
---
 include/linux/of_irq.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..988d5c9 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -78,6 +78,9 @@ extern void of_irq_init(const struct of_device_id *matches);
 #endif /* CONFIG_OF_IRQ */
 
 #else /* !CONFIG_OF */
+
+struct device_node;
+
 static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
 						int index)
 {
-- 
1.8.1.4
