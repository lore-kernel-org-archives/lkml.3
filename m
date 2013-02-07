Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161068Ab3BGVaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:30:05 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:21348 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161008Ab3BGVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:30:04 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Unbind ACPI drv when probe failed
Date: Thu,  7 Feb 2013 14:19:13 -0700
Message-Id: <1360271953-15643-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_device_install_notify_handler() failed in acpi_device_probe(),
it calls acpi_drv->ops.remove() and fails the probe.  However, the ACPI
driver is left bound to the acpi_device.  Fix it by clearing the driver
and driver_data fields.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
This patch is based on linux-pm.git/bleeding-edge.
---
 drivers/acpi/scan.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d6caf1d..39659bb 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -627,6 +627,8 @@ static int acpi_device_probe(struct device * dev)
 			if (ret) {
 				if (acpi_drv->ops.remove)
 					acpi_drv->ops.remove(acpi_dev);
+				acpi_dev->driver = NULL;
+				acpi_dev->driver_data = NULL;
 				return ret;
 			}
 		}
