Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaLaJCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:02:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55188 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbaLaJB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 04:01:57 -0500
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
Subject: [PATCH 0/3] fix non-working eMMC on Marvell BG2Q DMP board
Date: Wed, 31 Dec 2014 16:57:49 +0800
Message-ID: <1420016272-6789-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
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

The eMMC on Marvell BG2Q DMP board doesn't work due to the following reasons:

 1. the sdhci2 host needs "core" clk to work.
 2. there's no card detection for the eMMC.
 3. the non-exist "smemc" clk occpuies the enable bit for nfc clock which is
    use for the sdhci2's "core" clk.

These pathes fix them.

Please consider for stable as well.

Jisheng Zhang (3):
  ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2
    host
  ARM: berlin: add broken-cd and set bus width for eMMC in Marvell DMP
    DT
  clk: berlin: bg2q: remove non-exist "smemc" gate clock

 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 2 ++
 arch/arm/boot/dts/berlin2q.dtsi            | 3 ++-
 drivers/clk/berlin/bg2q.c                  | 1 -
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.1.4

