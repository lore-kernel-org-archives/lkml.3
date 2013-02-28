Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137Ab3B1FZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:25:33 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:57343 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3B1FZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:25:32 -0500
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/2] mempolicy: fix wrong sp_node insertion
Date: Thu, 28 Feb 2013 00:25:06 -0500
Message-Id: <1362029107-3908-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
References: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

From: Hillf Danton <dhillf@gmail.com>

n->end is accessed in sp_insert(). Thus it should be update
before calling sp_insert(). This mistake may make kernel panic.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 31d2663..868d08f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2391,8 +2391,8 @@ static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 				*mpol_new = *n->policy;
 				atomic_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, n->end, end, mpol_new);
-				sp_insert(sp, n_new);
 				n->end = start;
+				sp_insert(sp, n_new);
 				n_new = NULL;
 				mpol_new = NULL;
 				break;
-- 
1.7.1

