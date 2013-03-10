Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3CJNGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:06:40 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37198 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3CJNGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:06:39 -0400
From: Alex Grad <alex.grad@gmail.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, mikey@neuling.org, tiejun.chen@windriver.com,
        jason.wessel@windriver.com, fr@canb.auug.org.au,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Alex Grad <alex.grad@gmail.com>
Subject: [PATCH] kgdb: Removed kmalloc returned value cast
Date: Sun, 10 Mar 2013 15:06:19 +0200
Message-Id: <1362920779-25925-1-git-send-email-alex.grad@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Grad <alex.grad@gmail.com>
---
 arch/powerpc/kernel/kgdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 5ca82cd..c1eef24 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -159,7 +159,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
-	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
+	backup_current_thread_info = kmalloc(sizeof(struct thread_info), GFP_KERNEL);
 	/*
 	 * On Book E and perhaps other processors, singlestep is handled on
 	 * the critical exception stack.  This causes current_thread_info()
-- 
1.7.10.4

