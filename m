Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbaHZBcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 21:32:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44204 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaHZBbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 21:31:18 -0400
X-AuditID: cbfee68e-f79536d000000fd1-97-53fbe362f29b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, ch.naveen@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <edubezval@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 1/4] thermal: samsung: Exynos5260 and Exynos5420 should not
 use TRIM_RELOAD flag
Date: Tue, 26 Aug 2014 10:31:02 +0900
Message-id: <1409016665-3824-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkUDfp8e9ggzlnTS0aroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTxfwr11gtehdcZbM42/SG3WLTYyD38q45bBafe48wWsw4v4/J4snD
	PjYHXo+ds+6yeyze85LJY/OSeo++LasYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfGlCWZ
	BVvFKi7PO83ewLhYuIuRg0NCwETiyr2ULkZOIFNM4sK99WxdjFwcQgJLGSW2nz/GBJEwkVi4
	dTILiC0kMJ1R4up9ZoiiJiaJltlHwYrYBLQk9r+4wQZiiwh4Ssxd2MIEUsQssIdJoq/tOVi3
	sECKxNvfq8AaWARUJWavWADWwCvgIjFx7zJmiG1yEh/2PGIHsTkFXCX+TznDDLHZRaJr3i9G
	kKESAsfYJSbdX8oKMUhA4tvkQywQ78hKbDoANUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLS
	K07MLS7NS9dLzs/dxAiMk9P/nvXtYLx5wPoQowAHoxIP743438FCrIllxZW5hxhNgTZMZJYS
	Tc4HRmNeSbyhsZmRhamJqbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	HEu9j2xLUlReEVTCmC1a/OrsX7/Gx5LWLpck5p+3C2G+dun51j+sk99cnc4+edObFu1Tjsa2
	h3q6ut5O3zxnn/jTy6Yree43HNG/LKJwd96xJ6Wrnz0Osy5ZW6JQwfZpcuPXl8/PCha7GVaZ
	Pa5581m5+GbAuYN3TuwUiw05wPJPcI/TqRRjIyWW4oxEQy3mouJEAIj6aYaOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jQd2kx7+DDX4t0bFouBpisXHGelaL
	u88PM1pc//Kc1WLN/p9MFvOvXGO16F1wlc3ibNMbdotNj4Hcy7vmsFl87j3CaDHj/D4miycP
	+9gceD12zrrL7rF4z0smj81L6j36tqxi9Dh+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAhyoplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCWsYM6YsySzYKlZxed5p9gbGxcJdjJwcEgImEgu3TmaBsMUkLtxb
	zwZiCwlMZ5S4ep+5i5ELyG5ikmiZfZQJJMEmoCWx/8UNsCIRAU+JuQtbmECKmAX2MEn0tT0H
	myQskCLx9vcqsAYWAVWJ2SsWgDXwCrhITNy7jBlim5zEhz2P2EFsTgFXif9TzjBDbHaR6Jr3
	i3ECI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFx+Ex6B+OqBotDjAIcjEo8vDfi
	fwcLsSaWFVfmHmKU4GBWEuFleAgU4k1JrKxKLcqPLyrNSS0+xGgKdNVEZinR5HxgisgriTc0
	NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cDY5hRTtrU69fSXxqdr/u32
	/N34f6uIQfjlFcrsZQvmHKzJehq30Wnn0///Xr2JdTh6bZphcclKdSG/g9u/vp2eqf5x7/uC
	ea+6Z98N3xcmdnhnJrPdwXiXm/WJVT8ytfUEZv1hPDw3xGCD9nLnibIiWeGaVRKxyxNkZ18v
	Uvh+R3jqU83WVJWZSizFGYmGWsxFxYkAuUvLpNkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Currently these SoCs claim TRIM_RELOAD support but don't have
triminfo_ctrl register address defined in their struct
exynos_tmu_registers entries.  This causes incorrect write of
value "1" to data->base + 0x00 address (which happens to be
TRIMINFO register).  Additionally according to the documentation
that I have neither Exynos5260 nor Exynos5420 support/require
TRIM_RELOAD feature.  Thus fix the aforementioned issue by
removing TMU_SUPPORT_TRIM_RELOAD flag for both Exynos5260 and
Exynos5420.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index aa8e0de..8c0ada2 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -359,9 +359,8 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 #define EXYNOS5260_TMU_DATA \
 	__EXYNOS5260_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5260, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
 
 struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_data = {
@@ -451,16 +450,15 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5250, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
-			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
+			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME | \
+			TMU_SUPPORT_ADDRESS_MULTIPLE)
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.0

