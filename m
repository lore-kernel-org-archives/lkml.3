Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbbAWOaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:30:10 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58180 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbbAWOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:30:04 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-6f-54c25a5892eb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: dts: exynos4412-trats2: Add max77693 charger node
Date: Fri, 23 Jan 2015 15:29:55 +0100
Message-id: <1422023395-8407-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t/xa7oRUYdCDP6f47HYOGM9q8X8I+dY
	LV6/MLTof/ya2eJs0xt2i02Pr7FaXN41h81ixvl9TBZrj9xld+D02LSqk81j85J6j74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4/n4Pc0ErR8Xdh5+YGxjPsXUxcnBICJhIPN4q3sXICWSK
	SVy4tx4ozMUhJLCUUWLZkRYmCKePSeLh1ocsIFVsAsYSm5cvYQOxRQRWMEpcbLIEKWIWOMoo
	cWPWXSaQqcIC7hIzduWC1LAIqEq82j2DBSTMK+AmsfiNPsQyOYmTxyazTmDkXsDIsIpRNLU0
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjJFC+7mBceszqEKMAB6MSD++BNwdDhFgTy4orcw8xSnAw
	K4nwWmseChHiTUmsrEotyo8vKs1JLT7EyMTBKdXAqFS5Kn6l7aGJanf2TFL5VRzy/hLn9IZP
	gZOT11vlfDU6mpL6u1j+eKL4gz/+SVNUP/1mOJVxZ9/x2h1zBFbPMrT42DtP+1drsk0Sk4xz
	+jwBtbxHkcc3uk7rrstIPdL1tz3+UPuFzTvdVle8Dzjc0lZXp6zr97foikyawgENxxxZFWln
	xxmPlFiKMxINtZiLihMB0ez9cvIBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add to Trats2 DTS new node for configuring the max77693 charger driver.
Only the maxim,constant-microvolt differs from default value but set all
of the optional properties anyway.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b452643..496a05faca37 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -549,6 +549,16 @@
 				haptic-supply = <&ldo26_reg>;
 				pwms = <&pwm 0 38022 0>;
 			};
+
+			charger {
+				compatible = "maxim,max77693-charger";
+
+				maxim,constant-microvolt = <4350000>;
+				maxim,min-system-microvolt = <3600000>;
+				maxim,thermal-regulation-celsius = <100>;
+				maxim,battery-overcurrent-microamp = <3500000>;
+				maxim,charge-input-threshold-microvolt = <4300000>;
+			};
 		};
 	};
 
-- 
1.9.1

