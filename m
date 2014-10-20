Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaJTX2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:28:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61407 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaJTX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:28:11 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] pinctrl: rockchip: Parse pin groups before calling pinctrl_register()
Date: Mon, 20 Oct 2014 16:27:49 -0700
Message-Id: <1413847670-12245-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413847670-12245-1-git-send-email-dianders@chromium.org>
References: <1413847670-12245-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like in (529301c pinctrl: samsung: Parse pin groups before
calling pinctrl_register()), Rockchip also needs to parse pin groups
earlier to make hogs work.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 65efb88..14a5683 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1263,6 +1263,10 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 		}
 	}
 
+	ret = rockchip_pinctrl_parse_dt(pdev, info);
+	if (ret)
+		return ret;
+
 	info->pctl_dev = pinctrl_register(ctrldesc, &pdev->dev, info);
 	if (!info->pctl_dev) {
 		dev_err(&pdev->dev, "could not register pinctrl driver\n");
@@ -1280,12 +1284,6 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 		pinctrl_add_gpio_range(info->pctl_dev, &pin_bank->grange);
 	}
 
-	ret = rockchip_pinctrl_parse_dt(pdev, info);
-	if (ret) {
-		pinctrl_unregister(info->pctl_dev);
-		return ret;
-	}
-
 	return 0;
 }
 
-- 
2.1.0.rc2.206.gedb03e5

