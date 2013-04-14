Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3DNQFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:05:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3DNQFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:05:53 -0400
Date: Sun, 14 Apr 2013 09:05:25 -0700
From: tip-bot for Wei Yongjun <tipbot@zytor.com>
Message-ID: <tip-c481420248c6730246d2a1b1773d5d7007ae0835@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yongjun_wei@trendmicro.com.cn, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yongjun_wei@trendmicro.com.cn, tglx@linutronix.de
In-Reply-To: <CAPgLHd8j_fWcgqe=KLWjpBj+=o0Pw6Z-SEq=NTPU08c2w1tngQ@mail.gmail.com>
References: <CAPgLHd8j_fWcgqe=KLWjpBj+=o0Pw6Z-SEq=NTPU08c2w1tngQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix error return code
Git-Commit-ID: c481420248c6730246d2a1b1773d5d7007ae0835
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 14 Apr 2013 09:05:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c481420248c6730246d2a1b1773d5d7007ae0835
Gitweb:     http://git.kernel.org/tip/c481420248c6730246d2a1b1773d5d7007ae0835
Author:     Wei Yongjun <yongjun_wei@trendmicro.com.cn>
AuthorDate: Fri, 12 Apr 2013 11:05:54 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Apr 2013 06:33:56 +0200

perf: Fix error return code

Fix to return -ENOMEM in the allocation error case instead of 0
(if pmu_bus_running == 1), as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/CAPgLHd8j_fWcgqe%3DKLWjpBj%2B%3Do0Pw6Z-SEq%3DNTPU08c2w1tngQ@mail.gmail.com
[ Tweaked the error code setting placement and the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7f0d67e..7e0962e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5987,6 +5987,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;
