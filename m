Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaIQBAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:00:09 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56632 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaIQBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:00:07 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] mfd: ssbi: promote the driver to subsys level
Date: Wed, 17 Sep 2014 01:59:54 +0100
Message-Id: <1410915594-15599-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch promtes the driver to be at subsystem level as this driver
will be used by gpio controller drivers which inturn are used by many
platform drivers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mfd/ssbi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
index b78942e..4fbe02e 100644
--- a/drivers/mfd/ssbi.c
+++ b/drivers/mfd/ssbi.c
@@ -331,7 +331,12 @@ static struct platform_driver ssbi_driver = {
 		.of_match_table = ssbi_match_table,
 	},
 };
-module_platform_driver(ssbi_driver);
+
+static int ssbi_init(void)
+{
+	return platform_driver_register(&ssbi_driver);
+}
+subsys_initcall(ssbi_init);
 
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION("1.0");
-- 
1.9.1

