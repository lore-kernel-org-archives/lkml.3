Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbaFZRRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:17:36 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:41791 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757898AbaFZRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:17:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KAKhUrFNXQz8N/2dsb2JhbABagw2rRQUBAQEBAQEFAW2Yf4ENF3WEYCOBGjeIRgHCCxeFZIkcHYQtBY96il+LOog7g0Q7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/gcov/fs.c: remove unnecessary null test before debugfs_remove
Date: Thu, 26 Jun 2014 19:16:15 +0200
Message-Id: <1403802975-8711-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/gcov/fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 15ff01a..edf67c4 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -784,8 +784,7 @@ static __init int gcov_fs_init(void)
 
 err_remove:
 	pr_err("init failed\n");
-	if (root_node.dentry)
-		debugfs_remove(root_node.dentry);
+	debugfs_remove(root_node.dentry);
 
 	return rc;
 }
-- 
1.8.4.5

