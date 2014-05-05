Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaEEOne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:43:34 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:48183 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbaEEOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:43:32 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Cc: Dan Streetman <ddstreet@ieee.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] plist: replace pr_debug with printk in plist_test()
Date: Mon,  5 May 2014 10:43:05 -0400
Message-Id: <1399300985-11137-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace pr_debug() in lib/plist.c test function plist_test() with
printk(KERN_DEBUG ...).

Without DEBUG defined, pr_debug() is complied out, but the entire
plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so
printk should just be used directly.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
This is a trivial patch so this isn't really "v2", but for completeness
the "v1" was here:
https://lkml.org/lkml/2014/5/2/539

That added -DDEBUG to the lib/Makefile, but Steve suggested this
approach and I agree.

 lib/plist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/plist.c b/lib/plist.c
index 1ebc95f..b883a7a 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -175,7 +175,7 @@ static int  __init plist_test(void)
 	int nr_expect = 0, i, loop;
 	unsigned int r = local_clock();
 
-	pr_debug("start plist test\n");
+	printk(KERN_DEBUG "start plist test\n");
 	plist_head_init(&test_head);
 	for (i = 0; i < ARRAY_SIZE(test_node); i++)
 		plist_node_init(test_node + i, 0);
@@ -203,7 +203,7 @@ static int  __init plist_test(void)
 		plist_test_check(nr_expect);
 	}
 
-	pr_debug("end plist test\n");
+	printk(KERN_DEBUG "end plist test\n");
 	return 0;
 }
 
-- 
1.8.3.1

