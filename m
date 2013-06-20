Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab3FTJR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:17:57 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52228 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3FTJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:17:55 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] dmaengine: ste_dma40: Declare memcpy config as static
Date: Thu, 20 Jun 2013 11:17:39 +0200
Message-Id: <1371719859-4600-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings:

drivers/dma/ste_dma40.c:81:26: warning: symbol 'dma40_memcpy_conf_phy' was not declared. Should it be static?
drivers/dma/ste_dma40.c:95:26: warning: symbol 'dma40_memcpy_conf_log' was not declared. Should it be static?

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hi Linus,

just a quick sparse error fixup on the dma driver.

Thanks,
Fabio

 drivers/dma/ste_dma40.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index fa4f9a3..8f72085 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -78,7 +78,7 @@ static int dma40_memcpy_channels[] = {
 };
 
 /* Default configuration for physcial memcpy */
-struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
+static struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.mode = STEDMA40_MODE_PHYSICAL,
 	.dir = DMA_MEM_TO_MEM,
 
@@ -92,7 +92,7 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 };
 
 /* Default configuration for logical memcpy */
-struct stedma40_chan_cfg dma40_memcpy_conf_log = {
+static struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = DMA_MEM_TO_MEM,
 
-- 
1.8.2

