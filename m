Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966674AbaFTUjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:39:09 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:37634 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbaFTUjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:39:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHAKybpFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBGjeIRgHKLReFYokUHYQtBJpEk1qDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] fs/aio.c: remove null test before kfree
Date: Fri, 20 Jun 2014 22:37:50 +0200
Message-Id: <1403296670-6134-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/aio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4f078c0..9991a25 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -803,8 +803,7 @@ void exit_aio(struct mm_struct *mm)
 			if (!table || i >= table->nr) {
 				rcu_read_unlock();
 				rcu_assign_pointer(mm->ioctx_table, NULL);
-				if (table)
-					kfree(table);
+				kfree(table);
 				return;
 			}
 
-- 
1.8.4.5

