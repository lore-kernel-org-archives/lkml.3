Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3DVFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:09:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56100 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3DVFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:09:26 -0400
X-Spam-Score: -100.8
Message-ID: <5174C5D9.3060109@asianux.com>
Date: Mon, 22 Apr 2013 13:08:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM64: kernel: compiling issue, define cmpxchg64 and cmpxchg64_local
 for outside using.
References: <51712E5E.2020809@asianux.com> <201304191412.54601.arnd@arndb.de> <5171FD67.2080104@asianux.com> <2182812.ymprEm6XBb@wuerfel>
In-Reply-To: <2182812.ymprEm6XBb@wuerfel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  drivers use cmpxchg64, cmpxchg64_local ... to perform 64-bit operation,
  so they can cross 32-bit and 64-bit platforms (it is a standard way).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/cmpxchg.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h
index 968b5cb..8a8ce0e 100644
--- a/arch/arm64/include/asm/cmpxchg.h
+++ b/arch/arm64/include/asm/cmpxchg.h
@@ -170,4 +170,7 @@ static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
 				       (unsigned long)(n),		\
 				       sizeof(*(ptr))))
 
+#define cmpxchg64(ptr,o,n)		cmpxchg((ptr),(o),(n))
+#define cmpxchg64_local(ptr,o,n)	cmpxchg_local((ptr),(o),(n))
+
 #endif	/* __ASM_CMPXCHG_H */
-- 
1.7.7.6
