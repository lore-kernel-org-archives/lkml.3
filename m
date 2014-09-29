Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaI2Mmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:42:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50350 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaI2Mmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:42:33 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-13-542953b68897
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v2 2/4] dmaengine: pl330: Remove unused 'regs' variable
 in pl330_submit_req()
Date: Mon, 29 Sep 2014 14:42:19 +0200
Message-id: <1411994541-31494-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
References: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Fd1twZohBs+eWlpsnLGe1eL1v+ks
	FtOnXmC0WD31L5D7wtDibNMbdoslk+ezWlzeNYfNYu2Ru+wW715GWLzs28/iwO2xeM9LJo8l
	bw6xenx8eovFo2/LKkaPz5vkPPZ+/s0SwBbFZZOSmpNZllqkb5fAldG2dTZjwTm2ineN+5ga
	GNewdjFyckgImEjMWnidCcIWk7hwbz1bFyMXh5DAUkaJc2vnMIMkhAT6mCRWHs0HsdkEjCU2
	L18CViQi0Mok8WLmJxYQh1ngKKPE9N63YKOEBdIkulb1sYHYLAKqEs8XvGEEsXkF3CUe9XVB
	rZOTOHlsMtgZnAIeEucnv2OE2OYu8Wt5B/MERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS
	83M3MULC8MsOxsXHrA4xCnAwKvHwcqzQCBFiTSwrrsw9xCjBwawkwmtnqxkixJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgdHF6XGweByfkOWpBSFFXAqOu2fUJszMmvfyMWfy7LQN9i3GM/fmLvtW
	9GH9nTVcfHsn9mXrHhT96JCwduNep5XqRqu7ShZt4L7S5yx3qJIh4lX6+sTOyuyS7spC/omi
	NTd5c0NvXldLTd+g2Rabcdft/oPo6xv2hTe5pF9mbP6ze0oxx+sjp5VYijMSDbWYi4oTASL7
	qaQhAgAA
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

