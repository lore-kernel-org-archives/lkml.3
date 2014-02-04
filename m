Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaBDP7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:59:30 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:60511 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaBDP7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:24 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 02/17] amba: Add late and early PM callbacks
Date: Tue,  4 Feb 2014 16:58:43 +0100
Message-Id: <1391529538-21685-3-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To give provision for amba drivers to make use of the late|early PM
callbacks, we point the amba bus PM callbacks to the generic versions
of these.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/amba/bus.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3cf61a1..c255d62 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -123,6 +123,12 @@ static const struct dev_pm_ops amba_pm = {
 	.thaw		= pm_generic_thaw,
 	.poweroff	= pm_generic_poweroff,
 	.restore	= pm_generic_restore,
+	.suspend_late	= pm_generic_suspend_late,
+	.resume_early	= pm_generic_resume_early,
+	.freeze_late	= pm_generic_freeze_late,
+	.thaw_early	= pm_generic_thaw_early,
+	.poweroff_late	= pm_generic_poweroff_late,
+	.restore_early	= pm_generic_restore_early,
 	SET_PM_RUNTIME_PM_OPS(
 		amba_pm_runtime_suspend,
 		amba_pm_runtime_resume,
-- 
1.7.9.5

