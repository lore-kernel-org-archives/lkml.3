Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197Ab3ECLPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:15:43 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57988 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761442Ab3ECLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:15:42 -0400
Date: Fri, 3 May 2013 12:15:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/4 v2] mfd: ab8500-gpadc: Suppress 'ignoring
 regulator_enable() return value' warning
Message-ID: <20130503111537.GH24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367509690-24022-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mfd/ab8500-gpadc.c: In function ‘ab8500_gpadc_resume’:
drivers/mfd/ab8500-gpadc.c:911:18: warning: ignoring return value of
        ‘regulator_enable’, declared with attribute warn_unused_result
        [-Wunused-result]

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 5e65b28..13f7866 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -907,14 +907,17 @@ static int ab8500_gpadc_suspend(struct device *dev)
 static int ab8500_gpadc_resume(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
+	int ret;
 
-	regulator_enable(gpadc->regu);
+	ret = regulator_enable(gpadc->regu);
+	if (ret)
+		dev_err(dev, "Failed to enable vtvout LDO: %d\n", ret);
 
 	pm_runtime_mark_last_busy(gpadc->dev);
 	pm_runtime_put_autosuspend(gpadc->dev);
 
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
-	return 0;
+	return ret;
 }
 
 static int ab8500_gpadc_probe(struct platform_device *pdev)
