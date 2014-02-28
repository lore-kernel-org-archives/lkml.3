Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaB1NoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:44:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29579 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaB1NnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:20 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-28-5310927652ac
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
Subject: [PATCH v6 09/11] arm: add support for reserved memory defined by
 device tree
Date: Fri, 28 Feb 2014 14:42:54 +0100
Message-id: <1393594976-16728-10-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0hTYRzGe8/OzjlbDo/T4iClpYgUZM6CXkIyv71GoGgWFGEnHSo5lU1H
	BqEtJ3rysiailZeGsw9zXpjlZdhFWZtoiua11LSmlLrKmIjVZjn99vyf5/f79Kd4Yi3uT6Vn
	5kjlmWxGECHEh7ZtkyeUWjoh/N3kKejWWkm4rlLz4M9npQA2WEb4sMKh48M3rm4AHWXFOOxp
	/QHgsMpBwq6SGhJuTHzGoMk+xYe6Ij0Ox821BGyxzJOwfaUPg03TYxh8aivkQ1d1ABycdhLQ
	aGkkoaa6BYfqlxYSurtMOFztK8JhW80aDg1mF4Arvwbw84eQsd4I0N8/WoDWKjUAjZeXYajn
	8TyJSh2FfGQylBBobqqXQB36fDS7beehiQEVH7W6VjFU4Q5HdeZygMqfGwBymgLifK4KI1Ok
	GelKqfzkuRvCNPuLdTJ7mbxd9bUYFAAjwQEBxdCnmYVXHby9fJAZ/dS20wspMd0EmM7mt2Dv
	eIAxxoYvfA9F0BKG+87t2n60DjDOetwD8egFgikeK8U8gy99hamaq9gVcDqE2awb3BEoSkTH
	MNbGC57I0EeYWm2khxDstAXVC7u0mEbM7NY00ADRU7DPAA5Ic5OzFTdTZZIwBStT5GamhiVn
	yUxg748b3aDRerYf0BQI8hJpYrwTxHxWqciT9QOG4gX5iZZUdIJYlMLm3ZHKs5LkuRlSRT/A
	KIF/AZByvqIke6hTG//bGpJ4ZltzrO5fu3sx6tL1153c3WEbJ47a5CJusfe6vj00z8SKYj+M
	HG5CgTNRS9HckFK3Zr6c2LmlTgzXLcqu3Y+OyPdeDo3br/cZmuutLAl8pFZTzRdlqet6JtQr
	3paT/2TUO/jj0Xjz0vtgVjAscWaNB+GKNFZynCdXsP8BL3SwbqUCAAA=
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

