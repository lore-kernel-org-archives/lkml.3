Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbaCTRHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:07:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44841 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbaCTRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:07:45 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <galak@codeaurora.org>, <santosh.shilimkar@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH 2/3] mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE option
Date: Thu, 20 Mar 2014 19:06:23 +0200
Message-ID: <1395335184-4745-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

After testing NAND flash with ubifs for k2hk-emv board were committed
that flash doesn't support subpage writing, so we can fix it by
adding a property to disable subpage write.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 Documentation/devicetree/bindings/mtd/davinci-nand.txt | 2 ++
 drivers/mtd/nand/davinci_nand.c                        | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
index cfb18ab..50af930 100644
--- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
@@ -53,6 +53,8 @@ Recommended properties :
 				identifier is saved in OOB area. If not present
 				false.
 
+- ti,davinci-nosubpage-write:	disable subpage write for the device
+
 Deprecated properties:
 
 - ti,davinci-ecc-mode:		operation mode of the NAND ecc mode. ECC mode
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 4615d79..3ba058d 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -581,6 +581,9 @@ static struct davinci_nand_pdata
 		    of_property_read_bool(pdev->dev.of_node,
 			"ti,davinci-nand-use-bbt"))
 			pdata->bbt_options = NAND_BBT_USE_FLASH;
+		if (of_property_read_bool(pdev->dev.of_node,
+			"ti,davinci-no-subpage-write"))
+			pdata->options |= NAND_NO_SUBPAGE_WRITE;
 	}
 
 	return dev_get_platdata(&pdev->dev);
-- 
1.8.3.2

