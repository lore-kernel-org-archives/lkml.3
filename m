Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbbA1UX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:23:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:50867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767AbbA1UXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677268831"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v2 05/22] ACPI: Let the parser return false for disabled resources
Date: Wed, 28 Jan 2015 18:57:23 +0800
Message-Id: <1422442660-455-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
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
index 16d291c60277..cdb1a3c4a0b9 100644
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
 
@@ -268,10 +268,10 @@ bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
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

