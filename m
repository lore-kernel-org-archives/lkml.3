Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaGDGiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:38:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60751 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaGDGiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:38:52 -0400
From: Varka Bhadram <varkabhadram@gmail.com>
X-Google-Original-From: Varka Bhadram <varkab@cdac.in>
To: linux-gpio@vger.kernel.org
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: =?UTF-8?q?=5BPATCH=5D=20drivers/gpio/gpio-sch311x=3A=20check=20return=20value=20of=20gpiochip=5Fremove=28=29?=
Date: Fri,  4 Jul 2014 12:07:31 +0530
Message-Id: <1404455851-9996-1-git-send-email-varkab@cdac.in>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates the following warning

drivers/gpio/gpio-sch311x.c: In function ‘sch311x_gpio_probe’:
drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of ‘gpiochip_remove’, declared with attribute warn_unused_result

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/gpio/gpio-sch311x.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-sch311x.c b/drivers/gpio/gpio-sch311x.c
index f942b80..8a4ab8f 100644
--- a/drivers/gpio/gpio-sch311x.c
+++ b/drivers/gpio/gpio-sch311x.c
@@ -232,7 +232,7 @@ static int sch311x_gpio_probe(struct platform_device *pdev)
 	struct sch311x_pdev_data *pdata = pdev->dev.platform_data;
 	struct sch311x_gpio_priv *priv;
 	struct sch311x_gpio_block *block;
-	int err, i;
+	int err, i, ret;
 
 	/* we can register all GPIO data registers at once */
 	if (!request_region(pdata->runtime_reg + GP1, 6, DRV_NAME)) {
@@ -283,7 +283,11 @@ exit_err:
 	release_region(pdata->runtime_reg + GP1, 6);
 	/* release already registered chips */
 	for (--i; i >= 0; i--)
-		gpiochip_remove(&priv->blocks[i].chip);
+		ret = gpiochip_remove(&priv->blocks[i].chip);
+
+		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
+		     __func__, ret);
+
 	return err;
 }
 
-- 
1.7.9.5

