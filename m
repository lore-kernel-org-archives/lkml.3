Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbbAYS0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:26:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbbAYSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.18 162/183] ARM: imx6sx: Set PLL2 as parent of QSPI clocks
Date: Sun, 25 Jan 2015 10:08:04 -0800
Message-Id: <20150125180817.207004060@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7c168ed898931f6c3314d696e63cf993378ca192 upstream.

The default qspi2_clk_sel field of register CCM_CS2CDR contains '110' which is
marked as 'reserved', so we can't rely on the default value.

Provide a proper parent for QSPI clocks to avoid a kernel oops:

[    1.037920] Division by zero in kernel.
[    1.041807] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc7-next-20141204-00002-g5aa23e1 #2143
[    1.050967] Hardware name: Freescale i.MX6 SoloX (Device Tree)
[    1.056853] Backtrace:
[    1.059360] [<80011ea0>] (dump_backtrace) from [<8001203c>] (show_stack+0x18/0x1c)
[    1.066982]  r6:00000000 r5:00000000 r4:00000000 r3:00000000
[    1.072754] [<80012024>] (show_stack) from [<806b7100>] (dump_stack+0x88/0xa4)
[    1.080038] [<806b7078>] (dump_stack) from [<80011d20>] (__div0+0x18/0x20)
[    1.086958]  r5:be018500 r4:be017c00
[    1.090600] [<80011d08>] (__div0) from [<802aa418>] (Ldiv0+0x8/0x10)
[    1.097012] [<80504fbc>] (clk_divider_set_rate) from [<80503ddc>] (clk_change_rate+0x14c/0x17c)
[    1.105759]  r7:00000000 r6:00000000 r5:be018500 r4:00000000
[    1.111516] [<80503c90>] (clk_change_rate) from [<80503ea0>] (clk_set_rate+0x94/0x98)
[    1.119391]  r8:be7e0368 r7:00000000 r6:be11a000 r5:be018500 r4:00000000 r3:00000000
[    1.127290] [<80503e0c>] (clk_set_rate) from [<80410558>] (fsl_qspi_probe+0x23c/0x75c)
[    1.135260]  r5:be11a010 r4:be350010
[    1.138900] [<8041031c>] (fsl_qspi_probe) from [<80385a18>] (platform_drv_probe+0x50/0xac)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx6sx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mach-imx/clk-imx6sx.c
+++ b/arch/arm/mach-imx/clk-imx6sx.c
@@ -558,6 +558,9 @@ static void __init imx6sx_clocks_init(st
 	clk_set_parent(clks[IMX6SX_CLK_GPU_CORE_SEL], clks[IMX6SX_CLK_PLL3_PFD0]);
 	clk_set_parent(clks[IMX6SX_CLK_GPU_AXI_SEL], clks[IMX6SX_CLK_PLL3_PFD0]);
 
+	clk_set_parent(clks[IMX6SX_CLK_QSPI1_SEL], clks[IMX6SX_CLK_PLL2_BUS]);
+	clk_set_parent(clks[IMX6SX_CLK_QSPI2_SEL], clks[IMX6SX_CLK_PLL2_BUS]);
+
 	/* Set initial power mode */
 	imx6q_set_lpm(WAIT_CLOCKED);
 }


