Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab3BFXBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:01:20 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:11626 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3BFXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:01:14 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, linux-acpi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, bhelgaas@google.com,
        mika.westerberg@linux.intel.com, matthew.garrett@nebula.com,
        yinghai@kernel.org, liuj97@gmail.com, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 01/02] ACPI: sysfs eject support for ACPI scan handlers
Date: Wed,  6 Feb 2013 15:50:55 -0700
Message-Id: <1360191056-13293-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360191056-13293-1-git-send-email-toshi.kani@hp.com>
References: <1360191056-13293-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed sysfs eject, acpi_eject_store(), to support ACPI scan handlers.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index cfd7a69..3ff632e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -203,7 +203,7 @@ acpi_eject_store(struct device *d, struct device_attribute *attr,
 		return -EINVAL;
 	}
 #ifndef FORCE_EJECT
-	if (acpi_device->driver == NULL) {
+	if (!acpi_device->driver && !acpi_device->handler) {
 		ret = -ENODEV;
 		goto err;
 	}
