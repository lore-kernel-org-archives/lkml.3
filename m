Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaJNKLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:11:23 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52785 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbaJNKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:11:21 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] s5p-fimc: Only build suspend/resume for PM
Date: Tue, 14 Oct 2014 12:11:18 +0200
Message-Id: <1413281478-2866-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

If power management is disabled these functions become unused, so there
is no reason to build them. This fixes a couple of build warnings when
PM(_SLEEP,_RUNTIME) is not enabled.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- add #endif comment for readability

 drivers/media/platform/exynos4-is/fimc-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index b70fd996d794..aee92d908e49 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -832,6 +832,7 @@ err:
 	return -ENXIO;
 }
 
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 static int fimc_m2m_suspend(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -870,6 +871,7 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 
 	return 0;
 }
+#endif /* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */
 
 static const struct of_device_id fimc_of_match[];
 
-- 
2.1.2

