Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaFFIpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:45:44 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47752 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaFFIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:19 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] powerpc/powernv: Make set_bypass() callback a type
Date: Fri,  6 Jun 2014 18:44:05 +1000
Message-Id: <1402044246-13650-6-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-3568-0000-0000-000005A33722
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are going to be other callbacks which are going to be used as
function parameters so change the existing set_bypass() callback to be
a type.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index f503a5c..2bc8f8c 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -65,6 +65,7 @@ struct iommu_owner {
 	unsigned char __unused[0];
 };
 
+typedef void (*iommu_set_bypass_fn)(struct iommu_table *tbl, bool enable);
 struct iommu_table {
 	unsigned long  it_busno;     /* Bus number this table belongs to */
 	unsigned long  it_size;      /* Size of iommu table in entries */
@@ -82,7 +83,7 @@ struct iommu_table {
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *it_group;
 #endif
-	void (*set_bypass)(struct iommu_table *tbl, bool enable);
+	iommu_set_bypass_fn set_bypass;
 	struct iommu_owner *it_owner;
 };
 
-- 
2.0.0

