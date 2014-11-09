Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaKILWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:22:45 -0500
Received: from mail-pa0-f65.google.com ([209.85.220.65]:40934 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaKILWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:22:41 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: sjennings@variantweb.net, minchan@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zswap: unregister zswap_cpu_notifier_block in cleanup procedure
Date: Sun,  9 Nov 2014 19:22:23 +0800
Message-Id: <1415532143-4409-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zswap_cpu_init(), the code does not unregister *zswap_cpu_notifier_block*
during the cleanup procedure.

This patch fix this issue.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index ea064c1..51a2c45 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -404,6 +404,7 @@ static int zswap_cpu_init(void)
 cleanup:
 	for_each_online_cpu(cpu)
 		__zswap_cpu_notifier(CPU_UP_CANCELED, cpu);
+	__unregister_cpu_notifier(&zswap_cpu_notifier_block);
 	cpu_notifier_register_done();
 	return -ENOMEM;
 }
-- 
1.7.9.5

