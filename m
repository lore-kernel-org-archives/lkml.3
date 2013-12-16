Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3LPUua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:50:30 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:52094 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3LPUu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:50:29 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] rtc: s5m: s5m_rtc_{suspend,resume}() should depend on CONFIG_PM_SLEEP
Date: Mon, 16 Dec 2013 21:50:14 +0100
Message-Id: <1387227014-28274-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_SLEEP=n:

drivers/rtc/rtc-s5m.c:643: warning: ‘s5m_rtc_resume’ defined but not used
drivers/rtc/rtc-s5m.c:654: warning: ‘s5m_rtc_suspend’ defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/rtc/rtc-s5m.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index ae8119dc2846..476af93543f6 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -639,6 +639,7 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	s5m_rtc_enable_smpl(info, false);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int s5m_rtc_resume(struct device *dev)
 {
 	struct s5m_rtc_info *info = dev_get_drvdata(dev);
@@ -660,6 +661,7 @@ static int s5m_rtc_suspend(struct device *dev)
 
 	return ret;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops, s5m_rtc_suspend, s5m_rtc_resume);
 
-- 
1.7.9.5

