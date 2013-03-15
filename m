Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3COQvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:51:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3COQvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:51:46 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880048"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Robin Holt <holt@sgi.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-mm@kvack.org
Subject: [PATCH 3/9] mmu_notifier: use DEFINE_STATIC_SRCU() to define srcu struct
Date: Sat, 16 Mar 2013 00:50:51 +0800
Message-Id: <1363366257-4886-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:26,
	Serialize complete at 2013/03/16 00:50:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_STATIC_SRCU() defines srcu struct and do init at build time.
also remove unneeded mmu_notifier_init().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/mmu_notifier.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index be04122..aa7c785 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 
 /* global SRCU for all MMs */
-static struct srcu_struct srcu;
+DEFINE_STATIC_SRCU(srcu);
 
 /*
  * This function can't run concurrently against mmu_notifier_register
@@ -326,9 +326,3 @@ void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_unregister);
 
-static int __init mmu_notifier_init(void)
-{
-	return init_srcu_struct(&srcu);
-}
-
-module_init(mmu_notifier_init);
-- 
1.7.4.4

