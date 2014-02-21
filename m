Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaBUM0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:26:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56324 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaBUM0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:22 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-cc-530745ecc22e
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
Subject: [PATCH v5 11/11] powerpc: add support for reserved memory defined by
 device tree
Date: Fri, 21 Feb 2014 13:25:27 +0100
Message-id: <1392985527-6260-12-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xq7pvXNmDDZp3aVr8nXSM3eJDUyuz
	xftlPYwW84+cY7Xof7OQ1eLAnx2MFm96O1gsdq57x2hxtukNu8X2zhnsFl+uPGSy2PT4GqvF
	wrYlLBaXd81hs1h75C67xYaXB5ksll6/yGSx4HgLq8Wf6XIWp65/ZrNYc2Qxu8WE6WtZLFr3
	HmG3+Lt9E4vFq4NtLBbrZ7xmsVi16w+jxcuPJ1gcZDzWzFvD6PH71yRGj9eTJzB6XO7rZfLY
	Oesuu0fPmxZWj02rOtk87lzbw+axeUm9x+1/j5k9rpxoYvVY9+cVk0f/XwOPubv6GD36tqxi
	9Pi8SS5AMIrLJiU1J7MstUjfLoEr40nfbqaCJZwVm+euZmlgvM3excjJISFgIjHh8FM2CFtM
	4sK99UA2F4eQwFJGiVe9t6GcbiaJva+fg3WwCRhKdL3tAusQEVjIKPF5HgtIEbPAfTaJjos9
	TCAJYYFoia/fZjOC2CwCqhJ9jw6ygti8Ah4Stz68BxrEAbROQWLOJBuQMCdQ+MyB52BhIQF3
	iXUdWRMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECInHLzsYFx+zOsQowMGoxMNb
	IMEWLMSaWFZcmXuIUYKDWUmE96A+e7AQb0piZVVqUX58UWlOavEhRiYOTqkGxjnTrb7+1j16
	w/3ObsUH6x+47dxw7+vlrcLvOdxmx73pD9txaUbj/nceX9wn3ha7M+Nbc0VeZtRWtndv5aT2
	34rckLx8EZPE6+mXpv06/zXY89IH2Tipp7OYTmsJzZGV92Ro97con73W7XjuRQPrDXsKtil2
	LNH/3jx530LLtgoGlfX3zjcff6SsxFKckWioxVxUnAgA1iN3T6UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reserved memory initialization from device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/powerpc/Kconfig       |    1 +
 arch/powerpc/kernel/prom.c |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 957bf344c0f5..3b6617fed8fc 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -90,6 +90,7 @@ config PPC
 	select BINFMT_ELF
 	select OF
 	select OF_EARLY_FLATTREE
+	select OF_RESERVED_MEM
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index f58c0d3aaeb4..591986215801 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/memblock.h>
 #include <linux/of.h>
+#include <linux/of_fdt.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -588,6 +589,8 @@ static void __init early_reserve_mem_dt(void)
 			memblock_reserve(base, size);
 		}
 	}
+
+	early_init_fdt_scan_reserved_mem();
 }
 
 static void __init early_reserve_mem(void)
-- 
1.7.9.5

