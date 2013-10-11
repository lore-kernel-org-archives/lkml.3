Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab3JKMUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:20:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:23512 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3JKMUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:20:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1080,1371106800"; 
   d="scan'208";a="306591654"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org, bhelgaas@google.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Resend PATCH 1/5] ACPI/Resource: Add memory prefetch check support
Date: Fri, 11 Oct 2013 20:18:57 +0800
Message-Id: <1381493941-4650-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
References: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

This patch is to check mem address space's acpi resource caching ability
and set prefetch flag of struct resource if it's prefetchable.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index b7201fc..929f416 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -202,6 +202,9 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 		res->flags = acpi_dev_memresource_flags(len,
 						addr.info.mem.write_protect,
 						window);
+
+		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
+			res->flags |= IORESOURCE_PREFETCH;
 		break;
 	case ACPI_IO_RANGE:
 		io_decode = addr.granularity == 0xfff ?
-- 
1.8.2.1

