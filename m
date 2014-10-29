Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaJ2JLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:11:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48376 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaJ2JK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:10:57 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <lisovy@merica.cz>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>, Rafal Milecki <zajec5@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, lisovy@gmail.com,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: [PATCH v2] mtd: spi-nor: Add support for Fujitsu MB85RS1MT FRAM
Date: Wed, 29 Oct 2014 10:10:47 +0100
Message-Id: <1414573847-15897-1-git-send-email-lisovy@merica.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested with this particular FRAM chip

Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
Acked-by: Marek Vasut <marex@denx.de>
---
Changes since v1:
* Rebased to the newest linux-next

 drivers/mtd/spi-nor/spi-nor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index a98c134..37a1c39 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -507,6 +507,9 @@ static const struct spi_device_id spi_nor_ids[] = {
 	{ "mr25h256", CAT25_INFO( 32 * 1024, 1, 256, 2, SPI_NOR_NO_ERASE | SPI_NOR_NO_FR) },
 	{ "mr25h10",  CAT25_INFO(128 * 1024, 1, 256, 3, SPI_NOR_NO_ERASE | SPI_NOR_NO_FR) },
 
+	/* Fujitsu */
+	{ "mb85rs1mt", INFO(0x047f27, 0, 128 * 1024, 1, SPI_NOR_NO_ERASE) },
+
 	/* GigaDevice */
 	{ "gd25q32", INFO(0xc84016, 0, 64 * 1024,  64, SECT_4K) },
 	{ "gd25q64", INFO(0xc84017, 0, 64 * 1024, 128, SECT_4K) },
-- 
1.9.1

