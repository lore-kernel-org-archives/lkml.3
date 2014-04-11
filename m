Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaDKIKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:10:16 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:6354 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaDKIKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:10:02 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <nicolas.pitre@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.com>,
        <m.szyprowski@samsung.com>, Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH v2 0/2] change ARM linux memory layout to support 32 CPUs
Date: Fri, 11 Apr 2014 16:00:50 +0800
Message-ID: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas or Russell,

This patch series change fixmap mapping region to suppport 32 CPUs.
Because the "top_pmd" covers 0xfffe0000 - 0xffffffff(2M). And part 
is used by vector table. So I move this region down to 0xffc00000
 - 0xffdffff. 


I have tested the patches on arma9(2 CPUs) and arma15(16 CPUs) platforms

BTW, As we know we can configure NR_CPUS up to 32. So we need 2048K 
at most. But for ARM systems with less cpus, there is a waste 
of virtual address. So should we change its size according to
NR_CPUS, as what MIPS linux does ?

Changes from v1:
---------------
- changed documentation for ARM linux memory layout.
- moved fixmap mapping region, not just extended.

Liu Hua (2):
  ARM : DMA : remove useless information about DMA
  ARM : extend fixmap mapping region to support 32 CPUs

 Documentation/arm/memory.txt   |  8 ++------
 arch/arm/include/asm/fixmap.h  |  4 ++--
 arch/arm/include/asm/highmem.h |  1 +
 arch/arm/include/asm/memory.h  |  2 --
 arch/arm/mm/highmem.c          | 10 +++++-----
 arch/arm/mm/mm.h               |  7 +++++++
 arch/arm/mm/mmu.c              |  4 ++++
 mm/highmem.c                   |  1 +
 8 files changed, 22 insertions(+), 15 deletions(-)

-- 
1.9.0

