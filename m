Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaBTKz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:55:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63238 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaBTKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:53:02 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-5a-5305de8ca8e0
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 5/7] arm: add support for reserved memory defined by device
 tree
Date: Thu, 20 Feb 2014 11:52:45 +0100
Message-id: <1392893567-31623-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0iTYRiGe7+zw9HnPPRhYjIQRfAEBm8mZRT49kMyxIgoatOh0qayL0VD
	0kxNl6e0pYiZog4Z87Qk3SinY+nUMk1TzNREQqZLKwXD1HL673ru54L7x83goirCk0lOuSdT
	pkjkYkpAjO4PTQWWLJCxIV/6/eFe5SANf+YV4HBDUwLgS8sYCcvtjSTs3+0F0F5aREBD+zqA
	H/LsNOwprqHh1tQSBvXL0yRsLGwm4KSxjoJtlnkadtoGMNgyM4HBhqF8Eu5We8ORmU0K6ixN
	NKyobiNgwVsLDfd69ARcHSgkYEfNGgG1xl0Abb+sRKQX0tXrAPq7UwnQWlUFQJNlpRgy1M7T
	qMSeTyK9tphCX6ffUOhVcw6a21/G0ZQ1j0Ttu6sYKt8LQS+MZQCVdWsB2tR7x7jcEEQkyOTJ
	GTJl8Lk7giTbugmkWZ0y/xj+0blgg1YBJ4Zjw7g+21NwxB7c+EIHpQICRsS2AO5j8wR2dDzB
	uKXFIsphUWwop/qhOmQ3thFwm/WEQ8LZRYormijBHA9XNo5Td7/HHUywvpxN00s6WMgiLu/x
	94M65qDOh6urjHDETuxl7tHC/KEiOlCMtZNkBRA2gGNa4C5Lj0/jpYmK0CBeouDTUxKD4lMV
	enA05FYvaBoMNwOWAWJn4fUZIlZESjL4LIUZcAwudhO+niVjRcIESdZ9mTL1tjJdLuPNAGOc
	PHOBny7aGhko+JyaM+q+bZqT/8aCca8LUueZq10GjW+2yr81MFv9cPtbofpuH/su7lm4accg
	w59HRQlau1Zdzp8aU0uv8+bhB4HHM0/3nbQNu6pX6sxXdGFnNW2mE2G3Oi75Sfdnx5PsnT7C
	T9P1XM/N0IvX+gNGolcsMWc8pkWDYoJPkoQG4Epe8h+2YKRwpgIAAA==
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
index 804d61566a53..eee55d75bbfa 100644
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
 
+	early_init_fdt_scan_reserved_mem();
+
 	/*
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
-- 
1.7.9.5

