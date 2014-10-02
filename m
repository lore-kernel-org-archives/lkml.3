Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaJBMWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:22:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42668 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaJBMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:22:25 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-5b-542d437ddd09
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/7] ARM: dts: exynos4412-trats: Add max77693 charger node
Date: Thu, 02 Oct 2014 14:22:06 +0200
Message-id: <1412252528-30148-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xq7q1zrohBg+vallsnLGe1WLSugNM
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdHfBRavXxha9C64ymZxtukNu8X9r0cZLTZ/
	72Cz2PT4GqvF5V1z2Cw+9x5htJhxfh+Txe3LvBZrj9xlt1h6/SKTxYTpa1ksWvceYbc43c1q
	cXp3icWqXX8YHSQ91sxbw+jR0tzD5nG5r5fJ4+/z6ywef1e9YPbYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnpsXlLv0bdlFaPH501yAXxRXDYpqTmZZalF+nYJXBn79/xhKvjGXnHx
	w03WBsbDbF2MnBwSAiYSv549YoWwxSQu3FsPFhcSWMoosbi9uouRC8juY5LY1niVGSTBJmAs
	sXn5EjaQhIjAX2aJCd9fMYE4zAJPmSXObdgCNkpYwEvi3PFTYDaLgKrE6h2tTCA2r4C7xNNd
	Uxkh1slJnDw2GayGU8BDYu7biewQq90l2ppWsU1g5F3AyLCKUTS1NLmgOCk911CvODG3uDQv
	XS85P3cTIySuvuxgXHzM6hCjAAejEg9vRoNOiBBrYllxZe4hRgkOZiUR3if2uiFCvCmJlVWp
	RfnxRaU5qcWHGJk4OKUaGFX3HuNmYqh8EP8mL6nO2uK046IvmSqTHh5o6no4py+oMt9F7oOl
	57cyq3nTXwpcPN8xg+Xsiq+iS6b+nvZstWzcjeSgQ7ld3Bb3mJ5uFfiZtafzwonmI6w5G9Ue
	G3cWzTvF5f/BYW7iml2nTldX9x0ot4iNmP/LorVE3+SPCffRrYaWYZ2vbiixFGckGmoxFxUn
	AgCdRW73iQIAAA==
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
index dd9ac66770f7..952aeba473f1 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -543,6 +543,16 @@
 					regulator-max-microamp = <2580000>;
 				};
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

