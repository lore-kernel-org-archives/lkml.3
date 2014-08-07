Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaHGXCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:02:37 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1148 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaHGXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:02:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Aug 2014 15:49:14 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 1/3] of: Add of_match_machine helper
Date: Fri, 8 Aug 2014 02:01:53 +0300
Message-ID: <1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_match_machine function to test the device tree root for an
of_match array. This can be useful when testing SoC versions at runtime,
for example.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/of/base.c  | 21 +++++++++++++++++++++
 include/linux/of.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d8574ad..37798ea 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -977,6 +977,27 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
 EXPORT_SYMBOL(of_find_matching_node_and_match);
 
 /**
+ * of_match_machine - Tell if root of device tree has a matching of_match struct
+ *	@matches:	array of of device match structures to search in
+ *
+ *	Returns the result of of_match_node for the root node.
+ */
+const struct of_device_id *of_match_machine(const struct of_device_id *matches)
+{
+	const struct of_device_id *match;
+	struct device_node *root;
+
+	root = of_find_node_by_path("/");
+	if (!root)
+		return NULL;
+
+	match = of_match_node(matches, root);
+	of_node_put(root);
+	return match;
+}
+EXPORT_SYMBOL(of_match_machine);
+
+/**
  * of_modalias_node - Lookup appropriate modalias for a device node
  * @node:	pointer to a device tree node
  * @modalias:	Pointer to buffer that modalias value will be copied into
diff --git a/include/linux/of.h b/include/linux/of.h
index 6c4363b..b7a8817 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -289,6 +289,8 @@ extern int of_n_addr_cells(struct device_node *np);
 extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
 	const struct of_device_id *matches, const struct device_node *node);
+extern const struct of_device_id *of_match_machine(
+	const struct of_device_id *matches);
 extern int of_modalias_node(struct device_node *node, char *modalias, int len);
 extern void of_print_phandle_args(const char *msg, const struct of_phandle_args *args);
 extern struct device_node *of_parse_phandle(const struct device_node *np,
@@ -584,6 +586,7 @@ static inline const char *of_prop_next_string(struct property *prop,
 
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
+#define of_match_machine(_matches)	NULL
 #endif /* CONFIG_OF */
 
 #if defined(CONFIG_OF) && defined(CONFIG_NUMA)
-- 
1.8.1.5

