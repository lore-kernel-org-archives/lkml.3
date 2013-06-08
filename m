Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3FHGbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 02:31:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36452 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3FHGbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 02:31:06 -0400
X-Spam-Score: -100.8
Message-ID: <51B2CF75.1090207@asianux.com>
Date: Sat, 08 Jun 2013 14:30:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, shli@fusionio.com,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: x86: include: asm: need 'unsigned' type cast for atomic_clear_mask()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


atomic_set_mask() has already have 'unsigned' type case, and
atomic_clear_mask() is the pair of atomic_set_mask().

So it also need 'unsigned' type case.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/x86/include/asm/atomic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 722aa3b..5b5cf52 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -255,7 +255,7 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+		     : : "r" (~(unsigned)(mask)), "m" (*(addr)) : "memory")
 
 #define atomic_set_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "orl %0,%1"			\
-- 
1.7.7.6
