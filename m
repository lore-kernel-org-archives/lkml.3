Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaFAXem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 19:34:42 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55916 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFAXel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 19:34:41 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: silicom: fix sparse warning for static variable
Date: Sun,  1 Jun 2014 19:34:28 -0400
Message-Id: <1401665668-15622-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warning in bpctl_mod.c:
warning: symbol 'bpvm_lock' was not declared. Should it be static?

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/silicom/bpctl_mod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index f74b5e7..765fce8 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -41,7 +41,7 @@ MODULE_AUTHOR("Anna Lukin, annal@silicom.co.il");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(BP_MOD_DESCR);
 MODULE_VERSION(BP_MOD_VER);
-spinlock_t bpvm_lock;
+static spinlock_t bpvm_lock;
 
 #define unlock_bpctl()					\
 	up(&bpctl_sema);
-- 
1.7.9.5

