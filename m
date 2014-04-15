Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaDOLOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:14:23 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:22998 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaDOLOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:14:20 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <nicolas.pitre@linaro.org>, <linux@arm.linux.org.uk>
CC: <will.deacon@arm.com>, <vitalya@ti.com>, <cyril@ti.com>,
        <santosh.shilimkar@ti.com>, <lauraa@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.co>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH v3 0/2] change ARM linux memory layout to support 32 CPUs
Date: Tue, 15 Apr 2014 19:06:05 +0800
Message-ID: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series change fixmap mapping region to suppport 32 CPUs.
Because the "top_pmd" covers 0xfffe0000 - 0xffffffff(2M). And part 
is used by vector table. So I move this region down to 0xffc00000
 - 0xffdffff. 


I have tested the patches on arma9(2 CPUs) and arma15(16 CPUs) platforms

Changes from v2:
---------------
- Removed two macros: FIX_KMAP_BEGIN and FIX_KMAP_END;
- Unchanged DMA mapping region related documentation; 

Changes from v1:
---------------
- changed documentation for ARM linux memory layout.
- moved fixmap mapping region, not just extended.


Liu Hua (2):
  ARM : fixmap : remove FIX_KMAP_BEGIN and FIX_KMAP_END
  ARM : change fixmap mapping region to support 32 CPUs

 Documentation/arm/memory.txt   |  2 +-
 arch/arm/include/asm/fixmap.h  | 21 ++++-----------------
 arch/arm/include/asm/highmem.h |  1 +
 arch/arm/mm/highmem.c          | 33 ++++++++++++++++++++++++---------
 arch/arm/mm/mmu.c              |  4 ++++
 5 files changed, 34 insertions(+), 27 deletions(-)

-- 
1.9.0

