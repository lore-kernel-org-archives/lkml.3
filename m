Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaEZTog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:44:36 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:62393 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbaEZTof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:44:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIKABWZg1NbsG99/2dsb2JhbABZgwerIwQBAQEBAQEFAYM8lFCBFRd0glMTHCMYgQIkE4hGAdUXhVWIfYRHAQOPP4ozAZMngzo7gTIk
Date: Mon, 26 May 2014 21:44:32 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ocfs2/ioctl.c: add static to local functions
Message-Id: <20140526214432.57fedfe9cb085bfc4ae8df11@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs_info_foo() and ocfs2_get_request_ptr functions are only used in ioctl.c

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/ioctl.c | 81 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 490229f..6f66b37 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -143,8 +143,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_blocksize(struct inode *inode,
-				struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_blocksize(struct inode *inode,
+				       struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_blocksize oib;
@@ -167,8 +167,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_clustersize(struct inode *inode,
-				  struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_clustersize(struct inode *inode,
+					 struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_clustersize oic;
@@ -192,8 +192,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_maxslots(struct inode *inode,
-			       struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_maxslots(struct inode *inode,
+				      struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_maxslots oim;
@@ -217,8 +217,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_label(struct inode *inode,
-			    struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_label(struct inode *inode,
+				   struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_label oil;
@@ -242,8 +242,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_uuid(struct inode *inode,
-			   struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_uuid(struct inode *inode,
+				  struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_uuid oiu;
@@ -267,8 +267,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_fs_features(struct inode *inode,
-				  struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_fs_features(struct inode *inode,
+					 struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_fs_features oif;
@@ -294,8 +294,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_journal_size(struct inode *inode,
-				   struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_journal_size(struct inode *inode,
+					  struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_journal_size oij;
@@ -319,9 +319,10 @@ bail:
 	return status;
 }
 
-int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
-				struct inode *inode_alloc, u64 blkno,
-				struct ocfs2_info_freeinode *fi, u32 slot)
+static int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
+				       struct inode *inode_alloc, u64 blkno,
+				       struct ocfs2_info_freeinode *fi,
+				       u32 slot)
 {
 	int status = 0, unlock = 0;
 
@@ -366,8 +367,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_freeinode(struct inode *inode,
-				struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_freeinode(struct inode *inode,
+				       struct ocfs2_info_request __user *req)
 {
 	u32 i;
 	u64 blkno = -1;
@@ -462,19 +463,19 @@ static void o2ffg_update_stats(struct ocfs2_info_freefrag_stats *stats,
 	stats->ffs_free_chunks_real++;
 }
 
-void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
-			   unsigned int chunksize)
+static void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
+				  unsigned int chunksize)
 {
 	o2ffg_update_histogram(&(ffg->iff_ffs.ffs_fc_hist), chunksize);
 	o2ffg_update_stats(&(ffg->iff_ffs), chunksize);
 }
 
-int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
-				   struct inode *gb_inode,
-				   struct ocfs2_dinode *gb_dinode,
-				   struct ocfs2_chain_rec *rec,
-				   struct ocfs2_info_freefrag *ffg,
-				   u32 chunks_in_group)
+static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
+					  struct inode *gb_inode,
+					  struct ocfs2_dinode *gb_dinode,
+					  struct ocfs2_chain_rec *rec,
+					  struct ocfs2_info_freefrag *ffg,
+					  u32 chunks_in_group)
 {
 	int status = 0, used;
 	u64 blkno;
@@ -572,9 +573,9 @@ bail:
 	return status;
 }
 
-int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
-				    struct inode *gb_inode, u64 blkno,
-				    struct ocfs2_info_freefrag *ffg)
+static int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
+					   struct inode *gb_inode, u64 blkno,
+					   struct ocfs2_info_freefrag *ffg)
 {
 	u32 chunks_in_group;
 	int status = 0, unlock = 0, i;
@@ -652,8 +653,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_freefrag(struct inode *inode,
-			       struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_freefrag(struct inode *inode,
+				      struct ocfs2_info_request __user *req)
 {
 	u64 blkno = -1;
 	char namebuf[40];
@@ -723,8 +724,8 @@ out_err:
 	return status;
 }
 
-int ocfs2_info_handle_unknown(struct inode *inode,
-			      struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_unknown(struct inode *inode,
+				     struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_request oir;
@@ -752,8 +753,8 @@ bail:
  * - distinguish different requests.
  * - validate size of different requests.
  */
-int ocfs2_info_handle_request(struct inode *inode,
-			      struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_request(struct inode *inode,
+				     struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_request oir;
@@ -811,8 +812,8 @@ bail:
 	return status;
 }
 
-int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
-			  u64 *req_addr, int compat_flag)
+static int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
+				 u64 *req_addr, int compat_flag)
 {
 	int status = -EFAULT;
 	u64 __user *bp = NULL;
@@ -849,8 +850,8 @@ bail:
  * a better backward&forward compatibility, since a small piece of
  * request will be less likely to be broken if disk layout get changed.
  */
-int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
-		      int compat_flag)
+static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
+			     int compat_flag)
 {
 	int i, status = 0;
 	u64 req_addr;
-- 
1.9.1
