Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab3KHCWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:22:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab3KHCVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Austin <jonathan.austin@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 67/91] clk: fixup argument order when setting VCO parameters
Date: Thu,  7 Nov 2013 18:15:22 -0800
Message-Id: <1383876946-2396-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Austin <jonathan.austin@arm.com>

commit 2f9f64bc5aa31836810cd25301aa4772ad73ebab upstream.

The order of arguments in the call to vco_set() for the ICST clocks appears to
have been switched in error, which results in the VCO not being initialised
correctly. This in turn stops the integrated LCD on things like Integrator/CP
from working correctly.

This patch fixes the order and restores the expected functionality.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clk/versatile/clk-icst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index 67ccf4a..f5e4c21 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -107,7 +107,7 @@ static int icst_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	vco = icst_hz_to_vco(icst->params, rate);
 	icst->rate = icst_hz(icst->params, vco);
-	vco_set(icst->vcoreg, icst->lockreg, vco);
+	vco_set(icst->lockreg, icst->vcoreg, vco);
 	return 0;
 }
 
-- 
1.8.1.2

