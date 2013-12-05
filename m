Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3LER1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:27:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47050 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab3LER1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:27:21 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v3 3/9] mtd: nand: davinci: check required ti,davinci-chipselect property
Date: Thu, 5 Dec 2013 19:25:51 +0200
Message-ID: <1386264358-9738-4-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The property "ti,davinci-chipselect" is required. So we have to check
if it is set.

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/mtd/nand/davinci_nand.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index ddcd7c8..9a96ac7 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -545,6 +545,9 @@ static struct davinci_nand_pdata
 		if (!of_property_read_u32(pdev->dev.of_node,
 			"ti,davinci-chipselect", &prop))
 			pdev->id = prop;
+		else
+			return ERR_PTR(-EINVAL);
+
 		if (!of_property_read_u32(pdev->dev.of_node,
 			"ti,davinci-mask-ale", &prop))
 			pdata->mask_ale = prop;
-- 
1.7.9.5

