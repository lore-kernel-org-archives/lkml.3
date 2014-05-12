Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaELJxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:53:09 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:53328 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaELJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:53:05 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: jet.chen@intel.com
Cc: mingo@kernel.org, fengguang.wu@intel.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: RE: [sched] BUG: unable to handle kernel paging request at 093cd001
Date: Mon, 12 May 2014 11:52:04 +0200
Message-Id: <1399888324-2007-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <53708067.7050700@intel.com>
References: <53708067.7050700@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does this patch solve your issue ?

A null line is missing at the end of the array for NUMA case.
My test was passed thanks to a null data after the allocated array 

regards,
Vincent
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f..941da33 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6232,7 +6232,7 @@ static void sched_init_numa(void)
 	}
 
 	/* Compute default topology size */
-	for (i = 0; sched_domain_topology[i].mask; i++);
+	for (i = 1; sched_domain_topology[i].mask; i++);
 
 	tl = kzalloc((i + level) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
-- 
1.9.1

