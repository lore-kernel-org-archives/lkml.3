Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaHRLVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:21:06 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41659 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHRLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:21:05 -0400
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Alban Crequy <alban.crequy@collabora.co.uk>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2] cgroup: reject cgroup names with '\n'
Date: Mon, 18 Aug 2014 12:20:20 +0100
Message-Id: <1408360820-3390-1-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
---
v2: Fixed according to comments from Tejun Heo: only reject '\n'

 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..c3d1802 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4543,6 +4543,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct cftype *base_files;
 	int ssid, ret;
 
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(name, '\n'))
+		return -EINVAL;
+
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;
-- 
1.8.5.3

