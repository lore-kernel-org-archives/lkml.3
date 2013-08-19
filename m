Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab3HSJPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3HSJOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:42 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/5] GFS2: WQ_NON_REENTRANT is meaningless and going away
Date: Mon, 19 Aug 2013 09:48:04 +0100
Message-Id: <1376902087-7783-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
References: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com

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
1.7.4

