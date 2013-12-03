Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3LCQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:05:21 -0500
Received: from frostfang.bitronictech.net ([198.20.106.155]:35300 "EHLO
	www.churchofgit.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3LCQFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:05:20 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 11:05:20 EST
From: Shawn Landden <shawn@churchofgit.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Shawn Landden <shawn@churchofgit.com>
Subject: [PATCH] tty: only print sysrq help for handlers that are enabled
Date: Tue,  3 Dec 2013 07:55:25 -0800
Message-Id: <1386086125-1865-1-git-send-email-shawn@churchofgit.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also print out a notice when sysrq is in selective mode.

Signed-off-by: Shawn Landden <shawn@churchofgit.com>
---
 drivers/tty/sysrq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index ce396ec..4eee0e4 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -548,9 +548,14 @@ void __handle_sysrq(int key, bool check_mask)
 					;
 				if (j != i)
 					continue;
-				printk("%s ", sysrq_key_table[i]->help_msg);
+				/* only print if handler is enabled */
+				if (sysrq_enabled & 1 ||
+				    sysrq_enabled & sysrq_key_table[i]->enable_mask)
+					printk("%s ", sysrq_key_table[i]->help_msg);
 			}
 		}
+		if (!(sysrq_enabled & 1))
+			printk("(some options are disabled)");
 		printk("\n");
 		console_loglevel = orig_log_level;
 	}
-- 
1.8.4.4

