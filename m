Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3FSSlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866Ab3FSSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:07 -0400
Date: Wed, 19 Jun 2013 11:40:36 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-c75e01288ce9c9a6b7beb6b23c07d2e4d1db8c84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <f4753a1730051341003ad2ad29a3229c7356678e.1370861520.git.viresh.kumar@linaro.org>
References: <f4753a1730051341003ad2ad29a3229c7356678e.1370861520.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don't set sd->
 child to NULL when it is already NULL
Git-Commit-ID: c75e01288ce9c9a6b7beb6b23c07d2e4d1db8c84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:40:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c75e01288ce9c9a6b7beb6b23c07d2e4d1db8c84
Gitweb:     http://git.kernel.org/tip/c75e01288ce9c9a6b7beb6b23c07d2e4d1db8c84
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon, 10 Jun 2013 16:27:19 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:45 +0200

sched: Don't set sd->child to NULL when it is already NULL

Memory for sd is allocated with kzalloc_node() which will initialize its fields
with zero. In build_sched_domain() we are setting sd->child to child even if
child is NULL, which isn't required.

Lets do it only if child isn't NULL.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/f4753a1730051341003ad2ad29a3229c7356678e.1370861520.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3de6264..88c2c0e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5955,8 +5955,8 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		sd->level = child->level + 1;
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
+		sd->child = child;
 	}
-	sd->child = child;
 	set_domain_attribute(sd, attr);
 
 	return sd;
