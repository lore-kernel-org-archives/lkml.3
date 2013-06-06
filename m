Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FFNaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:30:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:22976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3FFNaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:30:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="scan'208";a="349215595"
From: Alex Shi <alex.shi@intel.com>
To: akpm@linux-foundation.org
Cc: sgruszka@redhat.com, fweisbec@gmail.com, alex.shi@intel.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] math64: add div64_ul
Date: Thu,  6 Jun 2013 21:30:09 +0800
Message-Id: <1370525409-17123-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are div64_long() to handle the s64/long division. But no
micro do u64/ul division in kernel.
It is necessary on some scenarios. So add this function.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/math64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index b8ba855..f0afe9c 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -7,6 +7,7 @@
 #if BITS_PER_LONG == 64
 
 #define div64_long(x,y) div64_s64((x),(y))
+#define div64_ul(x,y)   div64_u64((x),(y))
 
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
@@ -48,6 +49,7 @@ static inline s64 div64_s64(s64 dividend, s64 divisor)
 #elif BITS_PER_LONG == 32
 
 #define div64_long(x,y) div_s64((x),(y))
+#define div64_ul(x,y)   div_u64((x),(y))
 
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
-- 
1.7.5.4

