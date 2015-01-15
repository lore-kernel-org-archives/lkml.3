Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbbAONDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:03:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbbAONCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:02:52 -0500
Date: Thu, 15 Jan 2015 05:02:23 -0800
From: tip-bot for Joerg Roedel <tipbot@zytor.com>
Message-ID: <tip-84d0779304b5c45134311dfc31b5a2325ce3ad84@git.kernel.org>
Cc: joro@8bytes.org, tglx@linutronix.de, bp@alien8.de, hpa@zytor.com,
        jiang.liu@linux.intel.com, tony.luck@intel.com, mingo@kernel.org,
        jroedel@suse.de, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, yinghai@kernel.org
Reply-To: yinghai@kernel.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, jroedel@suse.de, mingo@kernel.org,
        jiang.liu@linux.intel.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, joro@8bytes.org, tglx@linutronix.de
In-Reply-To: <1420615903-28253-13-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-13-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/amd:
  Check for irq-remap support amd_iommu_prepare()
Git-Commit-ID: 84d0779304b5c45134311dfc31b5a2325ce3ad84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84d0779304b5c45134311dfc31b5a2325ce3ad84
Gitweb:     http://git.kernel.org/tip/84d0779304b5c45134311dfc31b5a2325ce3ad84
Author:     Joerg Roedel <jroedel@suse.de>
AuthorDate: Wed, 7 Jan 2015 15:31:39 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

iommu/amd: Check for irq-remap support amd_iommu_prepare()

This allows to get rid of the irq_remapping_supported() function and
all its call-backs into the Intel and AMD IOMMU drivers.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1420615903-28253-13-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/amd_iommu_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index b0522f1..0039f87 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2123,6 +2123,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
 #ifdef CONFIG_IRQ_REMAP
 int __init amd_iommu_prepare(void)
 {
+	if (!amd_iommu_irq_remap)
+		return -1;
+
 	return iommu_go_to_state(IOMMU_ACPI_FINISHED);
 }
 
