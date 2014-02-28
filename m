Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaB1NoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:44:11 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23790 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaB1NnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:22 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-32-531092798323
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
Subject: [PATCH v6 11/11] powerpc: add support for reserved memory defined by
 device tree
Date: Fri, 28 Feb 2014 14:42:56 +0100
Message-id: <1393594976-16728-12-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAy2Ra0hTYRzGe8/OzjkbDo+b1kHEalFg4S0MXkokFOy1oAK/hBFz6lDBqexi
	atJsqcyl25igEl5m3mhemYFuJaUslaJItJkuG6ZUumWGEqab5bJvv//z/8Hz4aFYfCMeSuXm
	KySyfHGekODir/cm30eWGOnUmPpuAfQZJ0i4oa5kwR9dNQC22t+yod7TxoYvvCMAemo1OLT2
	rwP4Ru0h4XB1Iwm3ZpcwaFl2sGFbVQcOZ2xNBOyzL5JwcHUMg51z0xg0TVawobchHL6a2yRg
	r72dhIaGPhxWjtpJ6Bu24HBtrAqHA41uHJptXgBXf07hF8NQb0svQLs7RoDcdQaAZnS1GLI+
	XCRRjaeCjSzmagJ9dDwj0FCHCjn3lllodkrNRv3eNQzpfTGo2aYDSPfEDNCmJfx6UBo3PkuS
	l1skkUUnpHNzVnRPscIOTvFQcw9eDpykFlAUQ8cxW8sRWsDZx8PMu08DhBZwKT7dCZj2z27y
	4HiAMfd3BnG/RdCxjPa7lvBzMN0GmM0W3C+xaBfBaKZrMP9DQN9krM/1/yScPsnsqndZfubR
	Kcyws+5/8zGmyRjvjzn7cXmDi+1nPo0Y5/YcMACeCRwygxCJMrNQnpEtjY2Si6VyZX52VGaB
	1AIOdtwaAe0T58cBTQFhAM+QEpjKZ4uL5CXSccBQLGEwb0VNp/J5WeKSUomsQCRT5knk4wCj
	OKHlQGArhurFb4rOFFSm/318/mjypa+j3KDmqWuKpJDuiI3bf1RnJTaf5l4XvpAucvng1fkj
	2JLIGhctSpTpz3y5HHk3IfrROY3S5Gq9o+t3X0myF6nCSk8Zym6Ybm2L1l9ewAMEHxwd9WGJ
	1h5V8sIJoUObllGoyPz1WDNoDNQIcXmOOPY0SyYX/wU9PlwApQIAAA==
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

