Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaIZKbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:31:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbaIZJqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/142] s390/locking: Reenable optimistic spinning
Date: Fri, 26 Sep 2014 11:44:11 +0200
Message-Id: <f008331068945523ff12ff13f6d07d7303e0e8a9.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6671e8db1861..faa97bd4948e 100644
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
2.1.0

