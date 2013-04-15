Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3DOCnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:43:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab3DOCni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 07/27] ARM: imx35 Bugfix admux clock
Date: Sun, 14 Apr 2013 19:43:06 -0700
Message-Id: <20130415024231.910693221@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 75498083e25e96932ad998ffdeadb17234c68d3a upstream.

The admux clock seems to be the audmux clock as tests show. audmux does
not work without this clock enabled. Currently imx35 does not register a
clock device for audmux. This patch adds this registration. imx-audmux
driver already handles a clock device, so no changes are necessary
there.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx35.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -257,6 +257,7 @@ int __init mx35_clocks_init()
 	clk_register_clkdev(clk[wdog_gate], NULL, "imx2-wdt.0");
 	clk_register_clkdev(clk[nfc_div], NULL, "imx25-nand.0");
 	clk_register_clkdev(clk[csi_gate], NULL, "mx3-camera.0");
+	clk_register_clkdev(clk[admux_gate], "audmux", NULL);
 
 	clk_prepare_enable(clk[spba_gate]);
 	clk_prepare_enable(clk[gpio1_gate]);


