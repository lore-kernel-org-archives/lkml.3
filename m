Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaBRPE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:04:59 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55385 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaBRO45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:56:57 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 11/35] mtd: st_spi_fsm: Use device size to determine address width
Date: Tue, 18 Feb 2014 14:55:38 +0000
Message-Id: <1392735362-1245-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
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
index 68fa12e..1d7a13a0 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -670,6 +670,10 @@ static int stfsm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	fsm->info = info;
 
+	/* Use device size to determine address width */
+	if (info->sector_size * info->n_sectors > 0xFFFFFF)
+		info->flags |= FLASH_FLAG_32BIT_ADDR;
+
 	platform_set_drvdata(pdev, fsm);
 
 	fsm->mtd.dev.parent	= &pdev->dev;
-- 
1.8.3.2

