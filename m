Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955Ab3ICWBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:01:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:4258 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab3ICWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1016,1367996400"; 
   d="scan'208";a="290438463"
From: "Luck, Tony" <tony.luck@intel.com>
Date: Tue, 3 Sep 2013 14:49:49 -0700
Subject: [PATCH] lockref: Relax in cmpxchg loop
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-Id: <0129530@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we are likley to succeed and break out of this loop, it isn't
guaranteed.  We should be power and thread friendly if we do have to
go around for a second (or third, or more) attempt.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/lib/lockref.c b/lib/lockref.c
index 7819c2d..9d76f40 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -19,6 +19,7 @@
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
+		cpu_relax();							\
 	}									\
 } while (0)
 
-- 
1.8.1.4

