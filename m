Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaKSPup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:50:45 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63886 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaKSPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:50:41 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org
Subject: [PATCH] thermal: sti: Ignore suspend/resume functions when !PM
Date: Wed, 19 Nov 2014 15:50:31 +0000
Message-Id: <1416412231-2752-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevents build warning:

st_thermal.c:278:12:
    warning: ‘st_thermal_suspend’ defined but not used [-Wunused-function]
st_thermal.c:286:12:
    warning: ‘st_thermal_resume’ defined but not used [-Wunused-function]

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---

v1 => v2:
 - CONFIG_PM => CONFIG_PM_SLEEP suggested by David Paris.

 drivers/thermal/st/st_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
index 90163b3..d1ec580 100644
--- a/drivers/thermal/st/st_thermal.c
+++ b/drivers/thermal/st/st_thermal.c
@@ -275,6 +275,7 @@ int st_thermal_unregister(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(st_thermal_unregister);
 
+#ifdef CONFIG_PM_SLEEP
 static int st_thermal_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -305,6 +306,8 @@ static int st_thermal_resume(struct device *dev)
 
 	return 0;
 }
+#endif
+
 SIMPLE_DEV_PM_OPS(st_thermal_pm_ops, st_thermal_suspend, st_thermal_resume);
 EXPORT_SYMBOL_GPL(st_thermal_pm_ops);
 
-- 
1.9.1

