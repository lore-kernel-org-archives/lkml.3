Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbbAHCdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:33:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:27186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbbAHCa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:30:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509087038"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC Patch 12/19] ACPI: Enforce stricter checks for address space descriptors
Date: Thu,  8 Jan 2015 10:32:59 +0800
Message-Id: <1420684386-5975-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce stricter checks for address space descriptors according to
ACPI spec.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 26b47f1da523..e82149e44347 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -192,6 +192,14 @@ static bool acpi_decode_space(struct resource *res,
 	bool wp = base->info.mem.write_protect;
 	u64 len = addr->address_length;
 
+	/*
+	 * Filter out invalid descriptor according to ACPI Spec 5.0, section
+	 * 6.4.3.5 Address Space Resource Descriptors.
+	 */
+	if ((base->min_address_fixed != base->max_address_fixed && len) ||
+	    (base->min_address_fixed && base->max_address_fixed && !len))
+		return false;
+
 	res->start = addr->minimum;
 	res->end = addr->maximum;
 
-- 
1.7.10.4

