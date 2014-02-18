Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaBRLWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:22:37 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46936 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaBRLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:22:35 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] staging: android: binder: use stack for locally used variable
Date: Tue, 18 Feb 2014 20:23:26 +0900
Message-Id: <1392722606-965-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
References: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable `binder_debugfs_dir_entry_root` is declared as static
global variable although it is accessed from init function only. Declare
it as init function's local variable because it would be better to read
and memory efficiency.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/binder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index b23cbc9..78de730 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -49,7 +49,6 @@ static HLIST_HEAD(binder_procs);
 static HLIST_HEAD(binder_deferred_list);
 static HLIST_HEAD(binder_dead_nodes);
 
-static struct dentry *binder_debugfs_dir_entry_root;
 static struct dentry *binder_debugfs_dir_entry_proc;
 static struct binder_node *binder_context_mgr_node;
 static kuid_t binder_context_mgr_uid = INVALID_UID;
@@ -3514,6 +3513,7 @@ BINDER_DEBUG_ENTRY(transaction_log);
 
 static int __init binder_init(void)
 {
+	struct dentry *binder_debugfs_dir_entry_root;
 	int ret;
 
 	binder_deferred_workqueue = create_singlethread_workqueue("binder");
-- 
1.8.3.2

