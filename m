Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab3B0Qab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:30:31 -0500
Received: from mx2.promwad.com ([91.149.128.90]:41430 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab3B0Qaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:30:30 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH 8/9] removing of buffer filling flag and also reverting old buffer related fix which is not really effective
Date: Wed, 27 Feb 2013 19:30:19 +0300
Message-ID: <1361982619-5655-1-git-send-email-michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michail Kurachkin <michail.kurachkin@promwad.com>
---
 drivers/staging/tdm/kirkwood_tdm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tdm/kirkwood_tdm.c b/drivers/staging/tdm/kirkwood_tdm.c
index e4a9106..57c8925 100644
--- a/drivers/staging/tdm/kirkwood_tdm.c
+++ b/drivers/staging/tdm/kirkwood_tdm.c
@@ -678,7 +678,7 @@ static irqreturn_t kirkwood_tdm_irq(s32 irq, void *context_data)
 			}
 
 			/* waiting while dma providing access to buffer */
-			while(readl(&regs->chan0_buff_ownership + 4 * voice_num) & 1);
+			/* while(readl(&regs->chan0_buff_ownership + 4 * voice_num) & 1); */
 
 			/* set next buffer address */
 			writel((u32)onchip_ch->rx_buff_phy[next_buf_num],
@@ -714,7 +714,7 @@ static irqreturn_t kirkwood_tdm_irq(s32 irq, void *context_data)
 			}
 
 			/* waiting while dma providing access to buffer */
-			while(readl(&regs->chan0_buff_ownership + 4 * voice_num) & 0x100);
+			/* while(readl(&regs->chan0_buff_ownership + 4 * voice_num) & 0x100); */
 
 			/* set next buffer address */
 			writel((u32)onchip_ch->tx_buff_phy[next_buf_num],
-- 
1.7.5.4

