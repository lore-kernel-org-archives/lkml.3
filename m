Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaJCCGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbaJCCF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:05:57 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH 7/7] audit: rename audit_log_remove_rule to disambiguate for trees
Date: Thu,  2 Oct 2014 22:05:24 -0400
Message-Id: <7a6bba9e10a1188dee9f76e8d48d1b511a76e301.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename audit_log_remove_rule() to audit_tree_log_remove_rule() to avoid
confusion with watch and mark rule removal/changes.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit_tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index ace72ed..866d403 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -450,7 +450,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	return 0;
 }
 
-static void audit_log_remove_rule(struct audit_krule *rule)
+static void audit_tree_log_remove_rule(struct audit_krule *rule)
 {
 	struct audit_buffer *ab;
 
@@ -477,7 +477,7 @@ static void kill_rules(struct audit_tree *tree)
 		list_del_init(&rule->rlist);
 		if (rule->tree) {
 			/* not a half-baked one */
-			audit_log_remove_rule(rule);
+			audit_tree_log_remove_rule(rule);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
-- 
1.7.1

