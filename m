Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaEDQRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:17:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaEDPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Roger Quadros <rogerq@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        Partha Basak <parthab@india.ti.com>
Subject: [PATCH 3.10 08/86] ARM: OMAP3: hwmod data: Correct clock domains for USB modules
Date: Sun,  4 May 2014 11:40:43 -0400
Message-Id: <20140504154141.556625605@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit c6c56697ae4bf1226263c19e8353343d7083f40e upstream.

OMAP3 doesn't contain "l3_init_clkdm" clock domain. Use the
proper clock domains for USB Host and USB TLL modules.

Gets rid of the following warnings during boot
 omap_hwmod: usb_host_hs: could not associate to clkdm l3_init_clkdm
 omap_hwmod: usb_tll_hs: could not associate to clkdm l3_init_clkdm

Reported-by: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Fixes: de231388cb80a8ef3e779bbfa0564ba0157b7377 ("ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP3")
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Partha Basak <parthab@india.ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1955,7 +1955,7 @@ static struct omap_hwmod_irq_info omap3x
 static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 	.name		= "usb_host_hs",
 	.class		= &omap3xxx_usb_host_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "usbhost_clkdm",
 	.mpu_irqs	= omap3xxx_usb_host_hs_irqs,
 	.main_clk	= "usbhost_48m_fck",
 	.prcm = {
@@ -2040,7 +2040,7 @@ static struct omap_hwmod_irq_info omap3x
 static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod = {
 	.name		= "usb_tll_hs",
 	.class		= &omap3xxx_usb_tll_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "core_l4_clkdm",
 	.mpu_irqs	= omap3xxx_usb_tll_hs_irqs,
 	.main_clk	= "usbtll_fck",
 	.prcm = {


