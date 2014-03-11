Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaCKHbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:31:07 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54923 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaCKHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:31:05 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jkc@redhat.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: remove incorrect error handling after queue_delayed_work
Date: Tue, 11 Mar 2014 00:31:03 -0700 (PDT)
Message-ID: <21793673.iBPaGf0kxn@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The queue_delayed_work() return false if the work is
already on the queue, true otherwise.
So return value cannot be less than zero.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 .../unisys/visorchipset/visorchipset_main.c        |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 400cb03..0dff759 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -2055,11 +2055,8 @@ Away:
 		}
 	}
 
-	if (queue_delayed_work(Periodic_controlvm_workqueue,
-			       &Periodic_controlvm_work, Poll_jiffies) < 0) {
-		LOGERR("queue_delayed_work failed!");
-		POSTCODE_LINUX_2(QUEUE_DELAYED_WORK_PC, POSTCODE_SEVERITY_ERR);
-	}
+	queue_delayed_work(Periodic_controlvm_workqueue,
+			   &Periodic_controlvm_work, Poll_jiffies);
 }
 
 static void
@@ -2193,11 +2190,8 @@ Away:
 
 	Poll_jiffies = POLLJIFFIES_CONTROLVMCHANNEL_SLOW;
 
-	if (queue_delayed_work(Periodic_controlvm_workqueue,
-			       &Periodic_controlvm_work, Poll_jiffies) < 0) {
-		LOGERR("queue_delayed_work failed!");
-		POSTCODE_LINUX_2(QUEUE_DELAYED_WORK_PC, POSTCODE_SEVERITY_ERR);
-	}
+	queue_delayed_work(Periodic_controlvm_workqueue,
+			   &Periodic_controlvm_work, Poll_jiffies);
 }
 
 static void
-- 
1.7.4.4


