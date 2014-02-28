Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaB1NoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:44:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23790 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaB1NnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:21 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-4e-531092788412
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
Subject: [PATCH v6 10/11] arm64: add support for reserved memory defined by
 device tree
Date: Fri, 28 Feb 2014 14:42:55 +0100
Message-id: <1393594976-16728-11-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRW0iTYQCG+/79h7la/a0pP1ImgzAiT9XFh4gURnwrwsAuMiFdOtTYVDYn
	mkQy1OY8jQVq02xLZ7Gmxsp0wyBt6DAq15ZGzkOsi9RZ1jQ6zNWcdy8Pz8t78bJZPC0ezS4q
	LhPLikUSAcnBXwUn3sdXaOnMpHduHG5qxym4pqxlwW+9jQDes78hYIvPQMAXgWEAfU0qHFr7
	vwL4Wumj4FB9OwXX3Z8waPFOE9BQ14NDl62ThH32OQo+XhrFoHHGiUH9RA0BA20xcHLGT0Kz
	vZuCmrY+HNY+t1Nwc8iCw+XROhwOtK/g0GQLALj03YGf3I/MXWaA/v7RArRyWwOQq7kJQ1bd
	HIUafTUEspjqSeSZHiHRk56baDboZSG3Q0mg/sAyhlo2k9BdWzNAzU9NAPktMRf2Xuak5osl
	ReViWWJaLqewYVEFSh9SFfMNX8hqUE+qQQSboU8w3a4P2HaOYqbmB8KcRxsBYwhkqAEnlBsw
	JjjkDkskncyoV9VhiU8bAOPvwrckFr1AMipnY1jaR2cxtskN1lbG6UOMeqE1XODSQmb991qo
	wA6txTKd2tQtHBHC1W0LxPYwYmZ/zQAN4OrBDhOIFCvySuVXC6THEuQiqVxRXJCQVyK1gO0f
	N4aBcTxlDNBsINjF1Qj3ZPIIUbm8UjoGGDZLwOd+VtKZPG6+qPK6WFaSI1NIxPIxgLEjoqtB
	ypLQ65nK8qRVxdY9yvEE0/+lX9yNIs26QfGpEVyYbY36SOqOtxrvB0aqblyxH345qDoq5NsH
	8TNwuFzX/zb3QWvGJehYPDCa6JF1REqcyHUnm/bzz/7MqXToT8etKA7Wdqzqn+10xuWdE5y3
	tnfd6k3eKEP2HwJvafzqNQEuLxQlH2HJ5KL/kD+pbaUCAAA=
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

