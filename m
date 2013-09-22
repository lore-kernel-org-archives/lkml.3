Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3IVLGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 07:06:24 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44081 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3IVLGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 07:06:23 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Toshi Kani <toshi.kani@hp.com>, linux-acpi@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] Staging / quickstart: remove reduplicate if(acpi_disabled) check
Date: Sun, 22 Sep 2013 19:05:47 +0800
Message-Id: <1379847947-32366-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_bus_register_driver(), there is an if (acpi_disabled) check,
so the if(acpi_disabled) before it is reduplicate, remove it.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/staging/quickstart/quickstart.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
index 4247d60..9f6ebdb 100644
--- a/drivers/staging/quickstart/quickstart.c
+++ b/drivers/staging/quickstart/quickstart.c
@@ -390,10 +390,6 @@ static int __init quickstart_init(void)
 {
 	int ret;
 
-	/* ACPI Check */
-	if (acpi_disabled)
-		return -ENODEV;
-
 	/* ACPI driver register */
 	ret = acpi_bus_register_driver(&quickstart_acpi_driver);
 	if (ret)
-- 
1.7.9.5

