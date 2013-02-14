Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161099Ab3BNWr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:47:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161086Ab3BNWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:47:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Paul Walmsley <paul@pwsan.com>,
        Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3/9] ARM: omap2: include linux/errno.h in hwmod_reset
Date: Thu, 14 Feb 2013 23:47:45 +0100
Message-Id: <1360882071-4072668-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VCFIo0BL6NBuyn9zpcVjVUEgBfFXun2fB/uloiae3ZJ
 54fEEd/GMU6THEuiAf+c2GHIQm/jYHfvEV4t3ciLc9Qg/ZnbPR
 sl2zzXdaAV0JxpF1ewHNTScaehY14V2uz3OaYGnZ0T1hqMny0m
 bktZ8C3zvw5XgDC38kuBte7wgrD+ZvyzP2Qg5LyX/tRZx1iFbA
 YG65olsm+px/GezsoqmxwiwB7tk/YOvAVCsHunsvywIto8dKLN
 KLB4TriYBu3NEYf3cgF6MF82dagb7dINrvNwqZvmDYMG5a2Qim
 sjEwjyhyxikzby017bxK6T+jXWPg5SUdWcGOr+bnFYLSLxI1Ph
 Tv1TBFVG+OqpsyAomxVqmeYHRjyCsoKq2uvpvxtMW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly created omap_hwmod_reset.c is missing an
include of linux/errno.h in commit c02060d8 "ARM:
OMAP4+: AESS: enable internal auto-gating during
initial setup". It still works in omap2_defconfig,
but not in all other combinations.

Without this patch, building allmodconfig results in:

arch/arm/mach-omap2/omap_hwmod_reset.c: In function 'omap_hwmod_aess_preprogram':
arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: error: 'EINVAL' undeclared (first use in this function)
arch/arm/mach-omap2/omap_hwmod_reset.c:47:11: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Sebastien Guiriec <s-guiriec@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/omap_hwmod_reset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_reset.c b/arch/arm/mach-omap2/omap_hwmod_reset.c
index bba43fa..65e186c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_reset.c
+++ b/arch/arm/mach-omap2/omap_hwmod_reset.c
@@ -24,6 +24,7 @@
  * 02110-1301 USA
  */
 #include <linux/kernel.h>
+#include <linux/errno.h>
 
 #include <sound/aess.h>
 
-- 
1.8.1.2

