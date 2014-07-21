Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaGUXay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:30:54 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35726 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaGUXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:30:53 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: arnd@arndb.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: [PATCH] cleanup include/asm-generic/atomic.h
Date: Tue, 22 Jul 2014 05:00:37 +0530
Message-Id: <1405985437-16631-1-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072123-2000-0000-0000-0000012DF776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4b358e2206 "cleanup include/asm-generic/atomic.h" added
comments for #else/#endif, but ended up adding same comment
"BITS_PER_LONG == 64" on both sides. This patch fixes it.

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 include/asm-generic/atomic-long.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
index b7babf0..a8434c6 100644
--- a/include/asm-generic/atomic-long.h
+++ b/include/asm-generic/atomic-long.h
@@ -253,6 +253,6 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
 #define atomic_long_xchg(v, new) \
 	(atomic_xchg((atomic_t *)(v), (new)))
 
-#endif  /*  BITS_PER_LONG == 64  */
+#endif  /*  BITS_PER_LONG != 64  */
 
 #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
-- 
1.7.11.4

