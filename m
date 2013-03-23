Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422897Ab3CWBZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:25:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422814Ab3CWBZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338469"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/29] tsx: Add generic disable_txn macros
Date: Fri, 22 Mar 2013 18:24:57 -0700
Message-Id: <1364001923-10796-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add generic macros to disable transactions per process.
Without TSX (or other HTM) support this is a noop.
An RTM enabled x86 kernel uses its own version.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/thread_info.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e7e0473..5a4bec0 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -148,6 +148,12 @@ static inline bool test_and_clear_restore_sigmask(void)
 #error "no set_restore_sigmask() provided and default one won't work"
 #endif
 
+#ifndef CONFIG_RTM_LOCKS
+#define disable_txn() do {} while (0)
+#define reenable_txn() do {} while (0)
+#define txn_disabled() 0
+#endif
+
 #endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
-- 
1.7.7.6

