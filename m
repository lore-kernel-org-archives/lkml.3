Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaBTKxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:53:55 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9267 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaBTKxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:53:04 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-37-5305de8d5a77
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
Subject: [PATCH v4 6/7] arm64: add support for reserved memory defined by
 device tree
Date: Thu, 20 Feb 2014 11:52:46 +0100
Message-id: <1392893567-31623-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyXRXUjTURgG8M72/9ps9XdqHEREBl2oaBolJzHJLuJ0E9FIxQtt6VLLqWwp
	GWRrfi+dc0KamSmp0PCLpamrWY6lVrhcDofUZmY3zpWWfVhNyendj/fh4bl4Ga5QRwQzuflX
	pfJ8SZ6I4hNvtibtUXUuUhxjsyWgTd0EjdZUFVy02l0L0AOLlUT1ng4SvfCOAOSpqybQaN9X
	gKZVHhoN1zTT6Id9kYMMS3Mk6qjsJNCssZVCvRYnjQaWxzmoy2HjoPbJchJ5m0LRa8c6hXos
	D2mkbeolUIXJQqPNYQOB3OOVBOpvXiGQ3ugFaPnbFHEiBPe09QD8768O4JVGLcCzmjoOHm1x
	0rjWU05ig76Gwh/mnlH4cedN/H5riYvtUyoS93ndHFy/GYPvGzUAawb1AK8bQs/6p/ETsqR5
	ucVS+aHEC/wcu9ZBF24w15wbDZQSGGk14DGQPQKtViW56wNwxtVPqQGfEbJdAC6bVglfIGRv
	c6B5RugzxcZC9Rc15XMg2wHgehvhK3DZBQpW22o5viCATYEfh27tmGAPwsG3n3csYDGsWhza
	NrO9FgZbdQm+M489DctcTnJ3C0NjyyypBYJ2sEcPgqRFmYWKi9myw9EKiUxRlJ8dnVkgM4Dd
	P/4cAV0T8WbAMkC0V5DqIMRCUlKsKJGZAWS4okDBk3lSLBRkSUquS+UFGfKiPKnCDDgML1gJ
	7ihd4qd+r0olHvVAwK+mcHEqvBye1v9HmyXfiivwZgbzzg3H+6+xrVV0CIzj6+HGvLU00tqY
	8k5vvhQQZDn68rfbrTp1MqItPXFf2Fhy0n5T9bHnpeP3zkR2Zwx8ClyNX7ibPlZ5nJdkb5h+
	5IrSmG4oyoA++cr3To/fzPkREaHIkcRGcOUKyX8DABzepQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reserved memory initialization from device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm64/Kconfig   |    1 +
 arch/arm64/mm/init.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 27bbcfc7202a..6abf15407dca 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -43,6 +43,7 @@ config ARM64
 	select NO_BOOTMEM
 	select OF
 	select OF_EARLY_FLATTREE
+	select OF_RESERVED_MEM
 	select PERF_USE_VMALLOC
 	select POWER_RESET
 	select POWER_SUPPLY
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index d0b4c2efda90..447550d6bd9b 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -30,6 +30,7 @@
 #include <linux/memblock.h>
 #include <linux/sort.h>
 #include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/dma-contiguous.h>
 
 #include <asm/sections.h>
@@ -160,6 +161,7 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(base, size);
 	}
 
+	early_init_fdt_scan_reserved_mem();
 	dma_contiguous_reserve(0);
 
 	memblock_allow_resize();
-- 
1.7.9.5

