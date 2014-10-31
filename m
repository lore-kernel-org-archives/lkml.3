Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbaJaMN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 08:13:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52670 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaJaMN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 08:13:58 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] isofs: remove unused functions
Date: Fri, 31 Oct 2014 17:43:48 +0530
Message-Id: <1414757628-16326-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit "5b71ecfa78271d5c576f17156ed8a53981c1ecbb" removed the use
two functions isofs_hash() and isofs_dentry_cmp() , but their
definition was not removed.
So, as these functions are not used anywhere so it is safe to
remove them. It has been build tested after removing.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 fs/isofs/inode.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 859a309..fe839b9 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -29,13 +29,9 @@
 #define BEQUIET
 
 static int isofs_hashi(const struct dentry *parent, struct qstr *qstr);
-static int isofs_hash(const struct dentry *parent, struct qstr *qstr);
 static int isofs_dentry_cmpi(const struct dentry *parent,
 		const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name);
-static int isofs_dentry_cmp(const struct dentry *parent,
-		const struct dentry *dentry,
-		unsigned int len, const char *str, const struct qstr *name);
 
 #ifdef CONFIG_JOLIET
 static int isofs_hashi_ms(const struct dentry *parent, struct qstr *qstr);
@@ -254,25 +250,12 @@ static int isofs_dentry_cmp_common(
 }
 
 static int
-isofs_hash(const struct dentry *dentry, struct qstr *qstr)
-{
-	return isofs_hash_common(qstr, 0);
-}
-
-static int
 isofs_hashi(const struct dentry *dentry, struct qstr *qstr)
 {
 	return isofs_hashi_common(qstr, 0);
 }
 
 static int
-isofs_dentry_cmp(const struct dentry *parent, const struct dentry *dentry,
-		unsigned int len, const char *str, const struct qstr *name)
-{
-	return isofs_dentry_cmp_common(len, str, name, 0, 0);
-}
-
-static int
 isofs_dentry_cmpi(const struct dentry *parent, const struct dentry *dentry,
 		unsigned int len, const char *str, const struct qstr *name)
 {
-- 
1.8.1.2

