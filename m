Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3JJCdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:33:01 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6482 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3JJCc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:32:59 -0400
X-Spam-Score: -100.8
Message-ID: <5256117A.4000009@asianux.com>
Date: Thu, 10 Oct 2013 10:31:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] s390: include: asm: atomic.h: use 'unsigned int' instead
 of 'unsigned long' for atomic_*_mask()
References: <52561137.3070608@asianux.com>
In-Reply-To: <52561137.3070608@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type of 'v->counter' is always 'int', and related inline assembly
code also process 'int', so use 'unsigned int' instead of 'unsigned
long' for the 'mask'.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/s390/include/asm/atomic.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index a62ed2d..12c5ec1 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -113,12 +113,12 @@ static inline void atomic_add(int i, atomic_t *v)
 #define atomic_dec_return(_v)		atomic_sub_return(1, _v)
 #define atomic_dec_and_test(_v)		(atomic_sub_return(1, _v) == 0)
 
-static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
 	__ATOMIC_LOOP(v, ~mask, __ATOMIC_AND);
 }
 
-static inline void atomic_set_mask(unsigned long mask, atomic_t *v)
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 {
 	__ATOMIC_LOOP(v, mask, __ATOMIC_OR);
 }
-- 
1.7.7.6
