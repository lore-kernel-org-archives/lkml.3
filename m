Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3HWG2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:28:00 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55509 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3HWG17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:27:59 -0400
Message-ID: <1377239273.14131.0.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: rockchip: Remove of_match_ptr macro for DT
 only driver
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Aug 2013 14:27:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a DT only driver and rockchip_pinctrl_dt_match is always compiled in.
Thus remove of_match_ptr macro.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 64ad0c0..7eb1249 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1365,7 +1365,7 @@ static struct platform_driver rockchip_pinctrl_driver = {
 	.driver = {
 		.name	= "rockchip-pinctrl",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(rockchip_pinctrl_dt_match),
+		.of_match_table = rockchip_pinctrl_dt_match,
 	},
 };
 
-- 
1.8.1.2



