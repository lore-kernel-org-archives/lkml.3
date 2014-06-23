Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaFWQpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:45:25 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:60902 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbaFWQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:45:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAKJYqFNbskjJ/2dsb2JhbABZgw2rZgUBAQEBAQEFAZk1gQ8XdYQxLyOBGjeIRgHEKxeFY4g1ZB2ELQSaTIs1iC6DRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/1] fs/ocfs2/slot_map.c: replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:44:06 +0200
Message-Id: <1403541846-11025-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/slot_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 1424c15..a88b2a4 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -382,7 +382,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
 	trace_ocfs2_map_slot_buffers(bytes, si->si_blocks);
 
-	si->si_bh = kzalloc(sizeof(struct buffer_head *) * si->si_blocks,
+	si->si_bh = kcalloc(si->si_blocks, sizeof(struct buffer_head *),
 			    GFP_KERNEL);
 	if (!si->si_bh) {
 		status = -ENOMEM;
-- 
1.8.4.5

