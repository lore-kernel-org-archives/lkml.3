Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaIWNK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:10:26 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:47460 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaIWNKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:10:24 -0400
Date: Tue, 23 Sep 2014 09:10:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org
Subject: [GIT UPDATED PULL] cgroup fixes for v3.17-rc6
Message-ID: <20140923131020.GB14905@mtj.dyndns.org>
References: <20140923063353.GK11740@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923063353.GK11740@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

One late fix for cgroup.  I was waiting for another set of fixes for a
long-standing obscure cpuset bug but am not sure whether they'll be
ready before v3.17 release.  This one is a simple fix for a mutex
unlock balance bug in an allocation failure path in
pidlist_array_load().  The bug was introduced in v3.14 and the fix is
tagged for -stable.

Thanks.

The following changes since commit aa32362f011c6e863132b16c1761487166a4bad2:

  cgroup: check cgroup liveliness before unbreaking kernfs (2014-09-05 01:36:19 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes

for you to fetch changes up to eb4aec84d6bdf98d00cedb41c18000f7a31e648a:

  cgroup: fix unbalanced locking (2014-09-18 12:32:52 -0400)

----------------------------------------------------------------
Zefan Li (1):
      cgroup: fix unbalanced locking

 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 940aced..3a73f99 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3985,7 +3985,6 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {
-		mutex_unlock(&cgrp->pidlist_mutex);
 		pidlist_free(array);
 		return -ENOMEM;
 	}

-- 
tejun
