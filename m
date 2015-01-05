Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbbAELvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:51:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42803 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbbAELux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:50:53 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-79-54aa7a9906e2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 4/5] mfd/regulator: dt-bindings: max77686: Document gpio
 properties
Date: Mon, 05 Jan 2015 12:48:44 +0100
Message-id: <1420458525-22576-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Zd2ZVatCDLasVbLYOGM9q8XUh0/Y
	LOYfOcdq8fqFoUX/49fMFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4v4/Jgctj56y77B6bVnWy
	eWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGUfnnGYu+MdV8frWdeYGxv8cXYycHBIC
	JhJLe5cwQdhiEhfurWfrYuTiEBJYyijx92wHK4TTxyTxprUZrIpNwFhi8/IlYFUiAh8YJVZN
	+gFWxSwwjVHiwqnvzF2MHBzCAhESq5/4gDSwCKhKPLzUwghi8wq4S5xvb2KGWCcncfLYZFYQ
	m1PAQ6Lr6SewuBBQzbSdzcwTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJuS87
	GBcfszrEKMDBqMTD63FiZYgQa2JZcWXuIUYJDmYlEd5X6atChHhTEiurUovy44tKc1KLDzEy
	cXBKNTBGbcj6tLnafHe8eu6axDX2usrbXOW35c2ezVz1PpNph9Tq2LUle+VfnrV2PVuXOkn/
	tvmvbCE5x4ZTqaELd1SX3qwpaFil3Olut84lc+/0TkbhmpfMipnxrZPi4/PedUVfWuXgVexv
	pxC4da+3qGLizIPlfZe2BDEfnq63W/Rsqr7Ethun7iuxFGckGmoxFxUnAgCMpDHbFwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document usage of maxim,ena-gpios properties which turn on external/GPIO
control over regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 75fdfaf41831..e39f0bc1f55e 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -39,6 +39,12 @@ to get matched with their hardware counterparts as follow:
 	-BUCKn	:	1-4.
   Use standard regulator bindings for it ('regulator-off-in-suspend').
 
+  LDO20, LDO21, LDO22, BUCK8 and BUCK9 can be configured to GPIO enable
+  control. To turn this feature on this property must be added to the regulator
+  sub-node:
+	- maxim,ena-gpios :	one GPIO specifier enable control (the gpio
+				flags are actually ignored and always
+				ACTIVE_HIGH is used)
 
 Example:
 
@@ -65,4 +71,12 @@ Example:
 				regulator-always-on;
 				regulator-boot-on;
 			};
+
+			buck9_reg {
+				regulator-compatible = "BUCK9";
+				regulator-name = "CAM_ISP_CORE_1.2V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1200000>;
+				maxim,ena-gpios = <&gpm0 3 GPIO_ACTIVE_HIGH>;
+			};
 	}
-- 
1.9.1

