Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3CALRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:17:38 -0500
Received: from [84.200.39.61] ([84.200.39.61]:41301 "EHLO smtp.eikelenboom.it"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3CALRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:17:36 -0500
From: Sander Eikelenboom <linux@eikelenboom.it>
To: rjw@sisk.pl
Cc: Sander Eikelenboom <linux@eikelenboom.it>, aaron.lu@intel.com,
        jgarzik@pobox.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH] libata-acpi.c: fix copy and paste mistake in ata_acpi_register_power_resource
Date: Fri,  1 Mar 2013 12:16:42 +0100
Message-Id: <1362136602-30327-1-git-send-email-linux@eikelenboom.it>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <2508494.4AbRYXD1du@vostro.rjw.lan>
References: <2508494.4AbRYXD1du@vostro.rjw.lan>
To: rjw@sisk.pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a copy and paste mistake introduced in:

commit bc9b6407bd6df3ab7189e5622816bbc11ae9d2d8
"ACPI / PM: Rework the handling of devices depending on power resources"

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 drivers/ata/libata-acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 0ea1018..cb3eab6d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1027,7 +1027,7 @@ static void ata_acpi_register_power_resource(struct ata_device *dev)
 
 	handle = ata_dev_acpi_handle(dev);
 	if (handle)
-		acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
+		acpi_dev_pm_add_dependent(handle, &sdev->sdev_gendev);
 }
 
 static void ata_acpi_unregister_power_resource(struct ata_device *dev)
-- 
1.7.2.5

