Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaISPa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:30:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:47066 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741AbaISPax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437203"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Brian Norris <computersforpeace@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4/7] bitops: Silence nested-externs warnings
Date: Fri, 19 Sep 2014 08:29:37 -0700
Message-Id: <1411140580-20909-5-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Use the diagnostic control macros to ignore nested-externs warnings
in these caes.

CC: Ingo Molnar <mingo@kernel.org>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/bitops.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index cbc5833..0e072bd 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -36,6 +36,7 @@ extern unsigned long __sw_hweight64(__u64 w);
  * Provide __deprecated wrappers for the new interface, avoid flag day changes.
  * We need the ugly external functions to break header recursion hell.
  */
+DIAG_PUSH DIAG_IGNORE(nested-externs)
 #ifndef smp_mb__before_clear_bit
 static inline void __deprecated smp_mb__before_clear_bit(void)
 {
@@ -51,6 +52,7 @@ static inline void __deprecated smp_mb__after_clear_bit(void)
 	__smp_mb__after_atomic();
 }
 #endif
+DIAG_POP
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
-- 
1.9.3

