Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaJBIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:48:19 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60118 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJBIsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:48:14 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s5p-fimc: Only build suspend/resume for PM
Date: Thu,  2 Oct 2014 10:48:11 +0200
Message-Id: <1412239691-28719-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

If power management is disabled these functions become unused, so there
is no reason to build them. This fixes a couple of build warnings when
PM(_SLEEP,_RUNTIME) is not enabled.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index b70fd996d794..8e7435bfa1f9 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -832,6 +832,7 @@ err:
 	return -ENXIO;
 }
 
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
 static int fimc_m2m_suspend(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -870,6 +871,7 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 
 	return 0;
 }
+#endif
 
 static const struct of_device_id fimc_of_match[];
 
-- 
2.1.0

