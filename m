Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaIHInT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:43:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32504 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaIHInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:43:13 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-39-540d6c1fb1a6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/4] dmaengine: pl330: Remove unused 'regs' variable in
 pl330_submit_req()
Date: Mon, 08 Sep 2014 10:42:48 +0200
Message-id: <1410165770-4452-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410165770-4452-1-git-send-email-k.kozlowski@samsung.com>
References: <1410165770-4452-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xy7ryObwhBu+aeS02zljPajF96gVG
	i9VT/7JavH5haHG26Q27xZLJ81ktLu+aw2ax9shddouXfftZHDg9Fu95yeSx5M0hVo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKaNs6m7HgHFvFu8Z9TA2Ma1i7GDk5JARMJM6samaHsMUk
	Ltxbz9bFyMUhJLCUUaKnewsThNPHJLH3534WkCo2AWOJzcuXgFWJCHQySnycfJIVxGEWeMso
	8eHwZrBZwgLxEuvnbGDsYuTgYBFQlbjS4QAS5hVwk9g66zjUajmJk8cmg9mcAu4SbQ0rGEFs
	IaCai49PMk9g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyTAvuxgXHzM6hCjAAej
	Eg9vwlWeECHWxLLiytxDjBIczEoivAxhvCFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGJce8ixj
	2BJ61eOQVa5skEwVa4zohpVTFhacdJqaMPvB7MlRGx891Jz1oWFphI24/c4czrtSxrcdHzh+
	TZn8vNXvZuNRa079bR3vPUVcmGeHSjpevF5uxL3pxmaxhLk3PObtXmEYOLHz6ZP7Z+S9ldam
	bfz6fcvNRQrLajlerd/IzatTWLYg+JMSS3FGoqEWc1FxIgCeMJfjDgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'void __iomem *regs' is not used in pl330_submit_req() function.
Remove it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
=================
1. New patch.
---
 drivers/dma/pl330.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 57049f84d0c0..28e3775888a6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1367,13 +1367,10 @@ static int pl330_submit_req(struct pl330_thread *thrd,
 	struct pl330_dmac *pl330 = thrd->dmac;
 	struct _xfer_spec xs;
 	unsigned long flags;
-	void __iomem *regs;
 	unsigned idx;
 	u32 ccr;
 	int ret = 0;
 
-	regs = thrd->dmac->base;
-
 	if (pl330->state == DYING
 		|| pl330->dmac_tbd.reset_chan & (1 << thrd->id)) {
 		dev_info(thrd->dmac->ddma.dev, "%s:%d\n",
-- 
1.9.1

