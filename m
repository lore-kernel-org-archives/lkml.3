Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3DZMXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:23:32 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48956 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3DZMXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:23:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 6/6] dmaengine: ste_dma40_ll: Replace meaningless register set with comment
Date: Fri, 26 Apr 2013 12:38:15 +0100
Message-Id: <1366976295-11728-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
References: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
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
index ec03000..f2e15ac 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -189,8 +189,10 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
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

