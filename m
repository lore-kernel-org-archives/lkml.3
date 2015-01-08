Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbbAHCaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:30:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbbAHCat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:30:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509086993"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC Patch 09/19] ACPI: Fix a bug in parsing ACPI Memroy24 resource
Date: Thu,  8 Jan 2015 10:32:56 +0800
Message-Id: <1420684386-5975-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to ACPI spec 5, section 6.4.3.1 "24-Bit Memory Range Descriptor",
minimum, maximum and address_length field in struct acpi_resource_memory24
is in granularity of 256-bytes. So shift 8-bit left to get correct address.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index abe3a29ad802..f4aeef22a9d8 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -90,8 +90,8 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
 	switch (ares->type) {
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		memory24 = &ares->data.memory24;
-		acpi_dev_get_memresource(res, memory24->minimum,
-					 memory24->address_length,
+		acpi_dev_get_memresource(res, memory24->minimum << 8,
+					 memory24->address_length << 8,
 					 memory24->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
-- 
1.7.10.4

