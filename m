Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaIRJRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:17:34 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:46596 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaIRJRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:17:33 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: akpm@linux-foundation.org
Cc: gidisrael@gmail.com, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH] kernel/kallsyms.c: use __seq_open_private()
Date: Thu, 18 Sep 2014 10:17:20 +0100
Message-Id: <1411031840-23195-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using __seq_open_private() instead of seq_open()
in kallsyms_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 kernel/kallsyms.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index cb0cf37..606664d 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -565,19 +565,12 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 	 * using get_symbol_offset for every symbol.
 	 */
 	struct kallsym_iter *iter;
-	int ret;
-
-	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	iter = __seq_open_private(file, &kallsyms_op, sizeof(*iter));
 	if (!iter)
 		return -ENOMEM;
 	reset_iter(iter, 0);
 
-	ret = seq_open(file, &kallsyms_op);
-	if (ret == 0)
-		((struct seq_file *)file->private_data)->private = iter;
-	else
-		kfree(iter);
-	return ret;
+	return 0;
 }
 
 #ifdef	CONFIG_KGDB_KDB
-- 
1.7.10.4

