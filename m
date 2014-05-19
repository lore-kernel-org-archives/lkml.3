Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaESLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:25:56 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11647 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaESLZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:25:55 -0400
X-IronPort-AV: E=Sophos;i="4.98,866,1392159600"; 
   d="scan'208";a="74564408"
Date: Mon, 19 May 2014 19:25:48 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Tero Kristo <t-kristo@ti.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Turquette <mturquette@linaro.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH] CLK: TI: DRA7: return error code in failure case
In-Reply-To: <5379BC0C.3070401@ti.com>
Message-ID: <alpine.DEB.2.10.1405191924330.2564@hadrien>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-4-git-send-email-Julia.Lawall@lip6.fr> <20140519074155.GO15585@mwanda> <5379BC0C.3070401@ti.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add a returned error code in the MAX_APLL_WAIT_TRIES case.  Remove the
updating of the return variable r to 0 if MAX_APLL_WAIT_TRIES is not yet
reached, because r is already 0 at this point.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
index b986f61..efc71a0 100644
--- a/drivers/clk/ti/apll.c
+++ b/drivers/clk/ti/apll.c
@@ -77,13 +77,11 @@ static int dra7_apll_enable(struct clk_hw *hw)
 	if (i == MAX_APLL_WAIT_TRIES) {
 		pr_warn("clock: %s failed transition to '%s'\n",
 			clk_name, (state) ? "locked" : "bypassed");
-	} else {
+		r = -EBUSY;
+	} else
 		pr_debug("clock: %s transition to '%s' in %d loops\n",
 			 clk_name, (state) ? "locked" : "bypassed", i);

-		r = 0;
-	}
-
 	return r;
 }

