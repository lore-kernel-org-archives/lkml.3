Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3KGT3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:29:12 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39669 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3KGT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:28:52 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, davem@davemloft.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/2] dt/irq: add empty of_irq_count for !OF_IRQ
Date: Thu,  7 Nov 2013 12:15:49 -0600
Message-Id: <1383848149-15488-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383848149-15488-1-git-send-email-robherring2@gmail.com>
References: <1383848149-15488-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add an empty version of of_irq_count for !OF_IRQ. This fixes build error
on sparc in linux-next:

drivers/gpio/gpio-bcm-kona.c:542: undefined reference to `of_irq_count'

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/of_irq.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index c0d6dfe..3f23b44 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -37,12 +37,20 @@ extern int of_irq_parse_one(struct device_node *device, int index,
 extern unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
-extern int of_irq_count(struct device_node *dev);
 extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
 
 extern void of_irq_init(const struct of_device_id *matches);
 
+#ifdef CONFIG_OF_IRQ
+extern int of_irq_count(struct device_node *dev);
+#else
+static inline int of_irq_count(struct device_node *dev)
+{
+	return 0;
+}
+#endif
+
 #if defined(CONFIG_OF)
 /*
  * irq_of_parse_and_map() is used by all OF enabled platforms; but SPARC
-- 
1.8.1.2

