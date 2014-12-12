Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbaLLP0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:26:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:6440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759909AbaLLP0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:26:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807740"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 26/26] iommu/vt-d: Add a command line parameter for VT-d posted-interrupts
Date: Fri, 12 Dec 2014 23:15:00 +0800
Message-Id: <1418397300-10870-27-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable VT-d Posted-Interrtups and add a command line
parameter for it.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 Documentation/kernel-parameters.txt |  1 +
 drivers/iommu/irq_remapping.c       | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 838f377..324b790 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1453,6 +1453,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			nosid	disable Source ID checking
 			no_x2apic_optout
 				BIOS x2APIC opt-out request will be ignored
+			nopost	disable Interrupt Posting
 
 	iomem=		Disable strict checking of access to MMIO memory
 		strict	regions from userspace.
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index b008663..aa3cd23 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -24,7 +24,7 @@ int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
-int disable_irq_post = 1;
+int disable_irq_post = 0;
 
 static struct irq_remap_ops *remap_ops;
 
@@ -59,14 +59,18 @@ static __init int setup_irqremap(char *str)
 		return -EINVAL;
 
 	while (*str) {
-		if (!strncmp(str, "on", 2))
+		if (!strncmp(str, "on", 2)) {
 			disable_irq_remap = 0;
-		else if (!strncmp(str, "off", 3))
+			disable_irq_post = 0;
+		} else if (!strncmp(str, "off", 3)) {
 			disable_irq_remap = 1;
-		else if (!strncmp(str, "nosid", 5))
+			disable_irq_post = 1;
+		} else if (!strncmp(str, "nosid", 5))
 			disable_sourceid_checking = 1;
 		else if (!strncmp(str, "no_x2apic_optout", 16))
 			no_x2apic_optout = 1;
+		else if (!strncmp(str, "nopost", 6))
+			disable_irq_post = 1;
 
 		str += strcspn(str, ",");
 		while (*str == ',')
-- 
1.9.1

