Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3HVFkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:40:11 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51847 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3HVFkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:40:06 -0400
Date: Thu, 22 Aug 2013 13:39:56 +0800
From: larmbr <nasa4836@gmail.com>
To: linux-mm@kvack.org
Cc: mgorman@suse.de, riel@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmscan: make global_reclaim() inline
Message-ID: <20130822053956.GA10795@larmbr-lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though Gcc is likely to inline them, we should better
explictly do it manually, and also, this serve to document 
this fact.

Signed-off-by: Zhan Jianyu <nasa4836@gmail.com>
---
mm/vmscan.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1de652d..1946d7d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -135,12 +135,12 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_MEMCG
-static bool global_reclaim(struct scan_control *sc)
+static inline bool global_reclaim(struct scan_control *sc)
 {
 	return !sc->target_mem_cgroup;
 }
 #else
-static bool global_reclaim(struct scan_control *sc)
+static inline bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
