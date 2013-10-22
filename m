Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3JVWuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:50:37 -0400
Received: from ring0.de ([91.143.88.219]:38655 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab3JVWuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:50:18 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 10/14] DTS: ARM: OMAP3-N900: Add NAND support
Date: Wed, 23 Oct 2013 00:49:39 +0200
Message-Id: <1382482183-14426-11-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382482183-14426-1-git-send-email-sre@debian.org>
References: <1382482183-14426-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds supports for Nokia N900 NAND memory.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 0a45af3..999a80c 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -273,6 +273,78 @@
 	status = "disabled";
 };
 
+&gpmc {
+	ranges = <0 0 0x04000000 0x10000000>; /* 256MB */
+
+	/* gpio-irq for dma: 65 */
+
+	onenand@0,0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0 0 0x10000000>;
+
+		gpmc,sync-read;
+		gpmc,sync-write;
+		gpmc,burst-length = <16>;
+		gpmc,burst-read;
+		gpmc,burst-wrap;
+		gpmc,burst-write;
+		gpmc,device-width = <2>; /* GPMC_DEVWIDTH_16BIT */
+		gpmc,mux-add-data = <2>; /* GPMC_MUX_AD */
+		gpmc,cs-on-ns = <0>;
+		gpmc,cs-rd-off-ns = <87>;
+		gpmc,cs-wr-off-ns = <87>;
+		gpmc,adv-on-ns = <0>;
+		gpmc,adv-rd-off-ns = <10>;
+		gpmc,adv-wr-off-ns = <10>;
+		gpmc,oe-on-ns = <15>;
+		gpmc,oe-off-ns = <87>;
+		gpmc,we-on-ns = <0>;
+		gpmc,we-off-ns = <87>;
+		gpmc,rd-cycle-ns = <112>;
+		gpmc,wr-cycle-ns = <112>;
+		gpmc,access-ns = <81>;
+		gpmc,page-burst-access-ns = <15>;
+		gpmc,bus-turnaround-ns = <0>;
+		gpmc,cycle2cycle-delay-ns = <0>;
+		gpmc,wait-monitoring-ns = <0>;
+		gpmc,clk-activation-ns = <5>;
+		gpmc,wr-data-mux-bus-ns = <30>;
+		gpmc,wr-access-ns = <81>;
+		gpmc,sync-clk-ps = <15000>;
+
+		/*
+		 * MTD partition table corresponding to Nokia's
+		 * Maemo 5 (Fremantle) release.
+		 */
+		partition@0 {
+			label = "bootloader";
+			reg = <0x00000000 0x00020000>;
+			read-only;
+		};
+		partition@1 {
+			label = "config";
+			reg = <0x00020000 0x00060000>;
+		};
+		partition@2 {
+			label = "log";
+			reg = <0x00080000 0x00040000>;
+		};
+		partition@3 {
+			label = "kernel";
+			reg = <0x000c0000 0x00200000>;
+		};
+		partition@4 {
+			label = "initfs";
+			reg = <0x002c0000 0x00200000>;
+		};
+		partition@5 {
+			label = "rootfs";
+			reg = <0x004c0000 0x0fb40000>;
+		};
+	};
+};
+
 &mcspi1 {
 	/*
 	 * For some reason, touchscreen is necessary for screen to work at
-- 
1.8.4.rc3

