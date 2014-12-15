Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLOMCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:02:25 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:55004 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaLOL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:59:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 05/13] mtd: st_spi_fsm: Fix [-Wsign-compare] build warning
Date: Mon, 15 Dec 2014 11:59:12 +0000
Message-Id: <1418644760-18773-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mtd/devices/st_spi_fsm.c:1647:17:
  warning: comparison between signed and unsigned integer expressions

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index d82394a..63a84d2 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -1625,11 +1625,11 @@ static int stfsm_write(struct stfsm *fsm, const uint8_t *buf,
 	uint32_t size_lb;
 	uint32_t size_mop;
 	uint32_t tmp[4];
+	uint32_t i;
 	uint32_t page_buf[FLASH_PAGESIZE_32];
 	uint8_t *t = (uint8_t *)&tmp;
 	const uint8_t *p;
 	int ret;
-	int i;
 
 	dev_dbg(fsm->dev, "writing %d bytes to 0x%08x\n", size, offset);
 
-- 
1.9.1

