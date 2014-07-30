Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaG3L73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:59:29 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40609 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaG3L7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:59:07 -0400
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Alexander Popov <a13xp0p0v88@gmail.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] dmaengine: of: kconfig: select DMA_ENGINE when DMA_OF is selected
Date: Wed, 30 Jul 2014 15:58:51 +0400
Message-Id: <1406721531-23635-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select DMA_ENGINE when DMA_OF is selected since
of_dma_xlate_by_chan_id() from drivers/dma/of-dma.c uses
dma_get_slave_channel() from drivers/dma/dmaengine.c

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 drivers/dma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1eca7b9..f887b19 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -388,6 +388,7 @@ config DMA_ACPI
 config DMA_OF
 	def_bool y
 	depends on OF
+	select DMA_ENGINE
 
 comment "DMA Clients"
 	depends on DMA_ENGINE
-- 
1.8.4.2

