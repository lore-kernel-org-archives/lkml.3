Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaFYOHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:07:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26502 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbaFYOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:07:41 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-13-53aad7ab9dce
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v5 3/5] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
Date: Wed, 25 Jun 2014 19:33:50 +0530
Message-id: <1403705032-14835-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSq7v6+qpggzl7xSyWTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VotFW4Eq1s94zWLRsYzR4uaz7UwOPB4t
	zT1sHpuX1Hv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvvZ9QWPOCsObDnH1MC4kKOLkZND
	QsBEYsfK18wQtpjEhXvr2boYuTiEBJYySlzd+xPI4QAr+rySCyI+nVHi2LO/rCANQgITmCQu
	PMwDsdkEdCWevJ8LNkhEIFui//ZqFpAGZoHHjBJvVh5lBBkkLBAv0XPYBqSGRUBV4seaVkYQ
	m1fAQ2Jrfws7xC4FiTmTwEo4BTwlPs38zg6xykPi68z9zCAjJQS2sUu8apnCBDFHQOLb5EMs
	EL2yEpsOQP0iKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIExsDpf8/6
	djDePGB9iDEZaNxEZinR5HxgDOWVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsaNjOIvNEq531W8+W54euETxQ+XF7JYlbf+lN37Zon55qTUXy9i
	pn+efGSz7c3Wa57P1AIyfBe/bNz337esIY/v4dLPYW5brgQEuDVfjQ599NBib+ibjRJ7d8T9
	XHyheuvu6PcRwVe6zD6d9RBfPH2PSOb+t2VsvEUTTi2b4hMlaCgUfSY682SGEktxRqKhFnNR
	cSIAQB7r+5cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd3V11cFG7TP4LVYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS0WbQWqWD/jNYtFxzJGi5vPtjM58Hi0
	NPeweWxeUu/Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbm
	Sgp5ibmptkouPgG6bpk5QIcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlr
	GDPez64veMRZcWDLOaYGxoUcXYwcHBICJhKfV3J1MXICmWISF+6tZ+ti5OIQEpjOKHHs2V9W
	kISQwAQmiQsP80BsNgFdiSfv5zKD2CIC2RL9t1ezgDQwCzxmlHiz8igjyFBhgXiJnsM2IDUs
	AqoSP9a0MoLYvAIeElv7W9gh9ipIzJkEVsIp4CnxaeZ3dohVHhJfZ+5nnsDIu4CRYRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcIQ9k9rBuLLB4hCjAAejEg/vhdkrg4VYE8uKK3MPMUpw
	MCuJ8LrvXxUsxJuSWFmVWpQfX1Sak1p8iNEU6KiJzFKiyfnA6M8riTc0NjE3NTa1NLEwMbNU
	Euc90GodKCSQnliSmp2aWpBaBNPHxMEp1cBoe0lyXuvE3zOmCKcGuv5ZHTDD4Zto/BIjpZXP
	ta5PVdBmUNBsdhD/8K330+5VZwy1m5ZIxyTW+Rt6bZ/nr/HpHgOf54sSZUeLqxFJ29Ozj3WY
	eO41mMh7xIjF/nPsM3XTXtlrLV3n7pttV2ZYEHr9TeaFNC03xkPxG/3ZNDPSjPRcFvwTNlVi
	Kc5INNRiLipOBAB8nbBMxgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have removed static mappings from "regs-pmu.h" it does not
need map.h anymore. But "platsmp.c" needed this and till now it
got included indirectly. So lets move header inclusion of
"mach/map.h" from "regs-pmu.h" to "platsmp.c".

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c  |    2 ++
 arch/arm/mach-exynos/regs-pmu.h |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 4b934e3..71add5b 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -26,6 +26,8 @@
 #include <asm/smp_scu.h>
 #include <asm/firmware.h>
 
+#include <mach/map.h>
+
 #include "common.h"
 #include "regs-pmu.h"
 
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 77afda4..efad6cb 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -12,8 +12,6 @@
 #ifndef __ASM_ARCH_REGS_PMU_H
 #define __ASM_ARCH_REGS_PMU_H __FILE__
 
-#include <mach/map.h>
-
 #define S5P_CENTRAL_SEQ_CONFIGURATION		0x0200
 
 #define S5P_CENTRAL_LOWPWR_CFG			(1 << 16)
-- 
1.7.9.5

