Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaJQRAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:00:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaJQRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:00:00 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 3/9] watchdog: move definition of 'watchdog_proc_mutex' outside of proc_dowatchdog()
Date: Fri, 17 Oct 2014 19:06:22 +0200
Message-Id: <1413565588-4144-4-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
References: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes the proc_dowatchdog() function. Since multiple
new functions need the 'watchdog_proc_mutex' to serialize access to
the watchdog parameters in /proc/sys/kernel, move the mutex outside
of any function.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 kernel/watchdog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index da16a50..daf3b23 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -701,6 +701,8 @@ static int proc_watchdog_update(void)
 
 }
 
+static DEFINE_MUTEX(watchdog_proc_mutex);
+
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
@@ -710,7 +712,6 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 {
 	int err, old_thresh, old_enabled;
 	bool old_hardlockup;
-	static DEFINE_MUTEX(watchdog_proc_mutex);
 
 	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
-- 
1.7.11.7

