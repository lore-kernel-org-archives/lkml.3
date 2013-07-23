Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab3GWLuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:50:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60241 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab3GWLud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:50:33 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH] drivers/rtc/rtc-twl.c: fix: rtcX/wakealarm attribute isn't created
Date: Tue, 23 Jul 2013 14:48:33 +0300
Message-ID: <1374580113-7474-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device_init_wakeup() should be called before rtc_device_register().
Otherwise, sysfs "sys/class/rtc/rtcX/wakealarm" attribute will not be
seen from User space.

CC: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/rtc/rtc-twl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 02faf3c..c2e80d7 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -524,6 +524,8 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	rtc = rtc_device_register(pdev->name,
 				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -542,7 +544,6 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
-	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
-- 
1.7.9.5

