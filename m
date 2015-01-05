Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbbAEJF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:05:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31337 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbbAEJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-62-54aa52f8ff11
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 14/14] mfd: twl6040: Constify struct regmap_config and
 reg_default array
Date: Mon, 05 Jan 2015 10:01:33 +0100
Message-id: <1420448493-9355-14-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xa7o/glaFGPxZrGrx+oWhxf2vRxkt
	Lu+aw2Yxe0k/i8XpblaL/Ve8HNg8vn2dxOJx59oeNo95JwM9+rasYvT4vEkugDWKyyYlNSez
	LLVI3y6BK+P8bO2CxZwVyw+fZG1gvMDexcjJISFgIrH+x2o2CFtM4sK99UA2F4eQwFJGiYmb
	/7BCOH1MEjNnbwbrYBMwlti8fAlYh4hAlsSPaatZuhg5OJgFCiVaHkaBhIUFoiS2969hBLFZ
	BFQl5j/6BVbOK+AusXj3HKjFchInj01mBWnlBIrffhwJYgoJuEn8e5swgZF3ASPDKkbR1NLk
	guKk9FxDveLE3OLSvHS95PzcTYyQ4Pmyg3HxMatDjAIcjEo8vB4nVoYIsSaWFVfmHmKU4GBW
	EuFddwsoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbG6fd/m6SE65veE6vYFn7fvz5EvEDr0TCnA
	4NSD1XcWLGOvVJhkvfFUi5VNRZvq0oj/H313Xzxv8122denk5U4+Ji+ufl6jYdMSxVUw+cHX
	h9PaFEX15usLms+aEPlBtWbPpmO6HJInbwvq6ylkMnvdq6j8zydb9+iT5OtcoT9Kb+zkTj2o
	01diKc5INNRiLipOBACWAimG/AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make array of
struct reg_default const as well.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/twl6040.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 9687645162ae..f71ee3dbc2a2 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -44,7 +44,7 @@
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
 #define TWL6040_NUM_SUPPLIES	(2)
 
-static struct reg_default twl6040_defaults[] = {
+static const struct reg_default twl6040_defaults[] = {
 	{ 0x01, 0x4B }, /* REG_ASICID	(ro) */
 	{ 0x02, 0x00 }, /* REG_ASICREV	(ro) */
 	{ 0x03, 0x00 }, /* REG_INTID	*/
@@ -580,7 +580,7 @@ static bool twl6040_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config twl6040_regmap_config = {
+static const struct regmap_config twl6040_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

