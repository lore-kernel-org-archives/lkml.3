Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaGORCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:08 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48598 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaGORCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:05 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tero Kristo <t-kristo@ti.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 02/94] clk: ti: apll: not allocating enough data
Date: Tue, 15 Jul 2014 20:00:17 +0300
Message-Id: <1405443709-15288-2-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

There is a cut and paste bug here which will lead to memory corruption
because we don't allocate enough data.

Fixes: 4d008589e271 ('CLK: TI: APLL: add support for omap2 aplls')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/ti/apll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 
-- 
1.7.10.4

