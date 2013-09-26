Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3IZPNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:13:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53932 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab3IZPNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:13:46 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 3/4] ia64: cmpxchg: implement dummy cmpxchg64_relaxed operation
Date: Thu, 26 Sep 2013 16:13:30 +0100
Message-Id: <1380208411-31403-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
References: <1380208411-31403-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmpxchg64_relaxed can be used to provide barrier-less semantics for a
64-bit cmpxchg operation in cases where the strong memory ordering is
not required. A useful use-case for this is in the recently merged
lockless lockref code.

This patch implements a dummy implementation for ia64, which could
probably be improved by removing the half barrier associated with the
default cmpxchg64 macro.

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/ia64/include/uapi/asm/cmpxchg.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/uapi/asm/cmpxchg.h b/arch/ia64/include/uapi/asm/cmpxchg.h
index 4f37dbb..8984b6e 100644
--- a/arch/ia64/include/uapi/asm/cmpxchg.h
+++ b/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -124,6 +124,7 @@ extern long ia64_cmpxchg_called_with_bad_pointer(void);
 
 #define cmpxchg_local		cmpxchg
 #define cmpxchg64_local		cmpxchg64
+#define cmpxchg64_relaxed	cmpxchg64
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;
-- 
1.8.2.2

