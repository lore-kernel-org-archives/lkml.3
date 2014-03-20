Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaCTJVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:21:46 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33442 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbaCTJVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 11/36] mtd: st_spi_fsm: Use device size to determine address width
Date: Thu, 20 Mar 2014 09:20:43 +0000
Message-Id: <1395307268-12721-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take some known parameters, namely size and number of sectors and use
them to determine weather a device can support 32bit addressing or not.
If it can, set the associated flash capability flag for latter use.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 2740ae1..5a1b470 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -671,6 +671,10 @@ static int stfsm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	fsm->info = info;
 
+	/* Use device size to determine address width */
+	if (info->sector_size * info->n_sectors > 0x1000000)
+		info->flags |= FLASH_FLAG_32BIT_ADDR;
+
 	fsm->mtd.dev.parent	= &pdev->dev;
 	fsm->mtd.type		= MTD_NORFLASH;
 	fsm->mtd.writesize	= 4;
-- 
1.8.3.2

