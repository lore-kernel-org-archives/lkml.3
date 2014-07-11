Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaGKQNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:13:39 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:60571 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaGKQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:35 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Kosina <trivial@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH v2 trivial 2/6] crypto: ux500: Update error message for dmaengine_prep_slave_sg() API
Date: Fri, 11 Jul 2014 18:13:24 +0200
Message-Id: <1405095208-14642-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7e933d3b1e25b250b58b827ef455a1b489c84157 ("crypto: ux500: use
dmaengine_prep_slave_sg API") changed the code to use the new API, but
forgot to update an error message.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-crypto@vger.kernel.org
--
v2:
  - New
---
 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1c73f4fbc252..ffa05b8f3bd8 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -184,7 +184,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(ctx->device->dev,
-			"%s: device_prep_slave_sg() failed!\n", __func__);
+			"%s: dmaengine_prep_slave_sg() failed!\n", __func__);
 		return -EFAULT;
 	}
 
-- 
1.9.1

