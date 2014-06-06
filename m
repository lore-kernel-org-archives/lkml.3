Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaFFIoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:44:21 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57961 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFFIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:17 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] powerpc/powernv: Applying it_page_shift to platform code
Date: Fri,  6 Jun 2014 18:44:00 +1000
Message-Id: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-0260-0000-0000-0000051649CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is what I got for powernv in order to support variable page size
in iommu_table.

I am very uncertain about Patch #4 "Add @it_owner to iommu_table struct"
and wonder if there any better way to get PE from iommu_table.

Please comment. Thanks.


Alexey Kardashevskiy (6):
  powerpc/powernv: use it_page_shift for TCE invalidation
  powerpc/powernv: use it_page_shift in TCE build
  powerpc/powernv: Add a page size parameter to
    pnv_pci_setup_iommu_table()
  powerpc/powernv: Add @it_owner to iommu_table struct
  powerpc/powernv: Make set_bypass() callback a type
  powerpc/powernv: Make invalidate() callback an iommu_table callback

 arch/powerpc/include/asm/iommu.h            | 13 ++++++-
 arch/powerpc/platforms/powernv/pci-ioda.c   | 55 ++++++++++++++---------------
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  3 +-
 arch/powerpc/platforms/powernv/pci.c        | 43 +++++++++++++++-------
 arch/powerpc/platforms/powernv/pci.h        |  7 ++--
 5 files changed, 74 insertions(+), 47 deletions(-)

-- 
2.0.0

