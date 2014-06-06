Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaFFRev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:34:51 -0400
Received: from mout.web.de ([212.227.17.11]:49835 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaFFRes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:48 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-metag@vger.kernel.org
Subject: [PATCH 04/13] metag: dma: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:23 +0200
Message-Id: <1402076072-4044-4-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:VbYVyOTqA8TEQrIb/6M9HwjhiKLh7LuOwFC5SZNINsw9jbkCtcE
 V8Za+F7XwTCh6GNTbNZHlH0BkvsRezHERjmgHTawvCk1nHldhfRF6VvTihfvWyGULwqJW63
 LBDTXNeyI3C885axKa1p964Ee4vxQAHL1mAd3dvO+MI6AgbF+ur/2NMgrwiRwanGeeFlCx3
 L4S8HJBL5XD+rmoaMlRyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-metag@vger.kernel.org
---
 arch/metag/kernel/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/dma.c b/arch/metag/kernel/dma.c
index c700d62..8b384d8 100644
--- a/arch/metag/kernel/dma.c
+++ b/arch/metag/kernel/dma.c
@@ -138,7 +138,7 @@ found:
 	/*
 	 * Insert this entry _before_ the one we found.
 	 */
-	list_add_tail(&new->vm_list, &c->vm_list);
+	list_add_before(&new->vm_list, &c->vm_list);
 	new->vm_start = addr;
 	new->vm_end = addr + size;
 	new->vm_active = 1;
-- 
2.0.0

