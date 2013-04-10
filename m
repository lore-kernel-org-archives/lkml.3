Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684Ab3DJWTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:19:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3DJWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:52 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 1/6] DMA: shdma: (cosmetic) don't re-calculate a pointer
Date: Thu, 11 Apr 2013 00:19:44 +0200
Message-Id: <1365632389-2249-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:Ono1JfIrMK/9hp2WsV1Bi6mFBatSWS37OzU9nJnppAL
 SKue98f80atPQDdRPoainkIcgQH8KVmamzTHHX/m8EbSndoNW9
 kX7iDRjTcRFE9bhyMQ9cazWq/3YcH3S8Sk1UjemICZcK9jmgP3
 icQ5BuvmypQQrLC1FAZBLvEkQ38iI1tTlzceqkODE/KUYpdgKm
 m19hueRfQFIy/Cl6M/3bYyefXaUCjh2/75S11wD2hu3thxmg6o
 tbESeR8/+wgGOLngexuoEdCixRWGsEVaRfy96l/ne8jO8bLutx
 4Q9u0vkX/DAqOSqTPYSSgB5mqrssd1LObVrP7jRs+L7/tUf4Ze
 k8jvlKCV7YUbRls1DunBbCkdUWxj5U02KrhoNismKCEEsHT3a3
 DiWDr5RxSAFqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an existing pointer instead of retrieving it again.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index b70709b..a5a1887 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -729,7 +729,7 @@ static int sh_dmae_probe(struct platform_device *pdev)
 		goto eshdma;
 
 	/* platform data */
-	shdev->pdata = pdev->dev.platform_data;
+	shdev->pdata = pdata;
 
 	if (pdata->chcr_offset)
 		shdev->chcr_offset = pdata->chcr_offset;
-- 
1.7.2.5

