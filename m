Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaBEUPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:15:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:55584 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaBEUH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 192/213] mtd: cafe_nand: fix an & vs | mistake
Date: Wed, 5 Feb 2014 15:02:27 -0500
Message-ID: <1391630568-49251-193-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 48f8b641297df49021093763a3271119a84990a2 upstream.

The intent here was clearly to set result to true if the 0x40000000 flag
was set.  But instead there was a | vs & typo and we always set result
to true.

Artem: check the spec at
wiki.laptop.org/images/5/5c/88ALP01_Datasheet_July_2007.pdf
and this fix looks correct.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mtd/nand/cafe_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index e5a9f9ccea60..882d01910804 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -104,7 +104,7 @@ static const char *part_probes[] = { "cmdlinepart", "RedBoot", NULL };
 static int cafe_device_ready(struct mtd_info *mtd)
 {
 	struct cafe_priv *cafe = mtd->priv;
-	int result = !!(cafe_readl(cafe, NAND_STATUS) | 0x40000000);
+	int result = !!(cafe_readl(cafe, NAND_STATUS) & 0x40000000);
 	uint32_t irqs = cafe_readl(cafe, NAND_IRQ);
 
 	cafe_writel(cafe, irqs, NAND_IRQ);
-- 
1.8.5.2

