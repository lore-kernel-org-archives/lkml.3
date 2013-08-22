Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3HVFxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:53:31 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43164 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3HVFx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:53:26 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 2/5] clk: of: helper for determining number of parent clocks
Date: Wed, 21 Aug 2013 22:53:10 -0700
Message-Id: <1377150793-27864-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Walks the "clocks" array of parent clock phandles and returns the
number.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
No change since v3

 drivers/clk/clk.c            | 6 ++++++
 include/linux/clk-provider.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bc02037..2655882 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2189,6 +2189,12 @@ struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 	return clk;
 }
 
+int of_clk_get_parent_count(struct device_node *np)
+{
+	return of_count_phandle_with_args(np, "clocks", "#clock-cells");
+}
+EXPORT_SYMBOL_GPL(of_clk_get_parent_count);
+
 const char *of_clk_get_parent_name(struct device_node *np, int index)
 {
 	struct of_phandle_args clkspec;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 015f18c..5497739 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -471,6 +471,7 @@ void of_clk_del_provider(struct device_node *np);
 struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				  void *data);
 struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
+int of_clk_get_parent_count(struct device_node *np);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
-- 
1.8.1.2

