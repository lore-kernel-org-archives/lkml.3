Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3EEOPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 10:15:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3EEOP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 10:15:29 -0400
Date: Sun, 5 May 2013 07:15:18 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-642fb0f86fa38efefc0cf0e46ac20fa03e7f7f01@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <alpine.LFD.2.02.1305032015060.2990@ionos>
References: <alpine.LFD.2.02.1305032015060.2990@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick:
  Use zalloc_cpumask_var for allocating offstack cpumasks
Git-Commit-ID: 642fb0f86fa38efefc0cf0e46ac20fa03e7f7f01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  642fb0f86fa38efefc0cf0e46ac20fa03e7f7f01
Gitweb:     http://git.kernel.org/tip/642fb0f86fa38efefc0cf0e46ac20fa03e7f7f01
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 3 May 2013 20:22:36 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 5 May 2013 16:06:35 +0200

tick: Use zalloc_cpumask_var for allocating offstack cpumasks

commit b352bc1cbc (tick: Convert broadcast cpu bitmaps to
cpumask_var_t) broke CONFIG_CPUMASK_OFFSTACK in a very subtle way.

Instead of allocating the cpumasks with zalloc_cpumask_var it uses
alloc_cpumask_var, so we can get random data there, which of course
confuses the logic completely and causes random failures.

Reported-and-tested-by: Dave Jones <davej@redhat.com>
Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305032015060.2990@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 61d00a8..d70cdc4 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -785,11 +785,11 @@ bool tick_broadcast_oneshot_available(void)
 
 void __init tick_broadcast_init(void)
 {
-	alloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
-	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
 #endif
 }
