Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaLaJCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:02:03 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2491 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaLaJB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 04:01:58 -0500
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
Subject: [PATCH 2/3] ARM: berlin: add broken-cd and set bus width for eMMC in Marvell DMP DT
Date: Wed, 31 Dec 2014 16:57:51 +0800
Message-ID: <1420016272-6789-3-git-send-email-jszhang@marvell.com>
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

There's no card detection for the eMMC, so this patch adds the missing
broken-cd property. This patch also sets bus width as 8 to add
MMC_CAP_8_BIT_DATA in the Host capabilities.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Cc: stable@vger.kernel.org # 3.16+
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 28e7e20..a98ac1b 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -65,6 +65,8 @@
 };
 
 &sdhci2 {
+	broken-cd;
+	bus-width = <8>;
 	non-removable;
 	status = "okay";
 };
-- 
2.1.4

