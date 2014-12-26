Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLZJC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:02:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33754 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbaLZJBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:01:54 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sebastian.hesselbarth@gmail.com>,
        <antoine.tenart@free-electrons.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 2/3] ARM: dts: berlin: add PPI cpu mask to twd timer interrupts
Date: Fri, 26 Dec 2014 16:58:00 +0800
Message-ID: <1419584281-4811-3-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419584281-4811-1-git-send-email-jszhang@marvell.com>
References: <1419584281-4811-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412260098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the gic binding document, "bits[15:8] PPI interrupt cpu
mask.  Each bit corresponds to each of the 8 possible cpus attached to
the GIC.  A bit set to '1' indicated the interrupt is wired to that
CPU." This patch wants to add the PPI cpu mask for completeness.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 arch/arm/boot/dts/berlin2.dtsi   | 2 +-
 arch/arm/boot/dts/berlin2cd.dtsi | 2 +-
 arch/arm/boot/dts/berlin2q.dtsi  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 015a06c..63d00a6 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -104,7 +104,7 @@
 		local-timer@ad0600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
-			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_HIGH)>;
 			clocks = <&chip CLKID_TWD>;
 		};
 
diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index a318bc3..81b670a 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -76,7 +76,7 @@
 		local-timer@ad0600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
-			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_HIGH)>;
 			clocks = <&chip CLKID_TWD>;
 		};
 
diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 933dcbb..41a683f 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -112,7 +112,7 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
 			clocks = <&chip CLKID_TWD>;
-			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		};
 
 		gic: interrupt-controller@ad1000 {
-- 
2.1.4

