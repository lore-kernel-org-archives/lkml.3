Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3KGTcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:32:32 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:52959 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201Ab3KGTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:31:28 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v2 3/5] OF: export of_property_notify
Date: Thu,  7 Nov 2013 21:31:04 +0200
Message-Id: <1383852666-13551-4-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1383852666-13551-1-git-send-email-panto@antoniou-consulting.com>
References: <1383852666-13551-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_property_notify can be utilized by other users too, export it.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/base.c  |  8 +-------
 include/linux/of.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ca10916..0ffc5a9 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1424,7 +1424,7 @@ int of_count_phandle_with_args(const struct device_node *np, const char *list_na
 EXPORT_SYMBOL(of_count_phandle_with_args);
 
 #if defined(CONFIG_OF_DYNAMIC)
-static int of_property_notify(int action, struct device_node *np,
+int of_property_notify(int action, struct device_node *np,
 			      struct property *prop)
 {
 	struct of_prop_reconfig pr;
@@ -1433,12 +1433,6 @@ static int of_property_notify(int action, struct device_node *np,
 	pr.prop = prop;
 	return of_reconfig_notify(action, &pr);
 }
-#else
-static int of_property_notify(int action, struct device_node *np,
-			      struct property *prop)
-{
-	return 0;
-}
 #endif
 
 /**
diff --git a/include/linux/of.h b/include/linux/of.h
index 786c4f6..6fec255 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -307,6 +307,17 @@ extern int of_parse_phandle_with_fixed_args(const struct device_node *np,
 extern int of_count_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name);
 
+#if defined(CONFIG_OF_DYNAMIC)
+extern int of_property_notify(int action, struct device_node *np,
+			      struct property *prop);
+#else
+static inline int of_property_notify(int action, struct device_node *np,
+			      struct property *prop)
+{
+	return 0;
+}
+#endif
+
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
 
-- 
1.7.12

