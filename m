Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbbAEJDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:03:30 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32440 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbbAEJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:03:27 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-af-54aa53587561
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: dove: Constify struct regmap_config and
 of_device_id
Date: Mon, 05 Jan 2015 10:03:09 +0100
Message-id: <1420448590-9503-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJMWRmVeSWpSXmKPExsVy+t/xy7oRwatCDN5eFbZ4/cLQYsqf5UwW
	m+f/YbS4vGsOm8X7n44WTx80MVmsPDGL2YHd48mmi4weO2fdZfe4c20Pm0ffllWMHidPPWHx
	+LxJLoAtissmJTUnsyy1SN8ugSvj9ZfTjAVzOCp2f2pgb2D8zNbFyMkhIWAi8bHxJzOELSZx
	4d56sLiQwFJGidPvs7oYuYDsPiaJTTOvs4Ak2ASMJTYvX8IGkhAR2MQkcXfGUrCEsECIxMTd
	0xlBbBYBVYmOt51gk3gF3CRevoOISwjISZw8Npl1AiPXAkaGVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghQfFlB+PiY1aHGAU4GJV4eD1OrAwRYk0sK67MPcQowcGsJMK77hZQiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA6OPte0PqZ0H3uSecpWYNOvvbrmHdRHs34UuaZbMCzjVu+vOxUDN
	f0ICcydyPz/4srJOaM/5zMKbWmqTZ5rNFnzlnZa04myl7OnMUMm42/1BshF/hcs2PNq6YP3i
	wMha/2VeW/M2GvXo83XV60veYY/feCfv+uSJpga7XOVaXngG9reu2XS6rUaJpTgj0VCLuag4
	EQAtheeT6AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make also
of_device_id array const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 89a52e15f0ae..95bfd0653e8f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -751,12 +751,12 @@ static struct mvebu_pinctrl_soc_info dove_pinctrl_info = {
 
 static struct clk *clk;
 
-static struct of_device_id dove_pinctrl_of_match[] = {
+static const struct of_device_id dove_pinctrl_of_match[] = {
 	{ .compatible = "marvell,dove-pinctrl", .data = &dove_pinctrl_info },
 	{ }
 };
 
-static struct regmap_config gc_regmap_config = {
+static const struct regmap_config gc_regmap_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-- 
1.9.1

