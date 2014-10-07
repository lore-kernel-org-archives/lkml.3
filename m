Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaJGMPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:15:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60314 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaJGMPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:15:22 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v7 7/7] sched: add SD_PREFER_SIBLING for SMT level
Date: Tue,  7 Oct 2014 14:13:37 +0200
Message-Id: <1412684017-16595-8-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the SD_PREFER_SIBLING flag for SMT level in order to ensure that
the scheduler will put at least 1 task per core.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 37fb92c..731f2ad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6165,6 +6165,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	 */
 
 	if (sd->flags & SD_SHARE_CPUCAPACITY) {
+		sd->flags |= SD_PREFER_SIBLING;
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
 
-- 
1.9.1

