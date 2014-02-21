Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaBUM1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:27:50 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56314 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbaBUM0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:19 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-be-530745ea4c5f
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
Subject: [PATCH v5 09/11] arm: add support for reserved memory defined by
 device tree
Date: Fri, 21 Feb 2014 13:25:25 +0100
Message-id: <1392985527-6260-10-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xq7qvXNmDDfa+57b4O+kYu8WHplZm
	i/fLehgt5h85x2rR/2Yhq8WBPzsYLd70drBY7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaL
	hW1LWCwu75rDZrH2yF12iw0vDzJZLL1+kcliwfEWVos/0+UsTl3/zGax5shidosJ09eyWLTu
	PcJu8Xf7JhaLVwfbWCzWz3jNYrFq1x9Gi5cfT7A4yHismbeG0eP3r0mMHq8nT2D0uNzXy+Sx
	c9Zddo+eNy2sHptWdbJ53Lm2h81j85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYec3f1MXr0bVnF
	6PF5k1yAYBSXTUpqTmZZapG+XQJXxuOtH9gLnrJXTH3ewdjAuIati5GTQ0LARGLdu9nsELaY
	xIV764HiXBxCAksZJVZcuswM4XQzSbxtWMIKUsUmYCjR9bYLrFtEYCGjxOd5LCBFzAL32SQ6
	LvYwgSSEBcIlDi+aB1bEIqAq8X76TLAVvAIeEg93LACq4QBapyAxZ5INSJgTKHzmwHN2kLCQ
	gLvEuo6sCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExOOXHYyLj1kdYhTgYFTi
	4S2QYAsWYk0sK67MPcQowcGsJMJ7UJ89WIg3JbGyKrUoP76oNCe1+BAjEwenVANj7fJdkzkT
	L7/OSNmWGRfovL3y0+mj3N5Od5MfV/ztKkq8cC/n+yPdj3H6s1UUXoieO8by6nb1l91nXxpF
	abVKPZs5X8rkht8SjfZzHm8j/Zu0NTkyTwrLMRWbHYi+9dI5+5FfhrDdkWu5H72VTnlmPnlz
	q/f0f8l2+S9/JxsfbDNJ9vDeFcqmxFKckWioxVxUnAgAx96RFqUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reserved memory initialization from device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/Kconfig   |    1 +
 arch/arm/mm/init.c |    2 ++
 2 files changed, 3 insertions(+)

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
index 804d61566a53..2a77ba8796ae 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -323,6 +323,8 @@ void __init arm_memblock_init(struct meminfo *mi,
 	if (mdesc->reserve)
 		mdesc->reserve();
 
+	early_init_fdt_scan_reserved_mem();
+
 	/*
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
-- 
1.7.9.5

