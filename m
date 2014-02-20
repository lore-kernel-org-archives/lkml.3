Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaBTKxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:53:09 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9267 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaBTKxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:53:05 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-6a-5305de8f476a
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
Subject: [PATCH v4 7/7] powerpc: add support for reserved memory defined by
 device tree
Date: Thu, 20 Feb 2014 11:52:47 +0100
Message-id: <1392893567-31623-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xK7r991iDDd58E7T4O+kYu8WHplZm
	i/fLehgt5h85x2rR/2Yhq8WBPzsYLd70drBY7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaL
	hW1LWCwu75rDZrH2yF12iw0vDzJZLL1+kcliwfEWVos/0+UsTl3/zGax5shidosJ09eyWLTu
	PcJu8Xf7JhaLVwfbWCzWz3jNYrFq1x9Gi5cfT7A4yHismbeG0eP3r0mMHq8nT2D0uNzXy+Sx
	c9Zddo+eNy2sHptWdbJ53Lm2h81j85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYec3f1MXr0bVnF
	6PF5k1yAYBSXTUpqTmZZapG+XQJXxrPehywFazkrNp9aydrA+IS9i5GTQ0LAROL53U9MELaY
	xIV769m6GLk4hASWMkr8XbCCFSQhJNDNJPH6uTeIzSZgKNH1tosNxBYRWMgo8XkeC0gDs8B9
	NomOiz1gk4QFIiVWnH3FAmKzCKhKtO2fxgxi8wp4SLxcMx8ozgG0TUFiziQbkDCngKdE8727
	ULs8JHbNusw6gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQePyyg3HxMatDjAIc
	jEo8vBHXWYKFWBPLiitzDzFKcDArifBuu8kaLMSbklhZlVqUH19UmpNafIiRiYNTqoFRk9Nr
	95HL0wtvl2wRilCe2SvrMLkgzqEiU/tWxKfZj5KDVinzr39UESP/wsNYSpC3z4drc9C+/Ls5
	yx2UOo3uPykWk5lTu2qJ8Q6vQLt+kYu3P8g8nXjbg4XPIcdIsOK7sN6/yxqn5B3ZanZumSb7
	4Qeb3v7E2MbLqw38xf9uWBuddCPPJVuJpTgj0VCLuag4EQCFqE4jpQIAAA==
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
index f58c0d3aaeb4..b814262a2048 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/memblock.h>
 #include <linux/of.h>
+#include <linux/of_reserved_mem.h>
 
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

