Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3H0BRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:17:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3H0BHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 39/74] VFS: collect_mounts() should return an ERR_PTR
Date: Mon, 26 Aug 2013 18:08:37 -0700
Message-Id: <20130827010432.706525506@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 52e220d357a38cb29fa2e29f34ed94c1d66357f4 upstream.

This should actually be returning an ERR_PTR on error instead of NULL.
That was how it was designed and all the callers expect it.

[AV: actually, that's what "VFS: Make clone_mnt()/copy_tree()/collect_mounts()
return errors" missed - originally collect_mounts() was expected to return
NULL on failure]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1429,7 +1429,7 @@ struct vfsmount *collect_mounts(struct p
 			 CL_COPY_ALL | CL_PRIVATE);
 	namespace_unlock();
 	if (IS_ERR(tree))
-		return NULL;
+		return ERR_CAST(tree);
 	return &tree->mnt;
 }
 


