Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3G3Mld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:41:33 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:40872 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab3G3Mkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org, Tejun Heo <tj@kernel.org>,
        James Chapman <jchapman@katalix.com>, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 9/9] l2tp: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:28 -0400
Message-Id: <1375188028-11910-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375188028-11910-1-git-send-email-tj@kernel.org>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please route this through the subsystem tree.  As written in the
description, this shouldn't make any functional difference and just
prepares for the removal of WQ_NON_REENTRANT which is already noop.

Thanks.

------ 8< -------
dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Chapman <jchapman@katalix.com>
Cc: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index feae495..07f564b 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1996,7 +1996,7 @@ static int __init l2tp_init(void)
 	if (rc)
 		goto out;
 
-	l2tp_wq = alloc_workqueue("l2tp", WQ_NON_REENTRANT | WQ_UNBOUND, 0);
+	l2tp_wq = alloc_workqueue("l2tp", WQ_UNBOUND, 0);
 	if (!l2tp_wq) {
 		pr_err("alloc_workqueue failed\n");
 		rc = -ENOMEM;
-- 
1.8.3.1

