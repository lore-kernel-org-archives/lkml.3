Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3CPHho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 03:37:44 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58294 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3CPHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 03:37:43 -0400
From: Dmitry Voytik <dvv.kernel@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Dmitry Voytik <dvv.kernel@gmail.com>
Subject: [PATCH] staging: android: lowmemorykiller: well-marked debug print
Date: Sat, 16 Mar 2013 11:37:26 +0400
Message-Id: <1363419446-21236-1-git-send-email-dvv.kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303151508070.32475@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1303151508070.32475@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "lowmemorykiller:" prefix to the debug print so it's easier to
analyse LMK's debug output:
dmesg | grep lowmemorykiller

Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>
---
 drivers/staging/android/lowmemorykiller.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 53d80c2..fe74494 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -30,6 +30,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -61,7 +63,7 @@ static unsigned long lowmem_deathpending_timeout;
 #define lowmem_print(level, x...)			\
 	do {						\
 		if (lowmem_debug_level >= (level))	\
-			printk(x);			\
+			pr_info(x);			\
 	} while (0)
 
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
-- 
1.7.9.5

