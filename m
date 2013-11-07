Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3KGJCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:02:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17618 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab3KGJB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:01:58 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <mturquette@linaro.org>, <jason@lakedaemon.net>,
        <gregory.clement@free-electrons.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] clk: mvebu: staticize of_cpu_clk_setup
Date: Thu, 7 Nov 2013 16:59:33 +0800
Message-ID: <1383814773-5231-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_03:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311070013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This symbol is used only in this file. The patch fix the following
sparse warning:
warning: symbol 'of_cpu_clk_setup' was not declared. Should it be static?

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/clk/mvebu/clk-cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
index 1466865..8ebf757 100644
--- a/drivers/clk/mvebu/clk-cpu.c
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -101,7 +101,7 @@ static const struct clk_ops cpu_ops = {
 	.set_rate = clk_cpu_set_rate,
 };
 
-void __init of_cpu_clk_setup(struct device_node *node)
+static void __init of_cpu_clk_setup(struct device_node *node)
 {
 	struct cpu_clk *cpuclk;
 	void __iomem *clock_complex_base = of_iomap(node, 0);
-- 
1.8.4.2

