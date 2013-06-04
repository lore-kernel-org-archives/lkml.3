Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3FDWzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:55:44 -0400
Received: from 1wt.eu ([62.212.114.60]:35782 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab3FDWno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:44 -0400
Message-Id: <20130604172137.643220285@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 177/184] isdnloop: fix and simplify isdnloop_init()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

[ Upstream commit 77f00f6324cb97cf1df6f9c4aaeea6ada23abdb2 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/isdn/isdnloop/isdnloop.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index a335c85..22446f7 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include "isdnloop.h"
 
-static char *revision = "$Revision: 1.11.6.7 $";
 static char *isdnloop_id = "loop0";
 
 MODULE_DESCRIPTION("ISDN4Linux: Pseudo Driver that simulates an ISDN card");
@@ -1493,17 +1492,6 @@ isdnloop_addcard(char *id1)
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
1.7.12.2.21.g234cd45.dirty



