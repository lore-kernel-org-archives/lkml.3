Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3ENOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:48:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:52878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab3ENOsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="313414969"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 2/8] sched: msleep: take msecs_to_jiffies_timeout into use
Date: Tue, 14 May 2013 17:48:32 +0300
Message-Id: <1368542918-8861-3-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_timeout instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a860bba..f397d3b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1660,7 +1660,7 @@ void __init init_timers(void)
  */
 void msleep(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	unsigned long timeout = msecs_to_jiffies_timeout(msecs);
 
 	while (timeout)
 		timeout = schedule_timeout_uninterruptible(timeout);
@@ -1674,7 +1674,7 @@ EXPORT_SYMBOL(msleep);
  */
 unsigned long msleep_interruptible(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	unsigned long timeout = msecs_to_jiffies_timeout(msecs);
 
 	while (timeout && !signal_pending(current))
 		timeout = schedule_timeout_interruptible(timeout);
-- 
1.7.10.4

