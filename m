Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3F0CPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 22:15:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16527 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3F0CPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 22:15:03 -0400
X-Spam-Score: -100.8
Message-ID: <51CB9FF1.4020308@asianux.com>
Date: Thu, 27 Jun 2013 10:14:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>
CC: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: m32r: include: asm: add generic cmpxchg64() definition
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need define cmpxchg64(), so use generic one.

The related error (with allmodconfig):

  drivers/block/blockconsole.c: In function ‘bcon_advance_console_bytes’:
  drivers/block/blockconsole.c:164:2: error: implicit declaration of function ‘cmpxchg64’ [-Werror=implicit-function-declaration]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/m32r/include/asm/cmpxchg.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/include/asm/cmpxchg.h b/arch/m32r/include/asm/cmpxchg.h
index de651db..a188b03 100644
--- a/arch/m32r/include/asm/cmpxchg.h
+++ b/arch/m32r/include/asm/cmpxchg.h
@@ -217,5 +217,6 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
 	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	    \
 			(unsigned long)(n), sizeof(*(ptr))))
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#define cmpxchg64(ptr, o, n)	cmpxchg64_local((ptr), (o), (n))
 
 #endif /* _ASM_M32R_CMPXCHG_H */
-- 
1.7.7.6
