Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbbAEJD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:03:26 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31482 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbbAEJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:03:23 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b3-54aa5358df62
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pinctrl: bcm281xx: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:03:10 +0100
Message-id: <1420448590-9503-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448590-9503-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448590-9503-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t/xy7oRwatCDOZ/17J4/cLQYsqf5UwW
	m+f/YbS4vGsOm8X7n44WTx80MVmsPDGL2YHd48mmi4weO2fdZfe4c20Pm0ffllWMHidPPWHx
	+LxJLoAtissmJTUnsyy1SN8ugSujc/8MloJpnBXffmk1MN5h72Lk5JAQMJG4s3kFE4QtJnHh
	3nq2LkYuDiGBpYwScx6vZYFw+pgkNs28zgJSxSZgLLF5+RKwKhGBTUwSd2csBUsIC7hKXLy2
	khnEZhFQlehv72MFsXkF3CSOdF6GWicncfLYZLA4p4C7REPXNEYQWwio5u/L1cwTGHkWMDKs
	YhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJoi87GBcfszrEKMDBqMTD63FiZYgQa2JZcWXu
	IUYJDmYlEd51t4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGJnd9VoMd7bdkNqyasdNDfULCw4+
	thdWEbnNzlx5aMbivvmv849Nfa7AJb32QMpp6cieNvaa9Sz3VXR6Fpus989XK+vWM9nAfap1
	j8iv+bw/zTP6A/P+zbHo/eKg/KBt0tnKwN8z6vNnlL5116vjc2YJ7jzorPhfLEjgxJG/0/tP
	lmxV3/AyQYmlOCPRUIu5qDgRAGsAzvAAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make also
of_device_id array const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/pinctrl/pinctrl-bcm281xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-bcm281xx.c b/drivers/pinctrl/pinctrl-bcm281xx.c
index fa2a00f22ff1..b88cfe5ed55a 100644
--- a/drivers/pinctrl/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/pinctrl-bcm281xx.c
@@ -976,7 +976,7 @@ static inline void bcm281xx_pin_update(u32 *reg_val, u32 *reg_mask,
 	*reg_mask |= param_mask;
 }
 
-static struct regmap_config bcm281xx_pinctrl_regmap_config = {
+static const struct regmap_config bcm281xx_pinctrl_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -1435,7 +1435,7 @@ static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id bcm281xx_pinctrl_of_match[] = {
+static const struct of_device_id bcm281xx_pinctrl_of_match[] = {
 	{ .compatible = "brcm,bcm11351-pinctrl", },
 	{ },
 };
-- 
1.9.1

