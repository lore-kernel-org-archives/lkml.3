Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaFXTPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaFXTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:15:11 -0400
Date: Tue, 24 Jun 2014 15:14:54 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.com, mgorman@suse.de,
        mingo@kernel.org
Subject: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
Message-ID: <20140624151454.2a05082e@annuminas.surriel.com>
In-Reply-To: <1403538095-31256-1-git-send-email-riel@redhat.com>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function effective_load already makes the calculations that
task_h_load makes. Making them twice can throw off the calculations,
and is generally a bad idea.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1aaa3b4..318a275 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1227,7 +1227,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	dst_load = env->dst_stats.load;
 
 	/* Calculate the effect of moving env->p from src to dst. */
-	load = task_h_load(env->p);
+	load = env->p->se.load.weight;
 	tg = task_group(env->p);
 	src_load += effective_load(tg, env->src_cpu, -load, -load);
 	dst_load += effective_load(tg, env->dst_cpu, load, load);
@@ -1251,7 +1251,7 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (cur) {
 		/* Cur moves in the opposite direction. */
-		load = task_h_load(cur);
+		load = cur->se.load.weight;
 		tg = task_group(cur);
 		src_load += effective_load(tg, env->src_cpu, load, load);
 		dst_load += effective_load(tg, env->dst_cpu, -load, -load);
