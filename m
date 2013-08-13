Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3HMUUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:20:37 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13018 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031Ab3HMUUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:35 -0400
Message-ID: <201308132020.r7DKKY6c022764@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 15:37:06 -0400
Subject: [PATCH] tile: eliminate no-op "noatomichash" boot argument
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/atomic_32.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index f5cada7..42eacb1 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -208,15 +208,6 @@ struct __get_user __atomic_bad_address(int __user *addr)
 }
 
 
-#if CHIP_HAS_CBOX_HOME_MAP()
-static int __init noatomichash(char *str)
-{
-	pr_warning("noatomichash is deprecated.\n");
-	return 1;
-}
-__setup("noatomichash", noatomichash);
-#endif
-
 void __init __init_atomic_per_cpu(void)
 {
 #if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-- 
1.8.3.1

