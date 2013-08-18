Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3HRLUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 07:20:12 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60742 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3HRLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 07:20:09 -0400
Date: Sun, 18 Aug 2013 07:20:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.11-rc5
Message-ID: <20130818112005.GD7093@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains one patch to fix the return value of
cpuset's cgroups interface function, which used to always return
-ENODEV for the writes on the "memory_pressure_enabled" file.

The fix is available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-fixes

for you to fetch changes up to a903f0865a190f8778c73df1a810ea6e25e5d7cf:

  cpuset: fix the return value of cpuset_write_u64() (2013-08-13 10:54:40 -0400)

Thanks.

----------------------------------------------------------------
Li Zefan (1):
      cpuset: fix the return value of cpuset_write_u64()

 kernel/cpuset.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e565778..010a008 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1608,11 +1608,13 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
+	if (!is_cpuset_online(cs)) {
+		retval = -ENODEV;
 		goto out_unlock;
+	}
 
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:

--
tejun
