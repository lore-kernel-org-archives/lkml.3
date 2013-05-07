Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3EGEbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:31:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab3EGEZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:55 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=rz3WD9c0aXAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FzRvYJWq0XMA:10 a=fC4T7qsy4_4xvlMS5R0A:9 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035852.771181520@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Subject: [071/126] ARM: i.MX35: enable MAX clock
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0071-ARM-i.MX35-enable-MAX-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 5dc2eb7da1e387e31ce54f54af580c6a6f512ca6 ]

The i.MX35 has two bits per clock gate which are decoded as follows:
      0b00 -> clock off
      0b01 -> clock is on in run mode, off in wait/doze
      0b10 -> clock is on in run/wait mode, off in doze
      0b11 -> clock is always on

The reset value for the MAX clock is 0b10.

The MAX clock is needed by the SoC, yet unused in the Kernel, so the
common clock framework will disable it during late init time. It will
only disable clocks though which it detects as being turned on. This
detection is made depending on the lower bit of the gate. If the reset
value has been altered by the bootloader to 0b11 the clock framework
will detect the clock as turned on, yet unused, hence it will turn it
off and the system locks up.

This patch turns the MAX clock on unconditionally making the Kernel
independent of the bootloader.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-imx/clk-imx35.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/clk-imx35.c b/arch/arm/mach-imx/clk-imx35.c
index 65fb8bc..2941d7f 100644
--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -260,6 +260,7 @@ int __init mx35_clocks_init()
 	clk_prepare_enable(clk[gpio3_gate]);
 	clk_prepare_enable(clk[iim_gate]);
 	clk_prepare_enable(clk[emi_gate]);
+	clk_prepare_enable(clk[max_gate]);
 
 	/*
 	 * SCC is needed to boot via mmc after a watchdog reset. The clock code
-- 
1.7.10.4


