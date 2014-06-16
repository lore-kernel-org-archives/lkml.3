Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaFPR7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:59:42 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:25885 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932439AbaFPR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:59:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZFnhz2BERd1hAsCUyOBCRE3iEYBzyoXhWOJEx2ELQSXXoJlk1iDQjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] fs/jffs2/acl.c: remove null test before kfree
Date: Mon, 16 Jun 2014 19:58:07 +0200
Message-Id: <1402941487-3941-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jffs2/acl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 009ec0b..2f7a3c0 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -202,8 +202,7 @@ struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
 	} else {
 		acl = ERR_PTR(rc);
 	}
-	if (value)
-		kfree(value);
+	kfree(value);
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 	return acl;
-- 
1.8.4.5

