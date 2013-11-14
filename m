Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3KNQQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:16:30 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57182 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3KNQPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:18 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 13/40] staging/lustre/autoconf: remove vectored fops tests
Date: Fri, 15 Nov 2013 00:13:15 +0800
Message-Id: <1384445622-12346-14-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

file_operations.readv/writev have been removed since v2.6.19
We can remove the test and the dead code.

Lustre-change: http://review.whamcloud.com/5343
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Christopher J. Morrone <chris.morrone.llnl@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index efc614b..174ba4e 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -3000,17 +3000,12 @@ int ll_inode_permission(struct inode *inode, int mask)
 	return rc;
 }
 
-#define READ_METHOD aio_read
-#define READ_FUNCTION ll_file_aio_read
-#define WRITE_METHOD aio_write
-#define WRITE_FUNCTION ll_file_aio_write
-
 /* -o localflock - only provides locally consistent flock locks */
 struct file_operations ll_file_operations = {
 	.read	   = ll_file_read,
-	.READ_METHOD    = READ_FUNCTION,
+	.aio_read = ll_file_aio_read,
 	.write	  = ll_file_write,
-	.WRITE_METHOD   = WRITE_FUNCTION,
+	.aio_write = ll_file_aio_write,
 	.unlocked_ioctl = ll_file_ioctl,
 	.open	   = ll_file_open,
 	.release	= ll_file_release,
@@ -3023,9 +3018,9 @@ struct file_operations ll_file_operations = {
 
 struct file_operations ll_file_operations_flock = {
 	.read	   = ll_file_read,
-	.READ_METHOD    = READ_FUNCTION,
+	.aio_read    = ll_file_aio_read,
 	.write	  = ll_file_write,
-	.WRITE_METHOD   = WRITE_FUNCTION,
+	.aio_write   = ll_file_aio_write,
 	.unlocked_ioctl = ll_file_ioctl,
 	.open	   = ll_file_open,
 	.release	= ll_file_release,
@@ -3041,9 +3036,9 @@ struct file_operations ll_file_operations_flock = {
 /* These are for -o noflock - to return ENOSYS on flock calls */
 struct file_operations ll_file_operations_noflock = {
 	.read	   = ll_file_read,
-	.READ_METHOD    = READ_FUNCTION,
+	.aio_read    = ll_file_aio_read,
 	.write	  = ll_file_write,
-	.WRITE_METHOD   = WRITE_FUNCTION,
+	.aio_write   = ll_file_aio_write,
 	.unlocked_ioctl = ll_file_ioctl,
 	.open	   = ll_file_open,
 	.release	= ll_file_release,
-- 
1.7.9.5

