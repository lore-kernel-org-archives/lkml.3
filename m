Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3AWPZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:25:17 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37736 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3AWPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:25:16 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Thu, 24 Jan 2013 00:24:38 +0900
Message-Id: <1358954692-5625-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the compatible string for MSHC controller of Exynos4412, and
reuse the controller specific properties with Exynos5250 since those have same
features.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/mmc/host/dw_mmc-exynos.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 0cb9bcb..4f7685f 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -204,6 +204,8 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
 };
 
 static const struct of_device_id dw_mci_exynos_match[] = {
+	{ .compatible = "samsung,exynos4412-dw-mshc",
+			.data = &exynos5250_drv_data, },
 	{ .compatible = "samsung,exynos5250-dw-mshc",
 			.data = &exynos5250_drv_data, },
 	{},
-- 
1.7.10.4

