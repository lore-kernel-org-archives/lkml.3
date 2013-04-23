Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3DWGXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:23:37 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:63097 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab3DWGXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:23:13 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        zonque@gmail.com, sebastian.hesselbarth@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH 2/2] clk: si5351: Apply rate when clock-frequency is defined in devicetree.
Date: Tue, 23 Apr 2013 08:22:50 +0200
Message-Id: <1366698170-31346-2-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366698170-31346-1-git-send-email-marek.belisko@streamunlimited.com>
References: <1366698170-31346-1-git-send-email-marek.belisko@streamunlimited.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock-frequency property from devicetree was read but never used. Apply
defined rate when clock is registered.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 drivers/clk/clk-si5351.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index cf39e53..8323c31 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1477,6 +1477,16 @@ static int si5351_i2c_probe(struct i2c_client *client,
 			return -EINVAL;
 		}
 		drvdata->onecell.clks[n] = clk;
+
+		/* set rate when defined in devicetree */
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

