Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbbA1Fbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:31:52 -0500
Received: from mail.kernel.org ([198.145.29.136]:36881 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbbA1EOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:08 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Tejun Heo <tj@kernel.org>, Honggang Li <enjoymindful@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 010/177] Revert "percpu: free percpu allocation info for uniprocessor system"
Date: Wed, 28 Jan 2015 12:06:26 +0800
Message-Id: <1422418236-12852-19-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit bb2e226b3bef596dd56be97df655d857b4603923 upstream.

This reverts commit 3189eddbcafc ("percpu: free percpu allocation info for
uniprocessor system").

The commit causes a hang with a crisv32 image. This may be an architecture
problem, but at least for now the revert is necessary to be able to boot a
crisv32 image.

Cc: Tejun Heo <tj@kernel.org>
Cc: Honggang Li <enjoymindful@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 3189eddbcafc ("percpu: free percpu allocation info for uniprocessor system")
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/percpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 5f6042b..13b2eef 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1907,8 +1907,6 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
-
-	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
1.9.1

