Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3HGO6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:58:51 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60309 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592Ab3HGO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:42 -0400
Message-ID: <201308071458.r77Ewfca013087@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Aug 2013 14:32:49 -0400
Subject: [PATCH] tile: fix comment bug in sys_cmpxchg description
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index cb52d66..25966af 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1609,7 +1609,7 @@ ENTRY(sys_cmpxchg)
 	  * Because of C pointer arithmetic, we want to compute this:
 	  *
 	  * ((char*)atomic_locks +
-	  *  (((r0 >> 3) & (1 << (ATOMIC_HASH_SIZE - 1))) << 2))
+	  *  (((r0 >> 3) & ((1 << ATOMIC_HASH_SHIFT) - 1)) << 2))
 	  *
 	  * Instead of two shifts we just ">> 1", and use 'mm'
 	  * to ignore the low and high bits we don't want.
-- 
1.8.3.1

