Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3EIKjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:39:35 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:44228 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3EIKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:39:34 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 15/21] arch/tile: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:53 +0400
Message-Id: <1368095819-11011-4-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 arch/tile/lib/spinlock_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
index b16ac49..b34f79a 100644
--- a/arch/tile/lib/spinlock_32.c
+++ b/arch/tile/lib/spinlock_32.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(arch_spin_unlock_wait);
  * preserve the semantic that the same read lock can be acquired in an
  * interrupt context.
  */
-inline int arch_read_trylock(arch_rwlock_t *rwlock)
+int arch_read_trylock(arch_rwlock_t *rwlock)
 {
 	u32 val;
 	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 1);
-- 
1.8.1.4

