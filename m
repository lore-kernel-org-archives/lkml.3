Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3HGO6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:58:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60310 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3HGO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:44 -0400
Message-ID: <201308071458.r77Ewh6X013090@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Aug 2013 14:34:08 -0400
Subject: [PATCH] tile: fix tilegx vmalloc_sync_all BUG_ON
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As specified, the test wasn't correct, and in any case it should
be a BUILD_BUG_ON.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/fault.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index f7f99f9..6152819 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -870,7 +870,8 @@ void vmalloc_sync_all(void)
 {
 #ifdef __tilegx__
 	/* Currently all L1 kernel pmd's are static and shared. */
-	BUG_ON(pgd_index(VMALLOC_END) != pgd_index(VMALLOC_START));
+	BUILD_BUG_ON(pgd_index(VMALLOC_END - PAGE_SIZE) !=
+		     pgd_index(VMALLOC_START));
 #else
 	/*
 	 * Note that races in the updates of insync and start aren't
-- 
1.8.3.1

