Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaCVGwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:52:23 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55258 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaCVGwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:52:21 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: arnd@arndb.de, benh@kernel.crashing.org, paulus@samba.or,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/powerpc: Use RCU_INIT_POINTER(x, NULL) in platforms/cell/spu_syscalls.c
Date: Sat, 22 Mar 2014 12:20:56 +0530
Message-Id: <1395471056-2951-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here rcu_assign_pointer() is ensuring that the
initialization of a structure is carried out before storing a pointer
to that structure.
So, rcu_assign_pointer(p, NULL) can always safely be converted to
RCU_INIT_POINTER(p, NULL).

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 arch/powerpc/platforms/cell/spu_syscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index 3844f13..38e0a1a 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -170,7 +170,7 @@ EXPORT_SYMBOL_GPL(register_spu_syscalls);
 void unregister_spu_syscalls(struct spufs_calls *calls)
 {
 	BUG_ON(spufs_calls->owner != calls->owner);
-	rcu_assign_pointer(spufs_calls, NULL);
+	RCU_INIT_POINTER(spufs_calls, NULL);
 	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(unregister_spu_syscalls);
-- 
1.7.9.5

