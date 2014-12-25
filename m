Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaLYGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 01:16:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45834 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbaLYGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 01:16:01 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sebastian.hesselbarth@gmail.com>,
        <antoine.tenart@free-electrons.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH 1/2] ARM: dts: berlin: add pmu node for BG2Q and BG2CD
Date: Thu, 25 Dec 2014 14:12:21 +0800
Message-ID: <1419487942-2277-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419487942-2277-1-git-send-email-jszhang@marvell.com>
References: <1419487942-2277-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_03:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412250071
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pmu node, enabling the PMU unit on Marvell BG2Q and
BG2CD SoCs.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 arch/arm/boot/dts/berlin2cd.dtsi | 5 +++++
 arch/arm/boot/dts/berlin2q.dtsi  | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index 230df3b..a318bc3 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -45,6 +45,11 @@
 
 		ranges = <0 0xf7000000 0x1000000>;
 
+		pmu {
+			compatible = "arm,cortex-a9-pmu";
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		sdhci0: sdhci@ab0000 {
 			compatible = "mrvl,pxav3-mmc";
 			reg = <0xab0000 0x200>;
diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 35253c9..933dcbb 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -63,6 +63,14 @@
 		ranges = <0 0xf7000000 0x1000000>;
 		interrupt-parent = <&gic>;
 
+		pmu {
+			compatible = "arm,cortex-a9-pmu";
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		sdhci0: sdhci@ab0000 {
 			compatible = "mrvl,pxav3-mmc";
 			reg = <0xab0000 0x200>;
-- 
2.1.4

