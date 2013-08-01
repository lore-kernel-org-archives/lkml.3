Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3HAM3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:29:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:29837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3HAM3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,793,1367996400"; 
   d="scan'208";a="380064979"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ed Cashin <ecashin@coraid.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] aoe: use min() to simplify the code
Date: Thu,  1 Aug 2013 15:28:54 +0300
Message-Id: <1375360134-20860-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1375360134-20860-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

min() incorporates condition in it. In our case we could do assignment and
make a choice at once.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/block/aoe/aoedev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index db35ef6..92fadfa 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -13,6 +13,7 @@
 #include <linux/kdev_t.h>
 #include <linux/moduleparam.h>
 #include <linux/string.h>
+#include <linux/kernel.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -248,10 +249,7 @@ user_req(char *s, size_t slen, struct aoedev *d)
 	if (!d->gd)
 		return 0;
 	p = kbasename(d->gd->disk_name);
-	lim = sizeof(d->gd->disk_name);
-	lim -= p - d->gd->disk_name;
-	if (slen < lim)
-		lim = slen;
+	lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
 
 	return !strncmp(s, p, lim);
 }
-- 
1.8.3.2

