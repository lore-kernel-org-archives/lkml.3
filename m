Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3FZKH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:07:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11351 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3FZKH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:07:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 26 Jun 2013 03:04:01 -0700
From: Wei Ni <wni@nvidia.com>
To: <a.zummo@towertech.it>, <ldewangan@nvidia.com>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH] rtc: palmas: init wakeup before device register
Date: Wed, 26 Jun 2013 18:05:37 +0800
Message-ID: <1372241137-8175-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable dev as wakeup device before calling rtc_device_register(),
so that it can create the "wakealarm" sysfs.

Signed-off-by: Wei Ni <wni@nvidia.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-palmas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index 50204d4..a1fecc8 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -265,6 +265,7 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 
 	palmas_rtc->irq = platform_get_irq(pdev, 0);
 
+	device_init_wakeup(&pdev->dev, 1);
 	palmas_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&palmas_rtc_ops, THIS_MODULE);
 	if (IS_ERR(palmas_rtc->rtc)) {
@@ -283,7 +284,6 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	device_set_wakeup_capable(&pdev->dev, 1);
 	return 0;
 }
 
-- 
1.7.9.5

