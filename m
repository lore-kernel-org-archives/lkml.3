Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3K2UWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:22:04 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754647Ab3K2UWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:22:02 -0500
From: Richard Weinberger <richard@nod.at>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] Call arch_pick_mmap_layout() only once
Date: Fri, 29 Nov 2013 21:21:50 +0100
Message-Id: <1385756510-2556-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently both setup_new_exec() and flush_old_exec() issue
a call to arch_pick_mmap_layout().
As setup_new_exec() and flush_old_exec() are always called
pairwise arch_pick_mmap_layout() is called twice.

This patch removes one call from setup_new_exec() to have
it only called once.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/exec.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7ea097f..13226bb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1109,8 +1109,6 @@ EXPORT_SYMBOL(would_dump);
 
 void setup_new_exec(struct linux_binprm * bprm)
 {
-	arch_pick_mmap_layout(current->mm);
-
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-- 
1.8.1.4

