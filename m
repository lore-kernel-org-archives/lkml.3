Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3COUBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:01:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59322 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3COUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:01:08 -0400
From: Dmitry Voytik <dvv.kernel@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Dmitry Voytik <dvv.kernel@gmail.com>
Subject: [PATCH] staging: android: lowmemorykiller: well-marked debug print
Date: Sat, 16 Mar 2013 00:00:42 +0400
Message-Id: <1363377642-15414-1-git-send-email-dvv.kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "lmk:" prefix to the debug print so it's easier to analyse LMK's
debug output:
dmesg | grep lmk

Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>
---
 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 3b91b0f..4ea7b70 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -60,7 +60,7 @@ static unsigned long lowmem_deathpending_timeout;
 #define lowmem_print(level, x...)			\
 	do {						\
 		if (lowmem_debug_level >= (level))	\
-			printk(x);			\
+			pr_info("lmk: " x);		\
 	} while (0)
 
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
-- 
1.7.9.5

