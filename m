Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab3CTSDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:03:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:41657 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab3CTSDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:03:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/5] x86-64: remove dead debugging code for !pse setups
Date: Wed, 20 Mar 2013 14:03:30 -0400
Message-Id: <1363802612-32127-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
References: <1363802612-32127-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to maintain addr_end and p_end when they are never actually
read anywhere on !pse setups.  Remove the dead code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/mm/init_64.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7dd132c..1acba7e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1312,9 +1312,6 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 
 			if (!p)
 				return -ENOMEM;
-
-			addr_end = addr + PAGE_SIZE;
-			p_end = p + PAGE_SIZE;
 		} else {
 			next = pmd_addr_end(addr, end);
 
-- 
1.7.11.7

