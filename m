Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaIPVOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:14:16 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39639 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaIPVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:14:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@gmail.com>
To: dvhart@infradead.org, mjg59@srcf.ucam.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        peter.ujfalusi@gmail.com
Subject: [PATCH 1/2] intel-rst: Use ACPI_FAILURE() macro instead !ACPI_SUCCESS() for error checking
Date: Wed, 17 Sep 2014 00:13:55 +0300
Message-Id: <1410902036-10282-2-git-send-email-peter.ujfalusi@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
References: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI_SUCCESS is defined as:
#define ACPI_SUCCESS(a)			(!(a))

There is no need for the the double ! since there is already a macro
defined for failures: ACPI_FAILURE()

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
---
 drivers/platform/x86/intel-rst.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
index d45bca3..8c6a8fe 100644
--- a/drivers/platform/x86/intel-rst.c
+++ b/drivers/platform/x86/intel-rst.c
@@ -35,7 +35,7 @@ static ssize_t irst_show_wakeup_events(struct device *dev,
 	acpi = to_acpi_device(dev);
 
 	status = acpi_evaluate_integer(acpi->handle, "GFFS", NULL, &value);
-	if (!ACPI_SUCCESS(status))
+	if (ACPI_FAILURE(status))
 		return -EINVAL;
 
 	return sprintf(buf, "%lld\n", value);
@@ -59,7 +59,7 @@ static ssize_t irst_store_wakeup_events(struct device *dev,
 
 	status = acpi_execute_simple_method(acpi->handle, "SFFS", value);
 
-	if (!ACPI_SUCCESS(status))
+	if (ACPI_FAILURE(status))
 		return -EINVAL;
 
 	return count;
@@ -81,7 +81,7 @@ static ssize_t irst_show_wakeup_time(struct device *dev,
 	acpi = to_acpi_device(dev);
 
 	status = acpi_evaluate_integer(acpi->handle, "GFTV", NULL, &value);
-	if (!ACPI_SUCCESS(status))
+	if (ACPI_FAILURE(status))
 		return -EINVAL;
 
 	return sprintf(buf, "%lld\n", value);
@@ -105,7 +105,7 @@ static ssize_t irst_store_wakeup_time(struct device *dev,
 
 	status = acpi_execute_simple_method(acpi->handle, "SFTV", value);
 
-	if (!ACPI_SUCCESS(status))
+	if (ACPI_FAILURE(status))
 		return -EINVAL;
 
 	return count;
-- 
2.1.0

