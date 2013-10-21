Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3JUShz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:37:55 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:38281 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3JUShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:37:54 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] xfs: fix possible NULL dereference
Date: Mon, 21 Oct 2013 15:32:46 -0300
Message-Id: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
dereferencing.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/xfs/xfs_log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2dea108..8cdeb7e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3703,8 +3703,10 @@ xlog_verify_iclog(
 	spin_lock(&log->l_icloglock);
 	icptr = log->l_iclog;
 	for (i=0; i < log->l_iclog_bufs; i++) {
-		if (icptr == NULL)
+		if (!icptr) {
 			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
+			break;
+		}
 		icptr = icptr->ic_next;
 	}
 	if (icptr != log->l_iclog)
-- 
1.8.4

