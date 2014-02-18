Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaBRNmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:42:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61831 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbaBRNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:42:03 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-2d-530363290fda
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v3 5/6] ARM: init: add support for reserved memory defined by
 device tree
Date: Tue, 18 Feb 2014 14:38:00 +0100
Message-id: <1392730681-14695-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
References: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRW0iTYQCG+/7T/o0GP8vqb4HFwgtFTdPgoySlpL5uIpNu1Kilf7p0OjZP
	y4vGcB5GOtELJXRtOTHNaa3EOSrcGmmGnWZaHrNFoc4DKF20KblJd8/L+8B78dK4yESIaVlh
	MacslBZIKAHxbtvLxERm4+lxjpFEuNX4hgfXtTocPnC/J6HBZybhUMAOoK+uhoCDvasAjml9
	PDhQ28KDm+MLGLR5J0horrIQ0ONopaDVPcuDTxadGOyY/IRB03AlCQPN4XB0coOCDc1WAupe
	unlwa8BGwCVnFQH7WpYJ2O0IgJRDqMfYA5D/byNAy00NAHnq6zA0eH+Wh+75Kklk666l0MzE
	Cwo9s9xF09teHI2PaEnUG1jCkGErDtU/7wZowxaOnrZdvcxkCJJyuAJZKac8fuaGIO/b5jSl
	GOaX60drMA1Y5ekBn2aZRHb2VRu+ywfYj3N9lB4IaBHzELA6Yx+5G3QYuzK/SgUtioln9Sv6
	EIcxZsBuGImghDPNFNvevxYq9jGZrHXRGGKCiWDbF+wgyEIGsWv+3ztz9M7cUba1MSmIfOYi
	uzkZHTREO0b/vBdvAEIT2NMN9nOKbIXqZq48PlYllatKCnNjs4vkNhD67ZfYDro00AUYGkj2
	CtePYekiUlqqUstdgKVxSZgwMgNPFwlzpOo7nLLourKkgFO5wGGakBwUDulOp4mYXGkxl89x
	Ck75v8VovlgDsrKijkSfmpqzXGjrEPEzIyRwWCCTnXydqPqZWu2q9c05Uz5Mfa3R+Mk0Q68X
	vL2kLa82DXZ99khWHv/hn8toik64dtsSuGXw26VlyannuZhAwmjXWPG6A335/kPdOT/lcc40
	Aau6Io8L78y3C1xDyWUnKq64xY/OJsXFmCWEKk8aH4UrVdJ/jZifDLMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reserved memory initialization from device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/Kconfig   |    1 +
 arch/arm/mm/init.c |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e25419817791..d0262bea8020 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1918,6 +1918,7 @@ config USE_OF
 	select IRQ_DOMAIN
 	select OF
 	select OF_EARLY_FLATTREE
+	select OF_RESERVED_MEM
 	help
 	  Include support for flattened device tree machine descriptions.
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 804d61566a53..ebafdb479410 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -17,6 +17,7 @@
 #include <linux/nodemask.h>
 #include <linux/initrd.h>
 #include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
@@ -323,6 +324,8 @@ void __init arm_memblock_init(struct meminfo *mi,
 	if (mdesc->reserve)
 		mdesc->reserve();
 
+	early_init_dt_scan_reserved_mem();
+
 	/*
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
-- 
1.7.9.5

