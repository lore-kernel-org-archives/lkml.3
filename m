Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaIRSqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:46:19 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:6230 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352AbaIRSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:46:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgSAPknG1RbsHJU/2dsb2JhbABggw2BKrURAQEEBQFxmwQEAoELFwF5hDEvI4EaN4hCAbIDkEeGCYluHYQ1BZ0MlUiDYDsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] jffs2: fix sparse warning: unexpected unlock
Date: Thu, 18 Sep 2014 20:46:16 +0200
Message-Id: <1411065976-20386-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/summary.c:846:5: warning: context imbalance in 'jffs2_sum_write_sumnode' - unexpected unlock

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jffs2/summary.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index c522d09..a0bac7b 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -844,6 +844,8 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
 /* Write out summary information - called from jffs2_do_reserve_space */
 
 int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
+	__releases(&c->erase_completion_lock)
+	__acquires(&c->erase_completion_lock)
 {
 	int datasize, infosize, padsize;
 	struct jffs2_eraseblock *jeb;
-- 
1.9.1

