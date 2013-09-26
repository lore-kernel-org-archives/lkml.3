Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3IZPOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:14:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53943 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab3IZPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:13:58 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        <x86@kernel.org>
Subject: [RFC PATCH 2/4] x86: cmpxchg: implement dummy cmpxchg64_relaxed operation
Date: Thu, 26 Sep 2013 16:13:29 +0100
Message-Id: <1380208411-31403-2-git-send-email-will.deacon@arm.com>
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

This patch implements a dummy implementation for x86, since the memory
ordering issues aren't a concern for this architecture.

Cc: <x86@kernel.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/x86/include/asm/cmpxchg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index d47786a..aacb99a0 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -152,6 +152,9 @@ extern void __add_wrong_size(void)
 
 #define cmpxchg_local(ptr, old, new)					\
 	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
+
+#define cmpxchg64_relaxed(ptr, old, new)				\
+	cmpxchg64(ptr, old, new)
 #endif
 
 /*
-- 
1.8.2.2

