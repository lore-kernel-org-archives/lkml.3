Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3H0H5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:57:35 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:47723 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753134Ab3H0H5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:57:33 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, software@gaisler.com
Subject: [PATCH] of: Define of_irq_find_parent dummy for !defined(CONFIG_OF_IRQ)
Date: Tue, 27 Aug 2013 09:57:17 +0200
Message-Id: <1377590237-11046-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the dummy version of of_irq_find_parent to be defined when
!defined(CONFIG_OF_IRQ) instead of when !defined(CONFIG_OF). Without
this of_irq_find_parent is undefined on SPARC that defines CONFIG_OF but
not CONFIG_OF_IRQ.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 include/linux/of_irq.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..d0059a9 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -83,11 +83,13 @@ static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
 {
 	return 0;
 }
+#endif /* !CONFIG_OF */
+
+#endif /* __OF_IRQ_H */
 
+#if !defined(CONFIG_OF_IRQ)
 static inline void *of_irq_find_parent(struct device_node *child)
 {
 	return NULL;
 }
-#endif /* !CONFIG_OF */
-
-#endif /* __OF_IRQ_H */
+#endif /* !CONFIG_OF_IRQ */
-- 
1.7.10.4

