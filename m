Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbbALJ0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:26:36 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32012 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbALJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:23:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-46-54b3928a66b3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 2/3] ARM: dts: Specify MSHC realistic clocks and use frequency
 scaling
Date: Mon, 12 Jan 2015 10:23:04 +0100
Message-id: <1421054585-9032-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
References: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xy7pdkzaHGBzcbmmxccZ6VosJl7cz
	Wsw/co7V4savNlaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hszjyv5/RYsb5fUwWa4/cZbc4
	vjbcgddj06pONo871/aweWxeUu9x49VCJo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKuH5r
	PVvBd/aKR2s+sjYwXmDrYuTkkBAwkVj34SwLhC0mceHeeqA4F4eQwFJGiZZTW1ggnD4miZPf
	ZzGBVLEJGEtsXr4ErEpEYAuTxKo1a1lBHGaBo4wSN2bdBasSFgiTOH7qDdhcFgFVieb+JnYQ
	m1fATeLdvbXMEPvkJE4em8wKYnMKuEscnPgDzBYCqrm6q5NpAiPvAkaGVYyiqaXJBcVJ6bmG
	esWJucWleel6yfm5mxghofllB+PiY1aHGAU4GJV4eCfIbA4RYk0sK67MPcQowcGsJMLrWgYU
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJgq/oLntI6wecKPgru+L7Y6yc43OXEh97DslZdGe60L
	NyvICYv1MOQIO/BydN9orfq2P75SrTu6qaF/zZQzVq5C745nvNDf/u/Kqa0nD3zX402VFXTY
	dM5xYpnp1PvCU95lKV2fkjZ3RVXHGc5NnG5RZWfuspRuyU6Jstkr3fe4sdrrgLCDmxJLcUai
	oRZzUXEiAG05LlQrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lower the dw_mmc host clock from 400 MHz to 100 MHz because there are a
lot of MMC errors above 100 MHz.

Enable frequency scaling to reduce energy consumption. In idle this
reduced energy consumption by 2.6% (from 119.5 mA to 116.4 mA).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b452643..21f1236ae979 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -558,7 +558,9 @@
 		non-removable;
 		card-detect-delay = <200>;
 		vmmc-supply = <&vemmc_reg>;
-		clock-frequency = <400000000>;
+		clock-frequency = <100000000>;
+		clock-freq-min-max = <400000 100000000>;
+		frequency-scaling;
 		samsung,dw-mshc-ciu-div = <0>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
 		samsung,dw-mshc-ddr-timing = <1 2>;
-- 
1.9.1

