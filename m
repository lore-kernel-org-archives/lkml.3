Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaJIUta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:49:30 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:10520 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbaJIUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:49:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQNAJjzNlRbtAbo/2dsb2JhbABggw6BK7djBQFzmgqBChcBe4QxLyOBGjeIQgG0Xo45hiCKJB2ENQWdS4xciTWDZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com
Subject: [PATCH 1/1 linux-next] GFS2: directly return gfs2_dir_check()
Date: Thu,  9 Oct 2014 22:49:21 +0200
Message-Id: <1412887761-15293-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to store gfs2_dir_check result and test it before returning.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/inode.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c4ed823..b41b5c7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1045,11 +1045,7 @@ static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		return error;
 
-	error = gfs2_dir_check(&dip->i_inode, name, ip);
-	if (error)
-		return error;
-
-	return 0;
+	return gfs2_dir_check(&dip->i_inode, name, ip);
 }
 
 /**
-- 
1.9.3

