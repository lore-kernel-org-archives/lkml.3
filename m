Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3KAAQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:16:20 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:50957 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3KAAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:16:19 -0400
MIME-Version: 1.0
Date: Fri, 1 Nov 2013 08:16:18 +0800
Message-ID: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
Subject: [PATCH -next] mtd: nand: omap: fix error return code in omap_nand_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dwmw2@infradead.org, jg1.han@samsung.com, zonque@gmail.com,
        avinashphilip@ti.com, computersforpeace@gmail.com,
        artem.bityutskiy@linux.intel.com, pekon@ti.com, tony@atomide.com
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/nand/omap2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index ec40b8d..f777250 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1953,7 +1953,8 @@ static int omap_nand_probe(struct platform_device *pdev)
 		nand_chip->ecc.read_page	= omap_read_page_bch;
 		nand_chip->ecc.write_page	= omap_write_page_bch;
 		/* This ECC scheme requires ELM H/W block */
-		if (is_elm_present(info, pdata->elm_of_node, BCH8_ECC) < 0) {
+		err = is_elm_present(info, pdata->elm_of_node, BCH8_ECC);
+		if (err < 0) {
 			pr_err("nand: error: could not initialize ELM\n");
 			goto return_error;
 		}

