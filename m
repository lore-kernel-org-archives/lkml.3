Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaFWQkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:40:42 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:60157 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721AbaFWQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:40:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsHADhXqFNbskjJ/2dsb2JhbABZgw2rZQUBAQEBAQEFAZF1h0CBDxd1hAsCUyOBCRE3iEYBxCUXhWOINWQdhC0EhGMDkwCCZpNjg0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/1] fs/f2fs/segment.c: replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:39:15 +0200
Message-Id: <1403541555-10803-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index f25f0e0..96f51d4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1702,7 +1702,7 @@ static int build_curseg(struct f2fs_sb_info *sbi)
 	struct curseg_info *array;
 	int i;
 
-	array = kzalloc(sizeof(*array) * NR_CURSEG_TYPE, GFP_KERNEL);
+	array = kcalloc(NR_CURSEG_TYPE, sizeof(*array), GFP_KERNEL);
 	if (!array)
 		return -ENOMEM;
 
-- 
1.8.4.5

