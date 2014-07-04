Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaGDJzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:55:47 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38011 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaGDJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:55:43 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 04/23] mfd: max77686: Make platform data over-rule DT
Date: Fri,  4 Jul 2014 11:55:03 +0200
Message-Id: <1404467722-26687-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function max77802_i2c_parse_dt_pdata() should only be called
if there isn't already platform data for the device.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/max77686.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index d1f9d04..12d4c17 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -124,7 +124,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	unsigned int data;
 	int ret = 0;
 
-	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node)
+	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node && !pdata)
 		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
 
 	if (!pdata) {
-- 
2.0.0.rc2

