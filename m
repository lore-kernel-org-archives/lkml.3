Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaLUVSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:18:46 -0500
Received: from sauhun.de ([89.238.76.85]:52935 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbaLUVPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:45 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org
Subject: [PATCH 19/28] thermal: int340x_thermal: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:40 +0100
Message-Id: <1419196495-9626-20-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/thermal/int340x_thermal/int3400_thermal.c | 1 -
 drivers/thermal/int340x_thermal/int3402_thermal.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/thermal/int340x_thermal/int3400_thermal.c b/drivers/thermal/int340x_thermal/int3400_thermal.c
index dcb306ea14a4..65a98a97df07 100644
--- a/drivers/thermal/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/int340x_thermal/int3400_thermal.c
@@ -335,7 +335,6 @@ static struct platform_driver int3400_thermal_driver = {
 	.remove = int3400_thermal_remove,
 	.driver = {
 		   .name = "int3400 thermal",
-		   .owner = THIS_MODULE,
 		   .acpi_match_table = ACPI_PTR(int3400_thermal_match),
 		   },
 };
diff --git a/drivers/thermal/int340x_thermal/int3402_thermal.c b/drivers/thermal/int340x_thermal/int3402_thermal.c
index a5d08c14ba24..c5cbc3af3a05 100644
--- a/drivers/thermal/int340x_thermal/int3402_thermal.c
+++ b/drivers/thermal/int340x_thermal/int3402_thermal.c
@@ -231,7 +231,6 @@ static struct platform_driver int3402_thermal_driver = {
 	.remove = int3402_thermal_remove,
 	.driver = {
 		   .name = "int3402 thermal",
-		   .owner = THIS_MODULE,
 		   .acpi_match_table = int3402_thermal_match,
 		   },
 };
-- 
2.1.3

