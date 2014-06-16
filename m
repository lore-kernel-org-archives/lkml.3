Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaFPJcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:32:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37925 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaFPJcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:32:53 -0400
Date: Mon, 16 Jun 2014 12:32:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>,
        J Keerthy <j-keerthy@ti.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] CLK: TI: APLL: not allocating enough data
Message-ID: <20140616093233.GA9446@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a cut and paste bug here which will lead to memory corruption
because we don't allocate enough data.

Fixes: 4d008589e271 ('CLK: TI: APLL: add support for omap2 aplls')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
index 5428c9c..18dbaf12 100644
--- a/drivers/clk/ti/apll.c
+++ b/drivers/clk/ti/apll.c
@@ -338,7 +338,7 @@ static void __init of_omap2_apll_setup(struct device_node *node)
 	const char *parent_name;
 	u32 val;
 
-	ad = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
+	ad = kzalloc(sizeof(*ad), GFP_KERNEL);
 	clk_hw = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
 	init = kzalloc(sizeof(*init), GFP_KERNEL);
 
