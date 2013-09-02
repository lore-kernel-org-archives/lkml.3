Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3IBA5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:57:24 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:62432 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3IBA5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:57:22 -0400
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: imx-sdma: Staticize sdma_driver_data structures
Date: Sun,  1 Sep 2013 21:57:12 -0300
Message-Id: <1378083432-15728-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Sparse report the following warnings:

drivers/dma/imx-sdma.c:330:25: warning: symbol 'sdma_imx31' was not declared. Should it be static?
drivers/dma/imx-sdma.c:351:25: warning: symbol 'sdma_imx25' was not declared. Should it be static?
drivers/dma/imx-sdma.c:357:25: warning: symbol 'sdma_imx35' was not declared. Should it be static?
drivers/dma/imx-sdma.c:375:25: warning: symbol 'sdma_imx51' was not declared. Should it be static?
drivers/dma/imx-sdma.c:395:25: warning: symbol 'sdma_imx53' was not declared. Should it be static?
drivers/dma/imx-sdma.c:414:25: warning: symbol 'sdma_imx6q' was not declared. Should it be static?

Make the sdma_driver_data structures static.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 59bf9f5..fc43603 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -327,7 +327,7 @@ struct sdma_engine {
 	const struct sdma_driver_data	*drvdata;
 };
 
-struct sdma_driver_data sdma_imx31 = {
+static struct sdma_driver_data sdma_imx31 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX31,
 	.num_events = 32,
 };
@@ -348,13 +348,13 @@ static struct sdma_script_start_addrs sdma_script_imx25 = {
 	.shp_2_mcu_addr = 979,
 };
 
-struct sdma_driver_data sdma_imx25 = {
+static struct sdma_driver_data sdma_imx25 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX35,
 	.num_events = 48,
 	.script_addrs = &sdma_script_imx25,
 };
 
-struct sdma_driver_data sdma_imx35 = {
+static struct sdma_driver_data sdma_imx35 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX35,
 	.num_events = 48,
 };
@@ -372,7 +372,7 @@ static struct sdma_script_start_addrs sdma_script_imx51 = {
 	.shp_2_mcu_addr = 892,
 };
 
-struct sdma_driver_data sdma_imx51 = {
+static struct sdma_driver_data sdma_imx51 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX35,
 	.num_events = 48,
 	.script_addrs = &sdma_script_imx51,
@@ -392,7 +392,7 @@ static struct sdma_script_start_addrs sdma_script_imx53 = {
 	.mcu_2_firi_addr = 1290,
 };
 
-struct sdma_driver_data sdma_imx53 = {
+static struct sdma_driver_data sdma_imx53 = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX35,
 	.num_events = 48,
 	.script_addrs = &sdma_script_imx53,
@@ -411,7 +411,7 @@ static struct sdma_script_start_addrs sdma_script_imx6q = {
 	.mcu_2_spdif_addr = 1134,
 };
 
-struct sdma_driver_data sdma_imx6q = {
+static struct sdma_driver_data sdma_imx6q = {
 	.chnenbl0 = SDMA_CHNENBL0_IMX35,
 	.num_events = 48,
 	.script_addrs = &sdma_script_imx6q,
-- 
1.8.1.2

