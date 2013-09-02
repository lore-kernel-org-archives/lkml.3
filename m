Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3IBEHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 00:07:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3IBEHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 00:07:04 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v2 4/6] ACPI / processor: remove some dead code in acpi_processor_get_info()
Date: Mon,  2 Sep 2013 11:57:37 +0800
Message-Id: <1378094259-5922-5-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
References: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

errata.smp is used by nowhere, so the variable assignment is meanless,
remove it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/acpi_processor.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 66c9b70..5364d02 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -220,9 +220,6 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	acpi_status status = AE_OK;
 	static int cpu0_initialized;
 
-	if (num_online_cpus() > 1)
-		errata.smp = TRUE;
-
 	acpi_processor_errata(pr);
 
 	/*
-- 
1.7.9.5

