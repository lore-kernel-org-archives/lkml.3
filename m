Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaD2FAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:00:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64263 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaD2E7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:59:25 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-f6-535f31ac06e2
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v4 3/7] arm64: Introduce a kernel configuration option for
 VA_BITS
Date: Tue, 29 Apr 2014 13:59:23 +0900
Message-id: <000301cf6367$ca12e150$5e38a3f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jZVrJFchiuwljR/2ghksfz/LPsQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zI901hvHBBm/ni1r8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	wx3BBe94K7obVjA3MK7g7mLk5JAQMJE4tuMeK4QtJnHh3nq2LkYuDiGBZYwSyyadYexi5AAr
	mtBTCRFfxChxevIVqKI/jBLf9vczgXSzCWhKPLrbww6SEBHYwSgxee0iVhCHWeAho8TPt/uZ
	QaqEBUIkZnduZgIZyyKgKrH5mQtImFfAUuLeyndsELagxI/J91hAbGYBLYn1O48zQdjyEpvX
	vGWGOFVBYsfZ14wgtoiAnsTd3jnMEDUiEvtevGOEqOnlkDjxmhPEZhEQkPg2+RALxDeyEpsO
	QI2RlDi44gbLBEaxWUg2z0KyeRaSzbOQbFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cT
	IySi+3Yw3jxgfYgxGWj9RGYp0eR8YELIK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2MRQHtLxMft8neiEjW82h7dHr+r1jDV35HdSVu3X2iMnfr
	46xLxy60cDzbd3aVyizjmAszZmaefbCFa03NC6fPR0Szz2w0ZardUK/1x0fUWNUl9l26f838
	yM06YQyyfhcEu6ZLlN15/t/v8E7VQu9ikUKpTY9vmMVckrRzOr17guA57ok/ful4KrEUZyQa
	ajEXFScCALDUdhP+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd01hvHBBpeuC1j8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjIc7ggve8VZ0N6xgbmBcwd3FyMEhIWAiMaGnsouRE8gU
	k7hwbz1bFyMXh5DAIkaJ05OvQDl/GCW+7e9nAqliE9CUeHS3hx0kISKwg1Fi8tpFrCAOs8BD
	Romfb/czg1QJC4RIzO7czASygkVAVWLzMxeQMK+ApcS9le/YIGxBiR+T77GA2MwCWhLrdx5n
	grDlJTavecsMcZKCxI6zrxlBbBEBPYm7vXOYIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsY
	WVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeMZ1I7GFc2WBxiFOBgVOLhNYiKCxZiTSwr
	rsw9xCjBwawkwsuhGR8sxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAZJZXEm9obGJmZGlk
	ZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyihcZ/NeYy/c2yzzB/UGHarRK7
	0l3ptslNDkOlL50vKnsX9oruWvXs6IvYuGYJ3wUN3bzX90SVHZxu5vp3Zt9eQ61GyelBU0V2
	cn799utrzOU10VIb56nFGLRUvL0TKvtgh+ut+uvb7kX71HfH7Nstdmmi47Zs+dcX1zva57wR
	CWhgj3jMfk6JpTgj0VCLuag4EQD/KdCeXAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a kernel configuration for VA_BITS.

It helps to prevent unnecessary #ifdef statements insertions
for VA_BITS when implementing different page sizes and level of
translation tables.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm64/Kconfig              |    8 ++++++++
 arch/arm64/include/asm/memory.h |    6 +-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c7f5d65..7b8d429 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -186,6 +186,14 @@ config ARM64_3_LEVELS
 
 endchoice
 
+config ARM64_VA_BITS
+	int "Virtual address space size"
+	range 39 39 if ARM64_4K_PAGES && ARM64_3_LEVELS
+	range 42 42 if ARM64_64K_PAGES && ARM64_2_LEVELS
+	help
+	  This feature is determined by a combination of page size and
+	  level of translation tables.
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index e94f945..f6e7480 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -41,11 +41,7 @@
  * The module space lives between the addresses given by TASK_SIZE
  * and PAGE_OFFSET - it must be within 128MB of the kernel text.
  */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define VA_BITS			(42)
-#else
-#define VA_BITS			(39)
-#endif
+#define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
-- 
1.7.10.4


