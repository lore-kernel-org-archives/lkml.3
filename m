Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3BCFuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 00:50:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47457 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3BCFua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 00:50:30 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: include linux/sched.h to fix build
Date: Sat,  2 Feb 2013 22:50:14 -0700
Message-Id: <1359870614-23691-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This fixes:

drivers/base/regmap/regmap.c: In function 'regmap_async_complete_cb':
drivers/base/regmap/regmap.c:1656:3: error: 'TASK_NORMAL' undeclared (first use in this function)
drivers/base/regmap/regmap.c:1656:3: note: each undeclared identifier is reported only once for each function it appears in
drivers/base/regmap/regmap.c: In function 'regmap_async_complete':
drivers/base/regmap/regmap.c:1688:2: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
drivers/base/regmap/regmap.c:1688:2: error: implicit declaration of function 'schedule'

An alternative might be to adjust linux/wait.h to include linux/sched.h,
but since that hasn't been done before, I assume we're consciously
avoiding doing that.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bee8560..ebd1f22 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regmap.h>
-- 
1.7.10.4

