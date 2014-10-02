Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaJBHVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:21:33 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65307 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJBHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:21:32 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s5p-jpeg: Only build suspend/resume for PM
Date: Thu,  2 Oct 2014 09:21:29 +0200
Message-Id: <1412234489-1330-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

If power management is disabled these function become unused, so there
is no reason to build them. This fixes a couple of build warnings when
PM(_SLEEP,_RUNTIME) is not enabled.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index e525a7c8d885..cc5d6bd40256 100644
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
+#endif
 
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
2.1.0

