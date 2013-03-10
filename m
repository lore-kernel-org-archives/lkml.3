Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3CJWsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:48:32 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:35251 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:48:30 -0400
From: Alex Grad <alex.grad@gmail.com>
To: penberg@kernel.org
Cc: paulus@samba.org, mikey@neuling.org, tiejun.chen@windriver.com,
        jason.wessel@windriver.com, sfr@canb.auug.org.au,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        daniel.baluta@gmail.com, Alex Grad <alex.grad@gmail.com>
Subject: [PATCH]->[PATCH v2] kgdb: Removed kmalloc returned value cast
Date: Mon, 11 Mar 2013 00:39:48 +0200
Message-Id: <1362955188-3023-1-git-send-email-alex.grad@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, check kmalloc return value.

Signed-off-by: Alex Grad <alex.grad@gmail.com>
---
 arch/powerpc/kernel/kgdb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 5ca82cd..9e81dd8 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -159,7 +159,10 @@ static int kgdb_singlestep(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
-	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
+	backup_current_thread_info = kmalloc(sizeof(struct thread_info), GFP_KERNEL);
+	if (!backup_current_thread_info)
+		return -ENOMEM;
+
 	/*
 	 * On Book E and perhaps other processors, singlestep is handled on
 	 * the critical exception stack.  This causes current_thread_info()
-- 
1.7.10.4

