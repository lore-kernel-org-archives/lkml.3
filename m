Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbbAXOEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:38 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39316 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbbAXOEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:30 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/32] mm: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:33 -0500
Message-Id: <1422108218-25398-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mempolicy.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e0961b..b8a6907 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2838,8 +2838,7 @@ void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 			p += snprintf(p, buffer + maxlen - p, "relative");
 	}
 
-	if (!nodes_empty(nodes)) {
-		p += snprintf(p, buffer + maxlen - p, ":");
-	 	p += nodelist_scnprintf(p, buffer + maxlen - p, nodes);
-	}
+	if (!nodes_empty(nodes))
+		p += scnprintf(p, buffer + maxlen - p, ":%*pbl",
+			       nodemask_pr_args(&nodes));
 }
-- 
2.1.0

