Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaJUDnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:43:18 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:58951 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaJUDnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:43:16 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <9a29b1cf89f30d2cd8fc7cc8694d68d8>
X-DNS-TYPE: 1
From: zyw@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, dianders@chromium.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 1/6] pinctrl: rockchip: add suspend/resume functions
Date: Mon, 20 Oct 2014 20:42:48 -0700
Message-Id: <1413862968-2691-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
References: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris <zyw@rock-chips.com>

support suspend/resume of pinctrl, it allows handling sleep mode
for hogged pins in pinctrl

Signed-off-by: Chris <zyw@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

Changes in v3: None
Changes in v2: None

 drivers/pinctrl/pinctrl-rockchip.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index d0f3c18..d384d99 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1795,6 +1795,31 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 	return ctrl;
 }
 
+#ifdef CONFIG_PM
+static int rockchip_pinctrl_suspend(struct platform_device *pdev,
+				    pm_message_t state)
+{
+	struct rockchip_pinctrl *info;
+
+	info = platform_get_drvdata(pdev);
+	if (!info)
+		return -EINVAL;
+
+	return pinctrl_force_sleep(info->pctl_dev);
+}
+
+static int rockchip_pinctrl_resume(struct platform_device *pdev)
+{
+	struct rockchip_pinctrl *info;
+
+	info = platform_get_drvdata(pdev);
+	if (!info)
+		return -EINVAL;
+
+	return pinctrl_force_default(info->pctl_dev);
+}
+#endif
+
 static int rockchip_pinctrl_probe(struct platform_device *pdev)
 {
 	struct rockchip_pinctrl *info;
@@ -2010,6 +2035,10 @@ static struct platform_driver rockchip_pinctrl_driver = {
 		.owner	= THIS_MODULE,
 		.of_match_table = rockchip_pinctrl_dt_match,
 	},
+	#ifdef CONFIG_PM
+	.suspend = rockchip_pinctrl_suspend,
+	.resume = rockchip_pinctrl_resume,
+	#endif
 };
 
 static int __init rockchip_pinctrl_drv_register(void)
-- 
1.7.9.5

