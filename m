Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaF3JoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:44:24 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53257 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaF3JoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:44:23 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: mturquette@linaro.org, spk.linux@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: [PATCH 1/1] clk: Fix build warnings
Date: Mon, 30 Jun 2014 15:10:54 +0530
Message-Id: <1404121254-23823-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

‘all_lists’ and ‘orphan_list’ is accessed only when DEBUG_FS is defined.
Thus, make their compilation conditional to fix the below warnings introduced
by commit 27b8d5f723 ("clk: flatten clk tree in debugfs"):
drivers/clk/clk.c:40:27: warning: ‘all_lists’ defined but not used [-Wunused-variable]
drivers/clk/clk.c:46:27: warning: ‘orphan_list’ defined but not used [-Wunused-variable]

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 7dfb2f308b35..a95233c14f86 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -36,6 +36,7 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+#ifdef CONFIG_DEBUG_FS
 static struct hlist_head *all_lists[] = {
 	&clk_root_list,
 	&clk_orphan_list,
@@ -46,6 +47,7 @@ static struct hlist_head *orphan_list[] = {
 	&clk_orphan_list,
 	NULL,
 };
+#endif
 
 /***           locking             ***/
 static void clk_prepare_lock(void)
-- 
1.7.9.5

