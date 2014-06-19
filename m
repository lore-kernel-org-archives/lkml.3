Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaFSMe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:34:26 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37999 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaFSMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:34:24 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers/sbus/char: Micro-optimization in display7seg.c
Date: Thu, 19 Jun 2014 14:31:52 +0200
Message-Id: <1403181112-12018-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flipping a bit doesn't need four lines of code; and gcc seems to
actually generate two branches.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/sbus/char/display7seg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 7c71e7b..3221dff 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -143,10 +143,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case D7SIOCTM:
 		/* toggle device mode-- flip display orientation */
-		if (regs & D7S_FLIP)
-			regs &= ~D7S_FLIP;
-		else
-			regs |= D7S_FLIP;
+		regs ^= D7S_FLIP;
 		writeb(regs, p->regs);
 		break;
 	}
-- 
1.9.2

