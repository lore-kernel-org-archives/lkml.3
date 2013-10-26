Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3JZCeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:34:31 -0400
Received: from fifo99.com ([67.223.236.141]:32846 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3JZCea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:34:30 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cgroups: remove calls to simple_kstrtoll
Date: Fri, 25 Oct 2013 19:33:13 -0700
Message-Id: <1382754793-8827-3-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 kernel/cgroup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 41f71c3..bf8b891 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2276,7 +2276,7 @@ static ssize_t cgroup_write_X64(struct cgroup_subsys_state *css,
 {
 	char buffer[CGROUP_LOCAL_BUFFER_SIZE];
 	int retval = 0;
-	char *end;
+	int ret;
 
 	if (!nbytes)
 		return -EINVAL;
@@ -2287,13 +2287,15 @@ static ssize_t cgroup_write_X64(struct cgroup_subsys_state *css,
 
 	buffer[nbytes] = 0;     /* nul-terminate */
 	if (cft->write_u64) {
-		u64 val = simple_strtoull(strstrip(buffer), &end, 0);
-		if (*end)
+		u64 val;
+		ret = kstrtoull(strstrip(buffer), 0, &val);
+		if (ret != 0)
 			return -EINVAL;
 		retval = cft->write_u64(css, cft, val);
 	} else {
-		s64 val = simple_strtoll(strstrip(buffer), &end, 0);
-		if (*end)
+		s64 val;
+		ret = kstrtoll(strstrip(buffer), 0, &val);
+		if (ret != 0)
 			return -EINVAL;
 		retval = cft->write_s64(css, cft, val);
 	}
-- 
1.8.3.2

