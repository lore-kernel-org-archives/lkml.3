Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbaELOo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:44:57 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33167 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432AbaELOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:44:56 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: jet.chen@intel.com
Cc: mingo@kernel.org, fengguang.wu@intel.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [sched] BUG: unable to handle kernel paging request at 093cd001
Date: Mon, 12 May 2014 16:43:40 +0200
Message-Id: <1399905820-16943-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <5370DC83.3030406@intel.com>
References: <5370DC83.3030406@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry the previous patch, that i sent, becomes wrong after optimizing it
Could you please try this one ?

Regards,
Vincent
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f..205fa17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6234,7 +6234,7 @@ static void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + level) *
+	tl = kzalloc((i + level + 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
-- 
1.9.1

