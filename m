Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaHRPcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:32:33 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62300 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaHRPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:31:12 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v7 4/8] ASoC: mxs-saif: fix mixed use of public and provider clk API
Date: Mon, 18 Aug 2014 17:30:30 +0200
Message-Id: <1408375833-10703-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to changing the clk provider API to use struct clk_core instead
of struct clk.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Acked-by: Mark Brown <broonie@linaro.org>
---
 sound/soc/mxs/mxs-saif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 231d7e7..a24367d 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -682,11 +682,11 @@ static int mxs_saif_mclk_init(struct platform_device *pdev)
 {
 	struct mxs_saif *saif = platform_get_drvdata(pdev);
 	struct device_node *np = pdev->dev.of_node;
-	struct clk *clk;
+	struct clk_core *clk;
 	int ret;
 
 	clk = clk_register_divider(&pdev->dev, "mxs_saif_mclk",
-				   __clk_get_name(saif->clk), 0,
+				   clk_get_name(saif->clk), 0,
 				   saif->base + SAIF_CTRL,
 				   BP_SAIF_CTRL_BITCLK_MULT_RATE, 3,
 				   0, NULL);
-- 
1.9.3

