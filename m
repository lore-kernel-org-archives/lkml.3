Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaA3Nvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:51:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58796 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaA3Nve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:51:34 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4d-52ea58e3848b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: s2mps11: Fix NULL pointer of_node value when using
 platform data
Date: Thu, 30 Jan 2014 14:51:19 +0100
Message-id: <1391089879-7342-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t/xy7qPI14FGVzqULCY+vAJm8XrF4YW
	3650MFlc3jWHzeLiii9MDqweO2fdZffYtKqTzaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Xk95y1pwgaPi448X7A2MM9m7GDk4JARMJGZf4+li5AQyxSQu3FvP1sXIxSEksJRR4t26eWwg
	CSGBPiaJdf8cQGw2AWOJzcuXgBWJCPQwSrzc+pkZJMEsYCjx890fdhBbWCBO4vPZ5WA2i4Cq
	xLVTX8EG8Qq4Sfw+f5QVYrGCxJxJNhMYuRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93E
	CAmBLzsYFx+zOsQowMGoxMO7YvLLICHWxLLiytxDjBIczEoivBqar4KEeFMSK6tSi/Lji0pz
	UosPMTJxcEo1MDLY/forONWK99rEeSk2mlxe99VrmmYV16+KWrL1y53CLd4r4o/IHYtjX/PW
	7F/svTcXHnJ/3NDzV3+Jwdkpt0pya4/4+/C6Wmsa7GKcsXkJ/wv7801zq/QNQrIOd545dC9h
	bgbbk4QTQZULpQrYPZ8V/rCV+3ExneFgzu/kBT+W8Vjfmc8ryaXEUpyRaKjFXFScCAAFsMP4
	3wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_data is used for regulator (of_node of sec-core MFD device
is NULL) the config.of_node for regulator is not initialized. This NULL
value of config.of_node is later stored during regulator_register().
Thus any call by regulator consumers to of_get_regulator() will fail on
of_parse_phandle() returning NULL.

In this case (using platform_data and parent's driver of_node is NULL)
set the config.of_node to reg_node from platform_data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index d9e557990577..cd0b9e35a56d 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -441,6 +441,7 @@ common_reg:
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
 		if (!reg_np) {
 			config.init_data = pdata->regulators[i].initdata;
+			config.of_node = pdata->regulators[i].reg_node;
 		} else {
 			config.init_data = rdata[i].init_data;
 			config.of_node = rdata[i].of_node;
-- 
1.7.9.5

