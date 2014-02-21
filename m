Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaBUM11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:27:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63463 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaBUM0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:21 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-c5-530745eb45e1
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
Subject: [PATCH v5 10/11] arm64: add support for reserved memory defined by
 device tree
Date: Fri, 21 Feb 2014 13:25:26 +0100
Message-id: <1392985527-6260-11-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWReUiTYQDGe7fv2nD1NU3eJCSEiAyvinyJJRaJb4oWGERF1JrDGW7KlpYS
	ZfNgm9cySikzTa2YOscKPFDRMY+8SpwapUtZl2eKUqBT8sv/fvweHp4/HoYvfkj4MImqW3K1
	SprkRwmJ/s2e0YC5CDoueG1gL9oo7qbRkjaHj36/ygfohX2IREXzlSTqcDcBNF+gI1CzeRGg
	Qe08jRr1pTRadUzzkNU1RqLK3GoCjbSUUajePkkjy0wnD9WMD/NQRU82idwlvqhvfIVCdfYq
	GhlL6gmU02an0UajlUCznbkEaiidI5CpxQ3QzHIvEb4P15XXAby+Vgzw3CMjwCOFBTzc/HSS
	xvnz2SS2mvQUnhhrpfDb6vv4y6aLjx29WhKb3bM8XLQRjJ+3FAJc+M4E8IrV9/zuy0JJvDwp
	MU2uDgq7LlTkTelAyhv6jjPvF5UJ9JQBCBjIHoN2p42/zd7wo7NhywsZMVsD4PfMDoILxGwe
	D3Y/hhxTbAg0LBj+l73YSgBXygmuwGe/UlA3nM/jAk/2EsxasACOCfYAzLG30xyLWAz1rvek
	ATBba/thWbGE04ItPdDxk+a0mI2EZt1NIxBVgB0msEeeKkvR3EhQhgRqpEpNqiohUJastILt
	G1ebQFX3CRtgGeDnIUqBVJyYlKZp0pU2ABm+n5eoM4iOE4vipekZcnXyNXVqklxjAzxG4JMJ
	Kv+Mek9m9V2sd8We3fWhP6DrttE2cRVKdLK04+62k3cXj9bmMp8jl6dlXQnQ99lojONJbO/f
	hNDBB23jKjBVa3GGDQ1End5J36M2uhZazc0mf/0FtcU3ql37MmwyOvqbOlTZ/cPzyqdT+Ydj
	Xq9LwhWCMxEeRzKSlxznDh0cVvgRGoU0xJ+v1kj/AfeAx2KkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reserved memory initialization from device tree.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm64/Kconfig   |    1 +
 arch/arm64/mm/init.c |    1 +
 2 files changed, 2 insertions(+)

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
index d0b4c2efda90..3fb8d50dfdaa 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -160,6 +160,7 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(base, size);
 	}
 
+	early_init_fdt_scan_reserved_mem();
 	dma_contiguous_reserve(0);
 
 	memblock_allow_resize();
-- 
1.7.9.5

