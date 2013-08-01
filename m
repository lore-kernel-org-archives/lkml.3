Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3HAM3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:29:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:3891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab3HAM3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:29:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,793,1367996400"; 
   d="scan'208";a="340103028"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ed Cashin <ecashin@coraid.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] aoe: remove custom implementation of kbasename()
Date: Thu,  1 Aug 2013 15:28:53 +0300
Message-Id: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kernel we have a nice helper that may be used here. This patch
substitutes the custom implementation by the native function call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/block/aoe/aoedev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 784c92e..db35ef6 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -12,6 +12,7 @@
 #include <linux/bitmap.h>
 #include <linux/kdev_t.h>
 #include <linux/moduleparam.h>
+#include <linux/string.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -241,16 +242,12 @@ aoedev_downdev(struct aoedev *d)
 static int
 user_req(char *s, size_t slen, struct aoedev *d)
 {
-	char *p;
+	const char *p;
 	size_t lim;
 
 	if (!d->gd)
 		return 0;
-	p = strrchr(d->gd->disk_name, '/');
-	if (!p)
-		p = d->gd->disk_name;
-	else
-		p += 1;
+	p = kbasename(d->gd->disk_name);
 	lim = sizeof(d->gd->disk_name);
 	lim -= p - d->gd->disk_name;
 	if (slen < lim)
-- 
1.8.3.2

