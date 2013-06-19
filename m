Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3FSGdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:33:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42341 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3FSGdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:33:40 -0400
X-AuditID: 9c93016f-b7b6cae000007078-9c-51c150c37d3b
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] slub: do not put a slab to cpu partial list when cpu_partial is 0
Date: Wed, 19 Jun 2013 15:33:55 +0900
Message-Id: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In free path, we don't check number of cpu_partial, so one slab can
be linked in cpu partial list even if cpu_partial is 0. To prevent this,
we should check number of cpu_partial in put_cpu_partial().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slub.c b/mm/slub.c
index 57707f0..7033b4f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1955,6 +1955,9 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 	int pages;
 	int pobjects;
 
+	if (!s->cpu_partial)
+		return;
+
 	do {
 		pages = 0;
 		pobjects = 0;
-- 
1.7.9.5

