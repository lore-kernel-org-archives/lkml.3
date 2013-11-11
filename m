Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3KKINb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:13:31 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41677 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KKINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:13:24 -0500
X-AuditID: 85900ec0-d312bb9000001514-2e-528091a1c3eb
Subject: [PATCH] timer: Add __sched to msleep() and msleep_interruptible()
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com
Date: Mon, 11 Nov 2013 17:18:15 +0900
Message-ID: <20131111081815.20618.79098.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __sched to msleep() and msleep_interruptible() for avoiding to show
these functions in WCHAN. If a driver calls msleep() or msleep_interruptible()
in a lot of places, users cannot understand that the driver might sleep which
functions execute msleep() or msleep_interruptible(). So, by applying this
patch, users can confirm the function calling msleep() or msleep_interruptible()
from WCHAN.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
---
 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6582b82..cc1470f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1660,7 +1660,7 @@ void __init init_timers(void)
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for
  */
-void msleep(unsigned int msecs)
+void __sched msleep(unsigned int msecs)
 {
 	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
 
@@ -1674,7 +1674,7 @@ EXPORT_SYMBOL(msleep);
  * msleep_interruptible - sleep waiting for signals
  * @msecs: Time in milliseconds to sleep for
  */
-unsigned long msleep_interruptible(unsigned int msecs)
+unsigned long __sched msleep_interruptible(unsigned int msecs)
 {
 	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
 

