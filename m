Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3F3A7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 20:59:06 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40330 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3F3A7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 20:59:04 -0400
Message-ID: <1372553937.3107.1.camel@phoenix>
Subject: [PATCH] pinctrl: st: Remove unnecessary use of of_match_ptr macro
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 30 Jun 2013 08:58:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a DT only driver and st_pctl_of_match is always compiled
in. Hence of_match_ptr is unnecessary.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
This patch was sent on https://lkml.org/lkml/2013/6/28/420.
Resend to Mark because this driver is merged via regmap tree.

 drivers/pinctrl/pinctrl-st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index f95c82a..ea0eae5 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1391,7 +1391,7 @@ static struct platform_driver st_pctl_driver = {
 	.driver = {
 		.name = "st-pinctrl",
 		.owner = THIS_MODULE,
-		.of_match_table = of_match_ptr(st_pctl_of_match),
+		.of_match_table = st_pctl_of_match,
 	},
 	.probe = st_pctl_probe,
 };
-- 
1.8.1.2



