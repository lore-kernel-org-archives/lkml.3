Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3F1Kdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:33:55 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42885 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab3F1Kdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:33:53 -0400
Message-ID: <1372415628.1860.1.camel@phoenix>
Subject: [PATCH] pinctrl: st: Fix checking return value of
 syscon_regmap_lookup_by_phandle()
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 18:33:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscon_regmap_lookup_by_phandle() returns ERR_PTR on error.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 7effedf..f95c82a 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1299,9 +1299,9 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
 		return -ENOMEM;
 
 	info->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
-	if (!info->regmap) {
+	if (IS_ERR(info->regmap)) {
 		dev_err(info->dev, "No syscfg phandle specified\n");
-		return -ENOMEM;
+		return PTR_ERR(info->regmap);
 	}
 	info->data = of_match_node(st_pctl_of_match, np)->data;
 
-- 
1.8.1.2



