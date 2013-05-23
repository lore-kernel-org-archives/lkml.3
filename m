Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3EWMo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:44:58 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62594 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241Ab3EWMo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:44:56 -0400
Message-ID: <519E0F2A.4070602@linaro.org>
Date: Thu, 23 May 2013 20:44:26 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
although the chances are small, I think it should be fixed.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_driver.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index bec717f..dd64f23 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -579,6 +579,10 @@ static int __cpuinit acpi_processor_add(struct acpi_device
*device)
        per_cpu(processors, pr->id) = pr;

        dev = get_cpu_device(pr->id);
+       if (!dev) {
+               result = -ENODEV;
+               goto err_clear_processor;
+       }
        if (sysfs_create_link(&device->dev.kobj, &dev->kobj, "sysdev")) {
                result = -EFAULT;
                goto err_clear_processor;
-- 
1.7.1
