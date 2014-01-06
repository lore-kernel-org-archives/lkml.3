Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbaAGAFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:05:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbaAFWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lokesh Vutla <lokeshvutla@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 3.12 045/144] ARM: DRA7: hwmod: Fix boot crash with DEBUG_LL
Date: Mon,  6 Jan 2014 14:36:46 -0800
Message-Id: <20140106223746.630763415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajendra Nayak <rnayak@ti.com>

commit 38958c15dc640a9249e4f0cd0dfb0ddc7a23464d upstream.

With commit '7dedd34: ARM: OMAP2+: hwmod: Fix a crash in _setup_reset() with
 DEBUG_LL' we moved from parsing cmdline to identify uart used for earlycon
to using the requsite hwmod CONFIG_DEBUG_OMAPxUARTy FLAGS.

On DRA7 though, we seem to be missing this flag, and atleast on the DRA7 EVM
where we use uart1 for console, boot fails with DEBUG_LL enabled.

Reported-by: Lokesh Vutla <lokeshvutla@ti.com>
Tested-by:  Lokesh Vutla <lokeshvutla@ti.com> # on a different base
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Fixes: 7dedd346941d ("ARM: OMAP2+: hwmod: Fix a crash in _setup_reset() with DEBUG_LL")
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1637,7 +1637,7 @@ static struct omap_hwmod dra7xx_uart1_hw
 	.class		= &dra7xx_uart_hwmod_class,
 	.clkdm_name	= "l4per_clkdm",
 	.main_clk	= "uart1_gfclk_mux",
-	.flags		= HWMOD_SWSUP_SIDLE_ACT,
+	.flags		= HWMOD_SWSUP_SIDLE_ACT | DEBUG_OMAP2UART1_FLAGS,
 	.prcm = {
 		.omap4 = {
 			.clkctrl_offs = DRA7XX_CM_L4PER_UART1_CLKCTRL_OFFSET,


