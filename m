Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3FQDAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:00:41 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51507 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab3FQC7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:59:37 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 2/5] clk: of: helper for determining number of parent clocks
Date: Sun, 16 Jun 2013 19:58:22 -0700
Message-Id: <1371437905-15567-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371437905-15567-1-git-send-email-mturquette@linaro.org>
References: <1371437905-15567-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Walks the "clocks" array of parent clock phandles and returns the
number.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
No change since v1

 drivers/clk/clk.c            | 6 ++++++
 include/linux/clk-provider.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index edf3fe1..a9feab6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2081,6 +2081,12 @@ struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
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
index 4920fd1..8730cb9 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -457,6 +457,7 @@ void of_clk_del_provider(struct device_node *np);
 struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				  void *data);
 struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
+int of_clk_get_parent_count(struct device_node *np);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
-- 
1.8.1.2

