Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3BAMJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:09:32 -0500
Received: from nbd.name ([46.4.11.11]:41491 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab3BAMJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:09:28 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>,
        Thomas Langer <thomas.langer@lantiq.com>
Subject: [PATCH 11/11] PINCTRL: lantiq: fix pin number in ltq_pmx_gpio_request_enable
Date: Fri,  1 Feb 2013 13:05:05 +0100
Message-Id: <1359720305-31933-11-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mapping logic inside ltq_pmx_gpio_request_enable() was broken. This only
effected Falcon SoC.

Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-lantiq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-lantiq.c b/drivers/pinctrl/pinctrl-lantiq.c
index 7d11072..a703846 100644
--- a/drivers/pinctrl/pinctrl-lantiq.c
+++ b/drivers/pinctrl/pinctrl-lantiq.c
@@ -294,7 +294,7 @@ static int ltq_pmx_gpio_request_enable(struct pinctrl_dev *pctrldev,
 				unsigned pin)
 {
 	struct ltq_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
-	int mfp = match_mfp(info, pin + (range->id * 32));
+	int mfp = match_mfp(info, pin);
 	int pin_func;
 
 	if (mfp < 0) {
-- 
1.7.10.4

