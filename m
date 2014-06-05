Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaFEWJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:09:51 -0400
Received: from mxip6-inbound.gatech.edu ([130.207.182.15]:41567 "EHLO
	mxip6-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEWJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:09:49 -0400
X-RemoteIP: 130.207.185.161
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 89226128
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.98,983,1392181200"; 
   d="scan'208";a="89226128"
X-GT-Spam-Rating: (0%)
Message-ID: <5390EAAC.5070601@gatech.edu>
Date: Thu, 05 Jun 2014 18:09:48 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: arnd@arndb.de
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] define generic version of cmpxchg{64} only if not, previously
 defined
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define generic versions of cmpxchg{64} only if not previously defined.

This makes these definition in-line to other definitions of generic versions


Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/asm-generic/cmpxchg.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/cmpxchg.h b/include/asm-generic/cmpxchg.h
index 811fb1e..7154b79 100644
--- a/include/asm-generic/cmpxchg.h
+++ b/include/asm-generic/cmpxchg.h
@@ -102,7 +102,12 @@ unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 #endif
 
+#ifndef cmpxchg
 #define cmpxchg(ptr, o, n)	cmpxchg_local((ptr), (o), (n))
+#endif
+
+#ifndef cmpxchg64
 #define cmpxchg64(ptr, o, n)	cmpxchg64_local((ptr), (o), (n))
+#endif
 
 #endif /* __ASM_GENERIC_CMPXCHG_H */
-- 
1.7.9.5
