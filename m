Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3AZMSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:18:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3AZMSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:18:32 -0500
Date: Sat, 26 Jan 2013 04:17:57 -0800
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
Message-ID: <tip-38dc3348e36d6cbe6ad51d771e4db948cda5b0e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, pboonstoppel@nvidia.com,
        arnd@arndb.de, tglx@linutronix.de
Reply-To: arnd@arndb.de, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        pboonstoppel@nvidia.com, tglx@linutronix.de
In-Reply-To: <1359123276-15833-6-git-send-email-arnd@arndb.de>
References: <1359123276-15833-6-git-send-email-arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix warning in kernel/sched/fair.c
Git-Commit-ID: 38dc3348e36d6cbe6ad51d771e4db948cda5b0e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 26 Jan 2013 04:18:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38dc3348e36d6cbe6ad51d771e4db948cda5b0e3
Gitweb:     http://git.kernel.org/tip/38dc3348e36d6cbe6ad51d771e4db948cda5b0e3
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Fri, 25 Jan 2013 14:14:22 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 15:23:14 +0100

sched: Fix warning in kernel/sched/fair.c

a4c96ae319 "sched: Unthrottle rt runqueues in
__disable_runtime()" turned the unthrottle_offline_cfs_rqs
function into a static symbol, which now triggers a warning
about it being potentially unused:

  kernel/sched/fair.c:2055:13: warning: 'unthrottle_offline_cfs_rqs' defined but not used [-Wunused-function]

Marking it __maybe_unused shuts up the gcc warning and lets the
compiler safely drop the function body when it's not being used.

To reproduce, build the ARM bcm2835_defconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: linux-arm-kernel@list.infradead.org
Link: http://lkml.kernel.org/r/1359123276-15833-6-git-send-email-arnd@arndb.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..81fa536 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2663,7 +2663,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
