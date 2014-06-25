Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbaFYSR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:17:57 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:64587 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600AbaFYSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:17:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMHADQRq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZk6gQ4XdYQxLyOBGjeIRgGqdZgYF4VjiDVkHYQtBY90il2Ta4NEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Bob Copeland <me@bobcopeland.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/omfs/inode.c: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:17:17 +0200
Message-Id: <1403720237-19131-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/omfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index ec58c76..ba88197 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -321,7 +321,7 @@ static int omfs_get_imap(struct super_block *sb)
 		goto out;
 
 	sbi->s_imap_size = array_size;
-	sbi->s_imap = kzalloc(array_size * sizeof(unsigned long *), GFP_KERNEL);
+	sbi->s_imap = kcalloc(array_size, sizeof(unsigned long *), GFP_KERNEL);
 	if (!sbi->s_imap)
 		goto nomem;
 
-- 
1.9.1

