Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3CCPd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 10:33:59 -0500
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:53601 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753413Ab3CCPd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 10:33:58 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2013 10:33:58 EST
Message-ID: <1362324434.29435.34.camel@slavad-ubuntu-12.04>
Subject: [PATCH] posix_acl: fix warning in acl_by_type() function
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 03 Mar 2013 19:27:14 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] posix_acl: fix warning in acl_by_type() function

This patch fixes warning in function ‘acl_by_type’: include/linux/posix_acl.h:108:1: warning: control reaches end of non-void function [-Wreturn-type].

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 include/linux/posix_acl.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe..db1155a 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -102,9 +102,10 @@ static inline struct posix_acl **acl_by_type(struct inode *inode, int type)
 		return &inode->i_acl;
 	case ACL_TYPE_DEFAULT:
 		return &inode->i_default_acl;
-	default:
-		BUG();
 	}
+
+	BUG();
+	return NULL;
 }
 
 static inline struct posix_acl *get_cached_acl(struct inode *inode, int type)
-- 
1.7.9.5



