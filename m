Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaDVFpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:45:01 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55225 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDVFo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:44:57 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] cgroup: use uninitialized_var() for may-be uninitialized variable
Date: Tue, 22 Apr 2014 13:44:39 +0800
Message-Id: <1398145479-11400-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To suppress this warning:

 warning: ‘err’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  int err;
	^

Use the uninitialized_var() to decalre err. It also serves to be good documetation.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 24675f5..930569c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4144,7 +4144,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 {
 	struct cgroup *parent = cgrp->parent;
 	struct cgroup_subsys_state *css;
-	int err;
+	int uninitialized_var(err);
 
 	lockdep_assert_held(&cgroup_mutex);
 
-- 
2.0.0-rc0

