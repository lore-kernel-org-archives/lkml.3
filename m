Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaEML7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:59:34 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:40117 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932651AbaEML7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:59:31 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 1/2] clk: of: helper for determining flags properties
Date: Tue, 13 May 2014 13:57:32 +0200
Message-Id: <1399982253-21079-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_03:2014-05-13,2014-05-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch provides a helper to get flags properties of
a clock node.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 drivers/clk/clk.c            | 11 +++++++++++
 include/linux/clk-provider.h |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4d56220..cae8985 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2528,6 +2528,17 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
 }
 EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
 
+unsigned long of_clk_get_flags(struct device_node *np)
+{
+	unsigned long flags = 0;
+
+	if (of_property_read_bool(np, "set-rate-parent"))
+		flags |= CLK_SET_RATE_PARENT;
+
+	return flags;
+}
+EXPORT_SYMBOL_GPL(of_clk_get_flags);
+
 struct clock_provider {
 	of_clk_init_cb_t clk_init_cb;
 	struct device_node *np;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 59e2eb5..650bc10 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -519,6 +519,7 @@ int of_clk_get_parent_count(struct device_node *np);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
+unsigned long of_clk_get_flags(struct device_node *np);
 
 #else /* !CONFIG_OF */
 
@@ -546,6 +547,11 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
 {
 	return NULL;
 }
+static inline unsigned long of_clk_get_flags(struct device_node *np)
+{
+	return NULL;
+}
+
 #define of_clk_init(matches) \
 	{ while (0); }
 #endif /* CONFIG_OF */
-- 
1.9.1

