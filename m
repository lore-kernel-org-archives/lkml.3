Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850Ab3CWBZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:25:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422733Ab3CWBZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338468"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/29] tsx: Add generic noop macros for RTM intrinsics
Date: Fri, 22 Mar 2013 18:24:55 -0700
Message-Id: <1364001923-10796-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add generic noop macros (act like transaction aborted) for RTM.
The main use case is an occasional _xtest() added to generic
code, without needing ifdefs. On x86+RTM this will use
real TSX instructions.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/rtm.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/rtm.h

diff --git a/include/linux/rtm.h b/include/linux/rtm.h
new file mode 100644
index 0000000..887b221
--- /dev/null
+++ b/include/linux/rtm.h
@@ -0,0 +1,15 @@
+#ifndef _LINUX_RTM
+#define _LINUX_RTM 1
+
+#ifdef CONFIG_RTM_LOCKS
+#include <asm/rtm.h>
+#else
+/* Make transactions appear as always abort */
+#define _XBEGIN_STARTED 0
+#define _xbegin() 1
+#define _xtest()  0
+#define _xend()   do {} while (0)
+#define _xabort(x) do {} while (0)
+#endif
+
+#endif
-- 
1.7.7.6

