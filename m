Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3BGMLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:11:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3BGMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:11:48 -0500
Date: Thu, 7 Feb 2013 04:11:25 -0800
From: tip-bot for Daniel Baluta <dbaluta@ixiacom.com>
Message-ID: <tip-e97cbe3edf7d88aad4c21dd3de124d9f9d039881@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dbaluta@ixiacom.com, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, dbaluta@ixiacom.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1360186160-7566-1-git-send-email-dbaluta@ixiacom.com>
References: <1360186160-7566-1-git-send-email-dbaluta@ixiacom.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/hwbp: Fix cleanup in case of kzalloc()
  failure
Git-Commit-ID: e97cbe3edf7d88aad4c21dd3de124d9f9d039881
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 07 Feb 2013 04:11:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e97cbe3edf7d88aad4c21dd3de124d9f9d039881
Gitweb:     http://git.kernel.org/tip/e97cbe3edf7d88aad4c21dd3de124d9f9d039881
Author:     Daniel Baluta <dbaluta@ixiacom.com>
AuthorDate: Wed, 6 Feb 2013 23:29:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 7 Feb 2013 11:52:19 +0100

perf/hwbp: Fix cleanup in case of kzalloc() failure

Obviously this is a typo and could result in memory leaks
if kzalloc fails on a given cpu.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/1360186160-7566-1-git-send-email-dbaluta@ixiacom.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index fe8a916..a64f8ae 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -676,7 +676,7 @@ int __init init_hw_breakpoint(void)
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
 		for (i = 0; i < TYPE_MAX; i++)
-			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
+			kfree(per_cpu(nr_task_bp_pinned[i], err_cpu));
 		if (err_cpu == cpu)
 			break;
 	}
