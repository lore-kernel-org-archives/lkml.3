Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3BCXtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:49:23 -0500
Received: from mail-gh0-f173.google.com ([209.85.160.173]:41058 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3BCXtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:49:21 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regmap: Include <linux/sched.h> header
Date: Sun,  3 Feb 2013 21:49:03 -0200
Message-Id: <1359935343-30558-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 0e8c0234b2 (regmap: Add asynchronous I/O support) introduced the 
following build error:

drivers/base/regmap/regmap.c:1656:32: error: 'TASK_NORMAL' undeclared (first use in this function)
drivers/base/regmap/regmap.c:1688:271: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
drivers/base/regmap/regmap.c:1688:2: error: implicit declaration of function 'schedule' [-Werror=implicit-function-declaration]

Include <linux/sched.h> header to fix it.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
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
1.7.9.5

