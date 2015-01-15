Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbbAOKM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:12:58 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:38158 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbbAOKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:12:55 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH RESEND v9 09/10] sched: add SD_PREFER_SIBLING for SMT level
Date: Thu, 15 Jan 2015 11:09:29 +0100
Message-Id: <1421316570-23097-10-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
References: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
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

