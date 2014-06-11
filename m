Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbaFKI6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57639 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730AbaFKI6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 21/36] ARM: dts: OMAP2+: Fix OneNAND device nodes
Date: Wed, 11 Jun 2014 11:56:26 +0300
Message-ID: <1402477001-31132-22-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible id, fix chip select partition size and
I/O space size. OneNAND devices just need 128KB for I/O
and the minimum possible chips select partition can be
16MB.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap2420-n8x0-common.dtsi | 5 +++--
 arch/arm/boot/dts/omap3-n900.dts            | 6 ++++--
 arch/arm/boot/dts/omap3-n950-n9.dtsi        | 6 ++++--
 arch/arm/boot/dts/omap3430-sdp.dts          | 8 +++++---
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/omap2420-n8x0-common.dtsi b/arch/arm/boot/dts/omap2420-n8x0-common.dtsi
index 89608b2..14a67fb3 100644
--- a/arch/arm/boot/dts/omap2420-n8x0-common.dtsi
+++ b/arch/arm/boot/dts/omap2420-n8x0-common.dtsi
@@ -34,14 +34,15 @@
 };
 
 &gpmc {
-	ranges = <0 0 0x04000000 0x10000000>;
+	ranges = <0 0 0x04000000 0x1000000>;	/* CS0 space, 16MB min. */
 
 	/* gpio-irq for dma: 26 */
 
 	onenand@0,0 {
+		compatible = "ti,omap2-onenand";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		reg = <0 0 0x10000000>;
+		reg = <0 0 0x20000>;	/* OneNAND I/O 128K */
 
 		gpmc,sync-read;
 		gpmc,burst-length = <16>;
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 1a57b61..0c5af81 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -501,14 +501,16 @@
 };
 
 &gpmc {
-	ranges = <0 0 0x04000000 0x10000000>; /* 256MB */
+	ranges = <0 0 0x04000000 0x1000000>;	/* CS0 space, 16MB min. */
 
 	/* gpio-irq for dma: 65 */
 
 	onenand@0,0 {
+		compatible = "ti,omap2-onenand";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		reg = <0 0 0x10000000>;
+		reg = <0 0 0x20000>;	/* OneNAND I/O 128K */
+		ti,onenand-sync-rw;
 
 		gpmc,sync-read;
 		gpmc,sync-write;
diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index 5c26c18..9dcb367 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -101,12 +101,14 @@
 };
 
 &gpmc {
-	ranges = <0 0 0x04000000 0x20000000>;
+	ranges = <0 0 0x04000000 0x1000000>;	/* CS0 space, 16MB min. */
 
 	onenand@0,0 {
+		compatible = "ti,omap2-onenand";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		reg = <0 0 0x20000000>;
+		reg = <0 0 0x20000>;	/* OneNAND I/O 128K */
+		ti,onenand-sync-rw;
 
 		gpmc,sync-read;
 		gpmc,sync-write;
diff --git a/arch/arm/boot/dts/omap3430-sdp.dts b/arch/arm/boot/dts/omap3430-sdp.dts
index bf5f8b9..d6fe226 100644
--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -52,7 +52,7 @@
 &gpmc {
 	ranges = <0 0 0x10000000 0x08000000>,
 		 <1 0 0x28000000 0x08000000>,
-		 <2 0 0x20000000 0x10000000>,
+		 <2 0 0x20000000 0x1000000>,	/* CS2, 16MB min. */
 		 <255 0 0x6e000000 0x02d4>;	/* GPMC reg */
 
 	nor@0,0 {
@@ -151,10 +151,11 @@
 	};
 
 	onenand@2,0 {
-		linux,mtd-name= "samsung,kfm2g16q2m-deb8";
+		compatible = "ti,omap2-onenand";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		reg = <2 0 0x10000000>;
+		reg = <2 0 0x20000>;	/* OneNAND I/O 128K */
+		ti,onenand-sync-rw;
 
 		gpmc,device-width = <2>;
 		gpmc,mux-add-data = <2>;
@@ -173,6 +174,7 @@
 		gpmc,access-ns = <78>;
 		gpmc,wr-data-mux-bus-ns = <30>;
 
+		linux,mtd-name= "samsung,kfm2g16q2m-deb8";
 		partition@0 {
 			label = "xloader-onenand";
 			reg = <0 0x80000>;
-- 
1.8.3.2

