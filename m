Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaG0UVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 16:21:37 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:41983 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaG0UVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 16:21:36 -0400
From: Jessica Yu <jyu@cowsay.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jyu@cowsay.org>
Subject: [PATCH] Staging: lustre: linux-module: fix coding style issues.
Date: Sun, 27 Jul 2014 21:23:36 -0700
Message-Id: <1406521416-25031-1-git-send-email-jyu@cowsay.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues.

Signed-off-by: Jessica Yu <jyu@cowsay.org>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index ccadf65..de3c199 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -99,7 +99,7 @@ int libcfs_ioctl_popdata(void *arg, void *data, int size)
 extern struct cfs_psdev_ops	  libcfs_psdev_ops;
 
 static int
-libcfs_psdev_open(struct inode * inode, struct file * file)
+libcfs_psdev_open(struct inode *inode, struct file *file)
 {
 	struct libcfs_device_userstate **pdu = NULL;
 	int    rc = 0;
@@ -116,7 +116,7 @@ libcfs_psdev_open(struct inode * inode, struct file * file)
 
 /* called when closing /dev/device */
 static int
-libcfs_psdev_release(struct inode * inode, struct file * file)
+libcfs_psdev_release(struct inode *inode, struct file *file)
 {
 	struct libcfs_device_userstate *pdu;
 	int    rc = 0;
@@ -140,9 +140,9 @@ static long libcfs_ioctl(struct file *file,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if ( _IOC_TYPE(cmd) != IOC_LIBCFS_TYPE ||
+	if (_IOC_TYPE(cmd) != IOC_LIBCFS_TYPE ||
 	     _IOC_NR(cmd) < IOC_LIBCFS_MIN_NR  ||
-	     _IOC_NR(cmd) > IOC_LIBCFS_MAX_NR ) {
+	     _IOC_NR(cmd) > IOC_LIBCFS_MAX_NR) {
 		CDEBUG(D_IOCTL, "invalid ioctl ( type %d, nr %d, size %d )\n",
 		       _IOC_TYPE(cmd), _IOC_NR(cmd), _IOC_SIZE(cmd));
 		return (-EINVAL);
@@ -154,7 +154,7 @@ static long libcfs_ioctl(struct file *file,
 		if (!capable(CFS_CAP_SYS_BOOT))
 			return (-EPERM);
 		panic("debugctl-invoked panic");
-		return (0);
+		return 0;
 	case IOC_LIBCFS_MEMHOG:
 		if (!capable(CFS_CAP_SYS_ADMIN))
 			return -EPERM;
@@ -167,10 +167,10 @@ static long libcfs_ioctl(struct file *file,
 		rc = libcfs_psdev_ops.p_ioctl(&pfile, cmd, (void *)arg);
 	else
 		rc = -EPERM;
-	return (rc);
+	return rc;
 }
 
-static struct file_operations libcfs_fops = {
+static const struct file_operations libcfs_fops = {
 	.unlocked_ioctl	= libcfs_ioctl,
 	.open		= libcfs_psdev_open,
 	.release	= libcfs_psdev_release,
-- 
2.0.1

