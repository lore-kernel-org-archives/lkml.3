Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaIICCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:02:45 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:33476 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbaIICCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:02:39 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Huang Shijie <shijie8@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] mtd: denali: remove a set-but-unused variable
Date: Tue,  9 Sep 2014 11:01:55 +0900
Message-Id: <1410228117-14820-6-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable "retry" in wait_for_irq() is set, but not used.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---

Changes in v2: None

 drivers/mtd/nand/denali.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 259ca0ba..d37c2e1 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -697,7 +697,6 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 {
 	unsigned long comp_res;
 	uint32_t intr_status;
-	bool retry = false;
 	unsigned long timeout = msecs_to_jiffies(1000);
 
 	do {
@@ -717,7 +716,6 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 			 * need to wait again
 			 */
 			spin_unlock_irq(&denali->irq_lock);
-			retry = true;
 		}
 	} while (comp_res != 0);
 
-- 
1.9.1

