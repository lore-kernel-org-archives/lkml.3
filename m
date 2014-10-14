Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaJNKKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:10:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55660 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaJNKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:10:43 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] s5p-jpeg: Only build suspend/resume for PM
Date: Tue, 14 Oct 2014 12:10:40 +0200
Message-Id: <1413281440-2710-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

If power management is disabled these function become unused, so there
is no reason to build them. This fixes a couple of build warnings when
PM(_SLEEP,_RUNTIME) is not enabled.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- add #endif comment for readability
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e525a7c8d885..ec7339e84b57 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2632,6 +2632,7 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 static int s5p_jpeg_runtime_suspend(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
@@ -2681,7 +2682,9 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 
 	return 0;
 }
+#endif /* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_SLEEP
 static int s5p_jpeg_suspend(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
@@ -2697,6 +2700,7 @@ static int s5p_jpeg_resume(struct device *dev)
 
 	return s5p_jpeg_runtime_resume(dev);
 }
+#endif
 
 static const struct dev_pm_ops s5p_jpeg_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(s5p_jpeg_suspend, s5p_jpeg_resume)
-- 
2.1.2

