Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaDGJyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:54:23 -0400
Received: from relay.parallels.com ([195.214.232.42]:47167 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDGJyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:54:16 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH TRIVIAL] memcg: un-export __memcg_kmem_get_cache
Date: Mon, 7 Apr 2014 13:54:14 +0400
Message-ID: <1396864454-22116-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used in slab and should not be used anywhere else so there is
no need in exporting it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b4b6aef562fa..874594f57c90 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3504,7 +3504,6 @@ out:
 	rcu_read_unlock();
 	return cachep;
 }
-EXPORT_SYMBOL(__memcg_kmem_get_cache);
 
 /*
  * We need to verify if the allocation against current->mm->owner's memcg is
-- 
1.7.10.4

