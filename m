Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816AbaICXXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:23:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbaICWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 84/88] nfs3_list_one_acl(): check get_acl() result with IS_ERR_OR_NULL
Date: Wed,  3 Sep 2014 15:05:58 -0700
Message-Id: <20140903220518.464263738@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

commit 7a9e75a185e6b3a3860e6a26fb6e88691fc2c9d9 upstream.

There was a check for result being not NULL. But get_acl() may return
NULL, or ERR_PTR, or actual pointer.
The purpose of the function where current change is done is to "list
ACLs only when they are available", so any error condition of get_acl()
mustn't be elevated, and returning 0 there is still valid.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81111
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 74adf83f5d77 (nfs: only show Posix ACLs in listxattr if actually...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs3acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -256,7 +256,7 @@ nfs3_list_one_acl(struct inode *inode, i
 	char *p = data + *result;
 
 	acl = get_acl(inode, type);
-	if (!acl)
+	if (IS_ERR_OR_NULL(acl))
 		return 0;
 
 	posix_acl_release(acl);


