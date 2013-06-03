Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3FCACY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 20:02:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43321 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3FCACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 20:02:20 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] hw_rng: nomadik: use clk_prepare_enable()
Date: Mon,  3 Jun 2013 02:02:09 +0200
Message-Id: <1370217729-13699-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Nomadik HW RNG driver has seen some rust and is not preparing
the clock before use. Fix this up so we get rid of runtime
complaints from the clock subsystem.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/char/hw_random/nomadik-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index 96de024..232b87f 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -51,7 +51,7 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 		return ret;
 	}
 
-	clk_enable(rng_clk);
+	clk_prepare_enable(rng_clk);
 
 	ret = amba_request_regions(dev, dev->dev.init_name);
 	if (ret)
-- 
1.8.1.4

