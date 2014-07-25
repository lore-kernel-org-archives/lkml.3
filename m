Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbaGYWTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:19:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50884 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaGYWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:19:22 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H . Peter Anvin" <hpa@zytor.com>, Torsten Duwe <duwe@suse.de>
Subject: [PATCH] hwrng: Pass entropy to add_hwgenerator_randomness() in bits, not bytes
Date: Fri, 25 Jul 2014 15:19:18 -0700
Message-Id: <1406326758-4516-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rng_get_data() returns the number of bytes read from the hardware.
The entropy argument to add_hwgenerator_randomness() is passed
directly to credit_entropy_bits() so we should be passing the
number of bits, not bytes here.

Fixes: be4000bc464 "hwrng: create filler thread"
Cc: Torsten Duwe <duwe@suse.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index dc80cdab733d..6e02ec103cc7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -362,7 +362,7 @@ static int hwrng_fillfn(void *unused)
 			continue;
 		}
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
-					   (rc*current_quality)>>10);
+					   rc * current_quality * 8 >> 10);
 	}
 	hwrng_fill = NULL;
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

