Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaKZRWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:22:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31770 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaKZRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:22:18 -0500
X-AuditID: cbfee61a-f79c06d000004e71-92-54760c47e451
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: EXYNOS: use u8 for val[] in struct exynos_pmu_conf
Date: Wed, 26 Nov 2014 18:21:38 +0100
Message-id: <1787532.9Q2MHGpzCz@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAV13nrIQgyPLjC0aroZY9C64ymZx
	tukNu8Wmx9dYLS7vmsNmMeP8PiaLRVu/sDuwe2xeUu/Rt2UVo8fnTXIBzFFcNimpOZllqUX6
	dglcGf/Xr2As2MBR8XnaBtYGxitsXYycHBICJhKnT89hhbDFJC7cWw8U5+IQEljEKDGpcT8z
	hNPCJDFh5XkmkCo2ASuJie2rGEFsEQE1iZ7FWxlBipgFPjFKXJrQATZWWMBbYsLLn8wgNouA
	qsSbSUfAGngFNCUuTNoLFhcV8JTYOf0AVFxQ4sfkeywgNrOAvMS+/VNZIWwtifU7jzNNYOSb
	haRsFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDtBnUjsYVzZYHGIU4GBU
	4uGNkCoNEWJNLCuuzD3EKMHBrCTCy/EOKMSbklhZlVqUH19UmpNafIhRmoNFSZz3xs3cECGB
	9MSS1OzU1ILUIpgsEwenVAMjq21NbNbl67OzJ7cl6jQ33HDbt3DKatmnyWVR++8fOhjEvF9y
	i8ihzBWZm1aWsp+8FWHt2/5or8PBuRt2P0hxmXyQZ9cEoV/1Ooynrq/qFLDzXbTN1O77Qf7D
	/0+GLsqQeyYx91mB3Pzoy+plU+66fF0W+1qnx2Jn2Jv02g0Gah1bXZO03bekK7EUZyQaajEX
	FScCAMHpPlFMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Values stored in val[] are never bigger than a byte.

   text    data     bss     dec     hex filename
   7716    3692       8   11416    2c98 arch/arm/mach-exynos/pmu.o.before
   5436    1908       8    7352    1cb8 arch/arm/mach-exynos/pmu.o.after

Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
- rebased on top of next-20141126 branch of linux-next kernel tree
  (it also applies fine to for-next branch of linux-samsung.git)

 arch/arm/mach-exynos/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index ccb0120..c15761c 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -25,7 +25,7 @@
 
 struct exynos_pmu_conf {
 	unsigned int offset;
-	unsigned int val[NUM_SYS_POWERDOWN];
+	u8 val[NUM_SYS_POWERDOWN];
 };
 
 struct exynos_pmu_data {
-- 
1.8.2.3


