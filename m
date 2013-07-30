Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3G3MmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:42:00 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:56829 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3G3Mkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:46 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org, Tejun Heo <tj@kernel.org>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 8/9] ceph: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:27 -0400
Message-Id: <1375188028-11910-9-git-send-email-tj@kernel.org>
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
Cc: Sage Weil <sage@inktank.com>
Cc: ceph-devel@vger.kernel.org
---
 net/ceph/messenger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index eb0a46a..dd9b585 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -290,7 +290,7 @@ int ceph_msgr_init(void)
 	if (ceph_msgr_slab_init())
 		return -ENOMEM;
 
-	ceph_msgr_wq = alloc_workqueue("ceph-msgr", WQ_NON_REENTRANT, 0);
+	ceph_msgr_wq = alloc_workqueue("ceph-msgr", 0, 0);
 	if (ceph_msgr_wq)
 		return 0;
 
-- 
1.8.3.1

