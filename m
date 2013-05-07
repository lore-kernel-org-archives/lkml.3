Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab3EGEbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:31:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562Ab3EGEZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:55 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XBiM2Bpj944A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SrCJlh5D9QEA:10 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=XNN-oNMjSfgA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035852.923608771@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [072/126] ARM: clk-imx35: Bugfix iomux clock
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0072-ARM-clk-imx35-Bugfix-iomux-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

[ Upstream commit cab1e0a36c9dd0b0671fb84197ed294513f5adc1 ]

This patch enables iomuxc_gate clock. It is necessary to be able to
reconfigure iomux pads. Without this clock enabled, the
clk_disable_unused function will disable this clock and the iomux pads
are not configurable anymore. This happens at every boot. After a reboot
(watchdog system reset) the clock is not enabled again, so all iomux pad
reconfigurations in boot code are without effect.

The iomux pads should be always configurable, so this patch always
enables it.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-imx/clk-imx35.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/clk-imx35.c b/arch/arm/mach-imx/clk-imx35.c
index 2941d7f..0c6061d 100644
--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -261,6 +261,7 @@ int __init mx35_clocks_init()
 	clk_prepare_enable(clk[iim_gate]);
 	clk_prepare_enable(clk[emi_gate]);
 	clk_prepare_enable(clk[max_gate]);
+	clk_prepare_enable(clk[iomuxc_gate]);
 
 	/*
 	 * SCC is needed to boot via mmc after a watchdog reset. The clock code
-- 
1.7.10.4


