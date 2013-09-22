Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3IVElw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 00:41:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15336 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3IVElv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 00:41:51 -0400
X-Spam-Score: -100.9
Message-ID: <523E74CE.9010904@asianux.com>
Date: Sun, 22 Sep 2013 12:40:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: include: asm: add generic cmpxchg64(), cmpxchg64_local(),
 and cmpxchg_local() in cmpxchg.h
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of sub-systems may need cmpxchg64() or another cmpxchg*local()
functions, need implement them, or can not pass compiling.

The related error (allmodconfig for arc):

    CC      drivers/block/blockconsole.o
  drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
  drivers/block/blockconsole.c:164: error: implicit declaration of function ‘cmpxchg64’


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/cmpxchg.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arc/include/asm/cmpxchg.h b/arch/arc/include/asm/cmpxchg.h
index 03cd689..db251f3 100644
--- a/arch/arc/include/asm/cmpxchg.h
+++ b/arch/arc/include/asm/cmpxchg.h
@@ -140,4 +140,17 @@ static inline unsigned long __xchg(unsigned long val, volatile void *ptr,
  */
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)                                               \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#define cmpxchg64(ptr, o, n)    cmpxchg64_local((ptr), (o), (n))
+
+
 #endif
-- 
1.7.7.6
