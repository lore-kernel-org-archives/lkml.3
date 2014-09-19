Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaISK0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:26:47 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41536 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaISK0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:26:45 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v10 4/6] rtc: max77686: Remove unneded info log
Date: Fri, 19 Sep 2014 12:26:15 +0200
Message-Id: <1411122377-10426-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If devm_rtc_device_register() fails a dev_err() is already
reported so there is no need to do an additional dev_info().

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-max77686.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 55396bb..b177ba1 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -457,8 +457,6 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 					&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
-		dev_info(&pdev->dev, "%s: fail\n", __func__);
-
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
 		if (ret == 0)
-- 
2.1.0

