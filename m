Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbaISPa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:30:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:60855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbaISPax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437175"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3/7] atomic: Silence nested-externs warnings
Date: Fri, 19 Sep 2014 08:29:36 -0700
Message-Id: <1411140580-20909-4-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Silence the nested-externs warnings for these, as they are
truly wanted.

CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/atomic.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index fef3a80..81c7ad4 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -7,6 +7,7 @@
  * Provide __deprecated wrappers for the new interface, avoid flag day changes.
  * We need the ugly external functions to break header recursion hell.
  */
+DIAG_PUSH DIAG_IGNORE(nested-externs)
 #ifndef smp_mb__before_atomic_inc
 static inline void __deprecated smp_mb__before_atomic_inc(void)
 {
@@ -38,6 +39,7 @@ static inline void __deprecated smp_mb__after_atomic_dec(void)
 	__smp_mb__after_atomic();
 }
 #endif
+DIAG_POP
 
 /**
  * atomic_add_unless - add unless the number is already a given value
-- 
1.9.3

