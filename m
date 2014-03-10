Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaCJUxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:53:19 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:8276 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651AbaCJUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:53:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwGAMUlHlNbsHk5/2dsb2JhbABagwbCV4EgF3SCUxMcIxiBAiQTh30Bz22OW4Q/BJhEAYpWh1eDLjw
Date: Mon, 10 Mar 2014 21:53:03 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jaharkes <jaharkes@cs.cmu.edu>
Subject: [PATCH 1/1] CODA: add __init to init_inodecache()
Message-Id: <20140310215303.21c30508ed4808b4f2484c48@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_inodecache is only called by __init init_coda

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/coda/coda_int.h | 2 +-
 fs/coda/inode.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/coda_int.h b/fs/coda/coda_int.h
index b7143cf..381c993 100644
--- a/fs/coda/coda_int.h
+++ b/fs/coda/coda_int.h
@@ -10,7 +10,7 @@ extern int coda_hard;
 extern int coda_fake_statfs;
 
 void coda_destroy_inodecache(void);
-int coda_init_inodecache(void);
+int __init coda_init_inodecache(void);
 int coda_fsync(struct file *coda_file, loff_t start, loff_t end, int datasync);
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 506de34..ca688d2 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -73,7 +73,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-int coda_init_inodecache(void)
+int __init coda_init_inodecache(void)
 {
 	coda_inode_cachep = kmem_cache_create("coda_inode_cache",
 				sizeof(struct coda_inode_info),
-- 
1.8.1.4
