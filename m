Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3AULyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:54:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44921 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3AULyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:54:44 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mpm@selenic.com, herbert@gondor.hengli.com.au,
        sachin.kamat@linaro.org, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/1] char: hw_random: Make exynos_rng_pm_ops static
Date: Mon, 21 Jan 2013 17:15:49 +0530
Message-Id: <1358768749-6061-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'exynos_rng_pm_ops' is used only in this file. Without this patch
we get the following sparse warning:
drivers/char/hw_random/exynos-rng.c:165:1: warning:
symbol 'exynos_rng_pm_ops' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 48bbfec..2a4a86d 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -162,7 +162,7 @@ static int exynos_rng_runtime_resume(struct device *dev)
 }
 
 
-UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
+static UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
 					exynos_rng_runtime_resume, NULL);
 
 static struct platform_driver exynos_rng_driver = {
-- 
1.7.4.1

