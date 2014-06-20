Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966218AbaFTTpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:45:12 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58763 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965936AbaFTTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:45:11 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] trivial: drivers/macintosh/smu.c: Fix closing brace followed by if
Date: Fri, 20 Jun 2014 21:44:27 +0200
Message-Id: <1403293467-17521-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A closing brace followed by "if" is almost certainly a mistake. Maybe
"else if" was meant, but in this case it doesn't really matter.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/macintosh/smu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 23b4a3b..4eab93a 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -1257,7 +1257,8 @@ static unsigned int smu_fpoll(struct file *file, poll_table *wait)
 		if (pp->busy && pp->cmd.status != 1)
 			mask |= POLLIN;
 		spin_unlock_irqrestore(&pp->lock, flags);
-	} if (pp->mode == smu_file_events) {
+	}
+	if (pp->mode == smu_file_events) {
 		/* Not yet implemented */
 	}
 	return mask;
-- 
1.9.2

