Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaL2NtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:49:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:46873 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaL2NtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:49:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="630363975"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c / ACPI: Pick the first address if device has multiple
Date: Mon, 29 Dec 2014 15:48:48 +0200
Message-Id: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI specification allows I2C devices with multiple addresses. The current
implementation goes over all addresses and assigns the last one to the
device. This is typically not the primary address of the device.

Instead of doing that we assign the first address to the device and then
let the driver handle rest of the addresses as it wishes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/i2c/i2c-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 39d25a8cb1ad..a06be43b7842 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -102,7 +102,7 @@ static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
 		struct acpi_resource_i2c_serialbus *sb;
 
 		sb = &ares->data.i2c_serial_bus;
-		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
+		if (!info->addr && sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
 			info->addr = sb->slave_address;
 			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
 				info->flags |= I2C_CLIENT_TEN;
-- 
2.1.4

