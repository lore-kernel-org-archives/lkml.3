Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaAJSsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:48:55 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39467 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaAJSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:44 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ipc: simplify sysvipc_proc_open return
Date: Fri, 10 Jan 2014 10:48:24 -0800
Message-Id: <1389379707-20298-5-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of silly/useless label jumping.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/util.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 7afe7de..cecb46e 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -911,8 +911,10 @@ static int sysvipc_proc_open(struct inode *inode, struct file *file)
 		goto out;
 
 	ret = seq_open(file, &sysvipc_proc_seqops);
-	if (ret)
-		goto out_kfree;
+	if (ret) {
+		kfree(iter);
+		goto out;
+	}
 
 	seq = file->private_data;
 	seq->private = iter;
@@ -921,9 +923,6 @@ static int sysvipc_proc_open(struct inode *inode, struct file *file)
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
 out:
 	return ret;
-out_kfree:
-	kfree(iter);
-	goto out;
 }
 
 static int sysvipc_proc_release(struct inode *inode, struct file *file)
-- 
1.8.1.4

