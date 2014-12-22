Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaLVTFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:05:19 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:42639 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbaLVTFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:05:17 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwPAL1qmFRXQ5YW/2dsb2JhbABbgwaBKrQDBQEBAQEBAQUBd5coBAKBHBcBAQEBAX2EOi8jgRo3iDABwBWQVoYAiXIdhBMFlwORSyKBRQGCKT0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/1 linux-next] ocfs2: remove unnecessary sizeof(char)
Date: Mon, 22 Dec 2014 20:05:09 +0100
Message-Id: <1419275109-11641-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(char) is always 1.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e238bbc..750597c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -129,8 +129,8 @@ int ocfs2_compute_replay_slots(struct ocfs2_super *osb)
 	if (osb->replay_map)
 		return 0;
 
-	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) +
-			     (osb->max_slots * sizeof(char)), GFP_KERNEL);
+	replay_map = kzalloc(sizeof(struct ocfs2_replay_map) + osb->max_slots,
+			     GFP_KERNEL);
 
 	if (!replay_map) {
 		mlog_errno(-ENOMEM);
-- 
1.9.1

