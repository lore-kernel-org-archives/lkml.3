Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbaLLS1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:27:00 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40420 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaLLS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:26:58 -0500
From: Eduardo Valentin <edubezval@gmail.com>
To: Linux PM <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 1/2] thermal: db8500: Do not print error message in the EPROBE_DEFER case
Date: Fri, 12 Dec 2014 10:14:24 -0400
Message-Id: <1418393665-16850-2-git-send-email-edubezval@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418393665-16850-1-git-send-email-edubezval@gmail.com>
References: <1418393665-16850-1-git-send-email-edubezval@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid printing the error message in the EPROBE_DEFER case
where registering cpu cooling at db8500 thermal driver.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/thermal/db8500_cpufreq_cooling.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
index 3cc3dd9..28bbff9 100644
--- a/drivers/thermal/db8500_cpufreq_cooling.c
+++ b/drivers/thermal/db8500_cpufreq_cooling.c
@@ -30,8 +30,14 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
 
 	cdev = cpufreq_cooling_register(cpu_present_mask);
 	if (IS_ERR(cdev)) {
-		dev_err(&pdev->dev, "Failed to register cooling device\n");
-		return PTR_ERR(cdev);
+		int ret = PTR_ERR(cdev);
+
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"Failed to register cooling device %d\n",
+				ret);
+				
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, cdev);
-- 
2.1.3

