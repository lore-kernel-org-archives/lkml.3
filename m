Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaGKOEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:04:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49156 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaGKOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:45 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7a-53bfeefc1a48
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 04/21] leds: Reorder include directives
Date: Fri, 11 Jul 2014 16:04:07 +0200
Message-id: <1405087464-13762-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0/7/YHG0xcJ2yxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8bV569ZCh7zVzy9Mp2tgXETbxcjJ4eEgInE0fNbWCBs
	MYkL99azdTFycQgJTGeUeH/jPTOE084kcad9MjNIFZuAocTPF6+ZQGwRgXKJnvfPwDqYBVYz
	StzZ+pUVJCEsYCdxb94ssLEsAqoSF7u2soHYvAIeEp+WvweyOYDWKUjMmWQDEuYU8JQ42H8T
	rEQIqOTh2hPsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDrBnUjsYVzZYHGIU
	4GBU4uFVWL8vWIg1say4MvcQowQHs5II79U3+4OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5o
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1MHoFqLozKDupqKyau9RHoUak2KdCLN1VwEt998X5m/2s
	UmM+RD1rvd1lfKA+cVKL8S12feP1KuWKWz2+CezYKyyqUH3pztmSxyoTdQ79UX7vrBXknrZf
	45/ig8k7TpQxZwjzrA+zvnc11dUs69X9yfUpNUKBkkunbZ1kI+4q8dJA63jDy183lFiKMxIN
	tZiLihMBWWJcdCwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder include directives so that they are arranged
in alphabetical order.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |   13 +++++++------
 drivers/leds/led-core.c  |    3 ++-
 include/linux/leds.h     |    2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index da79bbb..0127783 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -9,16 +9,17 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/device.h>
 #include <linux/timer.h>
-#include <linux/err.h>
-#include <linux/ctype.h>
-#include <linux/leds.h>
 #include "leds.h"
 
 static struct class *leds_class;
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 0ac06ed..d156fb6 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -12,10 +12,11 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
-#include <linux/leds.h>
 #include "leds.h"
 
 DECLARE_RWSEM(leds_list_lock);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index e9b025d..1a130cc 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -14,8 +14,8 @@
 
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/spinlock.h>
 #include <linux/rwsem.h>
+#include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 
-- 
1.7.9.5

