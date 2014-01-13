Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaAMQmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:42:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaAMQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 090/208] tg3: Expand 4g_overflow_test workaround to skb fragments of any size.
Date: Mon, 13 Jan 2014 15:58:51 +0000
Message-Id: <1389628849-1614-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 9f535de..e7af885 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7555,7 +7555,7 @@ static inline int tg3_4g_overflow_test(dma_addr_t mapping, int len)
 {
 	u32 base = (u32) mapping & 0xffffffff;
 
-	return (base > 0xffffdcc0) && (base + len + 8 < base);
+	return base + len + 8 < base;
 }
 
 /* Test for TSO DMA buffers that cross into regions which are within MSS bytes
-- 
1.8.3.2

