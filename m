Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3CWJjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 05:39:51 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:52242 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3CWJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 05:39:49 -0400
Date: Sat, 23 Mar 2013 10:39:42 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 27/34] s390: Use generic idle loop
Message-ID: <20130323093942.GD3530@osiris>
References: <20130321214930.752934102@linutronix.de>
 <20130321215235.090816526@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321215235.090816526@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032309-1948-0000-0000-000004A272DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:53:18PM -0000, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/kernel/process.c |   25 +++++++------------------
>  arch/s390/kernel/smp.c     |    3 +--
>  2 files changed, 8 insertions(+), 20 deletions(-)

FWIW, the patch below is also needed to fix a compile error.
I'll take care it gets upstream independently of your work.

>From 10c8cd5139f9a18cd6e955793ae7ad0877b5dd86 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sat, 23 Mar 2013 10:29:01 +0100
Subject: [PATCH 2/2] s390/mm: provide emtpy check_pgt_cache() function

All architectures need to provide a check_pgt_cache() function. The s390 one
got lost somewhere.
So reintroduce it to prevent future compile errors e.g. if Thomas Gleixner's
idle loop rework patches get merged.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 4a29308..a11c773 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1533,6 +1533,8 @@ extern int s390_enable_sie(void);
  */
 #define pgtable_cache_init()	do { } while (0)
 
+static inline void check_pgt_cache(void) { }
+
 #include <asm-generic/pgtable.h>
 
 #endif /* _S390_PAGE_H */
-- 
1.7.12.4

