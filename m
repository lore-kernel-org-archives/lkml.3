Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3CNTbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:31:00 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:34411 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3CNTa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:30:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] m68k: Add missing cmpxchg64() if CONFIG_RMW_INSNS=y
Date: Thu, 14 Mar 2013 20:30:49 +0100
Message-Id: <1363289449-16116-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_RMW_INSNS=y:

drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
drivers/block/blockconsole.c:164: error: implicit declaration of function ‘cmpxchg64’

Map cmpxchg64 to cmpxchg64_local, which is already mapped to
__cmpxchg64_local_generic, just like for the CONFIG_RMW_INSNS=n case.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8398995/

 arch/m68k/include/asm/cmpxchg.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/include/asm/cmpxchg.h b/arch/m68k/include/asm/cmpxchg.h
index 5c81d0e..bc755bc 100644
--- a/arch/m68k/include/asm/cmpxchg.h
+++ b/arch/m68k/include/asm/cmpxchg.h
@@ -124,6 +124,9 @@ static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
 #define cmpxchg_local(ptr, o, n)					    \
 	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
 			(unsigned long)(n), sizeof(*(ptr))))
+
+#define cmpxchg64(ptr, o, n)	cmpxchg64_local((ptr), (o), (n))
+
 #else
 
 /*
-- 
1.7.0.4

