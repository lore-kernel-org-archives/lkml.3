Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbbAEJCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:02:06 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32293 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbbAEJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-60-54aa52f8156d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 13/14] mfd: twl-core: Constify struct regmap_config and
 reg_default array
Date: Mon, 05 Jan 2015 10:01:32 +0100
Message-id: <1420448493-9355-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xa7o/glaFGGz+wm/x+oWhxf2vRxkt
	Lu+aw2Yxe0k/i8XpblaL/Ve8HNg8vn2dxOJx59oeNo95JwM9+rasYvT4vEkugDWKyyYlNSez
	LLVI3y6BK2NO/0H2gib+im27ljA2MK7l6WLk5JAQMJHYP+kBE4QtJnHh3nq2LkYuDiGBpYwS
	G1e0MkE4fUwSM2dvZgepYhMwlti8fAkbiC0ikCXxY9pqli5GDg5mgUKJlodRIGFhgWiJxxtB
	BnFwsAioSmzrkAIJ8wq4S9z6MpUNYpecxMljk1lBSjiB4rcfR4KYQgJuEv/eJkxg5F3AyLCK
	UTS1NLmgOCk911CvODG3uDQvXS85P3cTIyR4vuxgXHzM6hCjAAejEg+vx4mVIUKsiWXFlbmH
	GCU4mJVEeNfdAgrxpiRWVqUW5ccXleakFh9iZOLglGpg3Oy+yGlNZl7P5cWTlTSsls9JfRFS
	tDl5xtMVa3tzFvfN5w8MTevlftHGwlp69I1EYXzmnJNp73YkdExxFzqjWv3/l+KPFUG/1E05
	Jm7vvHK95uvFFodJ5nny99KebxXxD5No12d++b3jsXhZ2L7QBBsbXwnzbgPWgopX+9jW+qTu
	LWM/ztulxFKckWioxVxUnAgAEkI7xPwBAAA=
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
 drivers/mfd/twl-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index db11b4f40611..489674a2497e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -207,7 +207,7 @@ static struct twl_mapping twl4030_map[] = {
 	{ 2, TWL5031_BASEADD_INTERRUPTS },
 };
 
-static struct reg_default twl4030_49_defaults[] = {
+static const struct reg_default twl4030_49_defaults[] = {
 	/* Audio Registers */
 	{ 0x01, 0x00}, /* CODEC_MODE	*/
 	{ 0x02, 0x00}, /* OPTION	*/
@@ -306,7 +306,7 @@ static const struct regmap_access_table twl4030_49_volatile_table = {
 	.n_yes_ranges = ARRAY_SIZE(twl4030_49_volatile_ranges),
 };
 
-static struct regmap_config twl4030_regmap_config[4] = {
+static const struct regmap_config twl4030_regmap_config[4] = {
 	{
 		/* Address 0x48 */
 		.reg_bits = 8,
@@ -369,7 +369,7 @@ static struct twl_mapping twl6030_map[] = {
 	{ 1, TWL6030_BASEADD_GASGAUGE },
 };
 
-static struct regmap_config twl6030_regmap_config[3] = {
+static const struct regmap_config twl6030_regmap_config[3] = {
 	{
 		/* Address 0x48 */
 		.reg_bits = 8,
@@ -1087,7 +1087,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	struct twl4030_platform_data	*pdata = dev_get_platdata(&client->dev);
 	struct device_node		*node = client->dev.of_node;
 	struct platform_device		*pdev;
-	struct regmap_config		*twl_regmap_config;
+	const struct regmap_config	*twl_regmap_config;
 	int				irq_base = 0;
 	int				status;
 	unsigned			i, num_slaves;
-- 
1.9.1

