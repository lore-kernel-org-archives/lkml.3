Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764Ab3KIH3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:29:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab3KIGvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.10 56/74] clk: fixup argument order when setting VCO parameters
Date: Fri,  8 Nov 2013 22:52:01 -0800
Message-Id: <20131109065117.423343174@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/versatile/clk-icst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -107,7 +107,7 @@ static int icst_set_rate(struct clk_hw *
 
 	vco = icst_hz_to_vco(icst->params, rate);
 	icst->rate = icst_hz(icst->params, vco);
-	vco_set(icst->vcoreg, icst->lockreg, vco);
+	vco_set(icst->lockreg, icst->vcoreg, vco);
 	return 0;
 }
 


