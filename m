Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbaGQN0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:26:55 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:33664 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGQN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:26:53 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-metag@vger.kernel.org
Cc: james.hogan@imgtec.com, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 1/3] arch/metag/kernel/cachepart.c: fix failure check
Date: Thu, 17 Jul 2014 16:26:26 +0300
Message-Id: <1405603586-12515-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/arch/metag/kernel/cachepart.c:102]: (style) Checking if unsigned variable 'thread_cache_size' is less than zero.

Source code is

        if (thread_cache_size < 0)
            pr_emerg("Can't read %s cache size\n",
                 cache_type ? "DCACHE" : "ICACHE");

but

    unsigned int thread_cache_size;

Function get_thread_cache_size returns an error code
as (unsigned int) -1.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80361
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 arch/metag/kernel/cachepart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
index 0a2385f..b137034 100644
--- a/arch/metag/kernel/cachepart.c
+++ b/arch/metag/kernel/cachepart.c
@@ -99,7 +99,7 @@ void check_for_cache_aliasing(int thread_id)
 	for (cache_type = ICACHE; cache_type <= DCACHE; cache_type++) {
 		thread_cache_size =
 				get_thread_cache_size(cache_type, thread_id);
-		if (thread_cache_size < 0)
+		if (thread_cache_size == (unsigned int)-1)
 			pr_emerg("Can't read %s cache size\n",
 				 cache_type ? "DCACHE" : "ICACHE");
 		else if (thread_cache_size == 0)
-- 
1.8.5.5

