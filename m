Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaHESsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:48:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaHESON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.15 34/42] vfs: fix check for fallocate on active swapfile
Date: Tue,  5 Aug 2014 11:13:48 -0700
Message-Id: <20140805181322.031151354@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers3@gmail.com>

commit 6d2b6170c8914c6c69256b687651fb16d7ec3e18 upstream.

Fix the broken check for calling sys_fallocate() on an active swapfile,
introduced by commit 0790b31b69374ddadefe ("fs: disallow all fallocate
operation on active swapfile").

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/open.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -263,11 +263,10 @@ int do_fallocate(struct file *file, int
 		return -EPERM;
 
 	/*
-	 * We can not allow to do any fallocate operation on an active
-	 * swapfile
+	 * We cannot allow any fallocate operation on an active swapfile
 	 */
 	if (IS_SWAPFILE(inode))
-		ret = -ETXTBSY;
+		return -ETXTBSY;
 
 	/*
 	 * Revalidate the write permissions, in case security policy has


