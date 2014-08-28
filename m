Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaH1TDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:03:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaH1SgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:23 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 34/97] mm, compaction: ignore pageblock skip when manually invoking compaction
Date: Thu, 28 Aug 2014 19:34:42 +0100
Message-Id: <1409250945-30874-35-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit 91ca9186484809c57303b33778d841cc28f696ed upstream.

The cached pageblock hint should be ignored when triggering compaction
through /proc/sys/vm/compact_memory so all eligible memory is isolated.
Manually invoking compaction is known to be expensive, there's no need
to skip pageblocks based on heuristics (mainly for debugging).

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 4530818..5c17302 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1191,6 +1191,7 @@ static void compact_node(int nid)
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
+		.ignore_skip_hint = true,
 	};
 
 	__compact_pgdat(NODE_DATA(nid), &cc);
-- 
1.8.4.5

