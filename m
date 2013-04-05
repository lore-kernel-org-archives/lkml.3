Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305Ab3DEFWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:22:35 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:65371 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161133Ab3DEFWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:22:34 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: add helper to set flags for clk-provider
Date: Fri,  5 Apr 2013 07:22:12 +0200
Message-Id: <1365139332-17775-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock providers are not allowed to mess with struct clk internals directly
but using helpers provided by clk-provider.h. This patch adds a helper to
allow to set flags of a clock after registration. This is useful, if clock
flags change during runtime, e.g. ability to set parent clock after mux
switch.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk.c            |    8 ++++++++
 include/linux/clk-provider.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..780a0c0 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -451,6 +451,14 @@ unsigned long __clk_get_flags(struct clk *clk)
 	return !clk ? 0 : clk->flags;
 }
 
+void __clk_set_flags(struct clk *clk, unsigned long flags)
+{
+	if (!clk)
+		return;
+
+	clk->flags = flags;
+}
+
 bool __clk_is_enabled(struct clk *clk)
 {
 	int ret;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7f197d7..e862d9c 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -351,6 +351,7 @@ unsigned int __clk_get_enable_count(struct clk *clk);
 unsigned int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
+void __clk_set_flags(struct clk *clk, unsigned long flags);
 bool __clk_is_enabled(struct clk *clk);
 struct clk *__clk_lookup(const char *name);
 
-- 
1.7.10.4

