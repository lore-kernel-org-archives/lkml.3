Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaFDQEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:04:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52936 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbaFDQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:03:52 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] ARM: dts: berlin: add SMP related nodes and properties for BG2Q
Date: Wed,  4 Jun 2014 18:03:46 +0200
Message-Id: <1401897826-11711-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401897826-11711-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401897826-11711-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required nodes and properties into the Berlin BG2Q device tree to
take advantage of the newly introduced SMP support. Add the scu and
cpu-ctrl nodes along with the CPUs enable-method property.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 07452a7483fa..570f12f7e9c4 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -17,6 +17,7 @@
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
+		enable-method = "marvell,berlin-smp";
 
 		cpu@0 {
 			compatible = "arm,cortex-a9";
@@ -94,6 +95,11 @@
 			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		scu: snoop-control-unit@ad0000 {
+			compatible = "arm,cortex-a9-scu";
+			reg = <0xad0000 0x58>;
+		};
+
 		gic: interrupt-controller@ad1000 {
 			compatible = "arm,cortex-a9-gic";
 			reg = <0xad1000 0x1000>, <0xad0100 0x100>;
@@ -101,6 +107,11 @@
 			#interrupt-cells = <3>;
 		};
 
+		cpu-ctrl@dd0000 {
+			compatible = "marvell,berlin-cpu-ctrl";
+			reg = <0xdd0000 0x10000>;
+		};
+
 		apb@e80000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
-- 
1.9.1

