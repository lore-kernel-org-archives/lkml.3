Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbaKEPm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:42:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbaKEPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:42:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/7] SELinux: Stub in copy-up handling
From: David Howells <dhowells@redhat.com>
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 15:42:48 +0000
Message-ID: <20141105154248.2555.15813.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide stubs for union/overlay copy-up handling.  The xattr copy up stub
discards lower SELinux xattrs rather than letting them be copied up so that
the security label on the copy doesn't get corrupted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e66314138b38..f3fe7dbbf741 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3142,6 +3142,19 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = isec->sid;
 }
 
+static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
+{
+	return 0;
+}
+
+static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
+				       const char *name, void *value, size_t *size)
+{
+	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
+		return 1; /* Discard */
+	return 0;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -5868,6 +5881,8 @@ static struct security_operations selinux_ops = {
 	.inode_setsecurity =		selinux_inode_setsecurity,
 	.inode_listsecurity =		selinux_inode_listsecurity,
 	.inode_getsecid =		selinux_inode_getsecid,
+	.inode_copy_up =		selinux_inode_copy_up,
+	.inode_copy_up_xattr =		selinux_inode_copy_up_xattr,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,

