Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaKDQU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:20:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbaKDQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:20:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/9] watchdog: move definition of 'watchdog_proc_mutex' outside of proc_dowatchdog()
Date: Tue,  4 Nov 2014 11:20:18 -0500
Message-Id: <1415118024-194247-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

This series removes the proc_dowatchdog() function. Since multiple
new functions need the 'watchdog_proc_mutex' to serialize access to
the watchdog parameters in /proc/sys/kernel, move the mutex outside
of any function.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dcf28b2..df4ef38 100644
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
1.7.1

