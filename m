Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbaD3FB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:01:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaD3E7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:45 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-0d-536083406362
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 10/12] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
Date: Wed, 30 Apr 2014 14:17:35 +0900
Message-id: <1398835057-3860-11-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t8zA12H5oRgg4XfDS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZfSvfcBasIazomPbKZYGxk/sXYwcHBICJhKrVmd2
	MXICmWISF+6tZwOxhQSWMUrsvGkKETeROLx3I1CcCyi+iFFi2vmFrBBOG5PE1d9L2UGq2AR0
	JZ68n8sMYosIZEtcabzPDFLELLCbUaKxcR7YWGGBRIlpV2YygdgsAqoSbadvsYBcwSvgIbFg
	mjPEQQoScybZgFRwAkUX3v7NCnGQu0RDQw8jyEgJgVXsEjNm3mSFGCMg8W3yIRaIXlmJTQeY
	IY6WlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFCQr5/B+PdA9aHGJOB
	xk1klhJNzgfGTF5JvKGxmZGFqYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYf
	YmTi4JRqYGzd7eMsnMQgz8ijysUmxXrxhVD5pUtyIVGi0dqz30qenDTPIj6rNuvYzT9luWsO
	NZWLsf7h+pJ2iadiwiyjFel+89Y+XnM601DphOQJu3svvuu+ema7NOH5oTn+818xLYhmXOf1
	bob0rL1bRY9+fuPZmqDWxbBfVOPW6pBF/icfC3eKhF27GqPEUpyRaKjFXFScCACtkuRbjwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2H5oRgg1O/dC2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zoX/uAtWAN
	Z0XHtlMsDYyf2LsYOTkkBEwkDu/dyAZhi0lcuLceyObiEBJYxCgx7fxCVginjUni6u+lYB1s
	AroST97PZQaxRQSyJa403mcGKWIW2M0o0dg4D2yUsECixLQrM5lAbBYBVYm207dYuhg5OHgF
	PCQWTHMGMSUEFCTmTLIBqeAEii68/ZsVxBYScJdoaOhhnMDIu4CRYRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcFQ9k97BuKrB4hCjAAejEg+vwNb4YCHWxLLiytxDjBIczEoivOcrE4KF
	eFMSK6tSi/Lji0pzUosPMSYD3TSRWUo0OR8Y8Xkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwDhnmwybZr/Tq48Rc4Wysoqlv2jn887k7On/+UI8V/VT1//p
	6//0XtWqeC8RWnXm6BpWWc0NU9j4pjmqFWz6Uj07N8vfuMhyr9btqKbiFwE+78+qvA540FH8
	SaTI/F7S/t4Nl5PtN5V86fyX/CM05m1gvsnXfSunrHX79MGocE/dKh3/6pt9sUosxRmJhlrM
	RcWJABJWheDuAgAA
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
---
 arch/arm/mach-exynos/platsmp.c  |    1 +
 arch/arm/mach-exynos/regs-pmu.h |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 375ea4e..8f3b866 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -27,6 +27,7 @@
 #include <asm/firmware.h>
 
 #include <plat/cpu.h>
+#include <mach/map.h>
 
 #include "common.h"
 #include "regs-pmu.h"
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index a72b1bc..1d83c7e 100644
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
1.7.10.4

