Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaEEI1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:27:45 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49777 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbaEEI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:27:43 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [Patch v3 1/5] driver: cpuidle-big-little: add of_device_id structure
Date: Mon,  5 May 2014 13:57:20 +0530
Message-Id: <1399278444-8312-2-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399278444-8312-1-git-send-email-chander.kashyap@linaro.org>
References: <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
 <1399278444-8312-1-git-send-email-chander.kashyap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver will be used by many big.Little Soc's. As of now it does
string matching of hardcoded compatible string to init the driver. This
comparison list will keep on growing with addition of new SoC's.
Hence add of_device_id structure to collect the compatible strings of
SoC's using this driver.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
---
 drivers/cpuidle/cpuidle-big_little.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
index b45fc62..4cd02bd 100644
--- a/drivers/cpuidle/cpuidle-big_little.c
+++ b/drivers/cpuidle/cpuidle-big_little.c
@@ -163,14 +163,23 @@ static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
 	return 0;
 }
 
+static const struct of_device_id compatible_machine_match[] = {
+	{ .compatible = "arm,vexpress,v2p-ca15_a7" },
+	{},
+};
+
 static int __init bl_idle_init(void)
 {
 	int ret;
+	struct device_node *root = of_find_node_by_path("/");
+
+	if (!root)
+		return -ENODEV;
 
 	/*
 	 * Initialize the driver just for a compliant set of machines
 	 */
-	if (!of_machine_is_compatible("arm,vexpress,v2p-ca15_a7"))
+	if (!of_match_node(compatible_machine_match, root))
 		return -ENODEV;
 	/*
 	 * For now the differentiation between little and big cores
-- 
1.7.9.5

