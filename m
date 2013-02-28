Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab3B1OvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:51:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42522 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3B1Ou7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 124/139] sparc64: Fix gfp_flags setting in tsb_grow().
Date: Thu, 28 Feb 2013 14:44:34 +0000
Message-Id: <1362062689-2567-125-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit a55ee1ff751f88252207160087d8197bb7538d4c upstream.

We should "|= more_flags" rather than "= more_flags".

Reported-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/mm/tsb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index c52add7..7c2d9ac 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -331,7 +331,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 retry_tsb_alloc:
 	gfp_flags = GFP_KERNEL;
 	if (new_size > (PAGE_SIZE * 2))
-		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
+		gfp_flags |= __GFP_NOWARN | __GFP_NORETRY;
 
 	new_tsb = kmem_cache_alloc_node(tsb_caches[new_cache_index],
 					gfp_flags, numa_node_id());
-- 
1.8.1.2

