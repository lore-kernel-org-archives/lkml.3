Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKGLoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:44:38 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8224 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKGLoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:44:34 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-c7-545cb09fc797
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: dts: Fix booting on Rinato market device
Date: Fri, 07 Nov 2014 12:44:22 +0100
Message-id: <1415360662-30390-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Vd35G2JCDLq/WFlMWneAyWL+kXOs
	Fv1vFrJanHu1ktHi9QtDi94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGux9PpFJosJ09eyWLTu
	PcLuwOuxZt4aRo+W5h42j8t9vUwef1e9YPZYufwLm8emVZ1sHpuX1Hv0bVnF6PF5k1wAZxSX
	TUpqTmZZapG+XQJXxpUD7AWLeCqO7VnI1sC4hquLkZNDQsBE4taVKSwQtpjEhXvr2boYuTiE
	BJYySqz/9ZIdwuljkrj68BhYFZuAscTm5UvAqkQEtjFLrGv8xQiSYBYwlPj57g87iC0sYCex
	+OcnZhCbRUBV4tvVo2A2r4C7xKTDt5gh1slJnDw2mXUCI/cCRoZVjKKppckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGCFB+HUH49JjVocYBTgYlXh4H4jEhAixJpYVV+YeYpTgYFYS4Z29GijEm5JY
	WZValB9fVJqTWnyIkYmDU6qBsdyixtl8HuvvW/+Or8pjcj7QKjZbeEfVx4lax47r5/87JD3h
	l8LzuMTc3uXSjKJS/+ZdMIpjXTrf9+iNaNf1s0TnMK+ZuCpEcLeO7l2f51GCUy5FmN7QP137
	pFbIzvDatunJK6xLN29ouHbOIZVt0Y+n2SF/eUUXpx97tX396tPld1PEb63iF1NiKc5INNRi
	LipOBAAIxmisIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bootloader on market Rinato (Gear 2) device checks for revision in
compatible field of DTB. If it is not present or lower than required
then booting fails with: "Could not do normal boot. (no DTB found)".

Log of bootloader in case of failure:
h/w: revision  = 0x06
h/w: schematic = SM-R380_Rev0.5_Final_0205
date = 2000/01/01 12:00:21 (UTC)
cmu_div:4, div:5, src_clk:800000000, pixel_clk:31860720
load_kernel: loading boot image from 57344.. (BOOT)
load_kernel: found zImage, size: 0x3267e8
0xbc Error!
Verify_Binary_Signature: failed.
pit_check_signature (BOOT) invalid.
load_kernel: found custom kernel (ret:-2147483647)
 No need to update kernel type.
Detected board: samsung,rinato-rev06
Could not do normal boot. (no DTB found)
: Entering usb mode for SM-R380_EUR_XX (65535)..

Add a "rev06" suffix to compatible to satisfy the bootloader.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 84380fa13e37..f72ba0a1d915 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -18,7 +18,8 @@
 
 / {
 	model = "Samsung Rinato board";
-	compatible = "samsung,rinato", "samsung,exynos3250", "samsung,exynos3";
+	compatible = "samsung,rinato", "samsung,rinato-rev06",
+			"samsung,exynos3250", "samsung,exynos3";
 
 	aliases {
 		i2c7 = &i2c_max77836;
-- 
1.9.1

