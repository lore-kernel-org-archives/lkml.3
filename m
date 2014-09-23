Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaIWQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:09:56 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34239 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaIWQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:09:41 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v6 6/6] sched: add SD_PREFER_SIBLING for SMT level
Date: Tue, 23 Sep 2014 18:08:05 +0200
Message-Id: <1411488485-10025-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the SD_PREFER_SIBLING flag for SMT level in order to ensure that
the scheduler will put at least 1 task per core.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7c8ac4..f72663e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6134,6 +6134,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	 */
 
 	if (sd->flags & SD_SHARE_CPUCAPACITY) {
+		sd->flags |= SD_PREFER_SIBLING;
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
 
-- 
1.9.1

