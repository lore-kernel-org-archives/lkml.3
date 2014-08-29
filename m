Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaH2QHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:07:41 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58835 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaH2QHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:07:15 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, jbaron@akamai.com, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH 4/4] lib: Use seq_open_private() instead of seq_open()
Date: Fri, 29 Aug 2014 17:06:40 +0100
Message-Id: <1409328400-18212-5-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using seq_open_private() removes boilerplate code from ddebug_proc_open()

The resultant code is shorter and easier to follow.

This patch does not change any functionality.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 lib/dynamic_debug.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7288e38..e067fb5 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -827,22 +827,9 @@ static const struct seq_operations ddebug_proc_seqops = {
  */
 static int ddebug_proc_open(struct inode *inode, struct file *file)
 {
-	struct ddebug_iter *iter;
-	int err;
-
 	vpr_info("called\n");
-
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (iter == NULL)
-		return -ENOMEM;
-
-	err = seq_open(file, &ddebug_proc_seqops);
-	if (err) {
-		kfree(iter);
-		return err;
-	}
-	((struct seq_file *)file->private_data)->private = iter;
-	return 0;
+	return seq_open_private(file, &ddebug_proc_seqops,
+				sizeof(struct ddebug_iter));
 }
 
 static const struct file_operations ddebug_proc_fops = {
-- 
1.7.10.4

