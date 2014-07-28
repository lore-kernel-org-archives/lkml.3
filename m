Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaG1SQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:16:50 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45846 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaG1SQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:16:49 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, vincent.guittot@linaro.org, mikey@neuling.org,
        mingo@kernel.org, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: [PATCH 0/2] load balancing fixes
Date: Mon, 28 Jul 2014 14:16:26 -0400
Message-Id: <1406571388-3227-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently update_sd_pick_busiest only identifies the busiest sd
that is either overloaded, or has a group imbalance. When no
sd is imbalanced or overloaded, the load balancer fails to find
the busiest domain.

This breaks load balancing between domains that are not overloaded,
in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
return true when the busiest sd yet is encountered.

Groups are ranked in the order overloaded > imbalanced > other,
with higher ranked groups getting priority even when their load
is lower. This is necessary due to the possibility of unequal
capacities and cpumasks between domains within a sched group.

Calculate_imbalance knows how to deal with the situation where
a less loaded group is picked, but will only do so when
sgs->group_imb is set.  This handling needs to be extended to
all situations where the busiest load is below the average load.


