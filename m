Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaBHVV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:21:59 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50266 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaBHVV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:21:56 -0500
Message-ID: <1391894514.19595.5.camel@x220>
Subject: [PATCH] iommu: shmobile: depend on ARCH_SHMOBILE
From: Paul Bolle <pebolle@tiscali.nl>
To: Joerg Roedel <joro@8bytes.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Feb 2014 22:21:54 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2014 21:21:55.0274 (UTC) FILETIME=[CAB8AAA0:01CF2513]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 78a2e12f51d9 ("iommu: shmobile: Enable driver compilation with
COMPILE_TEST") added an optional dependency on SH_MOBILE. But that
Kconfig symbol doesn't exist. It seems ARCH_SHMOBILE was intended. Use
that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Completely untested.

 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 79bbc21..df56e4c 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -207,7 +207,7 @@ config SHMOBILE_IOMMU
 	bool "IOMMU for Renesas IPMMU/IPMMUI"
 	default n
 	depends on ARM
-	depends on SH_MOBILE || COMPILE_TEST
+	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select IOMMU_API
 	select ARM_DMA_USE_IOMMU
 	select SHMOBILE_IPMMU
-- 
1.8.5.3

