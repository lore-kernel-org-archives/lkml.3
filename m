Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaKAWpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:45:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60258 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Alban Crequy" <alban.crequy@collabora.co.uk>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.915423757@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 005/102] cgroup: reject cgroup names with '\n'
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Crequy <alban.crequy@collabora.co.uk>

commit 71b1fb5c4473a5b1e601d41b109bdfe001ec82e0 upstream.

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
[bwh: Backported to 3.2:
 - Adjust context
 - We have to get the name from the dentry pointer]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3871,6 +3871,11 @@ static int cgroup_mkdir(struct inode *di
 {
 	struct cgroup *c_parent = dentry->d_parent->d_fsdata;
 
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(dentry->d_name.name, '\n'))
+		return -EINVAL;
+
 	/* the vfs holds inode->i_mutex already */
 	return cgroup_create(c_parent, dentry, mode | S_IFDIR);
 }

