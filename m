Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbaGXCbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 22:31:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:61771 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbaGXCbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 22:31:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,721,1400050800"; 
   d="scan'208";a="574547455"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: iommu/vt-d: Fix build error caused by unknown definition of acpi_handle
Date: Thu, 24 Jul 2014 10:33:27 +0800
Message-Id: <1406169208-11097-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140723153420.GC14017@8bytes.org>
References: <20140723153420.GC14017@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When both CONFIG_ACPI and CONFIG_DMAR_TABLE are disabled, commit
"Implement DMAR unit hotplug framework" causes build failure as below:
  CC      arch/x86/kernel/pci-dma.o
In file included from arch/x86/kernel/pci-dma.c:3:0:
include/linux/dmar.h:168:35: error: unknown type name ‘acpi_handle’
 static inline int dmar_device_add(acpi_handle handle)
                                   ^
include/linux/dmar.h:173:38: error: unknown type name ‘acpi_handle’
 static inline int dmar_device_remove(acpi_handle handle)
                                      ^
make[2]: *** [arch/x86/kernel/pci-dma.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Joerg,
	Could you please help to merge or fold this patch to fix the
build error?
Regards!
Gerry
---
 include/linux/dmar.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 9c06bb4b5b14..594d4ac79e75 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -165,12 +165,12 @@ static inline int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
 
 #else /* CONFIG_DMAR_TABLE */
 
-static inline int dmar_device_add(acpi_handle handle)
+static inline int dmar_device_add(void *handle)
 {
 	return 0;
 }
 
-static inline int dmar_device_remove(acpi_handle handle)
+static inline int dmar_device_remove(void *handle)
 {
 	return 0;
 }
-- 
1.7.10.4

