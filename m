Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaFKSYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:24:45 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:23454 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbaFKSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:24:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwHAJmdmFNbslCP/2dsb2JhbABagw2BKKpLBQEBAQEBAQUBmRuBCBd1hDEvI4EaN4hGAdAYF4VciBlkHYQrBI9kikqTS4M+Oy+BAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/nilfs2/super.c: remove unnecessary test on unsigned value
Date: Wed, 11 Jun 2014 20:23:22 +0200
Message-Id: <1402511002-9982-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned value is never < 0

Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/nilfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 8c532b2..401b97f 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1014,7 +1014,7 @@ int nilfs_checkpoint_is_mounted(struct super_block *sb, __u64 cno)
 	struct dentry *dentry;
 	int ret;
 
-	if (cno < 0 || cno > nilfs->ns_cno)
+	if (cno > nilfs->ns_cno)
 		return false;
 
 	if (cno >= nilfs_last_cno(nilfs))
-- 
1.8.4.5

