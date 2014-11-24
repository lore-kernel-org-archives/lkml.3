Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaKXWho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:37:44 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50767 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaKXWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:12 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 05/14] of/reconfig: Add empty stubs for the of_reconfig methods
Date: Mon, 24 Nov 2014 22:33:33 +0000
Message-Id: <1416868422-22103-6-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify subsystem setup code, make empty stubs for the
of_reconfig_*() methods. This is particularly useful for registering and
unregistering the notifiers so that it doesn't impact the flow of the
subsystem setup code.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 include/linux/of.h | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 8e3a264c869c..b59ee21933a4 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -324,11 +324,6 @@ struct of_prop_reconfig {
 	struct property		*old_prop;
 };
 
-extern int of_reconfig_notifier_register(struct notifier_block *);
-extern int of_reconfig_notifier_unregister(struct notifier_block *);
-extern int of_reconfig_notify(unsigned long, void *);
-extern int of_reconfig_get_state_change(unsigned long action, void *arg);
-
 extern int of_attach_node(struct device_node *);
 extern int of_detach_node(struct device_node *);
 
@@ -895,6 +890,11 @@ enum of_reconfig_change {
 };
 
 #ifdef CONFIG_OF_DYNAMIC
+extern int of_reconfig_notifier_register(struct notifier_block *);
+extern int of_reconfig_notifier_unregister(struct notifier_block *);
+extern int of_reconfig_notify(unsigned long, void *);
+extern int of_reconfig_get_state_change(unsigned long action, void *arg);
+
 extern void of_changeset_init(struct of_changeset *ocs);
 extern void of_changeset_destroy(struct of_changeset *ocs);
 extern int of_changeset_apply(struct of_changeset *ocs);
@@ -932,7 +932,24 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
 {
 	return of_changeset_action(ocs, OF_RECONFIG_UPDATE_PROPERTY, np, prop);
 }
-#endif
+#else /* CONFIG_OF_DYNAMIC */
+static inline int of_reconfig_notifier_register(struct notifier_block *nb)
+{
+	return -EINVAL;
+}
+static inline int of_reconfig_notifier_unregister(struct notifier_block *nb)
+{
+	return -EINVAL;
+}
+static inline int of_reconfig_notify(unsigned long action, void *arg)
+{
+	return -EINVAL;
+}
+static inline int of_reconfig_get_state_change(unsigned long action, void *arg)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_OF_DYNAMIC */
 
 /* CONFIG_OF_RESOLVE api */
 extern int of_resolve_phandles(struct device_node *tree);
-- 
1.9.1

