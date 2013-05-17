Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3EQIvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:51:39 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:51139 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433Ab3EQIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:51:36 -0400
Message-ID: <1368780693.1350.228.camel@x61.thuisdomein>
Subject: [PATCH v2] locking: Fix copy/paste errors "ARCH_INLINE_*_UNLOCK_BH"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 10:51:33 +0200
In-Reply-To: <20130408153614.GB17500@gmail.com>
References: <1365428154.1830.99.camel@x61.thuisdomein>
	 <20130408151609.GA13640@gmail.com>
	 <1365435015.1830.113.camel@x61.thuisdomein>
	 <20130408153614.GB17500@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 May 2013 08:51:34.0032 (UTC) FILETIME=[BBAD1100:01CE52DB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols ARCH_INLINE_READ_UNLOCK_IRQ,
ARCH_INLINE_SPIN_UNLOCK_IRQ, and ARCH_INLINE_WRITE_UNLOCK_IRQ were added
in v2.6.33, but have never actually been used. Ingo Molnar spotted that
this is caused by three identical copy/paste erros. Eg, the Kconfig
entry for
         INLINE_READ_UNLOCK_IRQ

has an (optional) dependency on
    ARCH_INLINE_READ_UNLOCK_BH

were it apparently should depend on
    ARCH_INLINE_READ_UNLOCK_IRQ

instead. Likewise for the Kconfig entries for INLINE_SPIN_UNLOCK_IRQ and
INLINE_WRITE_UNLOCK_IRQ. Fix these three errors.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v1 was titled "locking: remove three unused Kconfig symbols".

1) Still untested.

 kernel/Kconfig.locks | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 44511d1..d2b32ac 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -138,7 +138,7 @@ config INLINE_SPIN_UNLOCK_BH
 
 config INLINE_SPIN_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_SPIN_UNLOCK_IRQ
 
 config INLINE_SPIN_UNLOCK_IRQRESTORE
 	def_bool y
@@ -175,7 +175,7 @@ config INLINE_READ_UNLOCK_BH
 
 config INLINE_READ_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_READ_UNLOCK_IRQ
 
 config INLINE_READ_UNLOCK_IRQRESTORE
 	def_bool y
@@ -212,7 +212,7 @@ config INLINE_WRITE_UNLOCK_BH
 
 config INLINE_WRITE_UNLOCK_IRQ
 	def_bool y
-	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH
+	depends on !PREEMPT || ARCH_INLINE_WRITE_UNLOCK_IRQ
 
 config INLINE_WRITE_UNLOCK_IRQRESTORE
 	def_bool y
-- 
1.7.11.7

