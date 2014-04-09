Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbaDINvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:51:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60878 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933469AbaDINvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:36 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 12/15] pinctrl: sunxi: retrieve and enable PL clk gate for A31 SoC
Date: Wed,  9 Apr 2014 15:51:15 +0200
Message-Id: <1397051478-4113-13-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieve and enable the clock gate related to PL pins.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 64dffc8..da76ceb 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -898,6 +898,13 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 			return -ENOMEM;
 
 		pctl->get_membase = sun6i_a31_pinctrl_get_membase;
+		clk = devm_clk_get(&pdev->dev, "pioL_clk");
+		if (IS_ERR(clk))
+			return PTR_ERR(clk);
+
+		ret = clk_prepare_enable(clk);
+		if (ret)
+			return ret;
 	} else {
 		pctl->get_membase = sunxi_pinctrl_get_membase;
 	}
-- 
1.8.3.2

