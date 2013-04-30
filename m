Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911Ab3D3Pl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:41:59 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:45150 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203Ab3D3Plv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:41:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/5] ARM: ux500: Pass DMA memcpy channels though Device Tree
Date: Tue, 30 Apr 2013 16:41:34 +0100
Message-Id: <1367336497-10650-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not possible to configure memcpy channels dynamically with DT.
We're providing them despite the fact that they're the same as the
hard-coded channels, as they will be removed once the u8500 platform
goes DT-only.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 838214c..8e80ef7 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -218,6 +218,8 @@
 			interrupts = <0 25 0x4>;
 
 			#dma-cells = <3>;
+			memcpy-channels = <56 57 58 59 60>;
+			memcpy-num-chans = <5>;
 		};
 
 		prcmu: prcmu@80157000 {
-- 
1.7.10.4

