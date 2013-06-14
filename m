Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab3FNCl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:41:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759632Ab3FNCl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:41:56 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 25/33] xfs: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:50 -0700
Message-Id: <1cd76f83a114f3bc5bf6450bc71098aa2c6baa33.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_sysctl.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 2801b5c..1743b9f 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -25,11 +25,11 @@ static struct ctl_table_header *xfs_table_header;
 #ifdef CONFIG_PROC_FS
 STATIC int
 xfs_stats_clear_proc_handler(
-	ctl_table	*ctl,
-	int		write,
-	void		__user *buffer,
-	size_t		*lenp,
-	loff_t		*ppos)
+	struct ctl_table	*ctl,
+	int			write,
+	void			__user *buffer,
+	size_t			*lenp,
+	loff_t			*ppos)
 {
 	int		c, ret, *valp = ctl->data;
 	__uint32_t	vn_active;
@@ -55,11 +55,11 @@ xfs_stats_clear_proc_handler(
 
 STATIC int
 xfs_panic_mask_proc_handler(
-	ctl_table	*ctl,
-	int		write,
-	void		__user *buffer,
-	size_t		*lenp,
-	loff_t		*ppos)
+	struct ctl_table	*ctl,
+	int			write,
+	void			__user *buffer,
+	size_t			*lenp,
+	loff_t			*ppos)
 {
 	int		ret, *valp = ctl->data;
 
@@ -74,7 +74,7 @@ xfs_panic_mask_proc_handler(
 }
 #endif /* CONFIG_PROC_FS */
 
-static ctl_table xfs_table[] = {
+static struct ctl_table xfs_table[] = {
 	{
 		.procname	= "irix_sgid_inherit",
 		.data		= &xfs_params.sgid_inherit.val,
@@ -227,7 +227,7 @@ static ctl_table xfs_table[] = {
 	{}
 };
 
-static ctl_table xfs_dir_table[] = {
+static struct ctl_table xfs_dir_table[] = {
 	{
 		.procname	= "xfs",
 		.mode		= 0555,
@@ -236,7 +236,7 @@ static ctl_table xfs_dir_table[] = {
 	{}
 };
 
-static ctl_table xfs_root_table[] = {
+static struct ctl_table xfs_root_table[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

