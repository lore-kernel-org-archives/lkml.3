Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaJNG2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:28:18 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56893 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaJNG2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:28:16 -0400
From: Romain Perier <romain.perier@gmail.com>
To: devicetree@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        heiko@sntech.de, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com
Subject: [RFC v3 PATCH 1/5] of: Add standard property for poweroff capability
Date: Tue, 14 Oct 2014 06:31:09 +0000
Message-Id: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers create their own devicetree property when they register
poweroff capabilities. This is for example the case for mfd, regulator
or power drivers which define "vendor,system-power-controller" property.
This patch adds support for a standard property "poweroff-source"
which marks the device as able to shutdown the system.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 include/linux/of.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 6545e7a..27b3ba1 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -866,4 +866,15 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
 /* CONFIG_OF_RESOLVE api */
 extern int of_resolve_phandles(struct device_node *tree);
 
+/**
+ * of_system_has_poweroff_source - Tells if poweroff-source is found for device_node
+ * @np: Pointer to the given device_node
+ *
+ * return true if present false otherwise
+ */
+static inline bool of_system_has_poweroff_source(const struct device_node *np)
+{
+	return of_property_read_bool(np, "poweroff-source");
+}
+
 #endif /* _LINUX_OF_H */
-- 
1.9.1

