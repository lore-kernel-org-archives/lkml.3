Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaILDlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:41:50 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:58924 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120AbaILDls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:41:48 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/9] locktorture: Rename locktorture_runnable parameter
Date: Thu, 11 Sep 2014 20:40:16 -0700
Message-Id: <1410493224-3312-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to just 'torture_runnable'. It follows other variable naming
and is shorter.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 0955b88..8c770b2 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -87,9 +87,9 @@ static struct lock_writer_stress_stats *lwsa;
 #else
 #define LOCKTORTURE_RUNNABLE_INIT 0
 #endif
-int locktorture_runnable = LOCKTORTURE_RUNNABLE_INIT;
-module_param(locktorture_runnable, int, 0444);
-MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at module init");
+int torture_runnable = LOCKTORTURE_RUNNABLE_INIT;
+module_param(torture_runnable, int, 0444);
+MODULE_PARM_DESC(torture_runnable, "Start locktorture at module init");
 
 /* Forward reference. */
 static void lock_torture_cleanup(void);
@@ -355,7 +355,7 @@ static int __init lock_torture_init(void)
 		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
 	};
 
-	if (!torture_init_begin(torture_type, verbose, &locktorture_runnable))
+	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
 		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
-- 
1.8.4.5

