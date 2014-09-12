Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaILOJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:09:51 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:57357 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbaILOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:09:50 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH 2/2] fs: proc: use __seq_open_private()
Date: Fri, 12 Sep 2014 15:09:38 +0100
Message-Id: <1410530978-29627-3-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using __seq_open_private() instead of seq_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 fs/proc/task_mmu.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..c8e9045 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -235,19 +235,14 @@ static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
 	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+
+	priv = __seq_open_private(file, ops, sizeof(*priv));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pid = proc_pid(inode);
+
+	return 0;
 }
 
 static void
@@ -1495,19 +1490,14 @@ static int numa_maps_open(struct inode *inode, struct file *file,
 			  const struct seq_operations *ops)
 {
 	struct numa_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->proc_maps.pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+
+	priv = __seq_open_private(file, ops, sizeof(*priv));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->proc_maps.pid = proc_pid(inode);
+
+	return 0;
 }
 
 static int pid_numa_maps_open(struct inode *inode, struct file *file)
-- 
1.7.10.4

