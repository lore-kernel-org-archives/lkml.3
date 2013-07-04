Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3GDFgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:36:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:24897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab3GDFgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="360319196"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, hpa@linux.intel.com, tim.c.chen@linux.intel.com
Cc: linux-kernel@vger.kernel.org, andi.kleen@intel.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu
Subject: [PATCH 1/3] clocksource: clean up clocksource_select
Date: Thu,  4 Jul 2013 13:34:14 +0800
Message-Id: <1372916056-24301-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After clocksource_find_best() introduced, it is impossible to get into
some code path. so clean them up.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/time/clocksource.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e713ef7..021c159 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -582,26 +582,12 @@ static void __clocksource_select(bool skipcur)
 	if (!best)
 		return;
 
-	/* Check for the override clocksource. */
 	list_for_each_entry(cs, &clocksource_list, list) {
 		if (skipcur && cs == curr_clocksource)
 			continue;
 		if (strcmp(cs->name, override_name) != 0)
 			continue;
-		/*
-		 * Check to make sure we don't switch to a non-highres
-		 * capable clocksource if the tick code is in oneshot
-		 * mode (highres or nohz)
-		 */
-		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) && oneshot) {
-			/* Override clocksource cannot be used. */
-			printk(KERN_WARNING "Override clocksource %s is not "
-			       "HRT compatible. Cannot switch while in "
-			       "HRT/NOHZ mode\n", cs->name);
-			override_name[0] = 0;
-		} else
-			/* Override clocksource can be used. */
-			best = cs;
+		best = cs;
 		break;
 	}
 
-- 
1.7.12

