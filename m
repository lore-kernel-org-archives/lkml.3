Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaF0IAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:00:09 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38814 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaF0H6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:58:23 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC 1/5] clk: Add temporary mapping to the existing API
Date: Fri, 27 Jun 2014 09:57:48 +0200
Message-Id: <1403855872-14749-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To preserve git-bisectability, add aliases from the future provider API to the
existing public API.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---

Don't like this much, would be great to hear of alternatives.

 include/linux/clk-provider.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 0c287db..e9ccc50 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -16,6 +16,24 @@
 
 #ifdef CONFIG_COMMON_CLK
 
+/* Temporarily map the to-be-added API to the old API, just so stuff compiles */
+#define clk_core			clk
+
+#define clk_core_to_clk
+
+#define __clk_get_internal		clk_get
+#define __clk_get_sys_internal		clk_get_sys
+#define __devm_clk_get_internal		devm_clk_get
+#define __of_clk_get_internal		of_clk_get
+#define __of_clk_get_by_name_internal	of_clk_get_by_name
+
+#define __clk_set_rate_internal		clk_set_rate
+#define __clk_get_rate_internal		clk_get_rate
+#define __clk_set_parent_internal	clk_set_parent
+#define __clk_get_parent_internal	clk_get_parent
+#define __clk_prepare_internal		clk_prepare
+#define __clk_unprepare_internal	clk_unprepare
+
 /*
  * flags used across common struct clk.  these flags should only affect the
  * top-level framework.  custom flags for dealing with hardware specifics
-- 
1.9.3

