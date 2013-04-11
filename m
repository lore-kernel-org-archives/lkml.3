Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936765Ab3DKDti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:49:38 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:34292 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936184Ab3DKDth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:49:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz154dIzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Vakul Garg <vakul@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Andy Fleming <afleming@freescale.com>,
        Shaveta Leekha <shaveta@freescale.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] powerpc/crypto: Add property for 'era' in SEC dts crypto node
Date: Thu, 11 Apr 2013 09:15:23 +0530
Message-ID: <1365651923-24017-1-git-send-email-vakul@freescale.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crypto node now contains a new property 'fsl,sec-era'.
This is required so that applications can retrieve era info without
having to be able to read SEC's register space.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
Changelog:

	v2: Added era in p1023si-post.dtsi as per Kim's comments.

 arch/powerpc/boot/dts/fsl/p1023si-post.dtsi   |    1 +
 arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi   |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi |    1 +
 7 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/p1023si-post.dtsi b/arch/powerpc/boot/dts/fsl/p1023si-post.dtsi
index 941fa15..f1105bf 100644
--- a/arch/powerpc/boot/dts/fsl/p1023si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p1023si-post.dtsi
@@ -148,6 +148,7 @@
 
 	crypto: crypto@300000 {
 		compatible = "fsl,sec-v4.2", "fsl,sec-v4.0";
+		fsl,sec-era = <3>;
 		#address-cells = <1>;
 		#size-cells = <1>;
 		reg = <0x30000 0x10000>;
diff --git a/arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi b/arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi
index ffadcb5..bb3d826 100644
--- a/arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi
@@ -34,6 +34,7 @@
 
 crypto@30000 {
 	compatible = "fsl,sec-v4.4", "fsl,sec-v4.0";
+	fsl,sec-era = <3>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 	ranges		 = <0x0 0x30000 0x10000>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi
index 0cbbac3..02bee5f 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi
@@ -34,6 +34,7 @@
 
 crypto: crypto@300000 {
 	compatible = "fsl,sec-v4.0";
+	fsl,sec-era = <1>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 	reg = <0x300000 0x10000>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi
index 7990e0d..7f7574e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi
@@ -34,6 +34,7 @@
 
 crypto: crypto@300000 {
 	compatible = "fsl,sec-v4.2", "fsl,sec-v4.0";
+	fsl,sec-era = <3>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 	reg		 = <0x300000 0x10000>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi
index ffd458f..e298efb 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi
@@ -34,6 +34,7 @@
 
 crypto: crypto@300000 {
 	compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
+	fsl,sec-era = <5>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 	reg		 = <0x300000 0x10000>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi
index 7b2ab8a..33ff09d 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi
@@ -34,6 +34,7 @@
 
 crypto: crypto@300000 {
 	compatible = "fsl,sec-v5.2", "fsl,sec-v5.0", "fsl,sec-v4.0";
+	fsl,sec-era = <5>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 	reg		 = <0x300000 0x10000>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi
index 0339825..0877822 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi
@@ -34,6 +34,7 @@
 
 crypto: crypto@300000 {
 	compatible = "fsl,sec-v5.3", "fsl,sec-v5.0", "fsl,sec-v4.0";
+	fsl,sec-era = <4>;
 	#address-cells = <1>;
 	#size-cells = <1>;
 	reg		 = <0x300000 0x10000>;
-- 
1.7.7.6


