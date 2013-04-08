Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934833Ab3DHQq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:46:28 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:34567 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab3DHQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:46:26 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: export __clk_get_flags for modular clock providers
Date: Mon,  8 Apr 2013 18:46:01 +0200
Message-Id: <1365439561-18783-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common clock api provides some helpers for clk-providers but does
not export these helpers. This hinders clk-providers to be built as modules.
This patch adds __clk_get_flags() to the list of exported symbols.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ed87b24..3e478b8 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -450,6 +450,7 @@ unsigned long __clk_get_flags(struct clk *clk)
 {
 	return !clk ? 0 : clk->flags;
 }
+EXPORT_SYMBOL_GPL(__clk_get_flags);
 
 bool __clk_is_enabled(struct clk *clk)
 {
-- 
1.7.10.4

