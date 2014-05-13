Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbaEMJ74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:59:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60831 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760077AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        Partha Basak <parthab@india.ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/182] ARM: OMAP3: hwmod data: Correct clock domains for USB modules
Date: Tue, 13 May 2014 11:26:05 +0200
Message-Id: <cf6d0e70b481592f0f0398478a70e944a261e00e.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 60f23440082e..857e76c38a15 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1968,7 +1968,7 @@ static struct omap_hwmod_irq_info omap3xxx_usb_host_hs_irqs[] = {
 static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 	.name		= "usb_host_hs",
 	.class		= &omap3xxx_usb_host_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "usbhost_clkdm",
 	.mpu_irqs	= omap3xxx_usb_host_hs_irqs,
 	.main_clk	= "usbhost_48m_fck",
 	.prcm = {
@@ -2053,7 +2053,7 @@ static struct omap_hwmod_irq_info omap3xxx_usb_tll_hs_irqs[] = {
 static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod = {
 	.name		= "usb_tll_hs",
 	.class		= &omap3xxx_usb_tll_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "core_l4_clkdm",
 	.mpu_irqs	= omap3xxx_usb_tll_hs_irqs,
 	.main_clk	= "usbtll_fck",
 	.prcm = {
-- 
1.9.3

