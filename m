Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3DZMS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:18:26 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36963 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3DZMSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:18:23 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 5/5] mfd: ab8500-sysctrl: let sysctrl driver work without pdata
Date: Fri, 26 Apr 2013 14:17:18 +0200
Message-Id: <1366978638-967-6-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
References: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for a valid plat->sysctrl was introduced in:

2377e52 mfd: ab8500-sysctrl: Error check clean up

but the driver works just fine even without that initialization data.
This patch removes the check and let the driver go ahead with probe.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index b851692..eadae4d 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -104,7 +104,7 @@ void ab8500_restart(char mode, const char *cmd)
 
 	plat = dev_get_platdata(sysctrl_dev->parent);
 	pdata = plat->sysctrl;
-	if (pdata->reboot_reason_code)
+	if (pdata && pdata->reboot_reason_code)
 		reason = pdata->reboot_reason_code(cmd);
 	else
 		pr_warn("[%s] No reboot reason set. Default reason %d\n",
@@ -188,7 +188,7 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 
 	plat = dev_get_platdata(pdev->dev.parent);
 
-	if (!(plat && plat->sysctrl))
+	if (!plat)
 		return -EINVAL;
 
 	sysctrl_dev = &pdev->dev;
@@ -197,7 +197,6 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 		pm_power_off = ab8500_power_off;
 
 	pdata = plat->sysctrl;
-
 	if (pdata) {
 		int last, ret, i, j;
 
-- 
1.8.1.3

