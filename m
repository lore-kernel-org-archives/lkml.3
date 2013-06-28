Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3F1QKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:10:43 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46889 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3F1QKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:10:42 -0400
Message-ID: <1372435836.6153.0.camel@phoenix>
Subject: [PATCH] pinctrl: st: Remove unnecessary use of of_match_ptr macro
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 29 Jun 2013 00:10:36 +0800
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
---
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



