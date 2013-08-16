Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3HPKIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:08:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47920 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3HPKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:08:20 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: aik@ozlabs.ru, benh@au1.ibm.com, paulus@au1.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH 2/2] powerpc/iommu: check dev->iommu_group before remove a device from iommu_group
Date: Fri, 16 Aug 2013 18:08:07 +0800
Message-Id: <1376647687-20550-3-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081609-9574-0000-0000-000009353915
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/powerpc/kernel/iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b20ff17..5abf7c3 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1149,7 +1149,8 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	case BUS_NOTIFY_ADD_DEVICE:
 		return iommu_add_device(dev);
 	case BUS_NOTIFY_DEL_DEVICE:
-		iommu_del_device(dev);
+		if (dev->iommu_group)
+			iommu_del_device(dev);
 		return 0;
 	default:
 		return 0;
-- 
1.7.5.4

