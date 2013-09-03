Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab3ICHoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:44:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57764 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3ICHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:44:36 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: Move symbol export to proper location
Date: Tue,  3 Sep 2013 09:43:51 +0200
Message-Id: <1378194231-26828-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __clk_get_flags() symbol is exported immediately following the
clk_unprepare_unused_subtree() function. This is unusual, since a symbol
export typically follows body of the function that it exports.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clk/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2db08c0..b49c9ee 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -458,7 +458,6 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 			clk->ops->unprepare(clk->hw);
 	}
 }
-EXPORT_SYMBOL_GPL(__clk_get_flags);
 
 /* caller must hold prepare_lock */
 static void clk_disable_unused_subtree(struct clk *clk)
@@ -607,6 +606,7 @@ unsigned long __clk_get_flags(struct clk *clk)
 {
 	return !clk ? 0 : clk->flags;
 }
+EXPORT_SYMBOL_GPL(__clk_get_flags);
 
 bool __clk_is_prepared(struct clk *clk)
 {
-- 
1.8.4

