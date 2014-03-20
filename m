Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaCTLMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:12:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62931 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbaCTLMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:12:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, angus.clark@st.com
Subject: [PATCH 2/5] mtd: st_spi_fsm: Avoid duplicating MTD core code
Date: Thu, 20 Mar 2014 11:11:44 +0000
Message-Id: <1395313907-25318-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index dcc1dc3..27f9ec9 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -1728,14 +1728,6 @@ static int stfsm_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
 
 	dev_dbg(fsm->dev, "%s to 0x%08x, len %zd\n", __func__, (u32)to, len);
 
-	*retlen = 0;
-
-	if (!len)
-		return 0;
-
-	if (to + len > mtd->size)
-		return -EINVAL;
-
 	/* Offset within page */
 	page_offs = to % FLASH_PAGESIZE;
 
-- 
1.8.3.2

