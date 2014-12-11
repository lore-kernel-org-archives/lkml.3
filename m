Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbaLKWa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:30:58 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:51493 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758838AbaLKWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:30:57 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, msalter@redhat.com, tj@kernel.org,
        hdegoede@redhat.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH] sata: xgene: add ACPI support for APM X-Gene SATA ports
Date: Thu, 11 Dec 2014 14:31:10 -0800
Message-Id: <1418337070-17644-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds ACPI support for the APM X-Gene SATA ports. When the system
boots using ACPI table, the SATA ports are able to configure using the
values supplied by the ACPI table rather than the DTS.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/ata/ahci_xgene.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index d0c851a..4951392 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -22,6 +22,7 @@
  * NOTE: PM support is not currently available.
  *
  */
+#include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/ahci_platform.h>
@@ -521,6 +522,14 @@ disable_resources:
 	return rc;
 }
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id xgene_ahci_acpi_match[] = {
+	{ "APMC0D0D", },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
+#endif
+
 static const struct of_device_id xgene_ahci_of_match[] = {
 	{.compatible = "apm,xgene-ahci"},
 	{},
@@ -534,6 +543,7 @@ static struct platform_driver xgene_ahci_driver = {
 		.name = "xgene-ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = xgene_ahci_of_match,
+		.acpi_match_table = ACPI_PTR(xgene_ahci_acpi_match),
 	},
 };
 
-- 
1.9.1

