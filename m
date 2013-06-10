Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3FJK7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:59:48 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44487 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3FJK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:59:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] sched: don't sd->child to NULL when it is already NULL
Date: Mon, 10 Jun 2013 16:27:19 +0530
Message-Id: <f4753a1730051341003ad2ad29a3229c7356678e.1370861520.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory for sd is allocated with kzalloc_node() which will initialize its fields
with zero. In build_sched_domain() we are setting sd->child to child even if
child is NULL, which isn't required.

Lets do it only if child isn't NULL.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5faa748..a12113d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5942,8 +5942,8 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		sd->level = child->level + 1;
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
+		sd->child = child;
 	}
-	sd->child = child;
 	set_domain_attribute(sd, attr);
 
 	return sd;
-- 
1.7.12.rc2.18.g61b472e

