Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaIKNE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbaIKNEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Ingo Molnar" <mingo@kernel.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.13117840@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 057/131] s390/locking: Reenable optimistic spinning
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 36e7fdaa1a04fcf65b864232e1af56a51c7814d6 upstream.

commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc (locking/mutex: Disable
optimistic spinning on some architectures) fenced spinning for
architectures without proper cmpxchg.
There is no need to disable mutex spinning on s390, though:
The instructions CS,CSG and friends provide the proper guarantees.
(We dont implement cmpxchg with locks).

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -119,6 +119,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_SUPPORTS_ATOMIC_RMW
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y

