Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3FGHXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:23:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:50709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab3FGHWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:22:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="251855949"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: [patch v8 7/9] math64: add div64_ul macro
Date: Fri,  7 Jun 2013 15:20:50 +0800
Message-Id: <1370589652-24549-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are div64_long() to handle the s64/long division. But no
macro do u64/ul division in kernel.
It is necessary on some scenarios. So add this macro. And fixed
the coding style error.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/math64.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index b8ba855..2913b86 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -6,7 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
-#define div64_long(x,y) div64_s64((x),(y))
+#define div64_long(x, y) div64_s64((x), (y))
+#define div64_ul(x, y)   div64_u64((x), (y))
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -47,7 +48,8 @@ static inline s64 div64_s64(s64 dividend, s64 divisor)
 
 #elif BITS_PER_LONG == 32
 
-#define div64_long(x,y) div_s64((x),(y))
+#define div64_long(x, y) div_s64((x), (y))
+#define div64_ul(x, y)   div_u64((x), (y))
 
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
-- 
1.7.12

