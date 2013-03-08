Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab3CHP7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:59:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49204 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab3CHP7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:59:47 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: kgene.kim@samsung.com, ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] ARM: S3C64XX: Clear DMA flags on channel request
Date: Fri,  8 Mar 2013 15:53:04 +0000
Message-Id: <1362757984-19249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clears the DMA flags when a DMA channel is requested. This is
necessary because otherwise the channel may inherit incompatible
settings from its last usage.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 arch/arm/mach-s3c64xx/dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
index 6af1aa1..759846c 100644
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -509,6 +509,7 @@ int s3c2410_dma_request(enum dma_ch channel,
 	chan->client = client;
 	chan->in_use = 1;
 	chan->peripheral = channel;
+	chan->flags = 0;
 
 	local_irq_restore(flags);
 
-- 
1.7.2.5

