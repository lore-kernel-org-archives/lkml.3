Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaBEVOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:14:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:54240 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaBEUDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Wu Fengguang <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 027/213] isdnloop: fix and simplify isdnloop_init()
Date: Wed, 5 Feb 2014 14:59:42 -0500
Message-ID: <1391630568-49251-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 77f00f6324cb97cf1df6f9c4aaeea6ada23abdb2 upstream.

Fix a buffer overflow bug by removing the revision and printk.

[   22.016214] isdnloop-ISDN-driver Rev 1.11.6.7
[   22.097508] isdnloop: (loop0) virtual card added
[   22.174400] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff83244972
[   22.174400]
[   22.436157] Pid: 1, comm: swapper Not tainted 3.5.0-bisect-00018-gfa8bbb1-dirty #129
[   22.624071] Call Trace:
[   22.720558]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
[   22.815248]  [<ffffffff8222b623>] panic+0x110/0x329
[   22.914330]  [<ffffffff83244972>] ? isdnloop_init+0xaf/0xb1
[   23.014800]  [<ffffffff832448c3>] ? CallcNew+0x56/0x56
[   23.090763]  [<ffffffff8108e24b>] __stack_chk_fail+0x2b/0x30
[   23.185748]  [<ffffffff83244972>] isdnloop_init+0xaf/0xb1

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/isdn/isdnloop/isdnloop.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index b8a1098b66ed..385279b2d54c 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
 
-static char *revision = "$Revision: 1.11.6.7 $";
 static char *isdnloop_id = "loop0";
 
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card");
@@ -1494,17 +1493,6 @@ isdnloop_addcard(char *id1)
 static int __init
 isdnloop_init(void)
 {
-	char *p;
-	char rev[10];
-
-	if ((p = strchr(revision, ':'))) {
-		strcpy(rev, p + 1);
-		p = strchr(rev, '$');
-		*p = 0;
-	} else
-		strcpy(rev, " ??? ");
-	printk(KERN_NOTICE "isdnloop-ISDN-driver Rev%s\n", rev);
-
 	if (isdnloop_id)
 		return (isdnloop_addcard(isdnloop_id));
 
-- 
1.8.5.2

