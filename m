Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3KHAxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:53:35 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38752 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3KHAxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:53:31 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 2/3] panic: improve panic_timeout calculation
Date: Thu,  7 Nov 2013 18:46:39 -0600
Message-Id: <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to calculate the blinks per second, and instead of making it 5
(1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
per second.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 kernel/panic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 46e37ff..5a0bdaa 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -25,7 +25,7 @@
 #include <linux/nmi.h>
 
 #define PANIC_TIMER_STEP 100
-#define PANIC_BLINK_SPD 18
+#define PANIC_BLINK_SPD 4
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
 static unsigned long tainted_mask;
@@ -147,7 +147,7 @@ void panic(const char *fmt, ...)
 			touch_nmi_watchdog();
 			if (i >= i_next) {
 				i += panic_blink(state ^= 1);
-				i_next = i + 3600 / PANIC_BLINK_SPD;
+				i_next = i + 1000 / PANIC_BLINK_SPD;
 			}
 			mdelay(PANIC_TIMER_STEP);
 		}
@@ -181,7 +181,7 @@ void panic(const char *fmt, ...)
 		touch_softlockup_watchdog();
 		if (i >= i_next) {
 			i += panic_blink(state ^= 1);
-			i_next = i + 3600 / PANIC_BLINK_SPD;
+			i_next = i + 1000 / PANIC_BLINK_SPD;
 		}
 		mdelay(PANIC_TIMER_STEP);
 	}
-- 
1.8.4.2+fc1

