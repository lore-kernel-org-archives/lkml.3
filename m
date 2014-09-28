Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaI1T0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 15:26:55 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:27593 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbaI1T0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 15:26:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8NAB1gKFRXQ6qa/2dsb2JhbABggw63MwsFAXKaV3wXAXuEMS8jgQIYN4gqAxUBr2SHeA2HOIYSh1yCMB2ENQWbGIIQjxWGSINlOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: linux-sparse@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Fabian Frederick <fabf@skynet.be>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH V2 linux-next] jffs2: fix sparse warning: unexpected unlock
Date: Sun, 28 Sep 2014 21:26:32 +0200
Message-Id: <1411932392-7751-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/summary.c:846:5: warning: context imbalance in 'jffs2_sum_write_sumnode' - unexpected unlock

Suggested-by: Brian Norris <computersforpeace@gmail.com>
Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: use __must_hold instead of __releases / __acquires
(suggested by Brian Norris and Josh Triplett)

 fs/jffs2/summary.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index c522d09..bc53854 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -844,6 +844,7 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
 /* Write out summary information - called from jffs2_do_reserve_space */
 
 int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
+	__must_hold(&c->erase_completion_block)
 {
 	int datasize, infosize, padsize;
 	struct jffs2_eraseblock *jeb;
-- 
1.9.1

