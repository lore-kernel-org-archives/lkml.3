Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3I0CZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:25:35 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42751 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3I0CZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:25:31 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 3/6] cpuidle: calxeda: add ecx-2000 support
Date: Thu, 26 Sep 2013 21:24:51 -0500
Message-Id: <1380248694-13388-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add cpuidle support for Calxeda ecx-2000 SoC.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
---
 drivers/cpuidle/cpuidle-calxeda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
index b04767a..c6e9d80 100644
--- a/drivers/cpuidle/cpuidle-calxeda.c
+++ b/drivers/cpuidle/cpuidle-calxeda.c
@@ -66,7 +66,9 @@ static struct cpuidle_driver calxeda_idle_driver = {
 
 static int __init calxeda_cpuidle_init(void)
 {
-	if (!of_machine_is_compatible("calxeda,highbank") || !psci_ops.cpu_suspend)
+	if (!of_machine_is_compatible("calxeda,highbank") ||
+	    !of_machine_is_compatible("calxeda,ecx-2000") ||
+	    !psci_ops.cpu_suspend)
 		return -ENODEV;
 
 	return cpuidle_register(&calxeda_idle_driver, NULL);
-- 
1.8.1.2

