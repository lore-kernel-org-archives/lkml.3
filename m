Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaHEH5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:57:39 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:59638 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaHEH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:57:36 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        heiko.carstens@de.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: [PATCH] s390/locking: Reenable optimistic spinning
Date: Tue,  5 Aug 2014 09:57:51 +0200
Message-Id: <1407225471-14875-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080507-8372-0000-0000-000000BD2D5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc (locking/mutex: Disable
optimistic spinning on some architectures) fenced spinning for
architectures without proper cmpxchg.
There is no need to disable mutex spinning on s390, though:
The instructions CS,CSG and friends provide the proper guarantees.
(We dont implement cmpxchg with locks).

Please note: This is a quick fix for s390, suitable for stable
as 3.16 unintenionally disabled optimistic spinning.

The proper fix is probably to use ARCH_HAVE_NMI_SAFE_CMPXCHG
instead of introducing ARCH_SUPPORTS_ATOMIC_RMW.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: stable@vger.kernel.org
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9a0ea87..eab3c32 100644
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
1.8.4.2

