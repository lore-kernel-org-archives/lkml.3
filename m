Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaGNOoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:44:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59261 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaGNOoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:44:25 -0400
X-AuditID: cbfee61a-f79e46d00000134f-03-53c3ecc78560
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 1/2] ARM: EXYNOS: Fix build with PM_SLEEP=n part #2
Date: Mon, 14 Jul 2014 16:43:59 +0200
Message-id: <1405349040-5265-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1405349040-5265-1-git-send-email-b.zolnierkie@samsung.com>
References: <1405349040-5265-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAd0Tbw4HG/RuYrTYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc3iyqVTbBbrZ7xmceDx
	uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8bNZSdZC36xV0zf/Z+1
	gfEsWxcjJ4eEgInEuxOrmCBsMYkL99YDxbk4hAQWMUrsuz4DrEhIoItJ4vAnQxCbTcBKYmL7
	KkYQW0RATaJn8VZGkAZmgXXMEju3/QdrEBZwlmjc2MUCYrMIqEr877kL1sAr4C7xuKmBGWKb
	okT3swlg9ZwCHhJdnf+A4hxAy9wlLi6Tn8DIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcAA+k9rBuLLB4hCjAAejEg9vBsfhYCHWxLLiytxDjBIczEoivB43gEK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYQxSd5mhO3nwuMXZJS9tk5ciT
	M2p+bJ080YBt6dbIZcpKrDJel2T8vh/i2LR8bXlCW129+WeNoIN9ecacHw9XRM6WWsC3qlF/
	vZ6sluMBnZNuS1vZigpEost255f8cTt+7VzF7182Ny0eaLBOD9fxP9eU+ObQjGMvJkVcyoi8
	b19Wfs3r980UJZbijERDLeai4kQAz6u5tjwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos_defconfig with disabled CONFIG_PM_SLEEP by
adding checking whether Exynos cpuidle support is enabled before
accessing exynos_enter_aftr.

The build error message:
arch/arm/mach-exynos/built-in.o:(.data+0x74): undefined reference to `exynos_enter_aftr'
make: *** [vmlinux] Error 1

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/exynos.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 2a43a17..769cecb 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -171,7 +171,9 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 
 static struct platform_device exynos_cpuidle = {
 	.name              = "exynos_cpuidle",
+#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
 	.dev.platform_data = exynos_enter_aftr,
+#endif
 	.id                = -1,
 };
 
-- 
1.8.2.3

