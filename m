Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab3GLNoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:44:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914Ab3GLNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:08 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 7/8] DMA: shdma: make multiplexer platform data optional
Date: Fri, 12 Jul 2013 15:43:57 +0200
Message-Id: <1373636638-18496-8-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:d23oDVyhqApa6SfRqs5+RW0n54YAKBgBNnPSazXsHCZ
 l4sOlCZCPVTblL7SaPpGnwORnSmAT7M7SflE9yw8oLdy/8MWRS
 b/1fFCX0eVBVrjBuKfHSXU4wLFHreg2SepBdcURZF0vgu+9HOO
 UuDgfZhi7yYxPhpu94omVEuinFXm/7fzHeKAybyS2Hy1T8IYBL
 OEAFq1waryPMJcZ+ieksEOFtBphObkjZppdhKEHdK/9tPVSeaN
 85rxY6LZYK5ID7RTnj0KbNUR2cBV84km4G1pjuBGW1AWsGL/ul
 6XZt02cxsnQ78haP8HcbGSuiKNg1VzdajTNpjyUeNhV+eWz1yD
 y28MiMztmxuoRixH8qI1aIoD0T0Ygw1hBEGZdHW0AyLA641ily
 gNiR5Qhk2UYZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of supplying platform data to the shdma dmaengine driver via
AUXDATA in the DT case, we now support platform data via an OF match table.
Make platform data optional.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma-of.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index fd2fa10..e439e53 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -46,9 +46,6 @@ static int shdma_of_probe(struct platform_device *pdev)
 	const struct of_dev_auxdata *lookup = pdev->dev.platform_data;
 	int ret;
 
-	if (!lookup)
-		return -EINVAL;
-
 	ret = of_dma_controller_register(pdev->dev.of_node,
 					 shdma_of_xlate, pdev);
 	if (ret < 0)
-- 
1.7.2.5

