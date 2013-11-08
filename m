Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3KHAxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:53:49 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42003 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3KHAxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:53:35 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/3] panic: enable local IRQs for restart timeout too
Date: Thu,  7 Nov 2013 18:46:40 -0600
Message-Id: <1383871600-3831-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 kernel/panic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 5a0bdaa..e32919f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -133,6 +133,8 @@ void panic(const char *fmt, ...)
 
 	bust_spinlocks(0);
 
+	local_irq_enable();
+
 	if (!panic_blink)
 		panic_blink = no_blink;
 
@@ -176,7 +178,6 @@ void panic(const char *fmt, ...)
 		disabled_wait(caller);
 	}
 #endif
-	local_irq_enable();
 	for (i = 0; ; i += PANIC_TIMER_STEP) {
 		touch_softlockup_watchdog();
 		if (i >= i_next) {
-- 
1.8.4.2+fc1

