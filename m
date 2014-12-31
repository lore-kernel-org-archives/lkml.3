Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaLaJDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:03:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10727 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbaLaJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 04:03:47 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <sebastian.hesselbarth@gmail.com>, <mturquette@linaro.org>,
        <sboyd@codeaurora.org>, <alexandre.belloni@free-electrons.com>,
        <antoine.tenart@free-electrons.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH 1/3] ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host
Date: Wed, 31 Dec 2014 16:57:50 +0800
Message-ID: <1420016272-6789-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420016272-6789-1-git-send-email-jszhang@marvell.com>
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-31_04:2014-12-30,2014-12-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412310093
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On BG2Q, the sdhci2 host uses nfcecc for "io" clk and nfc for "core" clk.
The shdci2 can't work Without this patch due to the "core" clk is gated.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Cc: stable@vger.kernel.org # 3.16+
---
 arch/arm/boot/dts/berlin2q.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 35253c9..903f3bb 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -83,7 +83,8 @@
 			compatible = "mrvl,pxav3-mmc";
 			reg = <0xab1000 0x200>;
 			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&chip CLKID_SDIO1XIN>;
+			clocks = <&chip CLKID_NFC_ECC>, <&chip CLKID_NFC>;
+			clock-names = "io", "core";
 			status = "disabled";
 		};
 
-- 
2.1.4

