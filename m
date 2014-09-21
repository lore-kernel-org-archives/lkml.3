Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaIUWFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 18:05:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56193 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaIUWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 18:05:49 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Tejun Heo <tj@kernel.org>,
        Honggang Li <enjoymindful@gmail.com>
Subject: [PATCH] Revert "percpu: free percpu allocation info for uniprocessor system"
Date: Sun, 21 Sep 2014 15:04:53 -0700
Message-Id: <1411337093-683-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3189eddbcafc ("percpu: free percpu allocation info for
uniprocessor system").

The commit causes a hang with a crisv32 image. This may be an architecture
problem, but at least for now the revert is necessary to be able to boot a
crisv32 image.

Fixes: 3189eddbcafc ("percpu: free percpu allocation info for uniprocessor system")
Cc: Tejun Heo <tj@kernel.org>
Cc: Honggang Li <enjoymindful@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Resent as non-RFC patch per Tejun's request.

 mm/percpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index da997f9..2139e30 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1932,8 +1932,6 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
-
-	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
1.9.1

