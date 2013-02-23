Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3BWR5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 12:57:51 -0500
Received: from gloria.sntech.de ([95.129.55.99]:55922 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3BWR5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 12:57:49 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
Date: Sat, 23 Feb 2013 18:57:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
References: <201302231855.47560.heiko@sntech.de>
In-Reply-To: <201302231855.47560.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302231857.46445.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pinctrl is not built the fallback functions fail silently
and emit either 0 error codes or NULL pinctrl handles.

Therefore it's needed to also check for this NULL-handle when
falling back to parsing the i2c gpios from devicetree.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/i2c/busses/i2c-s3c2410.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index f6b880b..e58337f 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1060,7 +1060,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	if (i2c->pdata->cfg_gpio) {
 		i2c->pdata->cfg_gpio(to_platform_device(i2c->dev));
-	} else if (IS_ERR(i2c->pctrl) && s3c24xx_i2c_parse_dt_gpio(i2c)) {
+	} else if ((!i2c->pctrl || IS_ERR(i2c->pctrl)) &&
+		   s3c24xx_i2c_parse_dt_gpio(i2c)) {
 		return -EINVAL;
 	}
 
-- 
1.7.2.3
