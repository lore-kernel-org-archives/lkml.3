Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaAWF4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:56:37 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:40955 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaAWF4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:56:34 -0500
Date: Wed, 22 Jan 2014 21:56:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm, compaction: ignore pageblock skip when manually invoking
 compaction
Message-ID: <alpine.DEB.2.02.1401222154220.7503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cached pageblock hint should be ignored when triggering compaction
through /proc/sys/vm/compact_memory so all eligible memory is isolated.  
Manually invoking compaction is known to be expensive, there's no need to
skip pageblocks based on heuristics (mainly for debugging).

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1177,6 +1177,7 @@ static void compact_node(int nid)
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
+		.ignore_skip_hint = true,
 	};
 
 	__compact_pgdat(NODE_DATA(nid), &cc);
