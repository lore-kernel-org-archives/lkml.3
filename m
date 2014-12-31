Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaLaJCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 04:02:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20670 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbaLaJB6 (ORCPT
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
Subject: [PATCH 3/3] clk: berlin: bg2q: remove non-exist "smemc" gate clock
Date: Wed, 31 Dec 2014 16:57:52 +0800
Message-ID: <1420016272-6789-4-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420016272-6789-1-git-send-email-jszhang@marvell.com>
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-31_03:2014-12-30,2014-12-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412310092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "smemc" clock is removed on BG2Q SoCs. In fact, bit19 of clkenable
register is for nfc. Current code use bit19 for non-exist "smemc"
incorrectly, this prevents eMMC from working due to the sdhci's
"core" clk is still gated.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Cc: stable@vger.kernel.org # 3.16+
---
 drivers/clk/berlin/bg2q.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index 21784e4..440ef81 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -285,7 +285,6 @@ static const struct berlin2_gate_data bg2q_gates[] __initconst = {
 	{ "pbridge",	"perif",	15, CLK_IGNORE_UNUSED },
 	{ "sdio",	"perif",	16, CLK_IGNORE_UNUSED },
 	{ "nfc",	"perif",	18 },
-	{ "smemc",	"perif",	19 },
 	{ "pcie",	"perif",	22 },
 };
 
-- 
2.1.4

