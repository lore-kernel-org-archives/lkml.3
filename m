Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaBDQEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:04:13 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:38017 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaBDP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:35 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 06/17] spi: pl022: Let runtime PM callbacks be available for CONFIG_PM
Date: Tue,  4 Feb 2014 16:58:47 +0100
Message-Id: <1391529538-21685-7-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the SET_PM_RUNTIME_PM macro while defining the runtime PM
callbacks. This means the callbacks becomes available for both
CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME, which is needed to handle the
combinations of these scenarios.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/spi/spi-pl022.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2789b45..70fa907 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2288,7 +2288,7 @@ pl022_remove(struct amba_device *adev)
 	return 0;
 }
 
-#if defined(CONFIG_SUSPEND) || defined(CONFIG_PM_RUNTIME)
+#ifdef CONFIG_PM
 /*
  * These two functions are used from both suspend/resume and
  * the runtime counterparts to handle external resources like
@@ -2354,7 +2354,7 @@ static int pl022_resume(struct device *dev)
 }
 #endif	/* CONFIG_PM */
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int pl022_runtime_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
@@ -2374,7 +2374,7 @@ static int pl022_runtime_resume(struct device *dev)
 
 static const struct dev_pm_ops pl022_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pl022_suspend, pl022_resume)
-	SET_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
+	SET_PM_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
 };
 
 static struct vendor_data vendor_arm = {
-- 
1.7.9.5

