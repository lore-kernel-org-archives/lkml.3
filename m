Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3EOJy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:54:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43864 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab3EOJxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 35/39] dmaengine: ste_dma40_ll: Replace meaningless register set with comment
Date: Wed, 15 May 2013 10:51:58 +0100
Message-Id: <1368611522-9984-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsure of the author's intentions, rather than just removing the nop,
we're replacing it with a comment containing the possible intention
of the statement OR:ing with 0.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40_ll.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index a035dfe..27b818d 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -182,8 +182,10 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
 	else
 		lli->reg_cfg &= ~BIT(D40_SREG_CFG_TIM_POS);
 
-	/* Post link */
-	lli->reg_lnk |= 0 << D40_SREG_LNK_PHY_PRE_POS;
+	/*
+	 * Post link - D40_SREG_LNK_PHY_PRE_POS = 0
+	 * Relink happens after transfer completion.
+	 */
 
 	return 0;
 }
-- 
1.7.10.4

