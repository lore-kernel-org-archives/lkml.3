Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbbA1U04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:26:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:34810 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbbA1U0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:26:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269063"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch v2 15/22] ACPI: Add field offset to struct resource_list_entry
Date: Wed, 28 Jan 2015 18:57:33 +0800
Message-Id: <1422442660-455-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add field offset to struct resource_list_entry to host address space
translation offset so it could be used to represent bridge resources.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |    1 +
 include/linux/acpi.h    |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 4dc8cfb2e94e..1c3abae6f2fa 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -472,6 +472,7 @@ static acpi_status acpi_dev_new_resource_entry(struct resource_win *win,
 		return AE_NO_MEMORY;
 	}
 	rentry->res = win->res;
+	rentry->offset = win->offset;
 	list_add_tail(&rentry->node, c->list);
 	c->count++;
 	return AE_OK;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index be9eaee8f4ae..21dac3cb62d2 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -303,6 +303,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 struct resource_list_entry {
 	struct list_head node;
 	struct resource res;
+	resource_size_t offset;
 };
 
 void acpi_dev_free_resource_list(struct list_head *list);
-- 
1.7.10.4

