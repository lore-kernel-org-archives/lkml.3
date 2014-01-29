Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaA2O31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:29:27 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38296 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaA2O30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:29:26 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [PATCH] sched: delete is_same_group outside CONFIG_FAIR_GROUP_SCHED
Date: Wed, 29 Jan 2014 14:29:33 +0000
Message-Id: <1391005773-29493-1-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 29 Jan 2014 14:29:23.0390 (UTC) FILETIME=[815165E0:01CF1CFE]
X-MC-Unique: 114012914292304001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0TETWkx020994

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Since is_same_group is only used in group scheduling code, there is
no need to define it outside CONFIG_FAIR_GROUP_SCHED.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e64b0794060e..78b68e89cf77 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -426,12 +426,6 @@ static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	return 1;
-}
-
 static inline struct sched_entity *parent_entity(struct sched_entity *se)
 {
 	return NULL;
-- 
1.7.9.5


