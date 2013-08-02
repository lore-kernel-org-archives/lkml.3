Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3HBOuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:50:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3HBOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:50:48 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v5 7/7] ARM: shmobile: ape6evm-reference: enable DMA for the MMC interface
Date: Fri,  2 Aug 2013 16:50:42 +0200
Message-Id: <1375455042-24093-8-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:AjuAfe4aVxnvexUfLBjMykHLkAIUkSLb9Aq1b3zfjzc
 WdUZ+PKNHxc5HDXL3Akp4d+lFYm+esKNouF4kfvqHOQ9/B0n5+
 KTLbdcsaelKtVsUVqJy4msQfV8StQEqbFjAausnV3X+3usrQ+c
 NkbXnJZxyLyKMJicfa0BYPviDlIb77XQDyQtmSCEKL3dDFZGGI
 tbVXODQf7TQx+IXhr+hOvufHbeDnVS1gbz7z1as2Y4na/nrfqd
 4XOixRUXTOc9nU/jwsbEIbanMTnlHuUH6mDAKg3MEA6Mtel5/n
 vaZ/90OwAfDAJOyDPsfyoHaXN22+eCOFwouNTUVVAiSofBPooq
 jYMpytPIrj7L+nYm8ZZrpB+Y+y8wpvJtikyjFf+dssLR6ZfJmh
 hn644fOTI8DrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA slave bindings for the two required DMA channels
for MMCIF0 to ape6evm-reference.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts b/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
index 6797fac..631086a 100644
--- a/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
+++ b/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
@@ -112,6 +112,9 @@
 	vmmc-supply = <&vcc_mmc0>;
 	bus-width = <8>;
 	non-removable;
+	dmas = <&dmac 0xd1
+		&dmac 0xd2>;
+	dma-names = "tx", "rx";
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc0_pins>;
 	status = "okay";
-- 
1.7.2.5

