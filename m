Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbbAHCah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:30:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbbAHCab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:30:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509086917"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [RFC Patch 04/19] ACPI: Let the parser return false for disabled resources
Date: Thu,  8 Jan 2015 10:32:51 +0800
Message-Id: <1420684386-5975-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

If the parser disables a resource during parsing, let it return false,
so the calling code does not need to implement further checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c0578c05e2c2..deb70a839f80 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -219,10 +219,10 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 		res->flags = IORESOURCE_BUS;
 		break;
 	default:
-		res->flags = 0;
+		return false;
 	}
 
-	return true;
+	return !(res->flags & IORESOURCE_DISABLED);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
 
@@ -267,10 +267,10 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
 		res->flags = IORESOURCE_BUS;
 		break;
 	default:
-		res->flags = 0;
+		return false;
 	}
 
-	return true;
+	return !(res->flags & IORESOURCE_DISABLED);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_ext_address_space);
 
-- 
1.7.10.4

