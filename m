Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3G1D6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 23:58:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47407 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3G1D6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 23:58:46 -0400
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: mrustad@gmail.com, bhelgaas@google.com, yinghai@kernel.org,
        jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, jiang.liu@huawei.com,
        linux-pci@vger.kernel.org, joe.jin@oracle.com,
        "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH v3] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
Date: Sat, 27 Jul 2013 16:39:41 -0400
Message-Id: <1374957581-5542-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2: Corrected code style and tested for Linux v 3.11-rc2
V3: Fix the no space betwween words typo and keep the string in one line.

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 arch/x86/pci/mmconfig-shared.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..619b74b 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -700,8 +700,12 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 	if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
 		return -ENODEV;
 
-	if (start > end)
+	 if (start > end || !addr) {
+		 dev_warn(dev, FW_INFO
+			"Invalid address to add MMCONFIG start %02x end %02x addr %pR\n",
+			start, end, addr);
 		return -EINVAL;
+	}
 
 	mutex_lock(&pci_mmcfg_lock);
 	cfg = pci_mmconfig_lookup(seg, start);
@@ -716,11 +720,6 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 		return -EEXIST;
 	}
 
-	if (!addr) {
-		mutex_unlock(&pci_mmcfg_lock);
-		return -EINVAL;
-	}
-
 	rc = -EBUSY;
 	cfg = pci_mmconfig_alloc(seg, start, end, addr);
 	if (cfg == NULL) {
-- 
1.7.1

