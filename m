Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3B1QpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:45:22 -0500
Received: from [84.200.39.61] ([84.200.39.61]:48611 "EHLO smtp.eikelenboom.it"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759003Ab3B1QpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:45:19 -0500
Date: Thu, 28 Feb 2013 17:45:10 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <928867757.20130228174510@eikelenboom.it>
To: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
CC: linux-ide@vger.kernel.org
Subject: libata-acpi.c ata_acpi_register_power_resource copy and paste mistake ?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

During the last merge of ahci code (d9978ec5680059d727b39d6c706777c6973587f2), i saw this coming by:


--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1024,30 +1024,20 @@ static void ata_acpi_register_power_resource(struct ata_device *dev)
 {
        struct scsi_device *sdev = dev->sdev;
        acpi_handle handle;
-       struct device *device;
 
        handle = ata_dev_acpi_handle(dev);
-       if (!handle)
-               return;
-
-       device = &sdev->sdev_gendev;
-
-       acpi_power_resource_register_device(device, handle);
+       if (handle)
+               acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
 }

shouldn't:

acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);

be

acpi_dev_pm_add_dependent(handle, &sdev->sdev_gendev);

in the ata_acpi_register_power_resource function ?

(seems like a copy and paste mistake from the unregister function)

--
Sander



