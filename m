Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab3HNNyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:54:11 -0400
Received: from jenson.atom.hu ([62.112.193.66]:38086 "EHLO jenson.atom.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab3HNNyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:54:08 -0400
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2013 09:54:08 EDT
From: Gergely Risko <gergely@risko.hu>
To: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Gergely Risko <gergely@risko.hu>
Subject: [PATCH] mm: memcontrol: fix handling of swapaccount parameter
Date: Wed, 14 Aug 2013 15:21:35 +0200
Message-Id: <1376486495-21457-1-git-send-email-gergely@risko.hu>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed swap accounting option parsing to enable if called without argument.

Signed-off-by: Gergely Risko <gergely@risko.hu>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c290a1c..8ec2507 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6970,13 +6970,13 @@ struct cgroup_subsys mem_cgroup_subsys = {
 static int __init enable_swap_account(char *s)
 {
 	/* consider enabled if no parameter or 1 is given */
-	if (!strcmp(s, "1"))
+	if (*s++ != '=' || !*s || !strcmp(s, "1"))
 		really_do_swap_account = 1;
 	else if (!strcmp(s, "0"))
 		really_do_swap_account = 0;
 	return 1;
 }
-__setup("swapaccount=", enable_swap_account);
+__setup("swapaccount", enable_swap_account);
 
 static void __init memsw_file_init(void)
 {
-- 
1.8.3.2

