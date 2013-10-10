Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3JJJQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:16:05 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:41414 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab3JJJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:16:04 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: p.zabel@pengutronix.de
Cc: linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>
Subject: [PATCH] reset: Add non CONFIG_RESET_CONTROLLER routines
Date: Thu, 10 Oct 2013 12:14:35 +0300
Message-Id: <1381396475-17848-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Make sure client drivers will still build on systems
without reset control support.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Marek Vasut <marex@denx.de>
---
 include/linux/reset.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 6082247..0df3e30 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -4,6 +4,8 @@
 struct device;
 struct reset_control;
 
+#if defined(CONFIG_RESET_CONTROLLER)
+
 int reset_control_reset(struct reset_control *rstc);
 int reset_control_assert(struct reset_control *rstc);
 int reset_control_deassert(struct reset_control *rstc);
@@ -14,4 +16,46 @@ struct reset_control *devm_reset_control_get(struct device *dev, const char *id)
 
 int device_reset(struct device *dev);
 
+#else /* !CONFIG_RESET_CONTROLLER */
+
+/*
+ * Make sure client drivers will still build on systems without
+ * reset control support.
+ */
+static inline int reset_control_reset(struct reset_control *rstc)
+{
+	return 0;
+}
+
+static inline int reset_control_assert(struct reset_control *rstc)
+{
+	return 0;
+}
+
+static inline int reset_control_deassert(struct reset_control *rstc)
+{
+	return 0;
+}
+
+static inline struct reset_control *
+reset_control_get(struct device *dev, const char *id)
+{
+	return 0;
+}
+
+static inline void reset_control_put(struct reset_control *rstc){}
+
+static inline struct reset_control *
+devm_reset_control_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline int device_reset(struct device *dev)
+{
+	return 0;
+}
+
+#endif
+
 #endif
-- 
1.7.9.5

