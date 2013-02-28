Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3B1FZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:25:37 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:53302 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3B1FZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:25:33 -0500
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/2] mempolicy: fix typo
Date: Thu, 28 Feb 2013 00:25:07 -0500
Message-Id: <1362029107-3908-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
References: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, n_new is wrongly initialized. start and end parameter
are inverted. Let's fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 868d08f..7431001 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2390,7 +2390,7 @@ static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 
 				*mpol_new = *n->policy;
 				atomic_set(&mpol_new->refcnt, 1);
-				sp_node_init(n_new, n->end, end, mpol_new);
+				sp_node_init(n_new, end, n->end, mpol_new);
 				n->end = start;
 				sp_insert(sp, n_new);
 				n_new = NULL;
-- 
1.7.1

