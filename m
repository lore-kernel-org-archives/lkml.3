Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaAOWfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:35:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaAOVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 121/166] tg3: Expand 4g_overflow_test workaround to skb fragments of any size.
Date: Wed, 15 Jan 2014 13:52:15 -0800
Message-Id: <1389822780-4729-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 375679104ab3ccfd18dcbd7ba503734fb9a2c63a upstream.

The current driver assumes that an skb fragment can only be upto jumbo
size. Presumably this was a fast-path optimization. This assumption is
no longer true as fragments can be upto 32k.

v2: Remove unnecessary parantheses per Eric Dumazet.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 79096af..3149f5b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7030,7 +7030,7 @@ static inline int tg3_4g_overflow_test(dma_addr_t mapping, int len)
 {
 	u32 base = (u32) mapping & 0xffffffff;
 
-	return (base > 0xffffdcc0) && (base + len + 8 < base);
+	return base + len + 8 < base;
 }
 
 /* Test for DMA addresses > 40-bit */
-- 
1.8.3.2

