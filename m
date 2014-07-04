Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbaGDUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:25:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38641 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069AbaGDUZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:25:23 -0400
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
Subject: [PATCH v7 07/24] mfd: max77686: Remove unneeded OOM error message
Date: Fri,  4 Jul 2014 22:24:10 +0200
Message-Id: <1404505467-26526-8-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to print out-of-memory errors since this is already
done by the memory management subsystem which even calls dump_stack().

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/max77686.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 87fe52e..8650832 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -107,10 +107,8 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
 	struct max77686_platform_data *pd;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "could not allocate memory for pdata\n");
+	if (!pd)
 		return NULL;
-	}
 
 	dev->platform_data = pd;
 	return pd;
-- 
2.0.0.rc2

