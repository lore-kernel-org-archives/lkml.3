Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab3GZVmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:42:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3GZUsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jongsung Kim <neidhard.kim@lge.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 17/79] net/cadence/macb: fix bug/typo in extracting gem_irq_read_clear bit
Date: Fri, 26 Jul 2013 13:47:07 -0700
Message-Id: <20130726204723.735715051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jongsung Kim <neidhard.kim@lge.com>

[ Upstream commit 01276ed2424eb78c95461545410923d5da154d31 ]

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1070,7 +1070,7 @@ static void macb_configure_dma(struct ma
 static void macb_configure_caps(struct macb *bp)
 {
 	if (macb_is_gem(bp)) {
-		if (GEM_BF(IRQCOR, gem_readl(bp, DCFG1)) == 0)
+		if (GEM_BFEXT(IRQCOR, gem_readl(bp, DCFG1)) == 0)
 			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
 	}
 }


