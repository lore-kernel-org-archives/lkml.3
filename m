Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaHAIOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:14:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47484 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaHAIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:14:43 -0400
Date: Fri, 1 Aug 2014 11:14:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] clk: checking wrong variable in __set_clk_parents()
Message-ID: <20140801081417.GA28869@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a cut and paste bug so we check "pclk" instead of "clk".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
index 1f73019..4e1bda7 100644
--- a/drivers/clk/clk-conf.c
+++ b/drivers/clk/clk-conf.c
@@ -55,10 +55,10 @@ static int __set_clk_parents(struct device_node *node, bool clk_supplier)
 			goto err;
 		}
 		clk = of_clk_get_by_clkspec(&clkspec);
-		if (IS_ERR(pclk)) {
+		if (IS_ERR(clk)) {
 			pr_warn("clk: couldn't get parent clock %d for %s\n",
 				index, node->full_name);
-			rc = PTR_ERR(pclk);
+			rc = PTR_ERR(clk);
 			goto err;
 		}
 
