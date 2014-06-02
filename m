Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaFBJWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:22:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38040 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753274AbaFBJVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:21:10 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: dts: berlin: add SMP related nodes and properties for BG2
Date: Mon,  2 Jun 2014 11:21:05 +0200
Message-Id: <1401700866-24804-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add required nodes and properties into the Berlin BG2 device tree to
take advantage of the newly introduced SMP support. Add the scu and
cpu-ctrl nodes along with the CPUs enable-method property.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 56a1af2f1052..f38ddda8a75e 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -21,6 +21,7 @@
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
+		enable-method = "marvell,berlin-smp";
 
 		cpu@0 {
 			compatible = "marvell,pj4b";
@@ -72,6 +73,11 @@
 			cache-level = <2>;
 		};
 
+		scu: snoop-control-unit@ad0000 {
+			compatible = "arm,cortex-a9-scu";
+			reg = <0xad0000 0x58>;
+		};
+
 		gic: interrupt-controller@ad1000 {
 			compatible = "arm,cortex-a9-gic";
 			reg = <0xad1000 0x1000>, <0xad0100 0x0100>;
@@ -86,6 +92,11 @@
 			clocks = <&sysclk>;
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

