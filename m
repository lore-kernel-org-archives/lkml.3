Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3G3Mkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:40:46 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:61600 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3G3Mkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:42 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org, Tejun Heo <tj@kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 6/9] gfs2: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:25 -0400
Message-Id: <1375188028-11910-7-git-send-email-tj@kernel.org>
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
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index e04d0e0..7b0f504 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -155,7 +155,7 @@ static int __init init_gfs2_fs(void)
 		goto fail_wq;
 
 	gfs2_control_wq = alloc_workqueue("gfs2_control",
-			       WQ_NON_REENTRANT | WQ_UNBOUND | WQ_FREEZABLE, 0);
+					  WQ_UNBOUND | WQ_FREEZABLE, 0);
 	if (!gfs2_control_wq)
 		goto fail_recovery;
 
-- 
1.8.3.1

