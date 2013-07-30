Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3G3Mkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:40:47 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60484 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3G3Mkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:41 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org, Tejun Heo <tj@kernel.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 5/9] dlm: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:24 -0400
Message-Id: <1375188028-11910-6-git-send-email-tj@kernel.org>
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
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/dlm/ast.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 27a6ba9..0e90f0c 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -267,10 +267,7 @@ void dlm_callback_work(struct work_struct *work)
 int dlm_callback_start(struct dlm_ls *ls)
 {
 	ls->ls_callback_wq = alloc_workqueue("dlm_callback",
-					     WQ_UNBOUND |
-					     WQ_MEM_RECLAIM |
-					     WQ_NON_REENTRANT,
-					     0);
+					     WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
 	if (!ls->ls_callback_wq) {
 		log_print("can't start dlm_callback workqueue");
 		return -ENOMEM;
-- 
1.8.3.1

