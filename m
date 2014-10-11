Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJKQVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:21:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:29315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaJKQU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:20:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603887864"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 5/6] dmaengine: freescale: remove FSLDMA_EXTERNAL_START control method
Date: Sat, 11 Oct 2014 21:16:47 +0530
Message-Id: <1413042408-28491-6-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
References: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since users have been move to fsl_dma_external_start() API, so remove this
now

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/fsldma.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 0cded86..994bcb2 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1012,15 +1012,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		chan->set_request_count(chan, size);
 		return 0;
 
-	case FSLDMA_EXTERNAL_START:
-
-		/* make sure the channel supports external start */
-		if (!chan->toggle_ext_start)
-			return -ENXIO;
-
-		chan->toggle_ext_start(chan, arg);
-		return 0;
-
 	default:
 		return -ENXIO;
 	}
-- 
1.7.0.4

