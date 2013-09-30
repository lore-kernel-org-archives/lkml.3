Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab3I3U3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:29:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab3I3U3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029767"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/11] Disable initialized_var for clang
Date: Mon, 30 Sep 2013 13:29:03 -0700
Message-Id: <1380572952-30729-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LLVM clang doesn't understand uninitialized_var and always throws a
warning. Disable the macro for this case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/compiler-gcc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 24545cd..fa93722 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -110,6 +110,10 @@
  * A trick to suppress uninitialized variable warning without generating any
  * code
  */
+#ifdef __clang__
+#define uninitialized_var(x) x
+#else
 #define uninitialized_var(x) x = x
+#endif
 
 #define __always_inline		inline __attribute__((always_inline))
-- 
1.8.3.1

