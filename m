Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbbAFRy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:54:29 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54947 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbAFRy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:54:27 -0500
From: mathieu.poirier@linaro.org
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, pratikp@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mathieu.poirier@linaro.org
Subject: [PATCH] coresight: Fixing wrong #ifdef/#endif placement
Date: Tue,  6 Jan 2015 10:54:12 -0700
Message-Id: <1420566852-20816-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Fixing problem reported by:
        https://lkml.org/lkml/2015/1/6/86

The #ifdef/#endif is wrong and prevents the stub of function
of_get_coresight_platform_data() from being visible when
CONFIG_OF is not defined.

Moving CONFIG_OF condition out of CONFIG_CORESIGHT, making
them both independent.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/linux/coresight.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 5d3c54311f7a..4404033ee879 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -239,10 +239,6 @@ extern void coresight_disable(struct coresight_device *csdev);
 extern int coresight_is_bit_set(u32 val, int position, int value);
 extern int coresight_timeout(void __iomem *addr, u32 offset,
 			     int position, int value);
-#ifdef CONFIG_OF
-extern struct coresight_platform_data *of_get_coresight_platform_data(
-				struct device *dev, struct device_node *node);
-#endif
 #else
 static inline struct coresight_device *
 coresight_register(struct coresight_desc *desc) { return NULL; }
@@ -254,10 +250,14 @@ static inline int coresight_is_bit_set(u32 val, int position, int value)
 					 { return 0; }
 static inline int coresight_timeout(void __iomem *addr, u32 offset,
 				     int position, int value) { return 1; }
+#endif
+
 #ifdef CONFIG_OF
+extern struct coresight_platform_data *of_get_coresight_platform_data(
+				struct device *dev, struct device_node *node);
+#else
 static inline struct coresight_platform_data *of_get_coresight_platform_data(
 	struct device *dev, struct device_node *node) { return NULL; }
 #endif
-#endif
 
 #endif
-- 
1.9.1

