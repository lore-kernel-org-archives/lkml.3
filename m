Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaK0LV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:21:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44171 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaK0LVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:17 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-20-547709292ef8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 6/7] mfd/regulator: dt-bindings: max77686: Document gpio
 properties
Date: Thu, 27 Nov 2014 12:20:52 +0100
Message-id: <1417087253-12306-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xK7qanOUhBtd6dS02zljPajH14RM2
	i/lHzrFavH5haNH/+DWzxdmmN+wW978eZbT4dqWDyWLT42usFpd3zWGzmHF+H5PF2iN32R14
	PHbOusvusWlVJ5vHnWt72Dw2L6n36NuyitHj8ya5ALYoLpuU1JzMstQifbsEroyGdT1MBR+4
	Kv6tf8rWwPiNo4uRk0NCwETi4cGpjBC2mMSFe+vZuhi5OIQEljJK7G+YwQLh9DFJbN76khmk
	ik3AWGLz8iVsILaIwApGieM3FEFsZoH1TBIPtjmB2MICERIP7s0Hq2ERUJV4dvgaE4jNK+Au
	cXHKJqhtchInj01mBbE5BTwk9t66zQJiCwHV7Hl1h2UCI+8CRoZVjKKppckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGCHh+GUH4+JjVocYBTgYlXh4Ex6XhQixJpYVV+YeYpTgYFYS4eViLA8R4k1J
	rKxKLcqPLyrNSS0+xMjEwSnVwFiwqHOainH3pCUHr637ZngvIOzCG1kJrS61JQXvZc+p+L+M
	v7Tu9uneKL2LbpdfT3o4yz2QedWHAsHbq8rdbgtp3P1VzfCFZ/JL/4rH/C4N18xkV7ZMOp7C
	s61j8reqmrVuCidMvTp6Tv1+sPHkfSuFwzLXGr+pCUhO8wsP8dyw5m18deqLPU+UWIozEg21
	mIuKEwEMxE8GJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document usage of ena-gpios properties which turn on external/GPIO
control over regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 75fdfaf41831..93c4cd07ffc8 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -37,8 +37,12 @@ to get matched with their hardware counterparts as follow:
   Regulators which can be turned off during system suspend:
 	-LDOn	:	2, 6-8, 10-12, 14-16,
 	-BUCKn	:	1-4.
-  Use standard regulator bindings for it ('regulator-off-in-suspend').
 
+  Regulators which can be configured for GPIO enable control:
+	-LDOn	:	20, 21, 22
+	-BUCKn	:	8, 9
+  Use standard regulator bindings for these ('regulator-off-in-suspend',
+  'ena-gpios').
 
 Example:
 
@@ -65,4 +69,12 @@ Example:
 				regulator-always-on;
 				regulator-boot-on;
 			};
+
+			buck9_reg {
+				regulator-compatible = "BUCK9";
+				regulator-name = "CAM_ISP_CORE_1.2V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1200000>;
+				ena-gpios = <&gpm0 3 GPIO_ACTIVE_HIGH>;
+			};
 	}
-- 
1.9.1

