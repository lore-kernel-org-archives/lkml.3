Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKYKlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaKYKlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Honggang Li <enjoymindful@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 073/254] Revert "percpu: free percpu allocation info for uniprocessor system"
Date: Tue, 25 Nov 2014 10:37:03 +0000
Message-Id: <1416912004-5928-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/percpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 492f601df473..2ddf9a990dbd 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1933,8 +1933,6 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
-
-	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
2.1.0

