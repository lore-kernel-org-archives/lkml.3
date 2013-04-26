Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3DZMSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:18:18 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:42582 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3DZMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:18:13 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 4/5] mfd: ab8500-sysctrl: set sysctrl_dev during probe
Date: Fri, 26 Apr 2013 14:17:17 +0200
Message-Id: <1366978638-967-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
References: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver requires sysctrl_dev to be set at probe, as it's used by
other driver functions.  This was dropped by mistake in:

2377e52 mfd: ab8500-sysctrl: Error check clean up

making all driver functions fail.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 640495e..b851692 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -191,6 +191,8 @@ static int ab8500_sysctrl_probe(struct platform_device *pdev)
 	if (!(plat && plat->sysctrl))
 		return -EINVAL;
 
+	sysctrl_dev = &pdev->dev;
+
 	if (plat->pm_power_off)
 		pm_power_off = ab8500_power_off;
 
-- 
1.8.1.3

