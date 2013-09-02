Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3IBEIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 00:08:38 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36805 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3IBEIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 00:08:36 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v2 5/6] ACPI / processor: remove unnecessary if (!pr) check
Date: Mon,  2 Sep 2013 11:57:38 +0800
Message-Id: <1378094259-5922-6-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
References: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_processor_errata() is only called in acpi_processor_get_info(),
and the argument 'pr' passed to acpi_processor_errata() will never be
NULL, so the if (!pr) check is unnecessary and can be removed.

Since the 'pr' argument is not used by acpi_processor_errata() any more,
so change the argument into void too.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/acpi_processor.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 5364d02..7ce0750 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -140,15 +140,11 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 	return 0;
 }
 
-static int acpi_processor_errata(struct acpi_processor *pr)
+static int acpi_processor_errata(void)
 {
 	int result = 0;
 	struct pci_dev *dev = NULL;
 
-
-	if (!pr)
-		return -EINVAL;
-
 	/*
 	 * PIIX4
 	 */
@@ -220,7 +216,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	acpi_status status = AE_OK;
 	static int cpu0_initialized;
 
-	acpi_processor_errata(pr);
+	acpi_processor_errata();
 
 	/*
 	 * Check to see if we have bus mastering arbitration control.  This
-- 
1.7.9.5

