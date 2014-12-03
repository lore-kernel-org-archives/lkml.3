Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaLCMeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:34:16 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25806 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLCMeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:34:12 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-96-547f03439935
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Inki Dae <inki.dae@samsung.com>, Tobias Jakobi <Liquid.Acid@gmx.net>,
        Daniel Drake <drake@endlessm.com>, Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v2 4/7] ARM: dts: exynos4: add dependency between TV and LCD0
 power domains
Date: Wed, 03 Dec 2014 13:34:05 +0100
Message-id: <1417610045-29790-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1416814256-24288-5-git-send-email-a.hajda@samsung.com>
References: <1416814256-24288-5-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xy7rOzPUhBqdmsVjcWneO1aLhaojF
	o/mPmS2e3drLZDHp/gQWi/7Hr5ktNj2+xmpxedccNosZ5/cxWXT9/MlmsfbIXXaLRVu/sFus
	2vWH0eL42nAHPo9F37M8ds66y+6xeNN+No9NqzrZPO5c28PmcehwB6PH5iX1Hn1bVjF6fN4k
	F8AZxWWTkpqTWZZapG+XwJXRtc+u4BZrxZmld9kaGB+wdDFyckgImEjs7prGCGGLSVy4t56t
	i5GLQ0hgKaPE3fV3oZw+Jon21ctZQarYBAwlut52sYHYIgLZEj++TWYBKWIW2MIsMffWP/Yu
	Rg4OYYFYiW13k0BqWARUJZZv/g22gVfAQ2J5y2F2iG1yEv9frmACKecUcJF4O1cNJCwk4Cwx
	6cguxgmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATulx2Mi49ZHWIU4GBU4uFV
	mFIXIsSaWFZcmXuIUYKDWUmE99k3oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG4cQoP46AmTLn
	ZkldkD/6fLKn+vmF+UwrbodLhOTKBD8W/nVq5QSZ+kilD30CjqtPcXk07NOWcJ7utKv01ITi
	hwlzD+/xeXVNu21NePDG3Pe/SmU1ZvYUl8i27LIMXvJLeNmDX6t5NOT6QpSk4quZOLOX5txj
	SzgpK7ul2sa1pur+Zcv61HAlluKMREMt5qLiRABnRGCXOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TV Mixer needs both TV and LCD0 domains enabled to be fully operational.
This dependency is modelled by making TV power domains a sub-domain of
LCD0 power domain.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 4ed5868d723e..55385a84a71c 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -97,6 +97,7 @@
 	pd_tv: tv-power-domain@10023C20 {
 		compatible = "samsung,exynos4210-pd";
 		reg = <0x10023C20 0x20>;
+		samsung,power-domain = <&pd_lcd0>;
 	};
 
 	pd_cam: cam-power-domain@10023C00 {
-- 
1.9.2

