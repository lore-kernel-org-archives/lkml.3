Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaICHZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:25:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22669 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaICHXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d8-5406c1e3efb6
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/8] integrity: remove declaration of non-existing functions
Date: Wed, 03 Sep 2014 10:19:55 +0300
Message-id: <4ae21fa095c234dcb8f6b6ebb7b7fff308448fb8.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4Vd3HB9lCDL5ftra49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBnPbvazFGwUqJjy8wV7A+Nf3i5GTg4JAROJ3jMXWSBsMYkL99azdTFycQgJ
	LGWU+LCoE8rpZJJ4/LmfDaSKTUBPYkPzD3YQW0QgR2LSmQvMIDazQLrEp0m9YHFhAR+Jc4uX
	g8VZBFQlXt08CxbnFYiTuHtpBtQ2OYmTxyazdjFycHAKWEnMO6oFEhYSsJRov7qMEYfwBEb+
	BYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCwu7LDsbFx6wOMQpwMCrx8BaosYUIsSaW
	FVfmHmKU4GBWEuH1TQQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYOT+Zsn9tUnizF75na8fPyu2
	eRbof1hoS9X9xv+8JhtyCs7ter3FjePNAbayH0sq13z8xO4jMZ+VI5WVn6/2ya9/e6/HOB18
	tmrJrN8XOu/YTGu4emyFQoHBBY3VKgc7/3z3n3fZ7a2A4kp381tuWfot/lzL0vr837tN61oQ
	v5Zhy/d/7yz9O2cpsRRnJBpqMRcVJwIAqQK5NBkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed that there are declaration of few non-existing functions.
Also remove duplicated declaration of inegrity_iint_find().

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima.h   | 9 ---------
 security/integrity/integrity.h | 1 -
 2 files changed, 10 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 0fb456c..c6990a7 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -90,10 +90,7 @@ extern struct list_head ima_measurements;	/* list of all measurements */
 
 /* Internal IMA function definitions */
 int ima_init(void);
-void ima_cleanup(void);
 int ima_fs_init(void);
-void ima_fs_cleanup(void);
-int ima_inode_alloc(struct inode *inode);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
 			   const unsigned char *filename);
@@ -151,12 +148,6 @@ int ima_store_template(struct ima_template_entry *entry, int violation,
 void ima_free_template_entry(struct ima_template_entry *entry);
 const char *ima_d_path(struct path *path, char **pathbuf);
 
-/* rbtree tree calls to lookup, insert, delete
- * integrity data associated with an inode.
- */
-struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
-struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
-
 /* IMA policy related functions */
 enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, FIRMWARE_CHECK, POST_SETATTR };
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 904e68a..c0379d1 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -117,7 +117,6 @@ struct integrity_iint_cache {
 /* rbtree tree calls to lookup, insert, delete
  * integrity data associated with an inode.
  */
-struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
 struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 #define INTEGRITY_KEYRING_EVM		0
-- 
1.9.1

