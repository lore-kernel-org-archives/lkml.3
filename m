Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3JKMUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:20:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:53424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3JKMUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1080,1371106800"; 
   d="scan'208";a="415445797"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org, bhelgaas@google.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Resend PATCH 2/5] ACPI/Resource: Add address translation support
Date: Fri, 11 Oct 2013 20:18:58 +0800
Message-Id: <1381493941-4650-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
References: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

According ACPI 5.0 spec Section 19.1.8
"For bridges, translate addresses across the bridge, this is the
offset that must be added to the address on the secondary side
to obtain the address on the primary side. Non-bridge devices
must list 0."

This patch is to add address translation offset to the start/end
of struct resource in the acpi_dev_resource_address_space().
Further more, non-bridge device's translation_offset should 0.
So this change will affect other devices.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 929f416..84bc3db 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -192,8 +192,8 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 	if (ACPI_FAILURE(status))
 		return true;
 
-	res->start = addr.minimum;
-	res->end = addr.maximum;
+	res->start = addr.minimum + addr.translation_offset;
+	res->end = addr.maximum + addr.translation_offset;
 	window = addr.producer_consumer == ACPI_PRODUCER;
 
 	switch(addr.resource_type) {
-- 
1.8.2.1

