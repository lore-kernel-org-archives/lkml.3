Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3JCGTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:19:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41564 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3JCGTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:19:37 -0400
Date: Thu, 03 Oct 2013 07:19:36 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 13/17] isofs: don't pass dentry to isofs_hash{i,}_common()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcG8-0008Ce-CP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/isofs/inode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index e5d408a..4a9e10e 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -181,7 +181,7 @@ struct iso9660_options{
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hash_common(const struct dentry *dentry, struct qstr *qstr, int ms)
+isofs_hash_common(struct qstr *qstr, int ms)
 {
 	const char *name;
 	int len;
@@ -202,7 +202,7 @@ isofs_hash_common(const struct dentry *dentry, struct qstr *qstr, int ms)
  * Compute the hash for the isofs name corresponding to the dentry.
  */
 static int
-isofs_hashi_common(const struct dentry *dentry, struct qstr *qstr, int ms)
+isofs_hashi_common(struct qstr *qstr, int ms)
 {
 	const char *name;
 	int len;
@@ -259,13 +259,13 @@ static int isofs_dentry_cmp_common(
 static int
 isofs_hash(const struct dentry *dentry, struct qstr *qstr)
 {
-	return isofs_hash_common(dentry, qstr, 0);
+	return isofs_hash_common(qstr, 0);
 }
 
 static int
 isofs_hashi(const struct dentry *dentry, struct qstr *qstr)
 {
-	return isofs_hashi_common(dentry, qstr, 0);
+	return isofs_hashi_common(qstr, 0);
 }
 
 static int
@@ -286,13 +286,13 @@ isofs_dentry_cmpi(const struct dentry *parent, const struct dentry *dentry,
 static int
 isofs_hash_ms(const struct dentry *dentry, struct qstr *qstr)
 {
-	return isofs_hash_common(dentry, qstr, 1);
+	return isofs_hash_common(qstr, 1);
 }
 
 static int
 isofs_hashi_ms(const struct dentry *dentry, struct qstr *qstr)
 {
-	return isofs_hashi_common(dentry, qstr, 1);
+	return isofs_hashi_common(qstr, 1);
 }
 
 static int
-- 
1.7.2.5


