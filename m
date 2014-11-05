Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaKEPn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaKEPnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:43:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 6/7] SELinux: The copy-up operation must have read
 permission on the lower file
From: David Howells <dhowells@redhat.com>
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 15:43:19 +0000
Message-ID: <20141105154318.2555.7052.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copy-up operation must have read permission on the lower file for the task
that caused the copy-up.  This helps prevent overlayfs from being used to
access something it shouldn't.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f43f07fdc028..57f9c641779f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3144,7 +3144,8 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 
 static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
 {
-	return 0;
+	const struct cred *cred = current_cred();
+	return dentry_has_perm(cred, src, FILE__OPEN | FILE__READ);
 }
 
 static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,

