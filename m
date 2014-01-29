Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaA2EUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:20:45 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18218 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbaA2EUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:20:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EACqB6FKl5H4J/2dsb2JhbABahka6WIEldIMlGIE5iAXJNheOfx2EIgSYKJIfg0Eo
From: Alistair Popple <alistair@popple.id.au>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, olaf@aepfle.de, benh@kernel.crashing.org,
        Alistair Popple <alistair@popple.id.au>
Subject: [PATCH] powerpc/iommu: Fix initialisation of DART iommu table
Date: Wed, 29 Jan 2014 15:20:12 +1100
Message-Id: <1390969212-20758-1-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d084775738b746648d4102337163a04534a02982 switched the generic
powerpc iommu backend code to use the it_page_shift field to determine
page size. Commit 3a553170d35d69bea3877bffa508489dfa6f133d should have
initiliased this field for all platforms, however the DART iommu table
code was not updated.

This commit initialises the it_page_shift field to 4K for the DART
iommu.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
---
 arch/powerpc/sysdev/dart_iommu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index bd968a4..62c47bb 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -292,6 +292,7 @@ static void iommu_table_dart_setup(void)
 	iommu_table_dart.it_offset = 0;
 	/* it_size is in number of entries */
 	iommu_table_dart.it_size = dart_tablesize / sizeof(u32);
+	iommu_table_dart.it_page_shift = IOMMU_PAGE_SHIFT_4K;
 
 	/* Initialize the common IOMMU code */
 	iommu_table_dart.it_base = (unsigned long)dart_vbase;
-- 
1.7.10.4

