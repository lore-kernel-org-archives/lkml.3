Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaLDO4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:56:25 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37410 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaLDO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:56:23 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] power: bq24190_charger: suppress build warning
Date: Thu,  4 Dec 2014 14:56:04 +0000
Message-Id: <1417704964-23155-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following build warning:

In file included from include/linux/printk.h:261:0,
                 from include/linux/kernel.h:13,
                 from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from drivers/power/bq24190_charger.c:11:
drivers/power/bq24190_charger.c: In function ‘bq24190_irq_handler_thread’:
include/linux/dynamic_debug.h:86:20: warning: ‘ss_reg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   __dynamic_dev_dbg(&descriptor, dev, fmt, \
                    ^
drivers/power/bq24190_charger.c:1211:5: note: ‘ss_reg’ was declared here
  u8 ss_reg, f_reg;
     ^
In file included from include/linux/printk.h:261:0,
                 from include/linux/kernel.h:13,
                 from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from drivers/power/bq24190_charger.c:11:
include/linux/dynamic_debug.h:86:20: warning: ‘f_reg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   __dynamic_dev_dbg(&descriptor, dev, fmt, \
                    ^
drivers/power/bq24190_charger.c:1211:13: note: ‘f_reg’ was declared here
  u8 ss_reg, f_reg;

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/power/bq24190_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index ad3ff8f..72e552d 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -1208,7 +1208,7 @@ static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
 {
 	struct bq24190_dev_info *bdi = data;
 	bool alert_userspace = false;
-	u8 ss_reg, f_reg;
+	u8 ss_reg = 0, f_reg = 0;
 	int ret;
 
 	pm_runtime_get_sync(bdi->dev);
-- 
1.9.1

