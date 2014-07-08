Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaGHMD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:03:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9256 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaGHMDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:03:54 -0400
X-AuditID: cbfee61a-f79e46d00000134f-13-53bbde2889a6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: use u8 for val[] in struct exynos_pmu_conf
Date: Tue, 08 Jul 2014 14:03:37 +0200
Message-id: <2379473.Yu7PYOQ3m0@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQV2Ne7uDDV6ct7HoXXCVzeJs0xt2
	i02Pr7FaXN41h81ixvl9TA6sHpuX1Hv0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxoLZexkL
	+tgrJu1rZmpgPMPaxcjJISFgItHefhbKFpO4cG89WxcjF4eQwHRGiZlPb7FCOC1MEqunfGME
	qWITsJKY2L4KzBYRUJPoWbyVEaSIWWAGo8SGpkvMIAlhAQ+JjQ1vmUBsFgFVic2N61hAbF4B
	TYkVn2+AxUUFPCV2bF/JBhEXlPgx+R5YDbOAvMS+/VNZIWwtifU7jzNNYOSbhaRsFpKyWUjK
	FjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDsdnUjsYVzZYHGIU4GBU4uFdcXBXsBBr
	YllxZe4hRgkOZiUR3i+ndgcL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpa
	kFoEk2Xi4JRqYMwTbJmUvG8Wx+eSvP6t0//V6BywYQj7v1ueSUi6Y8uKqqaZKXPa7wo0ft2/
	oGbTo0kvjhgY/lLY1xrUcEHmdtJpJ/GSTR2RUuGntX9dPbhC6ISFl1DF2tTwuatVT+aaiRuZ
	7/oaP/tZcORa4bfdJYXvUvS4T/Vszloe906VW2yyn41NjVKLrxJLcUaioRZzUXEiAFYXpZVD	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Values stored in val[] are never bigger than a byte.

   text    data     bss     dec     hex filename
   5264       4       4    5272    1498 arch/arm/mach-exynos/pmu.o.before
   2992       4       4    3000     bb8 arch/arm/mach-exynos/pmu.o.after

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index b850db4..55ff019 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -101,7 +101,7 @@ enum sys_powerdown {
 
 struct exynos_pmu_conf {
 	void __iomem *reg;
-	unsigned int val[NUM_SYS_POWERDOWN];
+	u8 val[NUM_SYS_POWERDOWN];
 };
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
-- 
1.8.2.3


