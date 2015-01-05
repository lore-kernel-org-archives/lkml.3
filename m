Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbbAEJDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:03:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39707 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbbAEJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:03:52 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-0e-54aa53784745
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] pwm: pca9685: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:03:44 +0100
Message-id: <1420448624-9567-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJMWRmVeSWpSXmKPExsVy+t/xK7oVwatCDJ5+4bJ4/cLQ4vKuOWwW
	d++uYrT4uWseiwOLx85Zd9k9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+NhyzuWgga2ipMt
	H9gaGBtZuxg5OSQETCQ6bh5khrDFJC7cW8/WxcjFISSwlFFi6cE/LBBOH5PEmS8v2UCq2ASM
	JTYvXwJmiwhkSOzev5AdxGYWMJT4+e4PkM3BISxgI/Higi5ImEVAVeLUtGlgJbwCbhLbX5xg
	h1gmJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEePzrDsalx6wOMQpw
	MCrx8HqcWBkixJpYVlyZe4hRgoNZSYR33S2gEG9KYmVValF+fFFpTmrxIUYmDk6pBsZ2t+s9
	doGvn5X9FXqieWRmc2Lw+eLl2i6e0jJJZ2Mmy9p69+d81zapOp4o4JtznWHvti7JPQc09ob9
	3yltaTkt69vtVd85VTm9Xu1b8bXcKPFYwDzJLOtf67PvCH6qr0/MnFHuzibtvlGBK2BC3naN
	x5N+3fgVONM5yG2Hf/K2Pdlrwzo3uCmxFGckGmoxFxUnAgDlT7RE1gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/pwm/pwm-pca9685.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index 3fb775ded0df..34b5c275a92a 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -202,7 +202,7 @@ static const struct pwm_ops pca9685_pwm_ops = {
 	.owner = THIS_MODULE,
 };
 
-static struct regmap_config pca9685_regmap_i2c_config = {
+static const struct regmap_config pca9685_regmap_i2c_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = PCA9685_NUMREGS,
-- 
1.9.1

