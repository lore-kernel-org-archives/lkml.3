Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaICUYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:24:44 -0400
Received: from syn.loicp.eu ([176.31.96.212]:56929 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbaICUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:23:31 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] staging: goldfish: avoid multiple assignments
Date: Wed,  3 Sep 2014 22:23:15 +0200
Message-Id: <1409775795-12521-7-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409775795-12521-1-git-send-email-loic@loicp.eu>
References: <1409775795-12521-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: avoid multiple assignments

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_nand.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index c6c85d3..d68f216 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -329,9 +329,10 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 
 	mtd->priv = nand;
 
-	mtd->name = name = devm_kzalloc(&pdev->dev, name_len + 1, GFP_KERNEL);
+	name = devm_kzalloc(&pdev->dev, name_len + 1, GFP_KERNEL);
 	if (name == NULL)
 		return -ENOMEM;
+	mtd->name = name;
 
 	result = goldfish_nand_cmd(mtd, NAND_CMD_GET_DEV_NAME, 0, name_len,
 				   name);
-- 
2.0.4

