Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbaIOWOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:14:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbaIOWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 166/187] s390/locking: Reenable optimistic spinning
Date: Mon, 15 Sep 2014 15:09:36 -0700
Message-Id: <1410818997-9432-167-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c8d8283..8993c96 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -93,6 +93,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
+	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT
-- 
1.9.1

