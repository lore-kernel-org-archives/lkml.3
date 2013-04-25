Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3DYOOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:14:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40846 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab3DYOOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:14:50 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Hongbo Zhang <hongbo.zhang@stericsson.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH 2/2] thermal: db8500_cpufreq_cooling: remove usage of IS_ERR_OR_NULL()
Date: Thu, 25 Apr 2013 10:13:34 -0400
Message-ID: <1366899214-22639-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com>
References: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
macro. This macro can lead to dangerous results, like returning
success (0) during a failure scenario (NULL pointer handling).

The case present in this driver can be translated to a simple
check for IS_ERR(), as the cpufreq_cooling_register() returns
either a valid pointer or an ERR_PTR().

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Hongbo Zhang <hongbo.zhang@stericsson.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/db8500_cpufreq_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
index 21419851..786d192 100644
--- a/drivers/thermal/db8500_cpufreq_cooling.c
+++ b/drivers/thermal/db8500_cpufreq_cooling.c
@@ -37,7 +37,7 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
 	cpumask_set_cpu(0, &mask_val);
 	cdev = cpufreq_cooling_register(&mask_val);
 
-	if (IS_ERR_OR_NULL(cdev)) {
+	if (IS_ERR(cdev)) {
 		dev_err(&pdev->dev, "Failed to register cooling device\n");
 		return PTR_ERR(cdev);
 	}
-- 
1.8.2.1.342.gfa7285d

