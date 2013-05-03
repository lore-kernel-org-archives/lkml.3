Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab3ECFxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:53:42 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58496 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab3ECFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:53:40 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: zonque@gmail.com, vladimir.koutny@streamunlimited.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH v2 2/2] clk: si5351: Set initial clkout rate when defined in platform data.
Date: Fri,  3 May 2013 07:53:23 +0200
Message-Id: <1367560403-21685-2-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367560403-21685-1-git-send-email-marek.belisko@streamunlimited.com>
References: <1367560403-21685-1-git-send-email-marek.belisko@streamunlimited.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
Changes v1->v2:
- update commit message and comment to refer to platform data not DT

 drivers/clk/clk-si5351.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index cf39e53..24f5536 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1477,6 +1477,16 @@ static int si5351_i2c_probe(struct i2c_client *client,
 			return -EINVAL;
 		}
 		drvdata->onecell.clks[n] = clk;
+
+		/* set initial clkout rate */
+		if (pdata->clkout[n].rate != 0) {
+			int ret;
+			ret = clk_set_rate(clk, pdata->clkout[n].rate);
+			if (ret != 0) {
+				dev_err(&client->dev, "Cannot set rate : %d\n",
+					ret);
+			}
+		}
 	}
 
 	ret = of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
-- 
1.7.9.5

