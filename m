Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaHFEpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:45:40 -0400
Received: from s87.loopia.se ([194.9.94.112]:34210 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbaHFEn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:43:56 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 11/15] TTY: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:43:42 -0700
Message-Id: <1407300222-365-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/tty/moxa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 1deaca4..14c54e0 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1096,7 +1096,7 @@ static int __init moxa_init(void)
 				continue;
 			}
 
-			printk(KERN_INFO "MOXA isa board found at 0x%.8lu and "
+			printk(KERN_INFO "MOXA isa board found at 0x%.8lx and "
 					"ready (%u ports, firmware loaded)\n",
 					baseaddr[i], brd->numPorts);
 
-- 
2.0.0.526.g5318336

