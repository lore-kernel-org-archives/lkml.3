Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaEJGin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaEJGia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:30 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-48-536dc964dbd0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 09/11] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
Date: Sat, 10 May 2014 15:56:36 +0900
Message-id: <1399704998-13321-10-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zA92Uk7nBBrOX8lksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgytixczJLwRrOioerT7E3MH5i72Lk4JAQMJFYdFyl
	i5ETyBSTuHBvPVsXIxeHkMAyRomDfT1sEAkTiS9TWhghEtMZJXouf4aqamOS+H74LzNIFZuA
	rsST93PBbBGBbIkrjfeZQYqYBXYzSjQ2zgMbJSyQKPFvzQ4WEJtFQFVib/M3MJtXwFPiwPTl
	rBAnKUjMmWQDEuYECn/9upgJxBYS8JB40L0UbKaEwDp2iU8Tf7JDzBGQ+Db5EAtEr6zEpgPM
	EFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxghYd+3g/HmAetDjMlA
	4yYyS4km5wPjJq8k3tDYzMjC1MTU2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MLLu37bkoWFSIPuhNy+VNG64dWeEPekyjGgRLNv3pmD9U+MbxYoHjndmbM3mNWco
	XLQ8StzkxknfZ284RBvEZFki5q/6cEWiY+Pyto48vbqctKQTexg1i6ZKRk/4MiFVxtskUv7r
	nwoJ0SdLr66pXBTy9OOO5R15txmWtE87zWbxQKc/4YNelhJLcUaioRZzUXEiABmCGeeRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd2Uk7nBBlPWcVksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ixY+dkloI1
	nBUPV59ib2D8xN7FyMkhIWAi8WVKCyOELSZx4d56ti5GLg4hgemMEj2XP0M5bUwS3w//ZQap
	YhPQlXjyfi6YLSKQLXGl8T4zSBGzwG5GicbGeWwgCWGBRIl/a3awgNgsAqoSe5u/gdm8Ap4S
	B6YvZ+1i5ABapyAxZ5INSJgTKPz162ImEFtIwEPiQfdS5gmMvAsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBMfVM6kdjCsbLA4xCnAwKvHwFrzNCRZiTSwrrsw9xCjBwawkwrviYG6w
	EG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucDYz6vJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaB
	QgLpiSWp2ampBalFMFuYODilGhj3bYiIi/hzn21F8xXJcFUR5ek7/n+bWVxk4JyrWy2yO+7q
	1ulKNZKGi9sftej+mHci5KvMkpUn7rWy2zbuT/r16feJ5Av3He6G7WXdkLkpI9lcarIlQ9up
	6bmHnh3/99My8J5Q5kwP71PMqVwaq5mFly0+sO149h/nUm2Vbr8j17dw3j3z7NAuJZbijERD
	Leai4kQA5B3dju8CAAA=
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
index 33eb364..d0482c2 100644
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

