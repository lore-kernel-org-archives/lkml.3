Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaDYMQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:16:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaDYMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:07 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-b0-535a51c9ebde
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 09/10] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
Date: Fri, 25 Apr 2014 21:32:45 +0900
Message-id: <1398429166-5539-10-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+Zke6pwKhgg9dbGS02zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdovDb9pZLdbPeM1icfPZdiaLHS2rWRx4
	PFqae9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6MyZ8LC9ZyVpw9fY61gfEzexcj
	J4eEgInEp1NvGCFsMYkL99azdTFycQgJLGOUePd2MVzR7bUfmCASi4ASW9ezQjhtTBJHelew
	gFSxCehKPHk/lxnEFhHIlrjSeB/MZhZ4zyjx+bA6iC0skCgxZ8IrVhCbRUBV4ko7yFRODl4B
	D4mObXOAzuAA2qYgMWeSDUiYEyh8YvlHdohdrYwS53/fZgFxJAS2sUscOdnLBDFIQOLb5EMs
	EM2yEpsOMENcLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTCxB2M
	9w9YH2JMBho3kVlKNDkfGEt5JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cB46ex31v1nc351vD57L86kNPuF5Iutaz7adLwQNmd9GuCUbsJyNpZx
	yfEjJsVpolI3Vne3LnjV5luwZn3+wjcGmQlh7Rs+LZERef1tSvfV6wfVpvrHeJf5cC9lUNC4
	3q2gazQtcluw999HETHPz1w7lfvMdc+jp8e9XnQz9L3wbRNbX/xB/Iq1EktxRqKhFnNRcSIA
	hIAE55sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd2TgVHBBn//W1psnLGe1WLZpLts
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi0dYv7BaH37SzWqyf8ZrF4uaz7UwWO1pWszjw
	eLQ097B5bF5S79G3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYMyZ/LixYy1lx9vQ51gbGz+xdjJwcEgImErfXfmCCsMUkLtxbz9bFyMUhJLCIUeLd1vWs
	EE4bk8SR3hUsIFVsAroST97PZQaxRQSyJa403gezmQXeM0p8PqwOYgsLJErMmfCKFcRmEVCV
	uNIOsYFXwEOiY9scxi5GDqBtChJzJtmAhDmBwieWf2SH2NXKKHH+922WCYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIER9oz6R2MqxosDjEKcDAq8fBOkI0MFmJNLCuuzD3EKMHB
	rCTC+8EvKliINyWxsiq1KD++qDQntfgQYzLQVROZpUST84FJIK8k3tDYxMzI0sjMwsjE3Jw0
	YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGL1L07evC7p8XOZTebZ0Q9z5u68iveeHvmvY
	YeL+auLTtDMyO/JYbbYlr3Is7JFXeZF0lDk75dysrxpzIk6s07U++yptcms2j1vCD7Z7jE2T
	9e8u1N1p1LVc5NmRtt/6z5eejt690ENdMKho8ofvTBMnGZu2/rizQ72PITmsate9UG97A7Y1
	65RYijMSDbWYi4oTAfDsFgb4AgAA
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
index 9ce4c9f9..3831e6c 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -26,6 +26,7 @@
 #include <asm/firmware.h>
 
 #include <plat/cpu.h>
+#include <mach/map.h>
 
 #include "common.h"
 #include "regs-pmu.h"
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 7f3bf65..bb57b62 100644
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

