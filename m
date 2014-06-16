Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbaFPSE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:04:28 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:55055 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256AbaFPSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:04:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZFnhz2BERd1hAsCJC8jgQkRN4hGAc8qF4VjiRMdhC0El16CZZNYg0I7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] fs/jffs2/xattr.c:  remove null test before kfree
Date: Mon, 16 Jun 2014 20:02:49 +0200
Message-Id: <1402941769-4539-1-git-send-email-fabf@skynet.be>
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
 fs/jffs2/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index ad0f2e2..d72817a 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -756,8 +756,7 @@ void jffs2_clear_xattr_subsystem(struct jffs2_sb_info *c)
 	for (i=0; i < XATTRINDEX_HASHSIZE; i++) {
 		list_for_each_entry_safe(xd, _xd, &c->xattrindex[i], xindex) {
 			list_del(&xd->xindex);
-			if (xd->xname)
-				kfree(xd->xname);
+			kfree(xd->xname);
 			jffs2_free_xattr_datum(xd);
 		}
 	}
-- 
1.8.4.5

