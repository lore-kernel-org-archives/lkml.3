Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbbAEIbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:31:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54303 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbAEIbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:31:21 -0500
Date: Mon, 5 Jan 2015 10:23:10 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: omap-des: fix BUG_ON condition
Message-ID: <20150105082310.GA19423@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dd->total is unsigned so it won't do any good to check for negative value after subtracting
instead of that we should check if the subtracted value is bigger than him

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/crypto/omap-des.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index e350f5b..0b8dcf5 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -965,9 +965,9 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 			}
 		}
 
-		dd->total -= DES_BLOCK_SIZE;
+		BUG_ON(dd->total < DES_BLOCK_SIZE);
 
-		BUG_ON(dd->total < 0);
+		dd->total -= DES_BLOCK_SIZE;
 
 		/* Clear IRQ status */
 		status &= ~DES_REG_IRQ_DATA_OUT;
-- 
1.7.0.4

