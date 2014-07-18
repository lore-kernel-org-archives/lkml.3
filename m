Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762252AbaGRUhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:37:17 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35929 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762141AbaGRUhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:37:15 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: jejb@parisc-linux.org
Cc: deller@gmx.de, tiwai@suse.de, jkosina@suse.cz, joe@perches.com,
        dave.anglin@bell.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: Remove FIXME comment
Date: Fri, 18 Jul 2014 16:37:03 -0400
Message-Id: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment for size of frame not being needed is incorrect , the
function called needs this parameter.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/parisc/kernel/signal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 1cba8f2..1d550b5 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -240,7 +240,6 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 	
 	usp = (regs->gr[30] & ~(0x01UL));
-	/*FIXME: frame_size parameter is unused, remove it. */
 	frame = get_sigframe(ka, usp, sizeof(*frame));
 
 	DBG(1,"SETUP_RT_FRAME: START\n");
-- 
1.9.1

