Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaGQLvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:51:43 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59750 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130AbaGQLvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:51:39 -0400
Message-ID: <53C7B8AC.2040305@de.ibm.com>
Date: Thu, 17 Jul 2014 13:51:08 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mingo@kernel.org, dave.anglin@bell.net,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: torvalds@linux-foundation.org, catalin.marinas@arm.com,
        peterz@infradead.org, cmetcalf@tilera.com, jason.low2@hp.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        James.Bottomley@hansenpartnership.com, will.deacon@arm.com,
        waiman.long@hp.com, james.hogan@imgtec.com, mpatocka@redhat.com,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, vgupta@synopsys.com,
        benh@kernel.crashing.org, jejb@parisc-linux.org
Subject: Re: [tip:locking/urgent] locking/mutex:  Disable optimistic spinning
 on some architectures
References: <20140606175316.GV13930@laptop.programming.kicks-ass.net> <tip-4badad352a6bb202ec68afa7a574c0bb961e5ebc@git.kernel.org>
In-Reply-To: <tip-4badad352a6bb202ec68afa7a574c0bb961e5ebc@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071711-0542-0000-0000-00000011A00C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390: s390 also supports proper atomic read modify write,

There is no need to disable mutex spinning. The instructions 
CS,CSG and friends provide the proper guarantees. (We dont 
implement cmpxchg with locks).

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bb63499..8c5df31 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -63,6 +63,7 @@ config S390
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
 	select ARCH_INLINE_READ_LOCK_IRQ
-- 
1.7.9.5

