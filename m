Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab3EJMNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:13:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:21342 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3EJMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:13:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="300434842"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/11] sched: msleep: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:20 +0300
Message-Id: <1368188011-23661-2-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index dbf7a78..dcdc8bd 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1799,7 +1799,7 @@ void __init init_timers(void)
  */
 void msleep(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	unsigned long timeout = msecs_to_jiffies_min(msecs);
 
 	while (timeout)
 		timeout = schedule_timeout_uninterruptible(timeout);
@@ -1813,7 +1813,7 @@ EXPORT_SYMBOL(msleep);
  */
 unsigned long msleep_interruptible(unsigned int msecs)
 {
-	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
+	unsigned long timeout = msecs_to_jiffies_min(msecs);
 
 	while (timeout && !signal_pending(current))
 		timeout = schedule_timeout_interruptible(timeout);
-- 
1.7.10.4

